import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringExists extends TargetFilter {
  KeepIfStringExists(String importantWord, num importantNum) : super(importantWord, importantNum);

  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getStringMemory(importantWord) != null;
  }

}