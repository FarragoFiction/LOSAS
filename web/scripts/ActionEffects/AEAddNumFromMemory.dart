import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromMemory extends ActionEffect {
  String secondKey;
  AEAddNumFromMemory(String importantString, String this.secondKey, num importantNum ) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantString);
      num toAdd = e.getNumMemory(secondKey);
      print("In AEAddNumFromMemory, old value is $oldValue and new is $toAdd");
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantString,oldValue + toAdd);
    }
  }

}