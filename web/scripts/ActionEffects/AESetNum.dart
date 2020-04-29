import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNum extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "num";
  @override
  String type ="SetNum";
  @override
  String explanation = "Provide a number value store in the targets memory at a specific key.";

  AESetNum(String key,num number) : super({KEY:key}, {NUM:number});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNumMemory(importantWords[KEY], importantNumbers[NUM]));
  }

}