import 'package:CommonLib/Random.dart';

import '../Entity.dart';
import '../Scene.dart';

/*
    TODO Pile:
     add serialied scene
     forget memory key at random
 */
abstract class ActionEffect {
    //are we applying this to my targets, or to myself?
    bool vriska = false;
    //each subclass MUST implement this
    String type;
    Map<String,String> importantWords = new Map<String,String>();
    Map<String, num> importantNumbers = new Map<String,num>();


    ActionEffect(this.importantWords, this.importantNumbers);

    void effectEntities(Entity effector, List<Entity> entities);

    Map<String,dynamic> getSerialization() {
        Map<String,dynamic> ret = new Map<String,dynamic>();
        ret["type"] = type;
        ret["importantWords"] = importantWords;
        ret["importantNumbers"] = importantNumbers;
        return ret;
    }

    String debugString() {
        return "Effect: ${runtimeType} $importantWords, $importantNumbers , Vriska: $vriska";
    }


    void applyEffect(Scene scene) {
        List<Entity> targets;
        if(vriska) {
            targets = new List<Entity>();
            targets.add(scene.owner);
        }else {
            targets = new List.from(scene.finalTargets);
        }
        effectEntities(scene.owner,targets);
    }

}