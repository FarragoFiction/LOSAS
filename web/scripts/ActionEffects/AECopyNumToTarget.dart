import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumToTarget extends ActionEffect {
  String myKey;
  AECopyNumToTarget(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNumMemory(importantString, effector.getNumMemory(myKey)));
  }

}