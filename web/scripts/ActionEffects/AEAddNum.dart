import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

class AEAddNum extends ActionEffect {
  static const String MEMORYKEY = "memoryKey";
  static const String ADDOR = "numToAdd";
  @override
  List<String> get knownKeys => [importantWords[MEMORYKEY]];

  @override
  String type ="AddNewNumToExisting";
  @override
  String explanation = "Provide a number value to add to a stored value located at a given key for the target(s).";

  AEAddNum(String memoryKey, num addor) : super(<String,String>{MEMORYKEY:memoryKey}, <String,num>{ADDOR:addor});


  @override
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    for(SentientObject e in entities) {
      num oldValue = e.getNumMemory(importantWords[MEMORYKEY]);
      oldValue ??=0;
      e.setNumMemory(importantWords[MEMORYKEY],oldValue + importantNumbers[ADDOR]);
    }
  }

  @override
  ActionEffect makeNewOfSameType() => new AEAddNum(null,null);

}