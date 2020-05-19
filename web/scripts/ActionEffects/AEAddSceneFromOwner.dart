import '../Entity.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AEAddSceneFromOwner extends ActionEffect {
    static const String INPUTVALUE = "sceneDataString";
    @override
    String type ="AEAddSceneFromOwner";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a given memory key belonging to the owner.";
    AEAddSceneFromOwner(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddSceneFromOwner(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.addSceneFront(new Scene.fromDataString((effector.getStringMemory(importantWords[INPUTVALUE])))));
  }

}