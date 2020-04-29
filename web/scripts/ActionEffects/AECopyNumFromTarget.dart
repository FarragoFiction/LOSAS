import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyNumFromTarget extends ActionEffect {
  static const String THEIRKEY = "theirNumKey";
  static const String MYKEY = "myStorageKey";
  @override
  String type ="CopyNumFromTarget";
  @override
  String explanation = "Copies a number from the target(s) to the owner.";

  AECopyNumFromTarget(String theirKey, String myKey) : super(<String,String>{THEIRKEY:theirKey, MYKEY:myKey}, {});
  @override
  ActionEffect makeNewOfSameType() => new AECopyNumFromTarget(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => effector.setNumMemory(importantWords[MYKEY], e.getNumMemory(importantWords[THEIRKEY])));
  }

}