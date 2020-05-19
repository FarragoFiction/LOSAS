import '../Entity.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AEAddSceneFromTarget extends ActionEffect {
    static const String INPUTVALUE = "sceneDataString";
    @override
    String type ="AddSceneFromTarget";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a given memory key belonging to the target.";
    AEAddSceneFromTarget(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddSceneFromTarget(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.addSceneFront(new Scene.fromDataString((e.getStringMemory(importantWords[INPUTVALUE])))));
  }

}