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

    Scenario(this.seed) {
        rand = new Random(seed);

    }

    void curtainsUp(Element parent) {
        container = new DivElement()..classes.add("scenario");
        parent.append(container);
        renderNavigationArrows();
        lookForNextScene();
    }

    void addEntity(Entity entity) {
        _entities.add(entity);
        entity.scenario = this;
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
        entitiesReadOnly.forEach((Entity e)=> print(e.debugString()));
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
            showScene(spotlightScene);
        }else {
            print("Time to check stop scenes");
            spotlightScene = checkStopScenes();
            if(spotlightScene == null) {
                numberTriesForScene ++;
                spotLightEntity = null;
                lookForNextScene();
            }else {
                showScene(spotlightScene);
            }
        }
    }

    Scene checkStopScenes() {
      for(final Scene scene in stopScenes) {
          print("checking stop scene $scene");
          if(scene.checkIfActivated(activeEntitiesReadOnly)){
              return  scene;
          }
      }
    }

    void showScene(Scene spotlightScene) {
        numberTriesForScene = 0;
        Element sceneElement = spotlightScene.render(sceneElements.length);
        sceneElements.add(sceneElement);
        container.append(sceneElement);
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
        final Entity alice = new Entity("Alice")..isActive = true;
        final Entity bob = new Entity("Bob")..isActive = true;
        final Entity carol = new Entity("Eve")..isActive = true;
        addEntity(alice);
        addEntity(bob);
        addEntity(carol);

        seed = 85;
        rand = new Random(seed);

    }

}