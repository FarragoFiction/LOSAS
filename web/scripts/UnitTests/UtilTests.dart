import 'dart:html';

import 'UnitTests.dart';

abstract class UtilTests {

    static void run(Element element) {
        List<String> parts = Util.getTagsForKey("Alice, having sent [OWNER.STRINGMEMORY.secretMessage] as a message. And her email is [OWNER.STRINGMEMORY.email] ",Scene.OWNERSTRINGMEMORYTAG);
        UnitTests.processTest("Util Tests ", ["secretMessage","email"].toString(), parts.toString(), element);
        Scenario scenario = Scenario.testScenario();
        UnitTests.setupAliceSendsMessage(scenario);
        UnitTests.processTest("Util Tests Replacement Null ", "Alice, having sent 0 messages, sends a new secret message to Bob.", scenario.entities.first.readOnlyScenes.first.proccessedBeforeText, element);
        scenario.entities.first.setNumMemory("secretMessageCount",3);
        UnitTests.processTest("Util Tests Replacement 3 ", "Alice, having sent 3 messages, sends a new secret message to Bob.", scenario.entities.first.readOnlyScenes.first.proccessedBeforeText, element);
    }
}