import '../Entity.dart';
import '../SentientObject.dart';
import 'ActionEffect.dart';

class AEUnSetString extends ActionEffect {
    static const String KEY = "memoryKey";
    @override
    List<String> get knownKeys => [importantWords[KEY]];

    @override
    String type ="UnsetString";
    @override
    String explanation = "Remove a key entirely from string memory.";
    AEUnSetString(String key) : super({KEY:key},{});
    @override
    ActionEffect makeNewOfSameType() => new AEUnSetString(null);

    @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => e.removeStringMemoryKey(importantWords[KEY]));
  }

}