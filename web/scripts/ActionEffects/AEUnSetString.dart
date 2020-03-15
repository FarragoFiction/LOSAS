import '../Entity.dart';
import 'ActionEffect.dart';

class AEUnSetString extends ActionEffect {
    AEUnSetString(String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.removeStringMemoryKey(importantString));
  }

}