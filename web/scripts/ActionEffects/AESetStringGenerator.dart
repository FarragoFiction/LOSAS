import '../Entity.dart';
import 'ActionEffect.dart';

class AESetStringGenerator extends ActionEffect {
    String value;
    AESetStringGenerator(this.value,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      print("vriska is $vriska I am trying to use a generator for key ${value}, the current value is ${effector.getStringMemory(value)}");
    entities.forEach((Entity e) => e.generateStringValueForKey(effector.rand,value, importantString));
      print("vriska is $vriska I finished trying to use a generator for key ${value}, the current value is ${effector.getStringMemory(value)}");

  }

}