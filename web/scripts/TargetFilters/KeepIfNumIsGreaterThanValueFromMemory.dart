import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class KeepIfNumIsGreaterThanValueFromMemory extends TargetFilter {
static String MEMORYKEYLEFT="memoryKeyLeft";
static String MEMORYKEYRIGHT="memorykeyRight";
@override
List<String> get knownKeys => [importantWords[MEMORYKEYRIGHT], importantWords[MEMORYKEYLEFT]];

String type ="KeepIfNumIsGreaterThanValueFromMemory";
@override
String explanation = "If the target has a number stored to a given key (left), and its bigger than a value stored in a different key (right)";
  KeepIfNumIsGreaterThanValueFromMemory(String memoryKeyLeft, String memoryKeyRight) : super(<String,String>{MEMORYKEYLEFT:memoryKeyLeft, MEMORYKEYRIGHT: memoryKeyRight}, <String,num>{});
  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    num left = possibleTarget.getNumMemory(importantWords[MEMORYKEYLEFT]);
    num right = possibleTarget.getNumMemory(importantWords[MEMORYKEYRIGHT]);
    left ??=0;
    right ??=0;
    return left > right;
  }


@override
TargetFilter makeNewOfSameType() => new KeepIfNumIsGreaterThanValueFromMemory(null,null);

}