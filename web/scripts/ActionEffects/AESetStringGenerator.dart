import '../Entity.dart';
import 'ActionEffect.dart';

class AESetStringGenerator extends ActionEffect {
    static const String GENERATORKEY = "generatorKey";
    static const String DEFAULTVALUE = "defaultValue";
    AESetStringGenerator(String generatorKey, String defaultValue) : super(<String,String>{GENERATORKEY:generatorKey, DEFAULTVALUE:defaultValue}, {});

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.generateStringValueForKey(effector.rand,importantWords[GENERATORKEY], importantWords[DEFAULTVALUE]));
  }

}