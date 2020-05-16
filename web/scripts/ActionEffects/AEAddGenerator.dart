import '../Entity.dart';
import '../Generator.dart';
import '../Scene.dart';
import 'ActionEffect.dart';

class AEAddGenerator extends ActionEffect {
    static const String INPUTVALUE = "generatorDataString";

    @override
    String type ="AddGenerator";
    @override
    String explanation = "Adds a generator's datastring to the key it encodes.";
    AEAddGenerator(String inputValue) : super({INPUTVALUE:inputValue}, {});
    @override
    ActionEffect makeNewOfSameType() => new AEAddGenerator(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.addGenerator(Generator.fromDataString((importantWords[INPUTVALUE]))));
  }

}