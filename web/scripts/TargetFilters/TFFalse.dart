import '../Entity.dart';
import 'TargetFilter.dart';

//essentially a test condition, but could use it for bullshit.
class TFFalse extends TargetFilter {
  @override
  bool conditionForFilter(Entity actor, Entity possibleTarget) {
    return false;
  }

}