import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNum extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "num";
  AESetNum(key,num) : super({KEY:key}, {NUM:num});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNumMemory(importantWords[KEY], importantNumbers[NUM]));
  }

}