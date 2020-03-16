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
    num importantNum;
    String importantString;

    ActionEffect(this.importantString, this.importantNum);

    void effectEntities(Entity effector, List<Entity> entities);

    String debugString() {
        return "Effect: ${runtimeType} $importantString, $importantNum , Vriska: $vriska";
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