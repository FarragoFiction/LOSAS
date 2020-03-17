import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumFromTarget extends ActionEffect {
  String myKey;
  AECopyNumFromTarget(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => effector.setNumMemory(importantString, e.getNumMemory(myKey)));
  }

}