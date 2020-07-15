import '../Entity.dart';
import '../Generator.dart';
import '../Prepack.dart';
import '../SentientObject.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfHasPrepack extends TargetFilter {
  static String INPUTVALUE="PrepackDataString";

  @override
  String type ="KeepIfHasPrepack";
  @override
  String explanation = "If the target has all scenes and generators from this prepack (datastring accepted only, not archive image).";


  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfHasPrepack(String inputValue) : super(<String,String>{INPUTVALUE:inputValue}, <String,num>{});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    Prepack p = Prepack.fromDataString(importantWords[INPUTVALUE]);
    return possibleTarget is Entity? possibleTarget.hasPrepack(p):false;
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfHasPrepack(null);

}