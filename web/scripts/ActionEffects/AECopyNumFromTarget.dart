import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumFromTarget extends ActionEffect {
  String theirKey;
  AECopyNumFromTarget(String this.theirKey, String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => effector.setNumMemory(importantString, e.getNumMemory(theirKey)));
  }

}