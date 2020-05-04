import 'dart:html';

import '../DataStringHelper.dart';
import 'UnitTests.dart';

abstract class IntegrationTests {
    static void run(Element element) {
        Scenario scenario = Scenario.testScenario();
        UnitTests.setupAliceSendsMessage(scenario);
        bool activated = scenario.entitiesReadOnly.first.readOnlyScenes.first.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("Alice's scene to send bob a message should activate.", true, activated, element);
        UnitTests.processTest("Alice's should be only targeting one person. That person is Bob.", 1,scenario.entitiesReadOnly.first.readOnlyScenes.first.targets.length , element);
        UnitTests.processTest("Alice should be targeting only bob.", "{Bob}", scenario.entitiesReadOnly.first.readOnlyScenes.first.targets.toString(), element);

        Entity bob = scenario.entitiesReadOnly[1];
        Scene relevantScene = scenario.entitiesReadOnly.first.readOnlyScenes.first;
        UnitTests.processTest("Alice's should have a target", true,relevantScene.targets.length >0 , element);
        print("hey chief something is wrong, the relevant scene serialized is ${relevantScene.getSerialization()}");

        UnitTests.processTest("Alice's should be only targeting Bob.", bob.name,relevantScene.targets.first.name , element);

        scenario.entitiesReadOnly.first.readOnlyScenes.first.applyEffects();
        UnitTests.processTest("Bob Should have a message waiting to be read.", "Don't you think Carol's actually a ghost in disguise?", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        UnitTests.processTest("Alice should be aware that she has sent 1 message.", 1, scenario.entitiesReadOnly[0].getNumMemory("secretMessageCount"), element);
        UnitTests.processTest("Bob Should not know how many messages alice has sent.", 0,scenario.entitiesReadOnly[1].getNumMemory("secretMessageCount") , element);
        UnitTests.processTest("Alice should not know if Bob got the message.", null, scenario.entitiesReadOnly[0].getStringMemory("secretMessage"), element);

        Scene scene = scenario.entitiesReadOnly.first.readOnlyScenes.first;
        Scene scene2 = Scene.fromDataString(DataStringHelper.serializationToDataString("TestScene",scene.getSerialization()));

        UnitTests.processTest("Scene can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestScene",scene.getSerialization()), DataStringHelper.serializationToDataString("TestScene",scene2.getSerialization()), element);


    }
}