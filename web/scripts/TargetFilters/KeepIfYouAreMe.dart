import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfYouAreMe extends TargetFilter {
  @override
  String type ="KeepIfYouAreMe";
  @override
  String explanation = "If the target is the same as the owner.";


  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfYouAreMe(String importantWord, num importantNum) : super(importantWord, importantNum);
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget== actor;
  }

}