import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEAddNumFromYourMemory extends ActionEffect {
  @override
  List<String> get knownKeys => [importantWords[RESULTNUM], importantWords[ADDOR]];

  static const String RESULTNUM = "myMemoryKeyForFirstAddorAndStorage";
  static const String ADDOR = "yourMemoryKeyToAdd";
  @override
  String type ="AddNumFromTargetToExisting";
  @override
  String explanation = "Grab a number from the target(s) memory to add to a stored value in the owners memory and store it in the target(s).";

  AEAddNumFromYourMemory(String result,String addor) : super(<String,String>{RESULTNUM:result, ADDOR:addor}, {});

  @override
  ActionEffect makeNewOfSameType() => new AEAddNumFromYourMemory(null,null);

  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    for(SentientObject e in entities) {
      num oldValue = e.getNumMemory(importantWords[RESULTNUM]);
      num toAdd = e.getNumMemory(importantWords[ADDOR]);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantWords[RESULTNUM],oldValue + toAdd);
    }
  }

}