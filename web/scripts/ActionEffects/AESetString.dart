import '../Entity.dart';
import 'ActionEffect.dart';

class AESetString extends ActionEffect {
    String value;
  AESetString(this.value,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setStringMemory(value, importantString));
  }

}