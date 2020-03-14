import '../Entity.dart';
import '../Scene.dart';

abstract class TargetFilter {
    //should I invert my value?
    bool not = false;
    //should I apply my condition to myself, rather than my targets? (i.e. if I meet the condition I allow all targets to pass through to the next condition).
    bool vriska = false;
    bool conditionForFilter(Entity actor, Entity possibleTarget);


    List<Entity> filter(Scene scene, List<Entity> readOnlyEntities) {
        List<Entity> entities = new List.from(readOnlyEntities);
        print("Checking what entities remain before I filter ${entities.length}");
        if(not) {
            if(vriska) {
                //reject all if my condition isn't met
                if(!conditionForFilter(scene.owner,scene.owner)) entities.clear();
            }else {
                entities.removeWhere((Entity item) => !conditionForFilter(scene.owner,item));
            }

        }else {
            if(vriska) {
                //reject all if my condition is met
                if(conditionForFilter(scene.owner,scene.owner)) entities.clear();
            }else {
                entities.removeWhere((Entity item) => conditionForFilter(scene.owner,item));
            }
        }
        print("entities remain after I filter ${entities.length}");
        return entities;
    }

}