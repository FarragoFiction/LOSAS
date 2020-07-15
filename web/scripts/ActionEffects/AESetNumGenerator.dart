import 'package:CommonLib/Random.dart';

import '../Entity.dart';
import '../Scenario.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AESetNumGenerator extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "defaultValue";
  @override
  List<String> get knownKeys => [importantWords[KEY]];


  @override
  String type ="SetNumGenerator";
  @override
  String explanation = "Generates a new number for the target for a given key using any generators the target possesses. If they have none, intead sets it to the provided default value.";

  AESetNumGenerator(String key, num number) : super({KEY:key}, {NUM:number});
  @override
  ActionEffect makeNewOfSameType() => new AESetNumGenerator(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    Random rand = effector is Entity? effector.rand: (effector as Scenario).rand;
    entities.forEach((SentientObject e) => (e is Entity) ? e.generateNumValueForKey(rand,importantWords[KEY], importantNumbers[NUM]) : null);
  }

}