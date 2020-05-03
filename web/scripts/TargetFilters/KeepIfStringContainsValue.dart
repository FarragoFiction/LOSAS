import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringContainsValue extends TargetFilter {

  @override
  String type ="KeepIfStringContainsValue";
  @override
  String explanation = "If the target has a word or phrase stored to a given key, and it contains the supplied value";

  String value;

  KeepIfStringContainsValue(String importantWord, this.value, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    String currentValue = possibleTarget.getStringMemory(importantWord);
    if(currentValue == null) return false;
    return currentValue.toLowerCase().contains(value.toLowerCase());
  }

}