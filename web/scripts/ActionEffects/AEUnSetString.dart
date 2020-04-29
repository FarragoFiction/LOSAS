import '../Entity.dart';
import 'ActionEffect.dart';

class AEUnSetString extends ActionEffect {
    static const String KEY = "memoryKey";
    @override
    String type ="UnsetString";
    @override
    String explanation = "Remove a key entirely from string memory.";
    AEUnSetString(String key) : super({KEY:key},{});

    @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.removeStringMemoryKey(importantWords[KEY]));
  }

}