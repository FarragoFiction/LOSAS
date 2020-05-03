import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsValue extends TargetFilter {
  @override
  String type ="KeepIfNumIsValue";
  @override
  String explanation = "If the target has a number stored to a given key, and its equal to a supplied value";


  num value;

  KeepIfNumIsValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num currentValue = possibleTarget.getNumMemory(importantWord);
    if(currentValue == null) {
        print("Warning: Are you SURE you want to ask for $importantWord? It's not set for $possibleTarget...");
        return false;
    }
    return currentValue == importantNum;
  }

}