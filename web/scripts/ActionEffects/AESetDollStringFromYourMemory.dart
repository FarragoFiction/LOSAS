import '../Entity.dart';
import 'ActionEffect.dart';

class AESetDollStringFromYourMemory extends ActionEffect {
    static const String SHAREDKEY = "memoryKey";

    AESetDollStringFromYourMemory(String sharedKey) : super({SHAREDKEY:sharedKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      print("I'm going to set $entities dollstrings to ${entities.first.getStringMemory(importantWords[SHAREDKEY])}");
    entities.forEach((Entity e) => e.setNewDoll(e.getStringMemory(importantWords[SHAREDKEY])));
  }

}