import 'dart:async';
import 'dart:html';

import 'package:ImageLib/Encoding.dart';

import 'DataStringHelper.dart';
import 'Entity.dart';
import 'Prepack.dart';
import 'Scenario.dart';

abstract class DataObject {
    String name;
    Map<String, dynamic> getSerialization();

    String toString() => name;

    DataObject();



    String toDataString() {
        return DataStringHelper.serializationToDataString(name,getSerialization());
    }

    Future<void> loadFromSerialization(Map<String, dynamic> serialization);

    Future<void> loadFromDataString(String dataString) async {
        await loadFromSerialization(DataStringHelper.serializationFromDataString(dataString));
    }
}

abstract class ArchivePNGObject extends DataObject {
    //keep this around so you can render yourself as a black box
    ArchivePng externalForm;
    String fileKey; //override this plz

    Future<void> loadImage(Map<String, dynamic > serialization) async {
        if(serialization.containsKey("externalForm")){
            final ImageElement image = new ImageElement()..src = serialization["externalForm"];
            final Completer completer = new Completer<void>();
            image.onLoad.listen((Event e) {
                completer.complete();
            });
            await completer.future;
            CanvasElement canvas = new CanvasElement(
                width: image.width, height: image.height);
            canvas.context2D.drawImage(image, 0, 0);
            externalForm = new ArchivePng.fromCanvas(canvas);
        }
    }

    Future<void> loadFromArchive(ArchivePng png) async {
        final String dataString = await png.getFile(fileKey);
        await loadFromDataString(dataString);
        externalForm = png;
    }

    static Future<Scenario> getScenario(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        Scenario s = new Scenario.empty();
        await s.loadFromDataString(dataString);
        return s;
    }

    static Future<Prepack> getPrepack(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        Prepack s = new Prepack.empty();
        await s.loadFromDataString(dataString);
        return s;
    }

    static Future<Entity> getEntity(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        return new Entity.fromDataString(dataString);
    }
}