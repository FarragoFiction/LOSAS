import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNumGenerator extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "num";
  AESetNumGenerator(String key, num number) : super({KEY:key}, {NUM:number});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.generateNumValueForKey(effector.rand,importantWords[KEY], importantNumbers[NUM]));
  }

}