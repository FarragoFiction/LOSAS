import 'dart:html';

import 'UnitTests.dart';

abstract class UtilTests {

    static void run(Element element) {
        List<String> parts = Util.getTagsForKey("Alice, having sent [OWNER.STRINGMEMORY.secretMessage] as a message. And her email is [OWNER.STRINGMEMORY.email] ",Scene.OWNERSTRINGMEMORYTAG);
        UnitTests.processTest("Util Tests ", ["secretMessage","email"].toString(), parts.toString(), element);
        Scenario scenario = Scenario.testScenario();
        UnitTests.setupAliceSendsMessage(scenario);
        UnitTests.processTest("Util Tests Replacement Null ", "Alice, having sent 0 messages, sends a new secret message to Bob.", scenario.entitiesReadOnly.first.readOnlyScenes.first.proccessedBeforeText, element);
        scenario.entitiesReadOnly.first.setNumMemory("secretMessageCount",3);
        UnitTests.processTest("Util Tests Replacement 3 ", "Alice, having sent 3 messages, sends a new secret message to Bob.", scenario.entitiesReadOnly.first.readOnlyScenes.first.proccessedBeforeText, element);
        String text = "The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name].";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util get targetStringTags 1 ${targetStringTags} ", 1, targetStringTags.length, element);
        UnitTests.processTest("Util get ownerStringTags 0 ${ownerStringTags}", 0, ownerStringTags.length, element);
        UnitTests.processTest("Util get targetNumTags 0 ${targetNumTags}", 0, targetNumTags.length, element);
        UnitTests.processTest("Util get ownerNumTags 0 ${ownerNumTags}", 0, ownerNumTags.length, element);


    }
}