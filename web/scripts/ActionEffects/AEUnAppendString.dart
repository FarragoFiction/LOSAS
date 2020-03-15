import '../Entity.dart';
import 'ActionEffect.dart';

class AEUnAppendString extends ActionEffect {
  String value;
  AEUnAppendString(this.value,String importantString, num importantNum) : super(importantString, importantNum);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    for(final Entity e in entities) {
      String oldValue = e.getStringMemory(value);
      oldValue ??="";
      String newValue = oldValue.replaceAll(importantString,"");
      e.setStringMemory(value,newValue);
    }
  }

}