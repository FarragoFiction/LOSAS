import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringIsValue extends TargetFilter {
  @override
  String type ="KeepIfStringExists";
  @override
  String explanation = "If the target has a word or phrase stored to a given key (regardless of what the word or phrase is).";


  String value;

  KeepIfStringIsValue(String importantWord, this.value, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getStringMemory(importantWord) == value;
  }

}