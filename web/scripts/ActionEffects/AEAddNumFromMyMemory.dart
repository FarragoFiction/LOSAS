import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromMyMemory extends ActionEffect {
  static const String RESULTNUM = "resultNumberPlusStorage";
  static const String ADDOR = "numToAdd";
  AEAddNumFromMyMemory() : super({}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantWords[RESULTNUM]);
      num toAdd = effector.getNumMemory(importantWords[ADDOR]);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantWords[RESULTNUM],oldValue + toAdd);
    }
  }

}