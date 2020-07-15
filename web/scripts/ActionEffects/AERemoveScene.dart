import '../Entity.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

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
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => e.removeScene(Scene.fromDataString((importantWords[INPUTVALUE]))));
  }

}