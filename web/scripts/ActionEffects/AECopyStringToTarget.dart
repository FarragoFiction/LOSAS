import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringToTarget extends ActionEffect {
    static const String THEIRKEY = "theirStringKey";
    static const String MYKEY = "myStorageKey";
    AECopyStringToTarget(String myKey, String theirKey) : super({THEIRKEY:theirKey, MYKEY:myKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      entities.forEach((Entity e) => e.setStringMemory(importantWords[THEIRKEY], effector.getStringMemory(importantWords[MYKEY])));
  }

}