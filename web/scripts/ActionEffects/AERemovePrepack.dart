import '../Entity.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AERemovePrepack extends ActionEffect {
    static const String INPUTVALUE = "prepackDataString";
    @override
    String type ="AERemovePrepack";
    @override
    String explanation = "Removes the scenes and generators from a prepack to a target.";
    AERemovePrepack(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AERemovePrepack(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.unprocessSinglePrepack(Prepack.fromDataString((importantWords[INPUTVALUE]))));
  }

}