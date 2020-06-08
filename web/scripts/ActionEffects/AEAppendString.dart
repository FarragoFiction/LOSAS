import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendString extends ActionEffect {
  @override
  List<String> get knownKeys => [importantWords[STORAGEKEY]];

  static const String STORAGEKEY = "storageKey";
  static const String STRINGKEY = "stringToAppend";
  @override
  String type ="AppendStringToBack";
  @override
  String explanation = "Provide a word or phrase to add on to the back of whatever is currently in the target(s) memory at the given key.";

  AEAppendString(String storageKey, String stringToAppend) : super(<String,String>{STORAGEKEY:storageKey, STRINGKEY:stringToAppend}, {});

  @override
  ActionEffect makeNewOfSameType() => new AEAppendString(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(importantWords[STORAGEKEY]);
      oldValue ??="";
      e.setStringMemory(importantWords[STORAGEKEY],"$oldValue${importantWords[STRINGKEY]}");
    }
  }

}