import '../Entity.dart';
import '../Scene.dart';

abstract class ActionEffect {
    //are we applying this to my targets, or to myself?
    bool vriska = false;
    num importantNum;
    String importantString;

    ActionEffect(this.importantString, this.importantNum);

    void effectEntities(Entity effector, List<Entity> entities);


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