import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNum extends ActionEffect {
  AEAddNum(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantString);
      oldValue ??=0;
      e.setNumMemory(importantString,oldValue + importantNum);
    }
  }

}