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
    List<Scene> scenes = new List<Scene>();
    //before activation, these will be checked each tick
    List<Scene> activationScenes = new List<Scene>();

    @override
    String toString() {
        return name;
    }

    //if no scene can be performed, thems the breaks kids
    Scene performScene(List<Entity> everyone) {
        for(Scene scene in scenes) {
            if(scene.checkIfActivated(everyone)){
                return scene;
            }
        }
    }

    String debugString() {
        return "Entity Name: $name, Memory: $debugMemory, Scenes: ${scenes.map((Scene s)=> s.debugString())}";
    }

    Scene checkForActivationScenes(List<Entity> everyone) {
        for(Scene scene in activationScenes) {
            if(scene.checkIfActivated(everyone)){
                return scene;
            }
        }
    }

    String getStringMemory(String key) {
        return _stringMemory[key];
    }

    String removeStringMemoryKey(String key) {
        return _stringMemory.remove(key);
    }

    void setStringMemory(String key, String value) {
        _stringMemory[key] = value;
    }

    num getNumMemory(String key) {
        return _numMemory[key];
    }

    void setNumMemory(String key, num value) {
        _numMemory[key] = value;
    }

    Entity(this.name);

}