import '../Entity.dart';
import 'ActionEffect.dart';

class AEAppendString extends ActionEffect {
  String value;
  AEAppendString(this.value,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(value);
      oldValue ??="";
      e.setStringMemory(value,"$oldValue$importantString");
    }
  }

}