import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromYourMemory extends ActionEffect {
  static const String RESULTNUM = "myMemoryKeyForFirstAddorAndStorage";
  static const String ADDOR = "yourMemoryKeyToAdd";
  @override
  String type ="AddNumFromTargetToExisting";
  @override
  String explanation = "Grab a number from the targets memory to add to a stored value in the owners memory and store it in the target.";

  AEAddNumFromYourMemory(String result,String addor) : super(<String,String>{RESULTNUM:result, ADDOR:addor}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantWords[RESULTNUM]);
      num toAdd = e.getNumMemory(importantWords[ADDOR]);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantWords[RESULTNUM],oldValue + toAdd);
    }
  }

}