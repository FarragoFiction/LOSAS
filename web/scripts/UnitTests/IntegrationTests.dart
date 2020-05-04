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

        UnitTests.processTest("Alice's should be only targeting Bob.", scenario.entitiesReadOnly[1].name,scenario.entitiesReadOnly.first.readOnlyScenes.first.targets.first.name , element);

        scenario.entitiesReadOnly.first.readOnlyScenes.first.applyEffects();
        UnitTests.processTest("Bob Should have a message waiting to be read.", "Don't you think Carol's actually a ghost in disguise?", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        UnitTests.processTest("Alice should be aware that she has sent 1 message.", 1, scenario.entitiesReadOnly[0].getNumMemory("secretMessageCount"), element);
        UnitTests.processTest("Bob Should not know how many messages alice has sent.", 0,scenario.entitiesReadOnly[1].getNumMemory("secretMessageCount") , element);
        UnitTests.processTest("Alice should not know if Bob got the message.", null, scenario.entitiesReadOnly[0].getStringMemory("secretMessage"), element);

        Scene scene = scenario.entitiesReadOnly.first.readOnlyScenes.first;
        UnitTests.processTest("Scene can be serialized to and from datastring",DataStringHelper.serializationToDataString("Test",scene.getSerialization()), DataStringHelper.serializationToDataString("Test",scene.getSerialization()), element);

    }
}