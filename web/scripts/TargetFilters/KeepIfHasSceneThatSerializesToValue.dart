import '../Entity.dart';
import '../Scene.dart';
import '../SentientObject.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfHasSceneThatSerializesToValue extends TargetFilter {
  static String INPUTVALUE="sceneDataString";
  @override
  String type ="KeepIfHasSceneThatMatchesValue";
  @override
  String explanation = "Target has a scene that matches an input scene datastring. ";
  //name cannot be forgotten or changed. we can copy it to the memory store sure, but this is a True Name kind of deal.
  KeepIfHasSceneThatSerializesToValue(String inputValue) : super(<String,String>{INPUTVALUE:inputValue}, <String,num>{});
  @override
  bool conditionForKeep(SentientObject actor, SentientObject possibleTarget) {
    for(Scene s in possibleTarget.readOnlyScenes) {
      final Scene comparison = new Scene.fromDataString(importantWords[INPUTVALUE]);
      if(s.toDataString() == comparison.toDataString()) {
        return true;
      }
    }
    return false;
  }
  @override
  TargetFilter makeNewOfSameType() => new KeepIfHasSceneThatSerializesToValue(null);

}