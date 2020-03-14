import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class TFNumIsGreaterThanValue extends TargetFilter {

  TFNumIsGreaterThanValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num currentValue = possibleTarget.getNumMemory(importantWord);
    if(currentValue == null) return false; //filter me i don't even have this
    return currentValue >= importantNum;
  }

}