import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumFromTarget extends ActionEffect {
  static const String THEIRKEY = "theirNumKey";
  static const String MYKEY = "myStorageKey";
  AECopyNumFromTarget(String theirKey, String myKey) : super(<String,String>{THEIRKEY:theirKey, MYKEY:myKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => effector.setNumMemory(importantWords[MYKEY], e.getNumMemory(importantWords[THEIRKEY])));
  }

}