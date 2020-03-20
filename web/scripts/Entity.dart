/*
    TODO entities have string and int memory
    they have scenes and introscenes
    they have generators
    they have a dollstring and an originalDollString

 */
import 'package:CommonLib/Random.dart';

import 'Generator.dart';
import 'Scenario.dart';
import 'Scene.dart';

class Entity {
    //TODO most chars will be generated randomly but if someone wants to say "i made this" sure why not
    String author;
    String name;
    Scenario scenario;
    Random get rand => scenario.rand;
    Map<String,String> _stringMemory = new Map<String,String>();
    Map<String,dynamic> get debugMemory => new Map<String,dynamic>.from(_stringMemory)..addAll(_numMemory);
    Map<String,num> _numMemory = new Map<String, num>();
    //a generator will create a value for a given key and store it in either string memory or num memory based on what it is.
    Map<String, List<Generator>> _generators = new Map<String, List<Generator>>();
    bool isActive = false;
    //once active, these will be checked each tick
    List<Scene> _scenes = new List<Scene>();
    //before activation, these will be checked each tick, will activate once fired, you don't need to do this explicitly
    List<Scene> _activationScenes = new List<Scene>();

    List<Scene> get readOnlyScenes => _scenes;
    List<Scene> get readOnlyActivationScenes => _activationScenes;

    Entity(this.name) {
        setStringMemory("name",this.name);
    }

    @override
    String toString() {
        return name;
    }

    void addGenerator(Generator generator) {
        if(_generators.containsKey(generator.key)){
            _generators[generator.key].add(generator);
        }else{
            _generators[generator.key] = <Generator>[generator];
        }
    }

    void generateStringValueForKey(Random rand, String key, String defaultValue){
        if(_generators.containsKey(key)){
            setStringMemory(key,rand.pickFrom(_generators[key]).generateValue(rand));
        }else{
           setStringMemory(key, defaultValue);
        }
    }

    void generateNumValueForKey(Random rand, String key, num defaultValue){
        if(_generators.containsKey(key)){
            setNumMemory(key,rand.pickFrom(_generators[key]).generateValue(rand));
        }else{
            setNumMemory(key, defaultValue);
        }
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
                isActive = true;
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
        if(_numMemory.containsKey(key)){
        return _numMemory[key];
        }else{
            return 0; //null isn't a real thing for numbers for display purposes.
        }
    }

    void setNumMemory(String key, num value) {
        _numMemory[key] = value;
    }



}