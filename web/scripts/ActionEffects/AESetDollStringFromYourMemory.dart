import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AESetDollStringFromYourMemory extends ActionEffect {
    static const String SHAREDKEY = "memoryKey";
    @override
    List<String> get knownKeys => [importantWords[SHAREDKEY]];

    @override
    String type ="SetDollStringFromYourMemory";
    @override
    String explanation = "Sets the targets current dollstring based on the value of a given memory key belonging to the target.";
    AESetDollStringFromYourMemory(String sharedKey) : super({SHAREDKEY:sharedKey}, {});
    @override
    ActionEffect makeNewOfSameType() => new AESetDollStringFromYourMemory(null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.setNewDoll(e.getStringMemory(importantWords[SHAREDKEY])) : null);
  }

}