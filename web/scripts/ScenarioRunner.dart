import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

import 'Entity.dart';
import 'Game.dart';
import 'Prepack.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'SentientObject.dart';

class ScenarioRunner {
    int _seed;
    int get seed => _seed;
    set seed(int value) {
        _seed = value;
        rand = new Random(seed);
    }
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
    SentientObject spotLightEntity;
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntitiesReadOnly => _entities.where((Entity entity) =>entity.isActive).toList();

    ScenarioRunner(Scenario this.scenario, this._seed) {
        rand = new Random(seed);
    }

    void curtainsUp(Element parent) {
        print("curtains are going up");
        game = new GameUI(scenario);
        print("made a new game");
        game.setup(parent);
        Scene.attachDebugElement(parent, scenario, "test");
        print("setup the game");
        lookForNextScene();
        print("looked for a scene");
    }

    void batshitchars() {
        Random rand = new Random(seed);
        int numberChars = rand.nextInt(13)+1;
        for(int i = 0; i<numberChars; i++) {
            addEntity(spawnOneBatShitChar(rand));
        }
        _entities.first.isActive = true;


    }

    Entity spawnOneBatShitChar(Random rand) {
        Doll doll = new PigeonDoll(); //if a prepack doesn't do any overriding, this is just what the doll defaults to.
        doll.rand = scenario.rand;
        doll.randomize();
        Entity ret = new Entity(doll.dollName,[],scenario.rand.nextInt(), doll.toDataBytesX());
        ret.scenario = scenario;
        int numberTraits = rand.nextInt(3)+1;
        Set<Prepack> traits = new Set<Prepack>();
        for(int i = 0; i<numberTraits; i++) {
            //COPY the prepack, otherwise shit gets weird ( a scene can only be owned by one char), good catch by wizzardlylogger
            traits.add(Prepack.fromDataString(rand.pickFrom(scenario.prepacks).toDataStringWithoutImage()));
        }
        ret.prepacks.addAll(traits);
        if(rand.nextBool()) ret.isActive = true;
        ret.init();
        return ret;
    }


    void addEntity(Entity entity, [index]) {
        if(index != null) {
            _entities.insert(index,entity);
        }else {
            _entities.add(entity);
        }
        entity.scenario = scenario;
    }

    void removeEntity(Entity entity) {
        _entities.remove(entity);
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
            window.alert("something has gone wrong, went $numberTriesForScene loops without anything happening. There were ${activeEntitiesReadOnly.length} active entities.");
            theEnd = true;
            return;
        }
        Scene spotlightScene;
        final List<SentientObject> entitiesToCheck = getEntitiesToCheck();
        spotlightScene = checkEntitiesForScene(entitiesToCheck);
        if(spotlightScene != null) {
            game.showScene(spotlightScene);
        }else {
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

    List<SentientObject> getEntitiesToCheck() {
        print("making entity list spotLightEntity is $spotLightEntity");
        List<SentientObject> entitiesToCheck;
        //if an actual entity was picked, grab everything after them in the list
      if(spotLightEntity != null && spotLightEntity is Entity) {
          print("grabbbing everything after $spotLightEntity");
          entitiesToCheck = new List<SentientObject>.from(entitiesReadOnly.sublist(entitiesReadOnly.indexOf(spotLightEntity)+1));
      }else if(spotLightEntity != null && !(spotLightEntity is Entity)) { //if it was the scenario, it was first thing, so just pick the actual entities
          entitiesToCheck = new List<SentientObject>.from(entitiesReadOnly);
      }else { //we're starting over, so grab the entity list and shoehorn the scenario at the front of it
          //every time we get to the start of entities, we shuffle so its not so samey
          _entities.shuffle(rand);
          entitiesToCheck = new List<SentientObject>.from(entitiesReadOnly)..insert(0,scenario);
      }
      return entitiesToCheck;
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

    Scene checkEntitiesForScene(List<SentientObject> entitiesToCheck) {
        Scene ret;
        print("checking $entitiesToCheck for scenes");
        for(final SentientObject e in entitiesToCheck) {
            if(!(e is Entity) || (e as Entity).isActive) {
                //yes it includes yourself, what if you're gonna buff your party or something
                ret = e.performScene(activeEntitiesReadOnly, scenario);
                if(ret != null) {
                    spotLightEntity = e;
                    return ret;
                }
            }else if(e is Entity){
                ret = e.checkForActivationScenes(activeEntitiesReadOnly, scenario);
                if(ret != null) {
                    spotLightEntity = e;
                    return ret;
                }
            }
        }
        return null;
    }



}