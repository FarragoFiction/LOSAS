import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNameIsValue extends TargetFilter {
  @override
  String type ="KeepIfNameIsValue";
  @override
  String explanation = "Target's name matches input value";
  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfNameIsValue(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.name  == importantWord;
  }

}