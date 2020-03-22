import '../Entity.dart';
import 'ActionEffect.dart';

class AESetDollStringFromYourMemory extends ActionEffect {
    AESetDollStringFromYourMemory(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      print("I'm going to set $entities dollstrings to ${entities.first.getStringMemory(importantString)}");
    entities.forEach((Entity e) => e.setNewDoll(e.getStringMemory(importantString)));
  }

}