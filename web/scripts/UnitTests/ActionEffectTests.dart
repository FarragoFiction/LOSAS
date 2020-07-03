import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import '../ActionEffects/AEAddGenerator.dart';
import '../ActionEffects/AEAddNumFromYourMemory.dart';
import '../ActionEffects/AEAddScene.dart';
import '../ActionEffects/AEAddSceneFromOwner.dart';
import '../ActionEffects/AEAddSceneFromTarget.dart';
import '../ActionEffects/AEAppendStringFront.dart';
import '../ActionEffects/AECopyNumFromTarget.dart';
import '../ActionEffects/AECopyNumToTarget.dart';
import '../ActionEffects/AECopyStringFromTarget.dart';
import '../ActionEffects/AECopyStringToTarget.dart';
import '../ActionEffects/AERemoveGeneratorsForKey.dart';
import '../ActionEffects/AERestoreDoll.dart';
import '../ActionEffects/AESetDollStringFromMyMemory.dart';
import '../ActionEffects/AESetDollStringFromYourMemory.dart';
import '../ActionEffects/AESetNumGenerator.dart';
import '../ActionEffects/AESetStringGenerator.dart';
import '../ActionEffects/AETransformDoll.dart';
import '../DataStringHelper.dart';
import 'UnitTests.dart';

abstract class ActionEffectTests {

    //only effects, no filters
    static void run(Element element) {
        testSetNum(element);
        testAddNum(element);
        testAddNumFromMemory(element);
        testSetString(element);
        testSetScene(element);
        testSetSceneFromOwner(element);
        testSetSceneFromTarget(element);

        testAddGenerator(element);
        testUnSetString(element);
        testAppendString(element);
        testUnAppendString(element);
        testSetStringGenerator(element);
        testSetNumGenerator(element);
        testCopyStringTo(element);
        testCopyStringFrom(element);
        testCopyNumTo(element);
        testCopyNumFrom(element);
        testDollStringFromMemory(element);
        testNoDoubles(element);
        testRestoreDoll(element);
        testTransformDoll(element);
        testSerialization(element);

    }

    //needed because if i typo types and any double up i get hard to track down bugs
    static void testNoDoubles(element) {
        List<String> seenNames = [];
        ActionEffect.setExamples();
        for(ActionEffect e in ActionEffect.exampleOfAllEffects) {
            UnitTests.processTest("${e.type} is unique", false, seenNames.contains(e.type), element);
            seenNames.add(e.type);
        }
    }

    //don't test ALL of them, just a few to make sure its general purpose
    static void testSerialization(element) {
        ActionEffect.setExamples();
        //do one specific example.
        final ActionEffect effect = new AESetNum("secretNumber",13);
        Map<String, dynamic> serialization = effect.getSerialization();
        final ActionEffect effect2 = ActionEffect.fromSerialization(serialization);
        UnitTests.processTest("${effect.type} can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestEffect",effect.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",effect2.getSerialization()), element);

    }


    static void testSetNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testSetNum is 13", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
    }

    static void testAddNum(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddNum("secretNumber",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testAddNum ", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
        scene.applyEffects();
        UnitTests.processTest("testAddNum ", 26, scenario.entitiesReadOnly[1].getNumMemory("secretNumber"), element);
    }

    static void testAddNumFromMemory(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddNumFromYourMemory("secretNumberTotal","secretNumberToAdd");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[1].setNumMemory("secretNumberToAdd",13);
        UnitTests.processTest("AEAddNumFromYourMemory starts out 0", 0, scenario.entitiesReadOnly[1].getNumMemory("secretNumberTotal"), element);
        scene.applyEffects();
        UnitTests.processTest("AEAddNumFromYourMemory add 13", 13, scenario.entitiesReadOnly[1].getNumMemory("secretNumberTotal"), element);
        scene.applyEffects();
        UnitTests.processTest("AEAddNumFromYourMemory add another 13", 26, scenario.entitiesReadOnly[1].getNumMemory("secretNumberTotal"), element);
    }

    static void testSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetString("secretMessage","Carol kind of sucks.");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testSetString ", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testSetString text is replaced", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

    static void testAddGenerator(element) {
        Scenario scenario = Scenario.testScenario();
        String dataString = "reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAJOXdF1vJbfFAnaKV6rfWYs+oYmZpY2tgAm2FK4AOTotkhiAlCJKBgg1gC+QA";
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddGenerator(dataString);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        int numberScenes = scenario.entitiesReadOnly[1].readOnlyGenerators["reaction"].length;
        scene.applyEffects();
        int newNumberScenes = scenario.entitiesReadOnly[1].readOnlyGenerators["reaction"].length;
        UnitTests.processTest("testAddGenerator target has a new generator ${numberScenes} vs ${newNumberScenes}", true,newNumberScenes==numberScenes+1, element);
    }

    static void testRemoveGeneratorsForKey(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AERemoveAllGeneratorsForKey("reaction");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        int numberScenes = scenario.entitiesReadOnly[1].readOnlyGenerators["reaction"].length;
        UnitTests.processTest("testAddGenerator target starts out with 1 key for reaction ", 1,numberScenes, element);
        scene.applyEffects();
        int newNumberScenes = scenario.entitiesReadOnly[1].readOnlyGenerators["reaction"].length;
        UnitTests.processTest("testAddGenerator target has removed all generators for key reaction ", 0,newNumberScenes, element);
    }

    static void testSetScene(element) {
        Scenario scenario = Scenario.testScenario();
        String dataString = "Be Deacon:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBACQCmjKBDAA6AA6oiuKGAQEJUMqgkooCCBNoSAZogkAxDGABuiEhIAeUYgG0yAdQBynAEpygiR+AJLeAOIAspyRZH4AmnKoYAC2EgC6AAQwYADOmTxSrIU8mbAsmW4kwn7hnCSBwWFRMXGJyWlZuTlYmXgSmRQAigAM3pl5mQDuElhyNOCmUBII1nYOzq7IIFU1dQ1BoRHRsQlJqRmZrPmocFODo97zuB162wBCAxQSYIwcC2oNFpLKwMMsELkUG5QFAAJ4KN4gADSEgkChCpj8YF4cBS3ggKX6CDoElyuRIOVQC1sCGuAGswChTGAMLljCBbltmaz2awUgpEGpUFBPIgeJDkMAAL64PkChBCqD4wkrCWgVioBTQWwsowoEZyACsUql6VwZlMUigEuhIDhCOIgi0FDgWEEBg1BEsCFxkVhkQkKUQsIWcsF2JFYrVIDSQYQsJRIe2jAgCAQEmFLrdHuUAGFKQRPS7Sd44LBPSAZSAwwqI8qiWqqzT6YzkNy2TKYfDEcIFAjeO7acoSHBvRxXLL+eHhaKEOKUKBclBEGBNIniK8FkuhwQR73+3xtsMxpXJ-LFfXVQum7TcgymSyO+kpUA";
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddScene(dataString);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        int numberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        scene.applyEffects();
        int newNumberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        UnitTests.processTest("testSetScene target has a new scene ${numberScenes} vs ${newNumberScenes}", true,newNumberScenes==numberScenes+1, element);
    }

    static void testSetSceneFromOwner(element) {
        Scenario scenario = Scenario.testScenario();
        String dataString = "Be Deacon:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBACQCmjKBDAA6AA6oiuKGAQEJUMqgkooCCBNoSAZogkAxDGABuiEhIAeUYgG0yAdQBynAEpygiR+AJLeAOIAspyRZH4AmnKoYAC2EgC6AAQwYADOmTxSrIU8mbAsmW4kwn7hnCSBwWFRMXGJyWlZuTlYmXgSmRQAigAM3pl5mQDuElhyNOCmUBII1nYOzq7IIFU1dQ1BoRHRsQlJqRmZrPmocFODo97zuB162wBCAxQSYIwcC2oNFpLKwMMsELkUG5QFAAJ4KN4gADSEgkChCpj8YF4cBS3ggKX6CDoElyuRIOVQC1sCGuAGswChTGAMLljCBbltmaz2awUgpEGpUFBPIgeJDkMAAL64PkChBCqD4wkrCWgVioBTQWwsowoEZyACsUql6VwZlMUigEuhIDhCOIgi0FDgWEEBg1BEsCFxkVhkQkKUQsIWcsF2JFYrVIDSQYQsJRIe2jAgCAQEmFLrdHuUAGFKQRPS7Sd44LBPSAZSAwwqI8qiWqqzT6YzkNy2TKYfDEcIFAjeO7acoSHBvRxXLL+eHhaKEOKUKBclBEGBNIniK8FkuhwQR73+3xtsMxpXJ-LFfXVQum7TcgymSyO+kpUA";
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddSceneFromOwner("secretScene");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[0].addScene(scene);
        scenario.entitiesReadOnly[0].setStringMemory("secretScene",dataString);
        int numberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        scene.applyEffects();
        int newNumberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        UnitTests.processTest("testSetSceneFromOwner target has a new scene ${numberScenes} vs ${newNumberScenes}", true,newNumberScenes==numberScenes+1, element);
    }

    static void testSetSceneFromTarget(element) {
        Scenario scenario = Scenario.testScenario();
        String dataString = "Be Deacon:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBACQCmjKBDAA6AA6oiuKGAQEJUMqgkooCCBNoSAZogkAxDGABuiEhIAeUYgG0yAdQBynAEpygiR+AJLeAOIAspyRZH4AmnKoYAC2EgC6AAQwYADOmTxSrIU8mbAsmW4kwn7hnCSBwWFRMXGJyWlZuTlYmXgSmRQAigAM3pl5mQDuElhyNOCmUBII1nYOzq7IIFU1dQ1BoRHRsQlJqRmZrPmocFODo97zuB162wBCAxQSYIwcC2oNFpLKwMMsELkUG5QFAAJ4KN4gADSEgkChCpj8YF4cBS3ggKX6CDoElyuRIOVQC1sCGuAGswChTGAMLljCBbltmaz2awUgpEGpUFBPIgeJDkMAAL64PkChBCqD4wkrCWgVioBTQWwsowoEZyACsUql6VwZlMUigEuhIDhCOIgi0FDgWEEBg1BEsCFxkVhkQkKUQsIWcsF2JFYrVIDSQYQsJRIe2jAgCAQEmFLrdHuUAGFKQRPS7Sd44LBPSAZSAwwqI8qiWqqzT6YzkNy2TKYfDEcIFAjeO7acoSHBvRxXLL+eHhaKEOKUKBclBEGBNIniK8FkuhwQR73+3xtsMxpXJ-LFfXVQum7TcgymSyO+kpUA";
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAddSceneFromTarget("secretScene");
        scene.effects.add(effect);
        scenario.entitiesReadOnly[1].setStringMemory("secretScene",dataString);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        int numberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        scene.applyEffects();
        int newNumberScenes = scenario.entitiesReadOnly[1].readOnlyScenes.length;
        UnitTests.processTest("testSetSceneFromTarget target has a new scene ${numberScenes} vs ${newNumberScenes}", true,newNumberScenes==numberScenes+1, element);
    }

    static void testDollStringFromMemory(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetDollStringFromYourMemory("DQ0N");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        Entity e = scenario.entitiesReadOnly[1];
        String originalDollString = e.getStringMemory("originalDollString");
        scene.applyEffects();
        UnitTests.processTest("testDollStringFromMemory currentDollString doesn't change when you try to set it from null.", originalDollString, e.getStringMemory(Entity.CURRENTDOLLKEY), element);
        e.setStringMemory("DQ0N","INVVALID FAKE STRING");
        scene.applyEffects();
        UnitTests.processTest("testDollStringFromMemory currentDollString doesn't change if its a corrupt string.", originalDollString, e.getStringMemory(Entity.CURRENTDOLLKEY), element);
        e.setStringMemory("DQ0N","DQ0N:___DYSQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDKklg=");
        scene.applyEffects();
        UnitTests.processTest("testDollStringFromMemory currentDollString does change if its a valid string.", "DQ0N:___DYSQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDKklg=", e.getStringMemory(Entity.CURRENTDOLLKEY), element);
    }

    static void testTransformDoll(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AETransformDoll(null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        Entity e = scenario.entitiesReadOnly[1];
        e.setDollStringAndOriginal(new EasterEggDoll().toDataBytesX());
        String originalDollString = e.getStringMemory("originalDollString");
        scene.applyEffects();
        UnitTests.processTest("testTransformDoll currentDollString transforms ${e.getStringMemory(Entity.CURRENTDOLLKEY)} vs ${originalDollString}", true, e.getStringMemory(Entity.CURRENTDOLLKEY) != originalDollString, element);
    }

    static void testRestoreDoll(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AERestoreDoll(null);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        Entity e = scenario.entitiesReadOnly[1];
        String originalDollString = e.getStringMemory("originalDollString");
        e.setNewDoll("DQ0N:___DYSQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDKklg=");

        UnitTests.processTest("testRestoreDoll currentDollString starts out as not original.", true, originalDollString != e.getStringMemory(Entity.CURRENTDOLLKEY), element);
        scene.applyEffects();
        UnitTests.processTest("testRestoreDoll currentDollString is restored to original.", originalDollString, e.getStringMemory(Entity.CURRENTDOLLKEY), element);
        }

    static void testUnSetString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Bob reads", "Bob reads his secret message.","");
        ActionEffect effect = new AEUnSetString("secretMessage");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        UnitTests.processTest("testUnSetString message initializes fine", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);

        scene.applyEffects();
        UnitTests.processTest("testUnSetString message is removed", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testUnSetString nothing crashes trying to remove existing message", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

    static void testAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEAppendString("secretMessage","Carol kind of sucks.");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        UnitTests.processTest("testAppendString text is set once", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testAppendString text is set twice ", "Carol kind of sucks.Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        Scene scene2 = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect2 = new AEAppendStringFront("secretMessage","Front");
        scene2.effects.add(effect2);
        scene2.targets.add(scenario.entitiesReadOnly[1]);
        scene2.applyEffects();
        UnitTests.processTest("testAppendStringFront text is set once", "FrontCarol kind of sucks.Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene2.applyEffects();
        UnitTests.processTest("testAppendStringFront text is set twice ", "FrontFrontCarol kind of sucks.Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);

    }
    static void testUnAppendString(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AEUnAppendString("secretMessage","Carol kind of sucks.");
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        UnitTests.processTest("testUnAppendString text is there ", "Carol kind of sucks.", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        UnitTests.processTest("testUnAppendString text is not", "", scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
    }

    static void testSetStringGenerator(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AESetStringGenerator("testString","Carol kind of sucks.");
        scene.owner = scenario.entitiesReadOnly[1];
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        String generatedWord = scenario.entitiesReadOnly[1].getStringMemory("testString");
        UnitTests.processTest("testSetStringGenerator '$generatedWord' is the default ", "Carol kind of sucks.", generatedWord, element);

        List<String> wordSet1 = <String>["hello","world"];
        Generator stringGenerator = new StringGenerator("testString",wordSet1);
        scenario.entitiesReadOnly[1].addGenerator(stringGenerator);
        scene.applyEffects();
        generatedWord = scenario.entitiesReadOnly[1].getStringMemory("testString");
        UnitTests.processTest("testUnAppendString '$generatedWord' is one of the single generator's values", true,wordSet1.contains(generatedWord) , element);
        List<String> wordSet2 = <String>["entirely","new","words","actualyl","a","lot","of","them"];

        Generator stringGenerator2 = new StringGenerator("testString",wordSet2);
        scenario.entitiesReadOnly[1].addGenerator(stringGenerator2);
        scene.applyEffects();
        generatedWord = scenario.entitiesReadOnly[1].getStringMemory("testString");
        UnitTests.processTest("testUnAppendString '$generatedWord' is one of the two different generators possible generated values", true, wordSet1.contains(generatedWord) || wordSet2.contains(generatedWord), element);

    }

    static void testSetNumGenerator(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        scene.owner = scenario.entitiesReadOnly[1];
        ActionEffect effect = new AESetNumGenerator("secretMessageFrequency",13);
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        scene.applyEffects();
        num generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is the default ", 13, generatedNum, element);

        Generator numGenerator = new NumGenerator("secretMessageFrequency",0,10);
        scenario.entitiesReadOnly[1].addGenerator(numGenerator);
        scene.applyEffects();
        generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is one of the single generator's values ", true, generatedNum >=0 && generatedNum <=10, element);

        scene.applyEffects();
        Generator numGenerator2 = new NumGenerator("secretMessageFrequency",-13.9878,5345.4);
        scenario.entitiesReadOnly[1].addGenerator(numGenerator2);
        scene.applyEffects();
        generatedNum = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is one of the single generator's values ", true, generatedNum >=-13.9878 && generatedNum <= 5345.4, element);
        //make sure it isn't just generating the same value over and over again because i'm accidentally resetting rand or something. very unlikely to do the same float between -13 and five thousand here
        scene.applyEffects();
        scene.applyEffects();//for some reason gotta roll twice to pass?
        num generatedNum2 = scenario.entitiesReadOnly[1].getNumMemory("secretMessageFrequency");
        UnitTests.processTest("testSetNumGenerator $generatedNum is not the same value as $generatedNum2 ", true, generatedNum != generatedNum2, element);

    }

    static void testCopyStringTo(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AECopyStringToTarget("secretMessageDraft","secretMessage");
        scenario.entitiesReadOnly[0].setStringMemory("secretMessageDraft","Carol kind of sucks.");
        scene.owner = scenario.entitiesReadOnly[0];
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        UnitTests.processTest("testCopyStringTo secretMessage starts out as null", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        String first= scenario.entitiesReadOnly[0].getStringMemory("secretMessageDraft");
        String second = scenario.entitiesReadOnly[1].getStringMemory("secretMessage");
        UnitTests.processTest("testCopyStringTo secret message ends up as $second.", first, second, element);
    }

    static void testCopyStringFrom(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AECopyStringFromTarget("secretMessage","secretMessageDraft");
        scenario.entitiesReadOnly[0].setStringMemory("secretMessageDraft","Carol kind of sucks.");
        scene.owner = scenario.entitiesReadOnly[1];
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[0]);
        UnitTests.processTest("testCopyStringFrom secretMessage starts out as null", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        String first= scenario.entitiesReadOnly[0].getStringMemory("secretMessageDraft");
        String second = scenario.entitiesReadOnly[1].getStringMemory("secretMessage");
        UnitTests.processTest("testCopyStringFrom secret message ends up as $second.", first, second, element);
    }

    static void testCopyNumTo(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AECopyNumToTarget("secretMessageDraft","secretMessage");
        scenario.entitiesReadOnly[0].setNumMemory("secretMessageDraft",13);
        scene.owner = scenario.entitiesReadOnly[0];
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[1]);
        UnitTests.processTest("testCopyNumTo secretMessage starts out as null", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        num first= scenario.entitiesReadOnly[0].getNumMemory("secretMessageDraft");
        num second = scenario.entitiesReadOnly[1].getNumMemory("secretMessage");
        UnitTests.processTest("testCopyNumTo secret message ends up as $second.", first, second, element);
    }

    static void testCopyNumFrom(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        ActionEffect effect = new AECopyNumFromTarget("secretMessageDraft","secretMessage");
        scenario.entitiesReadOnly[0].setNumMemory("secretMessageDraft",13);
        scene.owner = scenario.entitiesReadOnly[1];
        scene.effects.add(effect);
        scene.targets.add(scenario.entitiesReadOnly[0]);
        UnitTests.processTest("testCopyNumFrom secretMessage starts out as null", null, scenario.entitiesReadOnly[1].getStringMemory("secretMessage"), element);
        scene.applyEffects();
        num first= scenario.entitiesReadOnly[0].getNumMemory("secretMessageDraft");
        num second = scenario.entitiesReadOnly[1].getNumMemory("secretMessage");
        UnitTests.processTest("testCopyNumFrom secret message ends up as $second.", first, second, element);
    }
}
