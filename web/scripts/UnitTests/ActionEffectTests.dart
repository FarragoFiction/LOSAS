import 'dart:html';

import '../ActionEffects/AESetNumGenerator.dart';
import '../ActionEffects/AESetStringGenerator.dart';
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
        testSetStringGenerator(element);
        testSetNumGenerator(element);
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

    static void testSetStringGenerator(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetStringGenerator("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        String generatedWord = scenario.entitiesReadOnly[1].getStringMemory("secretMessage");
        scene.applyEffects();
        UnitTests.processTest("testSetStringGenerator $generatedWord is the default ", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);

        List<String> wordSet1 = <String>["hello","world"];
        Generator stringGenerator = new StringGenerator("testString",wordSet1);
        scenario.entitiesReadOnly[1].addGenerator(stringGenerator);
        scene.applyEffects();
        generatedWord = scenario.entitiesReadOnly[1].getStringMemory("secretMessage");
        UnitTests.processTest("testUnAppendString $generatedWord is one of the single generator's values", true,wordSet1.contains(generatedWord) , element);
        List<String> wordSet2 = <String>["entirely","new","words","actualyl","a","lot","of","them"];

        Generator stringGenerator2 = new StringGenerator("testString",wordSet2);
        scenario.entitiesReadOnly[1].addGenerator(stringGenerator2);
        scene.applyEffects();
        generatedWord = scenario.entitiesReadOnly[1].getStringMemory("secretMessage");
        UnitTests.processTest("testUnAppendString $generatedWord is one of the two different generators possible generated values", true, wordSet1.contains(generatedWord) || wordSet2.contains(generatedWord), element);

    }

    static void testSetNumGenerator(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetNumGenerator("secretMessageFrequency",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        int generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is the default ", 13, generatedNum, element);

        Generator numGenerator = new NumGenerator("secretMessageFrequency",0,10);
        scenario.entitiesReadOnly[1].addGenerator(numGenerator);
        scene.applyEffects();
        generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is one of the single generator's values ", true, generatedNum >=0 && generatedNum <=10, element);

        Generator numGenerator2 = new NumGenerator("secretMessageFrequency",-13.9878,102345345.4);
        scenario.entitiesReadOnly[1].addGenerator(numGenerator2);
        scene.applyEffects();
        generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is one of the single generator's values ", true, generatedNum >=-13.9878 && generatedNum <= 102345345.4, element);

    }

}
