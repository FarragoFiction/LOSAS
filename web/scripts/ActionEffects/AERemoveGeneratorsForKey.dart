import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AERemoveAllGeneratorsForKey extends ActionEffect {
  static const String STORAGEKEY = "generatorKey";
  @override
  List<String> get knownKeys => [importantWords[STORAGEKEY]];

  @override
  String type ="RemoveAllGeneratorsForKey";
  @override
  String explanation = "Provide a word or phrase to store in the targets memory at a specific key.";
  AERemoveAllGeneratorsForKey(String storageKey) : super(<String,String>{STORAGEKEY:storageKey}, {});
  @override
  ActionEffect makeNewOfSameType() => new AERemoveAllGeneratorsForKey(null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.removeGeneratorsForKey(importantWords[STORAGEKEY]): null);
  }

}