import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValue extends TargetFilter {
  static String MEMORYKEY = "memorykey";
  static String INPUTVALUE = "inputvalue";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];
  @override
  String type ="KeepIfNumIsGreaterThanValue";
  @override
  String explanation = "If the target has a number stored to a given key, and its bigger than a supplied value";
  KeepIfNumIsGreaterThanValue(String memoryKey, num inputValue) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{INPUTVALUE:inputValue});
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    final num currentValue = possibleTarget.getNumMemory(importantWords[MEMORYKEY]);
    if(currentValue == null) return false; //filter me i don't even have this
    return currentValue > importantNumbers[INPUTVALUE];
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfNumIsGreaterThanValue(null,null);
}