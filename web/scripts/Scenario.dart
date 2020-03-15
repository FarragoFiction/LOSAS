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
        DivElement rightArrowDiv = new DivElement()..setInnerHtml(rightArrow);
        DivElement leftArrowDiv = new DivElement()..setInnerHtml(leftArrow);
        container.append(rightArrowDiv);
        container.append(leftArrowDiv);
        /* TODO
            want to have a left and right arrow here.
            left goes back a page (unless you are the first one)
            and right goes forwards a page
            if there IS no next page and we're not in the end, we need to call lookForNextScene
         */
    }

    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    void lookForNextScene() {
        //could be some amount of randomness baked in
        if(numberTriesForScene > maxNumberTriesForScene) {
            window.alert("something has gone wrong");
        }
        /*
            TODO
            go through all known entities until you find a scene (either intro or active)
            mark that entity as having the current spotlight.
            render their scene, and apply its effect, add it the list
            when you are out of entities to check, loop through your endings and if you find one render it and mark yourself as complete
         */
        Scene spotlightScene;
        for(final Entity e in entities) {
            if(e.isActive) {
                //yes it includes yourself, what if you're gonna buff your party or something
                spotlightScene = e.performScene(entities);
                if(spotlightScene != null) {
                    spotLightEntity = e;
                    break;
                }
            }else{
                spotlightScene = e.checkForActivationScenes(entities);
                if(spotlightScene != null) {
                    spotLightEntity = e;
                    break;
                }
            }
        }
        if(spotlightScene != null) {
            Element sceneElement = spotlightScene.render();
            sceneElements.add(sceneElement);
            container.append(sceneElement);
        }else {
            numberTriesForScene ++;
            lookForNextScene();
        }
    }

    Scenario.testScenario(){
        Entity alice = new Entity("Alice")..isActive = true;
        Entity bob = new Entity("Bob")..isActive = true;
        Entity carol = new Entity("Eve")..isActive = true;
        entities.add(alice);
        entities.add(bob);
        entities.add(carol);

        seed = 85;
        rand = new Random(seed);

    }

}