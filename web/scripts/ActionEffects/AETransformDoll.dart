import '../Entity.dart';
import 'ActionEffect.dart';

class AETransformDoll extends ActionEffect {
    @override
    List<String> get knownKeys => [];

    @override
    String type ="TransformDoll";
    @override
    String explanation = "Some doll types can transform/hatch into others (such as grubs growing up, or magical girls becoming monsters). If this is called on a target without the ability to transform, nothing happens.";
    AETransformDoll(String sharedKey) : super({}, {});
    @override
    ActionEffect makeNewOfSameType() => new AETransformDoll(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.hatch());
  }

}