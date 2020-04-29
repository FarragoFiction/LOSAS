import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNum extends ActionEffect {
  static const String MEMORYKEY = "memoryKey";
  static const String ADDOR = "numToAdd";
  AEAddNum(String memoryKey, num addor) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{ADDOR:addor});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantWords[MEMORYKEY]);
      oldValue ??=0;
      e.setNumMemory(importantWords[MEMORYKEY],oldValue + importantNumbers[ADDOR]);
    }
  }

}