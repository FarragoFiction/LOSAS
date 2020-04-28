import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringFromTarget extends ActionEffect {
    static const String THEIRKEY = "theirStorageKey";
    static const String MYKEY = "myStringKey";
    AECopyStringFromTarget(String myKey, String theirKey) : super({THEIRKEY:theirKey, MYKEY:myKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      entities.forEach((Entity e) => effector.setStringMemory(importantWords[MYKEY], e.getStringMemory(importantWords[THEIRKEY])));
  }

}