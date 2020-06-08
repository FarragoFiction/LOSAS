import '../Entity.dart';
import 'ActionEffect.dart';

class AEAddNumFromMyMemory extends ActionEffect {
  @override
  List<String> get knownKeys => [importantWords[RESULTNUM], importantWords[ADDOR]];

  static const String RESULTNUM = "yourMemoryKeyForFirstAddorAndStorage";
  static const String ADDOR = "myMemoryKeyToAdd";
  @override
  String type ="AddMyNumToTargetNum";
  String explanation = "Grab a number from the owners memory to add to a stored value in the target(s) memory and store it in the target(s).";

  AEAddNumFromMyMemory(String result, String addor) : super(<String,String>{RESULTNUM:result, ADDOR:addor}, {});

  @override
  ActionEffect makeNewOfSameType() => new AEAddNumFromMyMemory(null,null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(Entity e in entities) {
      num oldValue = e.getNumMemory(importantWords[RESULTNUM]);
      num toAdd = effector.getNumMemory(importantWords[ADDOR]);
      oldValue ??=0;
      toAdd ??=0;
      e.setNumMemory(importantWords[RESULTNUM],oldValue + toAdd);
    }
  }

}