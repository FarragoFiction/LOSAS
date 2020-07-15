import '../Entity.dart';
import 'TargetFilter.dart';
import '../SentientObject.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringIsValue extends TargetFilter {
  static String MEMORYKEY = "memorykey";
  static String INPUTVALUE = "inputvalue";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];

  @override
  String type ="KeepIfStringIsValue";
  @override
  String explanation = "If the target has a word or phrase stored to a given key (regardless of what the word or phrase is).";

  KeepIfStringIsValue(String memoryKey, String inputValue) : super(<String,String>{MEMORYKEY:memoryKey, INPUTVALUE: inputValue}, <String,num>{});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    return possibleTarget.getStringMemory(importantWords[MEMORYKEY]) == importantWords[INPUTVALUE];
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfStringIsValue(null,null);

}