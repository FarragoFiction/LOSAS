import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class TFNumIsValue extends TargetFilter {
  num value;

  TFNumIsValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num currentValue = possibleTarget.getNumMemory(importantWord);
    if(currentValue == null) return true;
    print("comparing $currentValue and $importantNum ${currentValue == importantNum}");
    return currentValue == importantNum;
  }

}