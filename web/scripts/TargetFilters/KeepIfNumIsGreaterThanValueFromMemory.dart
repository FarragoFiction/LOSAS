import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValueFromMemory extends TargetFilter {
String memoryKey;
  KeepIfNumIsGreaterThanValueFromMemory(String importantWord,String this.memoryKey, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num currentValue = possibleTarget.getNumMemory(importantWord);
    num otherValue = possibleTarget.getNumMemory(memoryKey);
    otherValue ??=0;
    currentValue ??=0;
    return currentValue >= otherValue;
  }

}