/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';

import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';
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
        window.console.error("TODO: need to actually have the scenes ticking so alice can try to send bob a secret message that carol tries to intercept");
        //if bob does not have a secret message, alice sends a message to bob. this sets his secretMessage string and increments his secretMessageCounter
        //if bob has a secret message, carol reads it.
        //if bob has a secret message, bob reads it, and clears it out.
        //the scenario ends after 8 secret messages have been sent.
    }

    static void runTargetFilterTests(Element element) {
        testBasic(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
        //TODO why isn't this doing anything?
        testTFStringContainsValue(element);
    }

    static void runActionEffectTests(Element element) {
        testSetNum(element);
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

