import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendStringFront extends ActionEffect {
  String memoryKey;
  AEAppendStringFront(this.memoryKey,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(memoryKey);
      oldValue ??="";
      e.setStringMemory(memoryKey,"$importantString$oldValue");
    }
  }

}