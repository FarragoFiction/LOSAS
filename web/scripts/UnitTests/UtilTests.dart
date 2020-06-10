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
        testTargetString(element);
        testTargetNum(element);
        testOwnerString(element);
        testOwnerNum(element);
        testMultiple(element);
        testClusterFuck(element);

    }

    static void testTargetString(Element element) {
      String text = "The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name].";
      List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
      List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
      List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
      List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

      UnitTests.processTest("Util testTargetString get targetStringTags 1 ${targetStringTags} ", 1, targetStringTags.length, element);
      UnitTests.processTest("Util testTargetString get ownerStringTags 0 ${ownerStringTags}", 0, ownerStringTags.length, element);
      UnitTests.processTest("Util testTargetString get targetNumTags 0 ${targetNumTags}", 0, targetNumTags.length, element);
      UnitTests.processTest("Util testTargetString get ownerNumTags 0 ${ownerNumTags}", 0, ownerNumTags.length, element);
    }

    static void testOwnerString(Element element) {
        String text = "The text before things happen. Uses markup like this [OWNER.STRINGMEMORY.name].";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util testOwnerString get targetStringTags 1 ${targetStringTags} ", 0, targetStringTags.length, element);
        UnitTests.processTest("Util testOwnerString get ownerStringTags 0 ${ownerStringTags}", 1, ownerStringTags.length, element);
        UnitTests.processTest("Util testOwnerString get targetNumTags 0 ${targetNumTags}", 0, targetNumTags.length, element);
        UnitTests.processTest("Util testOwnerString get ownerNumTags 0 ${ownerNumTags}", 0, ownerNumTags.length, element);
    }

    static void testTargetNum(Element element) {
        String text = "The text before things happen. Uses markup like this [TARGET.NUMMEMORY.name].";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util testTargetNum get targetStringTags 1 ${targetStringTags} ", 0, targetStringTags.length, element);
        UnitTests.processTest("Util testTargetNum get ownerStringTags 0 ${ownerStringTags}", 0, ownerStringTags.length, element);
        UnitTests.processTest("Util testTargetNum get targetNumTags 0 ${targetNumTags}", 1, targetNumTags.length, element);
        UnitTests.processTest("Util testTargetNum get ownerNumTags 0 ${ownerNumTags}", 0, ownerNumTags.length, element);
    }

    static void testOwnerNum(Element element) {
        String text = "The text before things happen. Uses markup like this [OWNER.NUMMEMORY.name].";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util testOwnerNum get targetStringTags 1 ${targetStringTags} ", 0, targetStringTags.length, element);
        UnitTests.processTest("Util testOwnerNum get ownerStringTags 0 ${ownerStringTags}", 0, ownerStringTags.length, element);
        UnitTests.processTest("Util testOwnerNum get targetNumTags 0 ${targetNumTags}", 0, targetNumTags.length, element);
        UnitTests.processTest("Util testOwnerNum get ownerNumTags 0 ${ownerNumTags}", 1, ownerNumTags.length, element);
    }

    static void testMultiple(Element element) {
        String text = "The text [OWNER.NUMMEMORY.rank] before things [OWNER.NUMMEMORY.name] happen. Uses markup like this [OWNER.NUMMEMORY.name].";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util testMultiple get targetStringTags 3 ${targetStringTags} ", 0, targetStringTags.length, element);
        UnitTests.processTest("Util testMultiple get ownerStringTags 0 ${ownerStringTags}", 0, ownerStringTags.length, element);
        UnitTests.processTest("Util testMultiple get targetNumTags 0 ${targetNumTags}", 0, targetNumTags.length, element);
        UnitTests.processTest("Util testMultiple get ownerNumTags 0 ${ownerNumTags}", 3, ownerNumTags.length, element);
    }

    static void testClusterFuck(Element element) {
        String text = "The [OWNER.STRINGMEMORY.name]text before things[TARGET.NUMMEMORY.name] happen. Uses [OWNER.STRINGMEMORY.name]markup like this [TARGET.STRINGMEMORY.name]. [OWNER.NUMMEMORY.name]";
        List<String> targetStringTags = Util.getTagsForKey(text, Scene.TARGETSTRINGMEMORYTAG);
        List<String> ownerStringTags = Util.getTagsForKey(text, Scene.OWNERSTRINGMEMORYTAG);
        List<String> targetNumTags = Util.getTagsForKey(text, Scene.TARGETNUMMEMORYTAG);
        List<String> ownerNumTags = Util.getTagsForKey(text, Scene.OWNERNUMMEMORYTAG);

        UnitTests.processTest("Util testClusterFuck get targetStringTags 1 ${targetStringTags} ", 1, targetStringTags.length, element);
        UnitTests.processTest("Util testClusterFuck get ownerStringTags 2 ${ownerStringTags}", 2, ownerStringTags.length, element);
        UnitTests.processTest("Util testClusterFuck get targetNumTags 1 ${targetNumTags}", 1, targetNumTags.length, element);
        UnitTests.processTest("Util testClusterFuck get ownerNumTags 1 ${ownerNumTags}", 1, ownerNumTags.length, element);
    }
}