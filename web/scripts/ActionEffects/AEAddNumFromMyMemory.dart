import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromMyMemory extends ActionEffect {
  String secondKey;
  AEAddNumFromMyMemory(String importantString, String this.secondKey, num importantNum ) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantString);
      num toAdd = effector.getNumMemory(secondKey);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantString,oldValue + toAdd);
    }
  }

}