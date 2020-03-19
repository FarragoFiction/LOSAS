import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'UnitTests/UnitTests.dart';

class Game {
    Element container;
    Scenario scenario;

    //all possible entitites for this
      Game(Scenario this.scenario) {
    }

    void testDisplay(Element parent) {
        container = new DivElement()..classes.add("game");
        parent.append(container);
        UnitTests.runTests(container);
    }

}