import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendString extends ActionEffect {
  static const String STORAGEKEY = "storageKey";
  static const String STRINGKEY = "stringToAppend";
  AEAppendString(storageKey, stringToAppend) : super(<String,String>{STORAGEKEY:storageKey, STRINGKEY:stringToAppend}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(importantWords[STORAGEKEY]);
      oldValue ??="";
      e.setStringMemory(importantWords[STORAGEKEY],"$oldValue${importantWords[STRINGKEY]}}");
    }
  }

}