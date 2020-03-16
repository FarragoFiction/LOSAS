import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNum extends ActionEffect {
  AESetNum(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.generateNumValueForKey(effector.rand,importantString, importantNum));
  }

}