//TODO a prepack consists of a lot of generators (which can include datastrings of scenes or dolls or whatever) and a description and  a list of scenes (that aren't tied to generators)
//TODO it should also have an image that does NOT get serialized. instead it is the datapng the datastring gets saved to on export.
//TODO on import of a prepack it stores the datapng it came with so it can be displayed
import 'dart:html';

import 'DataObject.dart';
import 'DataStringHelper.dart';
import 'Generator.dart';
import 'Scene.dart';

class Prepack extends DataObject {
    List<Generator> generators;
    //an entity given this prepack is going to have these scenes at a prioritization based on what order you give the prepacks to em
    List<Scene> scenes;
    String name;
    String description = "This prepack has a default description";
    String author = "???";
    ImageElement cardImage;

    Prepack.fromDataString(String dataString){
        Map<String,dynamic> serialization = DataStringHelper.serializationFromDataString(dataString);
        loadFromSerialization(serialization);
    }

  @override
  void loadFromDataString(String dataString) {
    // TODO: implement loadFromDataString
  }

  @override
  void loadFromSerialization(Map<String, dynamic> serialization) {
    // TODO: implement loadFromSerialization
  }



}