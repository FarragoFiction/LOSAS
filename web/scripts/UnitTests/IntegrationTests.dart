import 'dart:html';

import 'UnitTests.dart';

abstract class IntegrationTests {
    static void run(Element element) {
        Scenario scenario = Scenario.testScenario();
        UnitTests.setupAliceSendsMessage(scenario);
        bool activated = scenario.entities.first.readOnlyScenes.first.checkIfActivated(scenario.entities);
        UnitTests.processTest("Alice's scene to send bob a message should activate.", true, activated, element);
        UnitTests.processTest("Alice's should be only targeting one person. That person is Bob.", 1,scenario.entities.first.readOnlyScenes.first.targets.length , element);
        UnitTests.processTest("Alice should be targeting only bob.", "{Bob}", scenario.entities.first.readOnlyScenes.first.targets.toString(), element);

        UnitTests.processTest("Alice's should be only targeting Bob.", scenario.entities[1].name,scenario.entities.first.readOnlyScenes.first.targets.first.name , element);

        scenario.entities.first.readOnlyScenes.first.applyEffects();
        UnitTests.processTest("Bob Should have a message waiting to be read.", "Carol kind of sucks...", scenario.entities[1].getStringMemory("secretMessage"), element);
        UnitTests.processTest("Alice should be aware that she has sent 1 message.", 1, scenario.entities[0].getNumMemory("secretMessageCount"), element);
        UnitTests.processTest("Bob Should not know how many messages alice has sent.", 0,scenario.entities[1].getNumMemory("secretMessageCount") , element);
        UnitTests.processTest("Alice should not know if Bob got the message.", null, scenario.entities[0].getStringMemory("secretMessage"), element);

    }
}