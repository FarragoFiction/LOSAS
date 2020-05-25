//TODO a prepack consists of a lot of generators (which can include datastrings of scenes or dolls or whatever) and a description and  a list of scenes (that aren't tied to generators)
//TODO it should also have an image that does NOT get serialized. instead it is the datapng the datastring gets saved to on export.
//TODO on import of a prepack it stores the datapng it came with so it can be displayed
import 'dart:html';

import 'DataObject.dart';
import 'DataStringHelper.dart';
import 'Generator.dart';
import 'Scene.dart';

class Prepack extends DataObject {
    static String dataPngFile = "prepack.txt";

    List<Generator> generators;
    //an entity given this prepack is going to have these scenes at a prioritization based on what order you give the prepacks to em
    List<Scene> scenes;
    //when an entity slurps this prepack it keeps track of unique initial keys and generates shit based on them
    List<String> initialKeysToGenerate;
    String name;
    String description = "This prepack has a default description";
    String author = "???";
    ImageElement cardImage;

    Prepack(this.name, this.description, this.author, this.initialKeysToGenerate,this.generators, this.scenes);

    Prepack.fromDataString(String dataString){
        Map<String,dynamic> serialization = DataStringHelper.serializationFromDataString(dataString);
        loadFromSerialization(serialization);
    }

    Prepack.fromSerialization(Map<String, dynamic> serialization){
        loadFromSerialization(serialization);
    }

  @override
  void loadFromSerialization(Map<String, dynamic> serialization) {
      author = serialization["author"];
      name = serialization["name"];
      description = serialization["description"];
      initialKeysToGenerate = new List<String>.from(serialization["initialKeysToGenerate"]);
      scenes = new List.from((serialization["scenes"] as List).map((subserialization) => new Scene.fromSerialization(subserialization)));

      generators = new List.from((serialization["generators"] as List).map((subserialization) => Generator.fromSerialization(subserialization)));

  }

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["author"] = author;
      ret["name"] = name;
      ret["description"] = description;
      ret["initialKeysToGenerate"] = initialKeysToGenerate;
      ret["scenes"] = scenes.map((Scene scene) => scene.getSerialization()).toList();
      ret["generators"] = generators.map((Generator gen) => gen.getSerialization()).toList();

      return ret;
  }



}