import '../Entity.dart';
import 'ActionEffect.dart';

class AEUnAppendString extends ActionEffect {
  static const String STOREDSTRING = "storedString";
  static const String STRINGTOAPPEND = "stringToUnAppend";
  @override
  String type ="UnAppendString";
  @override
  String explanation = "Provide a word or phrase to remove entirely from a stored value at a given key.";


  AEUnAppendString(String storedString,String stringToUnAppend) : super(<String,String>{STOREDSTRING:storedString, STRINGTOAPPEND:stringToUnAppend}, {});
  @override
  ActionEffect makeNewOfSameType() => new AEUnAppendString(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(importantWords[STOREDSTRING]);
      oldValue ??="";
      String newValue = oldValue.replaceAll(importantWords[STRINGTOAPPEND],"");
      e.setStringMemory(importantWords[STOREDSTRING],newValue);
    }
  }

}