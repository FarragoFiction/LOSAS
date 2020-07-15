import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AECopyNumFromTarget extends ActionEffect {
  static const String THEIRKEY = "theirNumKey";
  static const String MYKEY = "myStorageKey";
  @override
  List<String> get knownKeys => [importantWords[THEIRKEY], importantWords[MYKEY]];

  @override
  String type ="CopyNumFromTarget";
  @override
  String explanation = "Copies a number from the target(s) to the owner.";

  AECopyNumFromTarget(String theirKey, String myKey) : super(<String,String>{THEIRKEY:theirKey, MYKEY:myKey}, {});
  @override
  ActionEffect makeNewOfSameType() => new AECopyNumFromTarget(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => effector.setNumMemory(importantWords[MYKEY], e.getNumMemory(importantWords[THEIRKEY])));
  }

}