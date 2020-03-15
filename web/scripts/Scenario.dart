//what are the base rules of this story? who are the characters? what are the main events? the driving forces?
import 'package:CommonLib/Random.dart';

import 'Entity.dart';
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
    Random rand;
    List<Entity> entities = new List<Entity>();
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntities => entities.where((Entity entity) =>entity.isActive).toList();

    Scenario(this.seed) {
        rand = new Random(seed);

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