import 'DataObject.dart';
import 'Prepack.dart';
import 'package:CommonLib/Collection.dart';
import 'Scenario.dart';
//TODO make builder for this
//TODO serialize this
class Archetype extends DataObject{
    Scenario scenario;
    String name;
    int min = 0; //there must be at least two players
    int max = 1; //there can't be more than 12
    List<TraitPool> traitPool =  new List<TraitPool>();

    Archetype(Scenario this.scenario);

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["traitPool"] = traitPool.map((TraitPool p) => p.getSerialization()).toList();
      ret["name"] = name;
      ret["min"] = min;
      ret["max"] = max;
      return ret;
  }

  @override
  Future<void> loadFromSerialization(Map<String, dynamic> serialization) {
      name = serialization["name"];
      min = serialization["min"];
      max = serialization["max"];
      traitPool = new List<TraitPool>();
      for(Map<String,dynamic> subserialization in serialization["traitPool"]) {
          final TraitPool p = new TraitPool(scenario);
          p.loadFromSerialization(subserialization);
          traitPool.add(p);
      }

  }

}

//how many of these traits can you/must you pick? between 0 and all of them?
//must you pick exactly one? can you pick between 1 and 3? etc etc
class TraitPool extends DataObject {
    //let people set weight when its in teh builder and make sure to export/import weights.
    WeightedList<Prepack> traits = new WeightedList<Prepack>();
    Scenario scenario;
    int min = 0;
    int max = 1;
    TraitPool(Scenario this.scenario);

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["traits"] = traits.map((Prepack p) => p.name).toList();
      ret["min"] = min;
      ret["max"] = max;

      return ret;
  }


  @override
  Future<void> loadFromSerialization(Map<String, dynamic> serialization) {
      min = serialization["min"];
      max = serialization["max"];
      for(final String trait in serialization["traits"]) {
          Prepack p = scenario.findTraitNamed(trait);
          if(p != null) traits.add(p);
      }
  }
}