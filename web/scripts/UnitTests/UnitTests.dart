/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';
import '../ActionEffects/AEAddNum.dart';
import '../ActionEffects/AEAddNumFromMemory.dart';
import '../ActionEffects/AEAppendString.dart';
import '../ActionEffects/AECopyNumFromTarget.dart';
import '../ActionEffects/AECopyStringToTarget.dart';
import '../ActionEffects/AESetNum.dart';
import '../ActionEffects/AESetNumGenerator.dart';
import '../ActionEffects/AESetString.dart';
import '../ActionEffects/AESetStringGenerator.dart';
import '../ActionEffects/AEUnAppendString.dart';
import '../ActionEffects/AEUnSetString.dart';
export '../ActionEffects/ActionEffect.dart';
import '../ActionEffects/ActionEffect.dart';
import '../Entity.dart';
import '../Generator.dart';
import '../TargetFilters/KeepIfNumIsGreaterThanValueFromMemory.dart';
import 'ActionEffectTests.dart';
import 'DollTests.dart';
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
        DollTests.run(element);
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

        setupCarol(scenario);

        bobReceivesMessage(scenario);

        aliceStopsAfterEnoughMessages(scenario);

        List<Entity> randos = new List<Entity>();
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        randos.add(new Entity("Rando","Rando%3A___A5GAAAA6NpX____________LOlg%3D")..facingRightByDefault=false);
        for(Entity rando in randos) {
            scenario.addEntity(rando);
        }
        scenario.curtainsUp(querySelector("#output"));
    }

    //the scenario ends after 8 secret messages have been sent.
    static void aliceStopsAfterEnoughMessages(Scenario scenario) {
      Scene finalScene = new Scene("The End", "Now that alice has sent [TARGET.NUMMEMORY.secretMessageCount] messages, the cycle of messages ends.","The End.")..targetOne=true;
      //if anyone has this greater than 5
      TargetFilter filter6 = new KeepIfNumIsGreaterThanValue("secretMessageCount",13);
      finalScene.targetFilters.add(filter6);
      scenario.stopScenes.add(finalScene);
    }

    //if bob has a secret message, bob reads it, and clears it out.
    static void bobReceivesMessage(Scenario scenario) {
      Scene scene3 = new Scene("Bob Reads", "Bob reads his message. '[OWNER.STRINGMEMORY.secretMessage]'. ","[OWNER.STRINGMEMORY.reaction], thinks about the number [OWNER.NUMMEMORY.randomNumber], then clears his messages out.")..targetOne=true;

      TargetFilter filter5 = new KeepIfStringExists("secretMessage",null)..vriska=true;
      ActionEffect effect = new AEUnSetString("secretMessage",null)..vriska=true;
      ActionEffect effect2 = new AESetStringGenerator("reaction","He posts three bears",null)..vriska=true;
      ActionEffect effect3 = new AESetNumGenerator("randomNumber",113)..vriska=true;

      scene3.targetFilters.add(filter5);
      scene3.effects.add(effect);
      scene3.effects.add(effect2);
      scene3.effects.add(effect3);
      scenario.entitiesReadOnly[1].addScene(scene3);
    }

    //        //if bob has a secret message, eve reads it.
    static void setupEveEvesdrops(Scenario scenario) {
      Scene scene2 = new Scene("Eve Intercepts", "Eve is snooping on Bob's message." ,"[OWNER.STRINGMEMORY.reaction]. Her scandal rating is [OWNER.NUMMEMORY.scandalRating]")..targetOne=true;
      ActionEffect effect1 = new AEAddNum("scandalRating",1)..vriska=true;
      ActionEffect effect2 = new AESetStringGenerator("reaction","She is scandalized times a million",null)..vriska=true;

      TargetFilter filter3 = new KeepIfStringExists("secretMessage",null);
      TargetFilter filter4 = new KeepIfNameIsValue("Bob",null);
      scene2.targetFilters = [filter3, filter4];
      scene2.effects.add(effect1);
      scene2.effects.add(effect2);
      scenario.entitiesReadOnly[2].addScene(scene2);
    }

    static void setupCarol(Scenario scenario) {
        final Entity carol = scenario.entitiesReadOnly.last;
        final Scene carolActivates = new Scene("Carol activates","Eve spreads the juicy gossip to Carol.","Carol can't believe Alice is talking shit about her. She knows [TARGET.STRINGMEMORY.name] is at scandal rating [OWNER.NUMMEMORY.scandalMemory].");
        TargetFilter carolFilter = new KeepIfNumIsGreaterThanValue("scandalRating",1);
        carolActivates.targetFilters.add(carolFilter);
        ActionEffect effect = new AESetNumGenerator("randomNumber",3)..vriska=true;
        ActionEffect rememberScandalRating = new AECopyNumFromTarget("scandalRating","scandalMemory",0);
        ActionEffect rememberScandalRating2 = new AECopyNumFromTarget("scandalRating","scandalMemory",0);
        carolActivates.effects.add(rememberScandalRating2);

        ActionEffect aggregate = new AEAddNumFromMemory("fumeRating","randomNumber",null)..vriska=true;

        //TODO add a random element to this
        final Scene carolFumes = new Scene("Carol fumes","[TARGET.STRINGMEMORY.name] spreads even more juicy gossip to Carol.","Carol fumes [OWNER.NUMMEMORY.randomNumber] points, but out of how many? Her fume rating is [OWNER.NUMMEMORY.fumeRating], and she knows [TARGET.STRINGMEMORY.name] is at scandal rating [OWNER.NUMMEMORY.scandalMemory].");
        //eve needs to have new gossip for carol to react ot it.
        TargetFilter filter3 = new KeepIfNumExists("scandalRating",null);
        TargetFilter filter2 = new KeepIfNumIsGreaterThanValueFromMemory("scandalRating","scandalMemory",null);
        carolFumes.targetFilters.add(filter3);
        carolFumes.targetFilters.add(filter2);
        carol.addActivationScene(carolActivates);
        carolFumes.effects.add(effect);
        carolFumes.effects.add(aggregate);
        carolFumes.effects.add(rememberScandalRating);
        carol.addScene(carolFumes);
    }

    //if bob does not have a secret message, alice sends a message to bob.
    // this sets his secretMessage string and increments his secretMessageCounter
    static void setupAliceSendsMessage(Scenario scenario) {
       Scene scene = new Scene("Alice Sends", "Alice, having sent [OWNER.NUMMEMORY.secretMessageCount] messages, sends a new secret message to Bob.","She notes she has now sent [OWNER.NUMMEMORY.secretMessageCount] total messages.")..targetOne=true;
       ActionEffect prerequisiteEffect = new AESetStringGenerator("secretMessageDraft","Carol absolutey sucks.",null)..vriska=true;
       ActionEffect effect = new AECopyStringToTarget("secretMessageDraft","secretMessage",null);
      ActionEffect effect2 = new AEAddNum("secretMessageCount",1)..vriska=true;
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

