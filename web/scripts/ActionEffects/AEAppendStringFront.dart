import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendStringFront extends ActionEffect {
  static const String STORAGEKEY = "storageKey";
  static const String STRINGKEY = "stringToAppend";

  AEAppendStringFront(memoryKey, stringToAppend) : super(<String,String>{STORAGEKEY:memoryKey, STRINGKEY:stringToAppend}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(importantWords[STORAGEKEY]);
      oldValue ??="";
      e.setStringMemory(importantWords[STORAGEKEY],"${importantWords[STRINGKEY]}}$oldValue");
    }
  }

}