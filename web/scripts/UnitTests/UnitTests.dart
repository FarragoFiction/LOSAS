/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';
import '../ActionEffects/AEAddNum.dart';
import '../ActionEffects/AEAppendString.dart';
import '../ActionEffects/AESetNum.dart';
import '../ActionEffects/AESetString.dart';
import '../ActionEffects/AESetStringGenerator.dart';
import '../ActionEffects/AEUnAppendString.dart';
import '../ActionEffects/AEUnSetString.dart';
export '../ActionEffects/ActionEffect.dart';
import '../ActionEffects/ActionEffect.dart';
import '../Entity.dart';
import '../Generator.dart';
import 'ActionEffectTests.dart';
import 'GeneratorTests.dart';
import 'IntegrationTests.dart';
import '../Scenario.dart';
import '../Scene.dart';
import '../TargetFilters/KeepIfNameIsValue.dart';
import '../TargetFilters/KeepIfStringContainsValue.dart';
import '../TargetFilters/KeepIfStringExists.dart';
import '../TargetFilters/KeepIfStringIsValue.dart';
import '../TargetFilters/KeepIfNumExists.dart';
import '../TargetFilters/KeepIfNumIsGreaterThanValue.dart';
import '../TargetFilters/KeepIfNumIsValue.dart';
import '../TargetFilters/TargetFilter.dart';
import '../Util.dart';
import 'TargetFilterTests.dart';
import 'UtilTests.dart';

export '../ActionEffects/AEAddNum.dart';
export '../ActionEffects/AEAppendString.dart';
export '../ActionEffects/AESetNum.dart';
export '../ActionEffects/AESetString.dart';
export '../ActionEffects/AEUnAppendString.dart';
export '../ActionEffects/AEUnSetString.dart';
export '../ActionEffects/ActionEffect.dart';
export '../Entity.dart';
export '../Generator.dart';
export '../Scenario.dart';
export '../Scene.dart';
export '../TargetFilters/KeepIfNameIsValue.dart';
export '../TargetFilters/KeepIfStringContainsValue.dart';
export '../TargetFilters/KeepIfStringExists.dart';
export '../TargetFilters/KeepIfStringIsValue.dart';
export '../TargetFilters/KeepIfNumExists.dart';
export '../TargetFilters/KeepIfNumIsGreaterThanValue.dart';
export '../TargetFilters/KeepIfNumIsValue.dart';
export '../TargetFilters/TargetFilter.dart';
export '../Util.dart';

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
        UtilTests.run(element);
        GeneratorTests.run(element);
        TargetFilterTests.run(element);
        ActionEffectTests.run(element);
        IntegrationTests.run(element);
        runDisplayTest(element);
        DivElement results = new DivElement()..setInnerHtml("$testsRan tests ran.");
        SpanElement span = new SpanElement()..style.background = "black"..style.color="red"..text = "WARNING: $testFailed failed.";

        element.append(results);
        if(testFailed > 0) element.append(span);

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
      Scene scene3 = new Scene("Bob Reads", "Bob reads his message. '[TARGET.STRINGMEMORY.secretMessage]'. ","[OWNER.STRINGMEMORY.reaction], then clears his messages out.")..targetOne=true;

      TargetFilter filter5 = new KeepIfStringExists("secretMessage",null)..vriska;
      ActionEffect effect = new AEUnSetString("secretMessage",null)..vriska;
      ActionEffect effect2 = new AESetStringGenerator("reaction","He posts three bears",null)..vriska;

      scene3.targetFilters.add(filter5);
      scene3.effects.add(effect);
      scene3.effects.add(effect2);
      scenario.entitiesReadOnly[1].addScene(scene3);
      return scene3;
    }

    //        //if bob has a secret message, eve reads it.
    static void setupEveEvesdrops(Scenario scenario) {
      Scene scene2 = new Scene("Eve Intercepts", "Eve is snooping on Bob's message." ,"[OWNER.STRINGMEMORY.reaction]. Her scandal rating is [OWNER.NUMMEMORY.scandalRating]")..targetOne=true;
      ActionEffect effect1 = new AEAddNum("scandalRating",1)..vriska=true;
      ActionEffect effect2 = new AESetStringGenerator("reaction","She is scandalized times a million",null)..vriska;

      TargetFilter filter3 = new KeepIfStringExists("secretMessage",null);
      TargetFilter filter4 = new KeepIfNameIsValue("Bob",null);
      scene2.targetFilters = [filter3, filter4];
      scene2.effects.add(effect1);
      scene2.effects.add(effect2);
      scenario.entitiesReadOnly.last.addScene(scene2);
    }

    //if bob does not have a secret message, alice sends a message to bob.
    // this sets his secretMessage string and increments his secretMessageCounter
    static void setupAliceSendsMessage(Scenario scenario) {
       Scene scene = new Scene("Alice Sends", "Alice, having sent [OWNER.NUMMEMORY.secretMessageCount] messages, sends a new secret message to Bob.","She notes she has now sent [OWNER.NUMMEMORY.secretMessageCount] total messages.")..targetOne=true;
      ActionEffect effect = new AESetString("secretMessage","[OWNER.STRINGMEMORY.secretMessageDraft]",null);
      ActionEffect effect2 = new AEAddNum("secretMessageCount",1)..vriska=true;
       ActionEffect prerequisiteEffect = new AESetStringGenerator("secretMessageDraft","Carol absolute sucks.",null)..vriska;
       TargetFilter filter = new KeepIfStringExists("secretMessage",null)..not=true;
      TargetFilter filter2 = new KeepIfNameIsValue("Bob",null);

       scene.effects.add(prerequisiteEffect);
       scene.effects.add(effect);
      scene.effects.add(effect2);
      scene.targetFilters.add(filter2);
      scene.targetFilters.add(filter);
      scenario.entitiesReadOnly.first.addScene(scene);
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




}

