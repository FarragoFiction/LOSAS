import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AESetNum extends ActionEffect {
  static const String KEY = "memoryKey";
  static const String NUM = "num";
  @override
  List<String> get knownKeys => [importantWords[KEY]];

  @override
  String type ="SetNum";
  @override
  String explanation = "Provide a number value to store in the targets memory at a specific key.";

  AESetNum(String key,num number) : super({KEY:key}, {NUM:number});
  @override
  ActionEffect makeNewOfSameType() => new AESetNum(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => e.setNumMemory(importantWords[KEY], importantNumbers[NUM]));
  }

}