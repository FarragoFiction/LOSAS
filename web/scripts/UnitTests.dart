/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';

import 'ActionEffects/AEAddNum.dart';
import 'ActionEffects/AEAppendString.dart';
import 'ActionEffects/AESetNum.dart';
import 'ActionEffects/AESetString.dart';
import 'ActionEffects/AEUnAppendString.dart';
import 'ActionEffects/AEUnSetString.dart';
import 'ActionEffects/ActionEffect.dart';
import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'TargetFilters/KeepIfNameIsValue.dart';
import 'TargetFilters/KeepIfStringContainsValue.dart';
import 'TargetFilters/KeepIfStringExists.dart';
import 'TargetFilters/KeepIfStringIsValue.dart';
import 'TargetFilters/KeepIfNumExists.dart';
import 'TargetFilters/KeepIfNumIsGreaterThanValue.dart';
import 'TargetFilters/KeepIfNumIsValue.dart';
import 'TargetFilters/TargetFilter.dart';

abstract class UnitTests {

    static int testsRan = 0;
    static int testFailed = 0;

    static void runTests(Element element) {
        window.onError.listen((Event e) {
            DivElement div = new DivElement()..style.fontSize="72px";
            div.text = ("Error found ${(e as ErrorEvent).error}");
            div.classes.add("failed");
            element.append(div);
        });
        print("todo test VRISKA for one filter and one effect");
        runTargetFilterTests(element);
        runActionEffectTests(element);
        //TODO run generator tests
        runIntegrationTest(element);
        DivElement results = new DivElement()..setInnerHtml("$testsRan tests ran.");
        SpanElement span = new SpanElement()..style.background = "black"..style.color="red"..text = "WARNING: $testFailed failed.";

        element.append(results);
        if(testFailed > 0) element.append(span);

    }


    static void runIntegrationTest(Element element) {
        Scenario scenario = Scenario.testScenario();
        //if bob does not have a secret message, alice sends a message to bob.
        // this sets his secretMessage string and increments his secretMessageCounter
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.")..targetOne=true;
        ActionEffect effect = new AESetString("secretMessage","Carol kind of sucks...",null);
        ActionEffect effect2 = new AEAddNum("secretMessageCount",1);

        TargetFilter filter = new KeepIfStringExists("secretMessage",null)..not=true;
        TargetFilter filter2 = new KeepIfNameIsValue("Bob",null);

        scene.effects.add(effect);
        scene.effects.add(effect2);
        scene.targetFilters.add(filter2);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);


        //if bob has a secret message, eve reads it.
        Scene scene2 = new Scene("Eve Intercepts", "Eve is snooping on Bob's message. She is scandalized that it reads [TARGET.STRINGMEMORY.secretMessage].")..targetOne=true;

        TargetFilter filter3 = new KeepIfStringExists("secretMessage",null);
        TargetFilter filter4 = new KeepIfNameIsValue("Bob",null);
        scene2.targetFilters = [filter3, filter4];
        scenario.entities.last.scenes.add(scene2);


        //if bob has a secret message, bob reads it, and clears it out.
        Scene scene3 = new Scene("Bob Reads", "Bob reads his message. [TARGET.STRINGMEMORY.secretMessage].")..targetOne=true;

        TargetFilter filter5 = new KeepIfStringExists("secretMessage",null)..vriska;
        scene3.targetFilters.add(filter5);
        scenario.entities[1].scenes.add(scene3);


        //the scenario ends after 8 secret messages have been sent.

        Scene finalScene = new Scene("The End", "The cycle of messages ends.")..targetOne=true;
        //if anyone has this greater than 5
        TargetFilter filter6 = new KeepIfNumIsGreaterThanValue("secretMessageCount",5);
        finalScene.targetFilters.add(filter6);
        scenario.stopScenes.add(scene3);

        scenario.curtainsUp(querySelector("#output"));
    }

    //only filters, no effects
    static void runTargetFilterTests(Element element) {
        testBasic(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
        testTFStringContainsValue(element);
        testTFNameIsValue(element);

    }

    //only effects, no filters
    static void runActionEffectTests(Element element) {
        testSetNum(element);
        testAddNum(element);
        testSetString(element);
        testUnSetString(element);
        testAppendString(element);
        testUnAppendString(element);

    }

    static void processTest(String label, dynamic expected, dynamic value, Element element) {
        testsRan ++;
        DivElement div = new DivElement();
        element.append(div);
        if(value == expected) {
            div.classes.add("passed");
            div.text = "$testsRan: $label Passed!!!";
        }else {
            testFailed ++;
            div.classes.add("failed");
            div.text = "$testsRan: $label Failed: Expected $expected but got $value";
        }
    }

    static void testSetNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        ActionEffect effect = new AESetNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scene.applyEffects();
        processTest("testSetNum ", 13, scenario.entities[1].getNumMemory("secretNumber"), element);
    }

    static void testAddNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        ActionEffect effect = new AEAddNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scene.applyEffects();
        processTest("testAddNum ", 13, scenario.entities[1].getNumMemory("secretNumber"), element);
        scene.applyEffects();
        processTest("testAddNum ", 26, scenario.entities[1].getNumMemory("secretNumber"), element);
        effect.importantNum = -13;
        scene.applyEffects();
        processTest("testAddNum ", 13, scenario.entities[1].getNumMemory("secretNumber"), element);
    }

    static void testSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        ActionEffect effect = new AESetString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scene.applyEffects();
        processTest("testSetString ", "Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        processTest("testSetString text is replaced", "Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);
    }

    static void testUnSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Bob reads", "Bob reads his secret message.");
        ActionEffect effect = new AEUnSetString("secretMessage",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scenario.entities[1].setStringMemory("secretMessage","Carol kind of sucks.");
        processTest("testUnSetString message initializes fine", "Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);

        scene.applyEffects();
        processTest("testUnSetString message is removed", null, scenario.entities[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        processTest("testUnSetString nothing crashes trying to remove existing message", null, scenario.entities[1].getStringMemory("secretMessage"), element);
    }

    static void testAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        ActionEffect effect = new AEAppendString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scene.applyEffects();
        processTest("testAppendString text is set once", "Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        processTest("testAppendString text is set twice ", "Carol kind of sucks.Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);
    }
    static void testUnAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        ActionEffect effect = new AEUnAppendString("secretMessage","Carol kind of sucks.",null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scenario.entities[1].setStringMemory("secretMessage","Carol kind of sucks.");
        processTest("testUnAppendString text is there ", "Carol kind of sucks.", scenario.entities[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        processTest("testUnAppendString text is not", "", scenario.entities[1].getStringMemory("secretMessage"), element);
    }

    static void testBasic(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFFalse", true, result, element);
        processTest("testTFFalse 3 targets", "{Alice, Bob, Eve}", scene.targets.toString(), element);
    }

    static void testTFNumExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfNumExists("secretNumber",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists Test1", false, result, element);
        processTest("testTFNumExists 0 targets", "{}", scene.targets.toString(), element);

        scenario.entities[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists Test2", true, result, element);
        processTest("testTFNumExists 0 targets", "{Bob}", scene.targets.toString(), element);

        filter.not = true;
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists TestNot", true, result, element);
        processTest("testTFNumExists 2 targets", "{Alice, Eve}", scene.targets.toString(), element);

        scene.targetOne = true;
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists can set it to target only one even though it just targeted 2", 1, scene.targets.length, element);

    }

    static void testTFNumIsGreaterThanValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfNumIsGreaterThanValue("secretNumber",13);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsGreaterThanValue Test1", false, result, element);
        processTest("testTFNumIsGreaterThanValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entities[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsGreaterThanValue Test2", true, result, element);
        processTest("testTFNumIsGreaterThanValue 1 targets", "{Bob}", scene.targets.toString(), element);

        filter.importantNum = 113;
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsGreaterThanValue Test3", false, result, element);
        processTest("testTFNumIsGreaterThanValue 0 targets2", "{}", scene.targets.toString(), element);

    }

    static void testTFNumIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfNumIsValue("secretNumber",85);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsValue Test1", false, result, element);
        processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entities[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsValue Test2", true, result, element);
        processTest("testTFNumIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entities[1].setNumMemory("secretNumber",113);
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumIsValue Test3", false, result, element);
        processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFStringExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfStringExists("secretMessage",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringExists Test1", false, result, element);
        processTest("testTFStringExists 0 targets", "{}", scene.targets.toString(), element);



        scenario.entities[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringExists Test2", true, result, element);
        processTest("testTFStringExists 0 targets", "{Bob}", scene.targets.toString(), element);
    }

    static void testTFStringIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfStringIsValue("secretMessage","Carol kind of sucks.",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test1", false, result, element);
        processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entities[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test2", true, result, element);
        processTest("testTFStringIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entities[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test3", false, result, element);
        processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFNameIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfNameIsValue("Bob",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test1", true, result, element);
        processTest("testTFStringIsValue 0 targets", "{Bob}", scene.targets.toString(), element);

    }

    static void testTFStringContainsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new KeepIfStringContainsValue("secretMessage","carol",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringContainsValue Test1", false, result, element);
        processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entities[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringContainsValue Test2", true, result, element);
        processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entities[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringContainsValue Test3", true, result, element);
        processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entities[1].setStringMemory("secretMessage","the eagle strikes at midnight");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringContainsValue Test3", false, result, element);
        processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);
    }

}

