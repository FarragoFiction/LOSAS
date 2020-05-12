import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringToTarget extends ActionEffect {
    static const String THEIRKEY = "theirStringKey";
    static const String MYKEY = "myStorageKey";
    @override
    String type ="CopyStringToTarget";
    @override
    String explanation = "Copies a word or phrase from the owner to the target(s).";
    AECopyStringToTarget(String myKey, String theirKey) : super({THEIRKEY:theirKey, MYKEY:myKey}, {});
    @override
    ActionEffect makeNewOfSameType() => new AECopyStringToTarget(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      entities.forEach((Entity e) => e.setStringMemory(importantWords[THEIRKEY], effector.getStringMemory(importantWords[MYKEY])));
  }

}