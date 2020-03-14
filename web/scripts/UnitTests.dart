/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';

import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'TargetFilters/KeepIfStringExists.dart';
import 'TargetFilters/KeepIfStringIsValue.dart';
import 'TargetFilters/KeepIfTrue.dart';
import 'TargetFilters/KeepIfNumExists.dart';
import 'TargetFilters/KeepIfNumIsGreaterThanValue.dart';
import 'TargetFilters/KeepIfNumIsValue.dart';
import 'TargetFilters/TargetFilter.dart';

abstract class UnitTests {

    static int testsRan = 0;
    static int testFailed = 0;

    static void runTests(Element element) {
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
    }

    static void runTargetFilterTests(Element element) {
        testTFFalse(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
    }

    static void runActionEffectTests(Element element) {

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

    static void testTFFalse(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new TFFalse(null,null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFFalse", true, result, element);
        processTest("testTFFalse 3 targets", "{Alice, Bob, Carol}", scene.targets.toString(), element);

        filter.not = true;
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFFalse Not Test", false, result, element);
        processTest("testTFFalse 0 targets", "{}", scene.targets.toString(), element);

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
        processTest("testTFStringIsValue 0 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entities[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test3", false, result, element);
        processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

}

