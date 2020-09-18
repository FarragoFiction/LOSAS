import 'Prepack.dart';
import 'package:CommonLib/Collection.dart';
//TODO make builder for this
//TODO serialize this
class Archetype {
    String name;
    List<TraitPool> traitPool =  new List<TraitPool>();

}

//how many of these traits can you/must you pick? between 0 and all of them?
//must you pick exactly one? can you pick between 1 and 3? etc etc
class TraitPool {
    //let people set weight when its in teh builder and make sure to export/import weights.
    WeightedList<Prepack> traits = new WeightedList<Prepack>();
    int min = 0;
    int max = 0;
}