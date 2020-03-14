import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';

class Game {
    Element container;
    Scenario scenario;

    //all possible entitites for this
      Game(Scenario this.scenario) {
    }

    void testDisplay(Element parent) {
        container = new DivElement()..classes.add("game");
        parent.append(container);
        Scene scene = scenario.activeEntities.first.scenes.first;
        DivElement test = new DivElement()..text = "Scene ${scene.name}: Activated: ${scene.checkIfActivated(scenario.activeEntities)}";
        container.append(test);
        scene.display(container);
    }
}