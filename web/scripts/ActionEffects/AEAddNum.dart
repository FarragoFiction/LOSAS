import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNum extends ActionEffect {
  static const String MEMORYKEY = "memoryKey";
  static const String ADDOR = "numToAdd";
  @override
  String type ="AddNewNumToExisting";
  @override
  String explanation = "Provide a number value to add to a stored value located at a given key.";
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