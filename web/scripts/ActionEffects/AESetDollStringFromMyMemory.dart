import '../Entity.dart';
import 'ActionEffect.dart';

class AESetDollStringFromMyMemory extends ActionEffect {
    static const String SHAREDKEY = "memoryKey";

    AESetDollStringFromMyMemory(String sharedKey) : super({SHAREDKEY:sharedKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNewDoll(effector.getStringMemory(importantWords[SHAREDKEY])));
  }

}