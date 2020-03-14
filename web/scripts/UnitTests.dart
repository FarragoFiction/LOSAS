/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';

import 'Scenario.dart';
import 'Scene.dart';
import 'TargetFilters/TFFalse.dart';
import 'TargetFilters/TFNumExists.dart';
import 'TargetFilters/TargetFilter.dart';

abstract class UnitTests {

    static int testsRan = 0;
    static int testFailed = 0;

    static void runTests(Element element) {
        runTargetFilterTests(element);
        DivElement results = new DivElement()..setInnerHtml("$testsRan tests ran.");
        SpanElement span = new SpanElement()..style.background = "black"..style.color="red"..text = "WARNING: $testFailed failed.";

        element.append(results);
        if(testFailed > 0) element.append(span);

    }

    static void runTargetFilterTests(Element element) {
        testTFFalse(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
    }

    static void processTest(String label, dynamic value, dynamic expected, Element element) {
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
        processTest("testTFFalse", result, true, element);
    }

    static void testTFNumExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.");
        TargetFilter filter = new TFNumExists("secretNumber",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.scenes.add(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists Test1", result, false, element);

        filter.not = true;
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists Test2", result, true, element);

        filter.not = false;
        scenario.entities[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNumExists Test3", result, true, element);
    }

    static void testTFNumIsGreaterThanValue(Element element) {

    }

    static void testTFNumIsValue(Element element) {

    }

    static void testTFStringExists(Element element) {

    }

    static void testTFStringIsValue(Element element) {

    }

}