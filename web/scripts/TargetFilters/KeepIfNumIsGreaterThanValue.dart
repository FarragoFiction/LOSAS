import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValue extends TargetFilter {

  KeepIfNumIsGreaterThanValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    final num currentValue = possibleTarget.getNumMemory(importantWord);
    if(currentValue == null) return false; //filter me i don't even have this
    return currentValue >= importantNum;
  }

}