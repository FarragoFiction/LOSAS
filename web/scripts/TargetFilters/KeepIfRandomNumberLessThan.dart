import 'package:CommonLib/Random.dart';

import '../Entity.dart';
import 'TargetFilter.dart';

//random number is between 0 and 1, so if you pick more than 1 you're being redundant
class KeepIfRandomNumberLessThan extends TargetFilter {
  @override
  String type ="KeepIfRandomNumberLessThan";
  @override
  String explanation = "Generate a random number between 0 and 1 for each targetable entity. If the number for an entity is less than the supplied number target them";
  KeepIfRandomNumberLessThan(String importantWord, num importantNum) : super(importantWord, importantNum);

  @override
  bool conditionForKeep(Entity actor, Entity possibleTarget) {
    Random rand = possibleTarget.scenario.rand;
    return rand.nextDouble() <= importantNum;
  }

}