import 'dart:html';

import 'package:CommonLib/Random.dart';

import 'Entity.dart';
import 'Game.dart';
import 'Scenario.dart';
import 'Scene.dart';

class ScenarioRunner {
    int seed;
    GameUI game;
    Scenario scenario;
    //seriously if NOTHING HAPPENS for 13 ticks in a row, lets just call it
    int numberTriesForScene = 0;
    int maxNumberTriesForScene = 13;

    bool theEnd = false;
    List<Scene> get frameScenes => scenario.frameScenes;
    List<Scene> get stopScenes => scenario.stopScenes;

    Random rand;

    List<Entity> _entities = new List<Entity>();
    List<Entity> get entitiesReadOnly  => _entities;

    //the person in the spotlight is on screen right now
    Entity spotLightEntity;
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntitiesReadOnly => _entities.where((Entity entity) =>entity.isActive).toList();

    ScenarioRunner(Scenario this.scenario, this.seed) {
        rand = new Random(seed);
    }

    void curtainsUp(Element parent) {
        print("curtains are going up");
        game = new GameUI(scenario);
        print("made a new game");
        game.setup(parent);
        initializeEntities();
        print("setup the game");
        lookForNextScene();
        print("looked for a scene");
    }

    void initializeEntities() {
        _entities.forEach((Entity e) => e.processPrepacks(rand));
    }

    void addEntity(Entity entity) {
        _entities.add(entity);
        entity.scenario = scenario;
    }

    void debugScenario() {
        entitiesReadOnly.forEach((Entity e)=> print(e.debugString()));
    }

    //if no scenes trigger, no introduction
    Scene getIntroduction() {
        for(final Scene scene in frameScenes) {
            final bool active = scene.checkIfActivated(activeEntitiesReadOnly);
            if(active){
                return  scene;
            }
        }
        return null;
    }


    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    //first you check all your entities
    //then you check your stop scenes
    //then you repeat
    void lookForNextScene() {
        if(theEnd) return;
        game.readyForNextScene = false;
        if(game.sceneElements.length == 0){
            Scene introduction = getIntroduction();
            if(introduction != null) {
                game.showScene(introduction);
                return;
            }
        }
        //could be some amount of randomness baked in
        if(numberTriesForScene > maxNumberTriesForScene) {
            window.alert("something has gone wrong, went $numberTriesForScene loops without anything happening");
        }
        Scene spotlightScene;
        List<Entity> entitiesToCheck = null;
        if(spotLightEntity != null) {
            entitiesToCheck = entitiesReadOnly.sublist(entitiesReadOnly.indexOf(spotLightEntity)+1);
        }else {
            //every time we get to the start of entities, we shuffle so its not so samey
            _entities.shuffle(rand);
            entitiesToCheck = entitiesReadOnly;
        }
        spotlightScene = checkEntitiesForScene(entitiesToCheck);
        if(spotlightScene != null) {
            game.showScene(spotlightScene);
        }else {
            print("Time to check stop scenes");
            spotlightScene = checkStopScenes();
            if(spotlightScene == null) {
                numberTriesForScene ++;
                spotLightEntity = null;
                lookForNextScene();
            }else {
                theEnd = true;
                game.showScene(spotlightScene);
            }
        }
    }

    Scene checkStopScenes() {
        for(final Scene scene in stopScenes) {
            scene.scenario ??=scenario;
            print("checking stop scene $scene with activeEntities $activeEntitiesReadOnly, btw the scene has these filters ${scene.targetFilters}");
            final bool active = scene.checkIfActivated(activeEntitiesReadOnly);
            print("was the stop scene activated: $active, the targets are ${scene.finalTargets}");
            if(active){
                return  scene;
            }
        }
        return null;
    }

    Scene checkEntitiesForScene(List<Entity> entitiesToCheck) {
        Scene ret;
        for(final Entity e in entitiesToCheck) {
            if(e.isActive) {
                //yes it includes yourself, what if you're gonna buff your party or something
                ret = e.performScene(activeEntitiesReadOnly);
                if(ret != null) {
                    spotLightEntity = e;
                    ret.scenario ??=scenario;
                    return ret;
                }
            }else{
                ret = e.checkForActivationScenes(activeEntitiesReadOnly);
                if(ret != null) {
                    spotLightEntity = e;
                    ret.scenario ??=scenario;
                    return ret;
                }
            }
        }
        return null;
    }



}