import '../Entity.dart';
import 'TargetFilter.dart';
import '../SentientObject.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringExists extends TargetFilter {
  static String MEMORYKEY="memoryKey";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];
  @override
  String type ="KeepIfStringExists";
  @override
  String explanation = "If the target has a word or phrase stored to a given key (regardless of what the word or phrase is).";


  KeepIfStringExists(String memoryKey) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{});

  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    return possibleTarget.getStringMemory(importantWords[MEMORYKEY]) != null;
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfStringExists(null);

}