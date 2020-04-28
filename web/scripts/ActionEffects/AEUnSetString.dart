import '../Entity.dart';
import 'ActionEffect.dart';

class AEUnSetString extends ActionEffect {
    static const String KEY = "memoryKey";
    AEUnSetString(String key) : super({KEY:key},{});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.removeStringMemoryKey(importantWords[KEY]));
  }

}