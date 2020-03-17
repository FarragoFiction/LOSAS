import '../Entity.dart';
import 'ActionEffect.dart';

class AECopyStringToTarget extends ActionEffect {
    String myKey;
    AECopyStringToTarget(String this.myKey, String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
      print("I am trying to put ${effector.getStringMemory(myKey)} into my targets. from key $myKey");
      entities.forEach((Entity e) => e.setStringMemory(importantString, effector.getStringMemory(myKey)));
  }

}