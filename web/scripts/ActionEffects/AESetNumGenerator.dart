import '../Entity.dart';
import 'ActionEffect.dart';

class AESetNumGenerator extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "defaultValue";

  @override
  String type ="SetNumGenerator";
  @override
  String explanation = "Generates a new number for the target for a given key using any generators the target possesses. If they have none, intead sets it to the provided default value.";

  AESetNumGenerator(String key, num number) : super({KEY:key}, {NUM:number});
  @override
  ActionEffect makeNewOfSameType() => new AESetNumGenerator(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.generateNumValueForKey(effector.rand,importantWords[KEY], importantNumbers[NUM]));
  }

}