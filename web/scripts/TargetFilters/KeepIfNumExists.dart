import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumExists extends TargetFilter {
  static String MEMORYKEY="memorykey";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];
  @override
  String type ="KeepIfNumExists";
  @override
  String explanation = "Keep if target knows about a number (its non zero) with a given key.";
  KeepIfNumExists(String memoryKey) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{});

  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    return possibleTarget.getNumMemory(importantWords[MEMORYKEY]) != 0;
  }

  @override
  TargetFilter makeNewOfSameType() => new KeepIfNumExists(null);

}