//what are the base rules of this story? who are the characters? what are the main events? the driving forces?
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

import 'Entity.dart';
import 'Game.dart';
import 'Generator.dart';
import 'Scene.dart';
import 'TargetFilters/KeepIfNumIsGreaterThanValue.dart';
import 'TargetFilters/TargetFilter.dart';
/*
    Scenario List
    SBURB/Farragnarok
    Worm (entities distribute prepacks of powers)
    Hogwartz
    Space Infection
 */
//TODO refactor out all the shit we don't need here into the game class, make scenarios have games, not the other way around.
class Scenario {
    //TODO be able to serialize the scenarios entire current state so you can return to any version of it for time shenanigans
    int seed;
    Game game;
    //TODO let people sign their work
    String author;
    //seriously if NOTHING HAPPENS for 13 ticks in a row, lets just call it
    int numberTriesForScene = 0;
    int maxNumberTriesForScene = 13;

    bool theEnd = false;



    Random rand;

    List<Entity> _entities = new List<Entity>();
    List<Entity> get entitiesReadOnly  => _entities;

    //the person in the spotlight is on screen right now
    Entity spotLightEntity;
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntitiesReadOnly => _entities.where((Entity entity) =>entity.isActive).toList();

    //if ANY of these trigger, then its time to stop ticking
    List<Scene> frameScenes = new List<Scene>();

    //if ANY of these trigger, then its time to stop ticking
    List<Scene> stopScenes = new List<Scene>();
    String name;
    //TODO actually make this a list of possible intros so we can have diff ones depending on what is relevant. (such as commenting on the lack of space/time)
    Scene introduction;

    Scenario(this.name, this.introduction, this.seed) {
        rand = new Random(seed);

    }


    void curtainsUp(Element parent) {
        game = new Game(this);
        game.setup(parent);
        lookForNextScene();
    }

    void addEntity(Entity entity) {
        _entities.add(entity);
        entity.scenario = this;
    }



    void debugScenario() {
        entitiesReadOnly.forEach((Entity e)=> print(e.debugString()));
    }



    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    //first you check all your entities
    //then you check your stop scenes
    //then you repeat
    void lookForNextScene() {
        if(theEnd) return;
        game.readyForNextScene = false;
        if(game.sceneElements.length == 0) {
            game.showScene(introduction);
            return;
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
                  return ret;
              }
          }else{
              ret = e.checkForActivationScenes(activeEntitiesReadOnly);
              if(ret != null) {
                  spotLightEntity = e;
                  return ret;
              }
          }
      }
       return null;
    }

    Scenario.testScenario(){
        final Entity alice = new Entity("Alice","Alice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true..facingRightByDefault=false;
        final Entity bob = new Entity("Bob","Bob%3A___A5GM5n_EOD_AKS7_v1J1tYBKiJY%3D")..isActive = true..facingRightByDefault=false;;
        final Entity eve = new Entity("Eve","Eve%3A___A5GPGpdulkxChkWJS4sAAAALEeA%3D")..isActive = true..facingRightByDefault=false;;
        final Entity carol = new Entity("Carol","Carol%3A___A5GAAAAMzMzA1AOCEcR-NxXKvg%3D%3D")..facingRightByDefault=false;;
        Generator messageGenerator = new StringGenerator("secretMessageDraft", <String>["Carol actually kind of sucks...","I've never really liked Carol.", "Don't you think Carol's actually a ghost in disguise?"]);
        Generator reactionGeneratorBob = new StringGenerator("reaction", <String>["[OWNER.STRINGMEMORY.name] posts a bear","[OWNER.STRINGMEMORY.name] doesn't really react"]);
        Generator reactionGeneratorEve = new StringGenerator("reaction", <String>["She is scandalized that it reads '[TARGET.STRINGMEMORY.secretMessage]'.","Reading '[TARGET.STRINGMEMORY.secretMessage]', she reaches new heights of scandalized.", "[OWNER.STRINGMEMORY.name] can not even BELIEVE Alice would say '[TARGET.STRINGMEMORY.secretMessage]' about poor Carol."]);
        Generator randomNumber = new NumGenerator("randomNumber", -113.4,113.2);
        Generator randomNumberInt = new NumGenerator("randomNumber", 0,113);

        alice.addGenerator(messageGenerator);
        bob.addGenerator(reactionGeneratorBob);
        bob.addGenerator(randomNumber);
        eve.addGenerator(reactionGeneratorEve);
        carol.addGenerator(randomNumberInt);
        addEntity(alice);
        addEntity(bob);
        addEntity(eve);
        addEntity(carol);
        name = "Alice messages Bob";
        introduction = new Scene("Introduction","In a cryptographically relevant corner of the universe...","");

        seed = 85;
        rand = new Random(seed);

    }

}