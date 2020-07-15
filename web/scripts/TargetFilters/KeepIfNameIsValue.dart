import '../Entity.dart';
import 'TargetFilter.dart';
import '../SentientObject.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNameIsValue extends TargetFilter {
  static String INPUTVALUE="inputValue";
  @override
  String type ="KeepIfNameIsValue";
  @override
  String explanation = "Target's name matches input value";
  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfNameIsValue(String inputValue) : super(<String,String>{INPUTVALUE:inputValue}, <String,num>{});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    return possibleTarget.name  == importantWords[INPUTVALUE];
  }
  @override
  TargetFilter makeNewOfSameType() => new KeepIfNameIsValue(null);

}