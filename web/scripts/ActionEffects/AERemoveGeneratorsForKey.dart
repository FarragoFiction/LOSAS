import '../Entity.dart';
import 'ActionEffect.dart';

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
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.removeGeneratorsForKey(importantWords[STORAGEKEY]));
  }

}