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
    //TODO i am so terrible but...what if scenarios let you add a color and quirk to the debug messages???
    int seed;
    //seriously if NOTHING HAPPENS for 13 ticks in a row, lets just call it
    int numberTriesForScene = 0;
    int maxNumberTriesForScene = 13;

    bool theEnd = false;
    //which scene are we on
    int currentSceneIndex = 0;

    Random rand;
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

    void renderNavigationArrows(Element element) {

        /*
            want to have a left and right arrow here.
            left goes back a page (unless you are the first one)
            and right goes forwards a page
            if there IS no next page and we're not in the end, we need to call lookForNextScene
         */
    }

    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    void lookForNextScene(Element element) {
        /*
            TODO
            go through all known entities until you find a scene (either intro or active)
            mark that entity as having the current spotlight.
            render their scene, and apply its effect, add it the list
            when you are out of entities to check, loop through your endings and if you find one render it and mark yourself as complete
         */

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