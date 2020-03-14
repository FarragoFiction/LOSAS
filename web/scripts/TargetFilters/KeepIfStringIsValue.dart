import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfStringIsValue extends TargetFilter {
  String value;

  KeepIfStringIsValue(String importantWord, this.value, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getStringMemory(importantWord) == value;
  }

}