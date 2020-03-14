import '../Entity.dart';
import '../Scene.dart';

abstract class TargetFilter {
    //should I invert my value?
    bool not = false;
    //should I apply my condition to myself, rather than my targets? (i.e. if I meet the condition I allow all targets to pass through to the next condition).
    bool vriska = false;
    bool conditionForKeep(Entity actor, Entity possibleTarget);
    String importantWord;
    num importantNum;

    TargetFilter(this.importantWord, this.importantNum);


    List<Entity> filter(Scene scene, List<Entity> readOnlyEntities) {
        List<Entity> entities = new List.from(readOnlyEntities);
        if(not) {
            if(vriska) {
                //reject all if my condition isn't met
                if(conditionForKeep(scene.owner,scene.owner)) entities.clear();
            }else {
                entities.removeWhere((Entity item) => conditionForKeep(scene.owner,item));
            }

        }else {
            if(vriska) {
                //reject all if my condition is met
                if(!conditionForKeep(scene.owner,scene.owner)) entities.clear();
            }else {
                entities.removeWhere((Entity item) => !conditionForKeep(scene.owner,item));
            }
        }
        return entities;
    }

}