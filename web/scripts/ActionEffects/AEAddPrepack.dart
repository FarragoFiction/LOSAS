import '../Entity.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEAddPrepack extends ActionEffect {
    static const String INPUTVALUE = "prepackDataString";
    @override
    String type ="AEAddPrepack";
    @override
    String explanation = "Adds the scenes and generators from a prepack to a target.";
    AEAddPrepack(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddPrepack(null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.processSinglePrepack(Prepack.fromDataString((importantWords[INPUTVALUE]))): null);
  }

}