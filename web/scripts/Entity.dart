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
    Map<String,num> _numMemory = new Map<String, int>();
    bool isActive = false;
    //once active, these will be checked each tick
    List<Scene> scenes = new List<Scene>();
    //before activation, these will be checked each tick
    List<Scene> activationScenes = new List<Scene>();

    String getStringMemory(String key) {
        return _stringMemory[key];
    }

    @override
    String toString() {
        return name;
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