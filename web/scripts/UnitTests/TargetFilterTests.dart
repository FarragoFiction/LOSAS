import 'dart:html';

import '../TargetFilters/KeepIfNumIsGreaterThanValueFromMemory.dart';
import 'UnitTests.dart';

abstract class TargetFilterTests {

    //only filters, no effects
    static void run(Element element) {
        testBasic(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsGreaterThanValueFromMemory(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
        testTFStringContainsValue(element);
        testTFNameIsValue(element);
        testTFNameIsValueAndStringDoesntExist(element);
    }

    static void testBasic(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFFalse", true, result, element);
        UnitTests.processTest("testTFFalse 3 targets", "{Alice, Bob, Eve, Carol}", scene.targets.toString(), element);
    }

    static void testTFNumExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumExists("secretNumber",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists Test1", false, result, element);
        UnitTests.processTest("testTFNumExists 0 targets", "{}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists Test2", true, result, element);
        UnitTests.processTest("testTFNumExists 0 targets", "{Bob}", scene.targets.toString(), element);

        filter.not = true;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists TestNot", true, result, element);
        UnitTests.processTest("testTFNumExists 2 targets", "{Alice, Eve, Carol}", scene.targets.toString(), element);

        scene.targetOne = true;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists can set it to target only one even though it just targeted 2", 1, scene.finalTargets.length, element);

    }

    static void testTFNumIsGreaterThanValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsGreaterThanValue("secretNumber",13);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test1", false, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test2", true, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 1 targets", "{Bob}", scene.targets.toString(), element);

        filter.importantNum = 113;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test3", false, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 0 targets2", "{}", scene.targets.toString(), element);

    }


    static void testTFNumIsGreaterThanValueFromMemory(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsGreaterThanValueFromMemory("secretNumber","secretNumberMemory",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory NeitherSet 1", true, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue NeitherSet, 0 targets", "{Alice, Bob, Eve, Carol}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory Number Set, Not Memory", true, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory Number Not Set,  Memory Is", true, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",113);
        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemoryBoth Set, number bigger", true, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",113);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemoryBoth Set, memory bigger", true, result, element);

    }
    static void testTFNumIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsValue("secretNumber",85);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test1", false, result, element);
        UnitTests.processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test2", true, result, element);
        UnitTests.processTest("testTFNumIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",113);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test3", false, result, element);
        UnitTests.processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFStringExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringExists("secretMessage",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringExists Test1", false, result, element);
        UnitTests.processTest("testTFStringExists 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringExists Test2", true, result, element);
        UnitTests.processTest("testTFStringExists 0 targets", "{Bob}", scene.targets.toString(), element);
    }

    static void testTFStringIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringIsValue("secretMessage","Carol kind of sucks.",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test1", false, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test2", true, result, element);
        UnitTests.processTest("testTFStringIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test3", false, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFNameIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNameIsValue("Bob",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test1", true, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{Bob}", scene.targets.toString(), element);

    }

    //this is to catch a bug where multiple filteres weren't working, and the order they were run in mattered.
    //originally i'd look for bob, then loook for "someone without a secret message" then only return that
    //but if i ran it the other way i'd instead target bob regardless of if he had a secret message
    //both are wrong
    static void testTFNameIsValueAndStringDoesntExist(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringExists("secretMessage",null)..not=true;
        TargetFilter filter2 = new KeepIfNameIsValue("Bob",null);
        scene.targetFilters = [filter2, filter];
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Test1", true, result, element);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist 1 targets", "{Bob}", scene.targets.toString(), element);

        scene.targetFilters = [filter, filter2];
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result2 = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Reverse TEst", true, result2, element);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Reverse 1 targets", "{Bob}", scene.targets.toString(), element);

    }

    static void testTFStringContainsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringContainsValue("secretMessage","carol",null);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test1", false, result, element);
        UnitTests.processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test2", true, result, element);
        UnitTests.processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test3", true, result, element);
        UnitTests.processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","the eagle strikes at midnight");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test3", false, result, element);
        UnitTests.processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);
    }
}