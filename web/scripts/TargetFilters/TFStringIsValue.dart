import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class TFStringExists extends TargetFilter {
  String value;

  TFStringExists(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForRemove(Entity actor, Entity possibleTarget) {
    return possibleTarget.getStringMemory(importantWord) != value;
  }

}