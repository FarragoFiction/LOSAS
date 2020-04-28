import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNum extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "num";
  AESetNum(String key,num number) : super({KEY:key}, {NUM:number});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNumMemory(importantWords[KEY], importantNumbers[NUM]));
  }

}