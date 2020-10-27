import 'DataObject.dart';
import 'Prepack.dart';
import 'package:CommonLib/Collection.dart';
//TODO make builder for this
//TODO serialize this
class Archetype extends DataObject{
    String name;
    List<TraitPool> traitPool =  new List<TraitPool>();

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["traitPool"] = traitPool.map((TraitPool p) => p.getSerialization()).toList();
      ret["name"] = name;
      return ret;
  }

  @override
  Future<void> loadFromSerialization(Map<String, dynamic> serialization) {
      name = serialization["name"];
  }

}

//how many of these traits can you/must you pick? between 0 and all of them?
//must you pick exactly one? can you pick between 1 and 3? etc etc
class TraitPool extends DataObject {
    //let people set weight when its in teh builder and make sure to export/import weights.
    WeightedList<Prepack> traits = new WeightedList<Prepack>();
    int min = 0;
    int max = 0;

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["todo"] = "prepack";
      ret["min"] = min;
      ret["max"] = max;

      return ret;
  }

  @override
  Future<void> loadFromSerialization(Map<String, dynamic> serialization) {
      min = serialization["min"];
      max = serialization["max"];

  }
}