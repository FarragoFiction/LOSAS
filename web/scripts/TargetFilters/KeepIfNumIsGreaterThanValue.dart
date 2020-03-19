import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValue extends TargetFilter {

  KeepIfNumIsGreaterThanValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    final num currentValue = possibleTarget.getNumMemory(importantWord);
    print("The filter KeepIfNumIsGreaterThanValue is going for target $possibleTarget, but their value for $importantWord is $currentValue");
    if(currentValue == null) return false; //filter me i don't even have this
    return currentValue >= importantNum;
  }

}