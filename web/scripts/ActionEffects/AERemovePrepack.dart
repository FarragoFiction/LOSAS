import '../Entity.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

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
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.unprocessSinglePrepack(Prepack.fromDataString((importantWords[INPUTVALUE]))): null);
  }

}