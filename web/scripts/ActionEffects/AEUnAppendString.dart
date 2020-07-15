import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEUnAppendString extends ActionEffect {
  static const String STOREDSTRING = "storedString";
  static const String STRINGTOAPPEND = "stringToUnAppend";
  @override
  List<String> get knownKeys => [importantWords[STOREDSTRING]];

  @override
  String type ="UnAppendString";
  @override
  String explanation = "Provide a word or phrase to remove entirely from a stored value at a given key.";


  AEUnAppendString(String storedString,String stringToUnAppend) : super(<String,String>{STOREDSTRING:storedString, STRINGTOAPPEND:stringToUnAppend}, {});
  @override
  ActionEffect makeNewOfSameType() => new AEUnAppendString(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    for(final SentientObject e in entities) {
      String oldValue = e.getStringMemory(importantWords[STOREDSTRING]);
      oldValue ??="";
      String newValue = oldValue.replaceAll(importantWords[STRINGTOAPPEND],"");
      e.setStringMemory(importantWords[STOREDSTRING],newValue);
    }
  }

}