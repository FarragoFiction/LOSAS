import '../Entity.dart';
import 'ActionEffect.dart';

class AERestoreDoll extends ActionEffect {
    @override
    List<String> get knownKeys => [];

    @override
    String type ="RestoreDollShitGoBack";
    @override
    String explanation = "All entities remember what their original form had been on simulation start, this restores them to that.";
    AERestoreDoll(String sharedKey) : super({}, {});
    @override
    ActionEffect makeNewOfSameType() => new AERestoreDoll(null);

  @override
  void effectEntities(Entity effector, List<Entity> entities) {
    entities.forEach((Entity e) => e.restoreDollToOriginal());
  }

}