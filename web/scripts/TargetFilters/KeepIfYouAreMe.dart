import '../Entity.dart';
import '../SentientObject.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfYouAreMe extends TargetFilter {
  @override
  String type ="KeepIfYouAreMe";
  @override
  String explanation = "If the target is the same as the owner.";


  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfYouAreMe() : super({}, {});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    return possibleTarget== actor;
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfYouAreMe();

}