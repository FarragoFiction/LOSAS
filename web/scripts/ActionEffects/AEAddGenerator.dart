import '../Entity.dart';
import '../Generator.dart';
import '../Scene.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEAddGenerator extends ActionEffect {
    static const String INPUTVALUE = "generatorDataString";

    @override
    String type ="AddGenerator";
    @override
    String explanation = "Adds a generator's datastring to the key it encodes.";
    AEAddGenerator(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddGenerator(null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.addGenerator(Generator.fromDataString((importantWords[INPUTVALUE]))):null);
  }

}