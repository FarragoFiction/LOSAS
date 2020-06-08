import '../Entity.dart';
import 'ActionEffect.dart';

class AESetString extends ActionEffect {
  static const String STORAGEKEY = "memoryKey";
  static const String STRINGKEY = "stringToStore";
  List<String> get knownKeys => [importantWords[STORAGEKEY]];

  @override
  String type ="SetString";
  @override
  String explanation = "Provide a word or phrase to store in the targets memory at a specific key.";
  AESetString(String storageKey, String stringToStore) : super(<String,String>{STORAGEKEY:storageKey, STRINGKEY:stringToStore}, {});
  @override
  ActionEffect makeNewOfSameType() => new AESetString(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setStringMemory(importantWords[STORAGEKEY], importantWords[STRINGKEY]));
  }

}