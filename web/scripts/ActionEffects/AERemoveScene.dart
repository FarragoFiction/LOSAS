import '../Entity.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AERemoveScene extends ActionEffect {
    static const String INPUTVALUE = "sceneDataString";
    @override
    String type ="AERemoveScene";
    @override
    String explanation = "Removes the scenes from a target.";
    AERemoveScene(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AERemoveScene(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.removeScene(Scene.fromDataString((importantWords[INPUTVALUE]))));
  }

}