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
        runIntegrationTests(element);
        runDisplayTest(element);
        DivElement results = new DivElement()..setInnerHtml("$testsRan tests ran.");
        SpanElement span = new SpanElement()..style.background = "black"..style.color="red"..text = "WARNING: $testFailed failed.";

        element.append(results);
        if(testFailed > 0) element.append(span);

    }

    static void runIntegrationTests(Element element) {
        Scenario scenario = Scenario.testScenario();
        setupAliceSendsMessage(scenario);
        bool activated = scenario.entities.first.readOnlyScenes.first.checkIfActivated(scenario.entities);
        processTest("Alice's scene to send bob a message should activate.", true, activated, element);
        processTest("Alice's should be only targeting one person. That person is Bob.", 1,scenario.entities.first.readOnlyScenes.first.targets.length , element);
        processTest("Alice should be targeting only bob.", "{Bob}", scenario.entities.first.readOnlyScenes.first.targets.toString(), element);

        processTest("Alice's should be only targeting Bob.", scenario.entities[1].name,scenario.entities.first.readOnlyScenes.first.targets.first.name , element);

        scenario.entities.first.readOnlyScenes.first.applyEffects();
        processTest("Bob Should have a message waiting to be read.", "Carol kind of sucks...", scenario.entities[1].getStringMemory("secretMessage"), element);
        processTest("Alice should be aware that she has sent 1 message.", 1, scenario.entities[0].getNumMemory("secretMessageCount"), element);
        processTest("Bob Should not know how many messages alice has sent.", null,scenario.entities[1].getNumMemory("secretMessageCount") , element);
        processTest("Alice should not know if Bob got the message.", null, scenario.entities[0].getStringMemory("secretMessage"), element);

    }


    static void runDisplayTest(Element element) {
        Scenario scenario = Scenario.testScenario();

        setupAliceSendsMessage(scenario);

        setupEveEvesdrops(scenario);

        Scene scene3 = bobReceivesMessage(scenario);

        aliceStopsAfterEnoughMessages(scenario, scene3);

        scenario.curtainsUp(querySelector("#output"));
    }

    //the scenario ends after 8 secret messages have been sent.
    static void aliceStopsAfterEnoughMessages(Scenario scenario, Scene scene3) {
      Scene finalScene = new Scene("The End", "The cycle of messages ends.","The End.")..targetOne=true;
      //if anyone has this greater than 5
      TargetFilter filter6 = new KeepIfNumIsGreaterThanValue("secretMessageCount",5);
      finalScene.targetFilters.add(filter6);
      scenario.stopScenes.add(scene3);
    }

    //if bob has a secret message, bob reads it, and clears it out.
    static Scene bobReceivesMessage(Scenario scenario) {
      Scene scene3 = new Scene("Bob Reads", "Bob reads his message. [TARGET.STRINGMEMORY.secretMessage]. ","He posts a bear, then clears his messages out.")..targetOne=true;

      TargetFilter filter5 = new KeepIfStringExists("secretMessage",null)..vriska;
      ActionEffect effect = new AEUnSetString("secretMessage",null)..vriska;
      scene3.targetFilters.add(filter5);
      scene3.effects.add(effect);
      scenario.entities[1].addScene(scene3);
      return scene3;
    }

    //        //if bob has a secret message, eve reads it.
    static void setupEveEvesdrops(Scenario scenario) {
      Scene scene2 = new Scene("Eve Intercepts", "Eve is snooping on Bob's message." ,"She is scandalized that it reads [TARGET.STRINGMEMORY.secretMessage]. Her scandal rating is [TARGET.NUMMEMORY.scandalRating]")..targetOne=true;
      ActionEffect effect2 = new AEAddNum("scandalRating",1)..vriska=true;

      TargetFilter filter3 = new KeepIfStringExists("secretMessage",null);
      TargetFilter filter4 = new KeepIfNameIsValue("Bob",null);
      scene2.targetFilters = [filter3, filter4];
      scene2.effects.add(effect2);
      scenario.entities.last.addScene(scene2);
    }

    //if bob does not have a secret message, alice sends a message to bob.
    // this sets his secretMessage string and increments his secretMessageCounter
    static void setupAliceSendsMessage(Scenario scenario) {
       Scene scene = new Scene("Alice Sends", "Alice, having sent [TARGET.NUMMEMORY.secretMessageCount] messages, sends a new secret message to Bob.","She notes she has now sent [TARGET.NUMMEMORY.secretMessageCount] total messages.")..targetOne=true;
      ActionEffect effect = new AESetString("secretMessage","Carol kind of sucks...",null);
      ActionEffect effect2 = new AEAddNum("secretMessageCount",1)..vriska=true;
      TargetFilter filter = new KeepIfStringExists("secretMessage",null)..not=true;
      TargetFilter filter2 = new KeepIfNameIsValue("Bob",null);

      scene.effects.add(effect);
      scene.effects.add(effect2);
      scene.targetFilters.add(filter2);
      scene.targetFilters.add(filter);
      scenario.entities.first.addScene(scene);
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
        testTFNameIsValueAndStringDoesntExist(element);
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entities[1]);
        scene.applyEffects();
        processTest("testSetNum ", 13, scenario.entities[1].getNumMemory("secretNumber"), element);
    }

    static void testAddNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
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
        Scene scene = new Scene("Bob reads", "Bob reads his secret message.","");
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        scenario.entities.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFFalse", true, result, element);
        processTest("testTFFalse 3 targets", "{Alice, Bob, Eve}", scene.targets.toString(), element);
    }

    static void testTFNumExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumExists("secretNumber",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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
        processTest("testTFNumExists can set it to target only one even though it just targeted 2", 1, scene.finalTargets.length, element);

    }

    static void testTFNumIsGreaterThanValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsGreaterThanValue("secretNumber",13);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsValue("secretNumber",85);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringExists("secretMessage",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringIsValue("secretMessage","Carol kind of sucks.",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNameIsValue("Bob",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFStringIsValue Test1", true, result, element);
        processTest("testTFStringIsValue 0 targets", "{Bob}", scene.targets.toString(), element);

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
        scenario.entities.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entities);
        processTest("testTFNameIsValueAndStringDoesntExist Test1", true, result, element);
        processTest("testTFNameIsValueAndStringDoesntExist 1 targets", "{Bob}", scene.targets.toString(), element);

        scene.targetFilters = [filter, filter2];
        scenario.entities.first.addScene(scene);
        bool result2 = scene.checkIfActivated(scenario.entities);
        processTest("testTFNameIsValueAndStringDoesntExist Reverse TEst", true, result2, element);
        processTest("testTFNameIsValueAndStringDoesntExist Reverse 1 targets", "{Bob}", scene.targets.toString(), element);

    }

    static void testTFStringContainsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringContainsValue("secretMessage","carol",null);
        scene.targetFilters.add(filter);
        scenario.entities.first.addScene(scene);
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

