import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringFromTarget extends ActionEffect {
    static const String THEIRKEY = "theirStorageKey";
    static const String MYKEY = "myStringKey";
    @override
    String type ="CopyStringFromTarget";
    @override
    String explanation = "Copies a word or phrase from the target(s) to the owner.";
    AECopyStringFromTarget(String myKey, String theirKey) : super({THEIRKEY:theirKey, MYKEY:myKey}, {});
    @override
    ActionEffect makeNewOfSameType() => new AECopyStringFromTarget(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      entities.forEach((Entity e) => effector.setStringMemory(importantWords[MYKEY], e.getStringMemory(importantWords[THEIRKEY])));
  }

}