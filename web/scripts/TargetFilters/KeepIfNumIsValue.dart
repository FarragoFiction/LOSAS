import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsValue extends TargetFilter {
  static String MEMORYKEY = "memorykey";
  static String INPUTVALUE = "inputvalue";
  @override
  String type ="KeepIfNumIsValue";
  @override
  String explanation = "If the target has a number stored to a given key, and its equal to a supplied value";



  KeepIfNumIsValue(String memoryKey, num inputValue) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{INPUTVALUE: inputValue});
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num currentValue = possibleTarget.getNumMemory(importantWords[MEMORYKEY]);
    if(currentValue == null) {
        return false;
    }
    return currentValue == importantNumbers[INPUTVALUE];
  }

}