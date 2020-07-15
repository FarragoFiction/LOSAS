import 'package:CommonLib/Random.dart';

import '../Entity.dart';
import '../Scenario.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AESetStringGenerator extends ActionEffect {
    static const String GENERATORKEY = "generatorKey";
    static const String DEFAULTVALUE = "defaultValue";
    @override
    List<String> get knownKeys => [importantWords[GENERATORKEY]];

    @override
    String type ="SetStringGenerator";
    @override
    String explanation = "Generates a new word or phrase for the target for a given key using any generators the target possesses. If they have none, intead sets it to the provided default value.";


    AESetStringGenerator(String generatorKey, String defaultValue) : super(<String,String>{GENERATORKEY:generatorKey, DEFAULTVALUE:defaultValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AESetStringGenerator(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
      Random rand = effector is Entity? effector.rand: (effector as Scenario).rand;
      entities.forEach((SentientObject e) => (e is Entity) ? e.generateStringValueForKey(rand,importantWords[GENERATORKEY], importantWords[DEFAULTVALUE]):null);
  }

}