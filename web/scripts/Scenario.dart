//what are the base rules of this story? who are the characters? what are the main events? the driving forces?
import 'dart:html';

import 'package:CommonLib/Random.dart';

import 'Entity.dart';
import 'Scene.dart';
/*
    Scenario List
    SBURB/Farragnarok
    Worm (entities distribute prepacks of powers)
    Hogwartz
    Space Infection
 */
class Scenario {
    //TODO be able to serialize the scenarios entire current state so you can return to any version of it for time shenanigans
    int seed;
    //seriously if NOTHING HAPPENS for 13 ticks in a row, lets just call it
    int numberTriesForScene = 0;
    int maxNumberTriesForScene = 13;

    bool theEnd = false;

    Element container;

    Random rand;
    //which scene are we on
    int currentSceneIndex = 0;
    //you can go forward and back through all scenes easily.
    List<Element> sceneElements = new List<Element>();
    List<Entity> entities = new List<Entity>();
    //the person in the spotlight is on screen right now
    Entity spotLightEntity;
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntities => entities.where((Entity entity) =>entity.isActive).toList();

    //if ANY of these trigger, then its time to stop ticking
    List<Scene> stopScenes = new List<Scene>();

    Scenario(this.seed) {
        rand = new Random(seed);

    }

    void curtainsUp(Element parent) {
        container = new DivElement()..classes.add("scenario");
        parent.append(container);
        renderNavigationArrows();
        lookForNextScene();
    }


    void renderNavigationArrows() {
        String rightArrow ='<svg class = "arrow" id = "right-arrow" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13 7v-6l11 11-11 11v-6h-13v-10z"/></svg>';
        String leftArrow = '<svg class = "arrow" id = "left-arrow" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13 7v-6l11 11-11 11v-6h-13v-10z"/></svg>';
        DivElement rightArrowDiv = new DivElement()..setInnerHtml(rightArrow, treeSanitizer: NodeTreeSanitizer.trusted);
        DivElement leftArrowDiv = new DivElement()..setInnerHtml(leftArrow, treeSanitizer: NodeTreeSanitizer.trusted);
        container.append(rightArrowDiv);
        container.append(leftArrowDiv);
        rightArrowDiv.onClick.listen((Event e) {
            goRight();
        });

        leftArrowDiv.onClick.listen((Event e) {
            goLeft();
        });
    }

    void goRight() {
        sceneElements[currentSceneIndex].remove();
        currentSceneIndex ++;
        if(currentSceneIndex >= sceneElements.length && !theEnd) {
            lookForNextScene();
        }else {
            renderCurrentScene();
        }

    }

    void goLeft() {
        sceneElements[currentSceneIndex].remove();
        currentSceneIndex += -1;
        if(currentSceneIndex < 0) {
            currentSceneIndex = 0;
        }
        renderCurrentScene();
    }

    void debugScenario() {
        entities.forEach((Entity e)=> print(e.debugString()));
    }

    void renderCurrentScene() {
        container.append(sceneElements[currentSceneIndex]);
    }

    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    //first you check all your entities
    //then you check your stop scenes
    //then you repeat
    void lookForNextScene() {
        print("looking for next scene");
        debugScenario();
        //could be some amount of randomness baked in
        if(numberTriesForScene > maxNumberTriesForScene) {
            window.alert("something has gone wrong, went $numberTriesForScene loops without anything happening");
        }
        Scene spotlightScene;
        List<Entity> entitiesToCheck = null;
        if(spotLightEntity != null) {
            print("spotlight entity is not null, so check starting at index ${entities.indexOf(spotLightEntity)+1} ");
            entitiesToCheck = entities.sublist(entities.indexOf(spotLightEntity)+1);
            print("I'm going to check $entitiesToCheck");
        }else {
            print("spotlight entity is null, so check whole list");
            entitiesToCheck = entities;
        }
        spotlightScene = checkEntitiesForScene(entitiesToCheck, spotlightScene);
        if(spotlightScene != null) {
            print("I found an entity scene, $spotlightScene");
            showScene(spotlightScene);
        }else {
            spotlightScene = checkStopScenes();
            if(spotlightScene == null) {
                print("I found an no scene,going to try again");
                numberTriesForScene ++;
                spotLightEntity = null;
                lookForNextScene();
            }else {
                print("I found a stop scene, $spotlightScene");
                showScene(spotlightScene);
            }
        }
    }

    Scene checkStopScenes() {
      for(final Scene scene in stopScenes) {
          if(scene.checkIfActivated(activeEntities)){
              return  scene;
          }
      }
    }

    void showScene(Scene spotlightScene) {
        numberTriesForScene = 0;
        print("entity $spotLightEntity is in the spotlight with memory ${spotLightEntity.debugMemory}");
        Element sceneElement = spotlightScene.render(sceneElements.length);
        spotlightScene.applyEffects(); //might have additional rendering?
        sceneElements.add(sceneElement);
        container.append(sceneElement);
    }

    Scene checkEntitiesForScene(List<Entity> entitiesToCheck, Scene spotlightScene) {
       for(final Entity e in entitiesToCheck) {
           print("checking Entity $e for scenes");
          if(e.isActive) {
              //yes it includes yourself, what if you're gonna buff your party or something
              spotlightScene = e.performScene(activeEntities);
              if(spotlightScene != null) {
                  spotLightEntity = e;
                  return spotlightScene;
              }
          }else{
              spotlightScene = e.checkForActivationScenes(activeEntities);
              if(spotlightScene != null) {
                  spotLightEntity = e;
                  return spotlightScene;
              }
          }
      }
       return null;
    }

    Scenario.testScenario(){
        final Entity alice = new Entity("Alice")..isActive = true;
        final Entity bob = new Entity("Bob")..isActive = true;
        final Entity carol = new Entity("Eve")..isActive = true;
        entities.add(alice);
        entities.add(bob);
        entities.add(carol);

        seed = 85;
        rand = new Random(seed);

    }

}