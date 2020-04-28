import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromYourMemory extends ActionEffect {
  AEAddNumFromYourMemory(importantWords, importantNumbers) : super(importantWords, importantNumbers);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantString);
      num toAdd = e.getNumMemory(secondKey);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantString,oldValue + toAdd);
    }
  }

}