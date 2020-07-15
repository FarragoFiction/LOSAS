import '../Entity.dart';
import 'ActionEffect.dart';
import '../SentientObject.dart';

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
  void effectEntities(SentientObject effector, List<SentientObject> entities) {
    entities.forEach((SentientObject e) => (e is Entity) ? e.restoreDollToOriginal() : null);
  }

}