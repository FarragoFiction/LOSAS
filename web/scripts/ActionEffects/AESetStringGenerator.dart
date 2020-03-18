import '../Entity.dart';
import 'ActionEffect.dart';

class AESetStringGenerator extends ActionEffect {
    String value;
    AESetStringGenerator(this.value,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.generateStringValueForKey(effector.rand,value, importantString));
  }

}