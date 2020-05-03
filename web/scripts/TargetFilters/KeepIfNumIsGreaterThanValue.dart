import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValue extends TargetFilter {
  @override
  String type ="KeepIfNumIsGreaterThanValue";
  @override
  String explanation = "If the target has a number stored to a given key, and its bigger than a supplied value";
  KeepIfNumIsGreaterThanValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    final num currentValue = possibleTarget.getNumMemory(importantWord);
    if(currentValue == null) return false; //filter me i don't even have this
    return currentValue > importantNum;
  }

}