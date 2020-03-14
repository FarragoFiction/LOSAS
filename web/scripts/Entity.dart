/*
    TODO entities have string and int memory
    they have scenes and introscenes
    they have generators
    they have a dollstring and an originalDollString

 */
import 'Scene.dart';

class Entity {
    String name;
    Map<String,String> stringMemory = new Map<String,String>();
    Map<String,int> intMemory = new Map<String, int>();
    bool isActive = false;
    //once active, these will be checked each tick
    List<Scene> scenes = new List<Scene>();
    //before activation, these will be checked each tick
    List<Scene> activationScenes = new List<Scene>();

    Entity(this.name);

}