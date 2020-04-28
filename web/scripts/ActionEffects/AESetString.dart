import '../Entity.dart';
import 'ActionEffect.dart';

class AESetString extends ActionEffect {
  static const String STORAGEKEY = "memoryKey";
  static const String STRINGKEY = "stringToStore";

  AESetString(String storageKey, String stringToStore) : super(<String,String>{STORAGEKEY:storageKey, STRINGKEY:stringToStore}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setStringMemory(importantWords[STORAGEKEY], importantWords[STRINGKEY]));
  }

}