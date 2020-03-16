import 'dart:html';

import 'UnitTests.dart';

abstract class ActionEffectTests {

    //only effects, no filters
    static void run(Element element) {
        testSetNum(element);
        testAddNum(element);
        testSetString(element);
        testUnSetString(element);
        testAppendString(element);
        testUnAppendString(element);

    }


    static void testSetNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testSetNum ", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
    }

    static void testAddNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testAddNum ", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
        scene.applyEffects();
        UnitTests.processTest("testAddNum ", 26, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
        effect.importantNum = -13;
        scene.applyEffects();
        UnitTests.processTest("testAddNum ", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
    }

    static void testSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testSetString ", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testSetString text is replaced", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

    static void testUnSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Bob reads", "Bob reads his secret message.","");
        ActionEffect effect = new AEUnSetString("secretMessage",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        UnitTests.processTest("testUnSetString message initializes fine", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);

        scene.applyEffects();
        UnitTests.processTest("testUnSetString message is removed", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testUnSetString nothing crashes trying to remove existing message", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

    static void testAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAppendString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testAppendString text is set once", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testAppendString text is set twice ", "Carol kind of sucks.Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }
    static void testUnAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEUnAppendString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        UnitTests.processTest("testUnAppendString text is there ", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testUnAppendString text is not", "", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

}