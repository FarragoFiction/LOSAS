import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendString extends ActionEffect {
  static const String STORAGEKEY = "myMemoryKeyForResultAndStorage";
  static const String STRINGKEY = "yourMemoryKeyToAdd";
  AEAppendString(storageKey, stringKey) : super(<String,String>{STORAGEKEY:storageKey, STRINGKEY:stringKey}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(importantWords[STORAGEKEY]);
      oldValue ??="";
      e.setStringMemory(importantWords[STORAGEKEY],"$oldValue${importantWords[STRINGKEY]}}");
    }
  }

}