import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumExists extends TargetFilter {
  KeepIfNumExists(String importantWord, num importantNum) : super(importantWord, importantNum);

  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getNumMemory(importantWord) != null;
  }

}