import '../Entity.dart';
import 'TargetFilter.dart';
import '../SentientObject.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringContainsValue extends TargetFilter {
  static String MEMORYKEY = "memorykey";
  static String INPUTVALUE = "inputvalue";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];

  @override
  String type ="KeepIfStringContainsValue";
  @override
  String explanation = "If the target has a word or phrase stored to a given key, and it contains the supplied value";

  String value;

  KeepIfStringContainsValue(String memoryKey, String inputValue) : super(<String,String>{MEMORYKEY:memoryKey, INPUTVALUE: inputValue}, <String,num>{});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    String currentValue = possibleTarget.getStringMemory(importantWords[MEMORYKEY]);
    if(currentValue == null) return false;
    return currentValue.toLowerCase().contains(importantWords[INPUTVALUE].toLowerCase());
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfStringContainsValue(null,null);

}