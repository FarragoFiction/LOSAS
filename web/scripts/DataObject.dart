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

    void loadFromSerialization(Map<String, dynamic> serialization);

    void loadFromDataString(String dataString) {
        loadFromSerialization(DataStringHelper.serializationFromDataString(dataString));
    }
}

abstract class ArchivePNGObject extends DataObject {
    //keep this around so you can render yourself as a black box
    ArchivePng externalForm;
    //TODO handle rendering your archive png to the screen

    static Future<Scenario> getScenario(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        return new Scenario.fromDataString(dataString);
    }

    static Future<Prepack> getPrepack(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        return new Prepack.fromDataString(dataString);
    }

    static Future<Entity> getEntity(ArchivePng png) async{
        String dataString = await png.getFile(Scenario.dataPngFile);
        return new Entity.fromDataString(dataString);
    }
}