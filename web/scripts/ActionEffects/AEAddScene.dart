import '../Entity.dart';
import '../Scene.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEAddScene extends ActionEffect {
    static const String INPUTVALUE = "sceneDataString";
    @override
    String type ="AEAddScene";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a datastring entered here.";
    AEAddScene(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddScene(null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => e.addSceneFront(new Scene.fromDataString((importantWords[INPUTVALUE]))));
  }

}