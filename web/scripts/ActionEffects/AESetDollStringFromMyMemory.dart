import '../Entity.dart';
import 'ActionEffect.dart';

class AESetDollStringFromMyMemory extends ActionEffect {
    static const String SHAREDKEY = "memoryKey";
    @override
    String type ="SetDollStringFromMemory";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a given memory key belonging to the owner.";
    AESetDollStringFromMyMemory(String sharedKey) : super({SHAREDKEY:sharedKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNewDoll(effector.getStringMemory(importantWords[SHAREDKEY])));
  }

}