import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumExists extends TargetFilter {
  @override
  String type ="KeepIfNumExists";
  @override
  String explanation = "Keep if target knows about a number with a given key.";
  KeepIfNumExists(String importantWord, num importantNum) : super(importantWord, importantNum);

  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getNumMemory(importantWord) != 0;
  }

}