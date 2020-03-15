/*
    TODO entities have string and int memory
    they have scenes and introscenes
    they have generators
    they have a dollstring and an originalDollString

 */
import 'Scene.dart';

class Entity {
    String name;
    Map<String,String> _stringMemory = new Map<String,String>();
    Map<String,dynamic> get debugMemory => new Map<String,dynamic>.from(_stringMemory)..addAll(_numMemory);
    Map<String,num> _numMemory = new Map<String, int>();
    bool isActive = false;
    //once active, these will be checked each tick
    List<Scene> _scenes = new List<Scene>();
    //before activation, these will be checked each tick
    List<Scene> _activationScenes = new List<Scene>();

    List<Scene> get readOnlyScenes => _scenes;
    List<Scene> get readOnlyActivationScenes => _activationScenes;

    @override
    String toString() {
        return name;
    }

    void addScene(Scene scene) {
        scene.owner = this;
        _scenes.add(scene);
    }

    void addActivationScene(Scene scene) {
        scene.owner = this;
        _activationScenes.add(scene);
    }

    //if no scene can be performed, thems the breaks kids
    Scene performScene(List<Entity> everyone) {
        for(Scene scene in _scenes) {
            if(scene.checkIfActivated(everyone)){
                return scene;
            }
        }
    }

    String debugString() {
        return "Entity Name: $name, Memory: $debugMemory, Scenes: ${_scenes.map((Scene s)=> s.debugString())}";
    }

    Scene checkForActivationScenes(List<Entity> everyone) {
        for(Scene scene in _activationScenes) {
            if(scene.checkIfActivated(everyone)){
                return scene;
            }
        }
    }

    String getStringMemory(String key) {
        key.replaceAll(" ","");
        return _stringMemory[key];
    }

    String removeStringMemoryKey(String key) {
        key.replaceAll(" ","");
        return _stringMemory.remove(key);
    }

    void setStringMemory(String key, String value) {
        key.replaceAll(" ","");
        _stringMemory[key] = value;
    }

    num getNumMemory(String key) {
        key.replaceAll(" ","");
        return _numMemory[key];
    }

    void setNumMemory(String key, num value) {
        key.replaceAll(" ","");
        _numMemory[key] = value;
    }

    Entity(this.name);

}