import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringFromTarget extends ActionEffect {
    String myKey;
    AECopyStringFromTarget(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      entities.forEach((Entity e) => effector.setStringMemory(importantString, e.getStringMemory(myKey)));
  }

}