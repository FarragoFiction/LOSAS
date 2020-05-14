import '../Entity.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AEAddScene extends ActionEffect {
    static const String INPUTVALUE = "sceneDataString";
    @override
    String type ="AEAddScene";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a given memory key belonging to the owner.";
    AEAddScene(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddScene(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.addScene(new Scene.fromDataString((importantWords[INPUTVALUE]))));
  }

}