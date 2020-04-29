import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumToTarget extends ActionEffect {
  static const String THEIRKEY = "theirStorageKey";
  static const String MYKEY = "myNumKey";
  @override
  String type ="CopyNumToTarget";
  @override
  String explanation = "Copies a number from the owner to the target(s).";

  AECopyNumToTarget(String myKey, String theirKey) : super(<String,String>{THEIRKEY:theirKey, MYKEY:myKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.setNumMemory(importantWords[THEIRKEY], effector.getNumMemory(importantWords[MYKEY])));
  }

}