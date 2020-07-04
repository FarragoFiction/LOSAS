import 'dart:html';

import '../DataStringHelper.dart';
import '../Prepack.dart';
import '../TargetFilters/KeepIfHasPrepack.dart';
import '../TargetFilters/KeepIfHasSceneThatSerializesToValue.dart';
import '../TargetFilters/KeepIfNumIsGreaterThanValueFromMemory.dart';
import '../TargetFilters/KeepIfRandomNumberLessThan.dart';
import '../TargetFilters/KeepIfYouAreMe.dart';
import 'UnitTests.dart';

abstract class TargetFilterTests {

    //only filters, no effects
    static void run(Element element) {
        testBasic(element);
        testTFNumExists(element);
        testTFNumIsGreaterThanValue(element);
        testTFNumIsGreaterThanValueFromMemory(element);
        testTFNumIsValue(element);
        testTFStringExists(element);
        testTFStringIsValue(element);
        testTFSceneIsValue(element);

        testTFStringContainsValue(element);
        testTFNameIsValue(element);
        testTFYouAreNotMe(element);
        testTFNameIsValueAndStringDoesntExist(element);
        testIfRandomNumberLessThan(element);
        testNoDoubles(element);
        testHasPrepack(element);
        testSerialization(element);
    }

    static void testHasPrepack(element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfHasPrepack("Bastard:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgB2YAttiiAEJiFSmYi2EQA5oKJRcAETgAbKQBUAngAcWyAIwAGfkJFcJ0uUuwA5JivYI4fEDkJkEAS0VR7cOqwBiiAARgARoWlobC8OLh5CADorezp7ZzApAGlseUJZOABxbDoqMDEUAG0QBBIyZ1crWGxmAGVXQRAAXX4ybKJC0EhYRFYMHHwiEnJKGhBGCEJ7MgB5ADNZ4igUTRBfQQAZODI8lzoAUTpeVAz4CCkAehhIOjFMAH1fTmrsqAjFOgbaccmyTe3y-aHViMMCxMgASToAUYsTAZHOAFkEHcAFJUBDyO4I0GYRARODCSqkERQaY5FCzBLEWi+bCzRDYdxSMAAN0QsmwAA8lqgCtMAOpGPZ4CI1WR4cFGDIIvYI6Z4ACaEQYzEaXkIiiYhB8dC8AAFsCyqPJXNgojSNlsdq4DphkvJWFZvlM-tbAXaUo7aGBZmIEEzWeyuTyQAVZABBPAZPayUXiyXS2XypUq7Bq0jBOhwKBeRRSEjETARLyySjyLxXI0+QiTQQ5TBeWD2bV8wXCuMSqUyuWKiIa7BkexENVVRtxfNeOCzLwAclC3AQmBnxdbQpFYs7iZ7SpKcIBjWLAAlgmQ4Iw89gxFJy5T7FJtVA4F5tiVJwgvPnSLrQeX8zXXJEVipqwBpGhippEggJLuHefqEB0IBQIYrDJNgijgrMCpwBA4YlAiLC0CyDiEAA1mAFJUtgtBZjyUAIBAVEgPY56INwNz8ogmDwcgwAAL60MxiisaCUBGBAjC0gg3F8bxzQgHSswDlA3EFKASHKKw4aKMohw1HRMSCOk7gWDc0QsQgbFQBxi7SSAXCIGAIj2qwwH8PpHzpFpOlHOwnALg2ID8Ux5mWWJElUNJQVEc2ZEoHRDGybJ3plPYLJuncthtCpckiDkCB5IgKmgCRnqoLuKUVLQ6lmBuCZWEJNb2L4+YAGoJAxKmhgKa4dgm3bJsqphquVynUF4vjQB+9glT441+TwXgAO7YVIvC0Ku7a1V2Sa9qmapoBMOb5c2RA6l4KTYL4FiLVYG3rvG23boNqpeLe96Nk+L5UeNA6QMQFbYDO2pgHNYSLk0-HFaViGULU9SVMhqBbRk9VwI1zXYG1UgdYUYyglMkLQrC8I1GAigwPYJR3DUiiU0QdziM2j4Wbg+KEo0iVAA");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testHasPrepack no char has bastard prepack", false, result, element);
        scenario.entitiesReadOnly.first.processSinglePrepack(Prepack.fromDataString("Bastard:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgB2YAttiiAEJiFSmYi2EQA5oKJRcAETgAbKQBUAngAcWyAIwAGfkJFcJ0uUuwA5JivYI4fEDkJkEAS0VR7cOqwBiiAARgARoWlobC8OLh5CADorezp7ZzApAGlseUJZOABxbDoqMDEUAG0QBBIyZ1crWGxmAGVXQRAAXX4ybKJC0EhYRFYMHHwiEnJKGhBGCEJ7MgB5ADNZ4igUTRBfQQAZODI8lzoAUTpeVAz4CCkAehhIOjFMAH1fTmrsqAjFOgbaccmyTe3y-aHViMMCxMgASToAUYsTAZHOAFkEHcAFJUBDyO4I0GYRARODCSqkERQaY5FCzBLEWi+bCzRDYdxSMAAN0QsmwAA8lqgCtMAOpGPZ4CI1WR4cFGDIIvYI6Z4ACaEQYzEaXkIiiYhB8dC8AAFsCyqPJXNgojSNlsdq4DphkvJWFZvlM-tbAXaUo7aGBZmIEEzWeyuTyQAVZABBPAZPayUXiyXS2XypUq7Bq0jBOhwKBeRRSEjETARLyySjyLxXI0+QiTQQ5TBeWD2bV8wXCuMSqUyuWKiIa7BkexENVVRtxfNeOCzLwAclC3AQmBnxdbQpFYs7iZ7SpKcIBjWLAAlgmQ4Iw89gxFJy5T7FJtVA4F5tiVJwgvPnSLrQeX8zXXJEVipqwBpGhippEggJLuHefqEB0IBQIYrDJNgijgrMCpwBA4YlAiLC0CyDiEAA1mAFJUtgtBZjyUAIBAVEgPY56INwNz8ogmDwcgwAAL60MxiisaCUBGBAjC0gg3F8bxzQgHSswDlA3EFKASHKKw4aKMohw1HRMSCOk7gWDc0QsQgbFQBxi7SSAXCIGAIj2qwwH8PpHzpFpOlHOwnALg2ID8Ux5mWWJElUNJQVEc2ZEoHRDGybJ3plPYLJuncthtCpckiDkCB5IgKmgCRnqoLuKUVLQ6lmBuCZWEJNb2L4+YAGoJAxKmhgKa4dgm3bJsqphquVynUF4vjQB+9glT441+TwXgAO7YVIvC0Ku7a1V2Sa9qmapoBMOb5c2RA6l4KTYL4FiLVYG3rvG23boNqpeLe96Nk+L5UeNA6QMQFbYDO2pgHNYSLk0-HFaViGULU9SVMhqBbRk9VwI1zXYG1UgdYUYyglMkLQrC8I1GAigwPYJR3DUiiU0QdziM2j4Wbg+KEo0iVAA"));
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testHasPrepack one char has bastard prepack", true, result, element);

    }

    //needed because if i typo types and any double up i get hard to track down bugs
    static void testNoDoubles(element) {
        List<String> seenNames = [];
        TargetFilter.setExamples();
        for(TargetFilter e in TargetFilter.exampleOfAllFilters) {
            UnitTests.processTest("${e.type} is unique", false, seenNames.contains(e.type), element);
            seenNames.add(e.type);
        }
    }


    static void testSerialization(element) {
        ActionEffect.setExamples();
        //do one specific example.
        final TargetFilter filter = new KeepIfNumIsValue("secretNumber",13);
        Map<String, dynamic> serialization = filter.getSerialization();
        final TargetFilter filter2 = TargetFilter.fromSerialization(serialization);
        UnitTests.processTest("${filter.type} can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestFilter",filter.getSerialization()), DataStringHelper.serializationToDataString("TestFilter",filter2.getSerialization()), element);

    }

    static void testBasic(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFFalse", true, result, element);
        UnitTests.processTest("testTFFalse 3 targets", "{Alice, Bob, Eve, Carol}", scene.targets.toString(), element);
    }

    static void testTFNumExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumExists("secretNumber");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists Test1", false, result, element);
        UnitTests.processTest("testTFNumExists 0 targets", "{}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists Test2", true, result, element);
        UnitTests.processTest("testTFNumExists 0 targets", "{Bob}", scene.targets.toString(), element);

        filter.not = true;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists TestNot", true, result, element);
        UnitTests.processTest("testTFNumExists 2 targets", "{Alice, Eve, Carol}", scene.targets.toString(), element);

        scene.targetOne = true;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumExists can set it to target only one even though it just targeted 2", 1, scene.finalTargets.length, element);

    }

    static void testTFNumIsGreaterThanValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsGreaterThanValue("secretNumber",13);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test1", false, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test2", true, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 1 targets", "{Bob}", scene.targets.toString(), element);

        filter.importantNumbers[KeepIfNumIsGreaterThanValue.INPUTVALUE] = 113;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValue Test3", false, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValue 0 targets2", "{}", scene.targets.toString(), element);

    }

    static void testIfRandomNumberLessThan(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfRandomNumberLessThan(0);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testIfRandomNumberLessThan nothing is less than 0", false, result, element);

        filter.importantNumbers[KeepIfRandomNumberLessThan.INPUTVALUE] = 1;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testIfRandomNumberLessThan everything is less than 1", true, result, element);

        filter.importantNumbers[KeepIfRandomNumberLessThan.INPUTVALUE] = 0.5;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testIfRandomNumberLessThan this is actually random", true, result, element);
    }


    static void testTFNumIsGreaterThanValueFromMemory(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsGreaterThanValueFromMemory("secretNumber","secretNumberMemory");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory NeitherSet 1", false, result, element);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory NeitherSet, 0 targets", "{}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory Number Set, Not Memory", true, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemory Number Not Set,  Memory Is", false, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",113);
        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemoryBoth Set, number bigger", true, result, element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        scenario.entitiesReadOnly[1].setNumMemory("secretNumberMemory",113);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsGreaterThanValueFromMemoryBoth Set, memory bigger", false, result, element);

    }

    static void testTFNumIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNumIsValue("secretNumber",85);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test1", false, result, element);
        UnitTests.processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);


        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",85);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test2", true, result, element);
        UnitTests.processTest("testTFNumIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setNumMemory("secretNumber",113);
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNumIsValue Test3", false, result, element);
        UnitTests.processTest("testTFNumIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFStringExists(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringExists("secretMessage");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringExists Test1", false, result, element);
        UnitTests.processTest("testTFStringExists 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringExists Test2", true, result, element);
        UnitTests.processTest("testTFStringExists 0 targets", "{Bob}", scene.targets.toString(), element);
    }

    static void testTFStringIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringIsValue("secretMessage","Carol kind of sucks.");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test1", false, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test2", true, result, element);
        UnitTests.processTest("testTFStringIsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test3", false, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{}", scene.targets.toString(), element);
    }

    static void testTFSceneIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        String dataString = "Be Deacon:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBACQCmjKBDAA6AA6oiuKGAQEJUMqgkooCCBNoSAZogkAxDGABuiEhIAeUYgG0yAdQBynAEpygiR+AJLeAOIAspyRZH4AmnKoYAC2EgC6AAQwYADOmTxSrIU8mbAsmW4kwn7hnCSBwWFRMXGJyWlZuTlYmXgSmRQAigAM3pl5mQDuElhyNOCmUBII1nYOzq7IIFU1dQ1BoRHRsQlJqRmZrPmocFODo97zuB162wBCAxQSYIwcC2oNFpLKwMMsELkUG5QFAAJ4KN4gADSEgkChCpj8YF4cBS3ggKX6CDoElyuRIOVQC1sCGuAGswChTGAMLljCBbltmaz2awUgpEGpUFBPIgeJDkMAAL64PkChBCqD4wkrCWgVioBTQWwsowoEZyACsUql6VwZlMUigEuhIDhCOIgi0FDgWEEBg1BEsCFxkVhkQkKUQsIWcsF2JFYrVIDSQYQsJRIe2jAgCAQEmFLrdHuUAGFKQRPS7Sd44LBPSAZSAwwqI8qiWqqzT6YzkNy2TKYfDEcIFAjeO7acoSHBvRxXLL+eHhaKEOKUKBclBEGBNIniK8FkuhwQR73+3xtsMxpXJ-LFfXVQum7TcgymSyO+kpUA";
        TargetFilter filter = new KeepIfHasSceneThatSerializesToValue(dataString);
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFSceneIsValue Test1", false, result, element);
        UnitTests.processTest("testTFSceneIsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly.first.addScene(new Scene.fromDataString(dataString));
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFSceneIsValue Test2", true, result, element);
        UnitTests.processTest("testTFSceneIsValue 1 targets", "{Alice}", scene.targets.toString(), element);

    }

    static void testTFNameIsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfNameIsValue("Bob");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringIsValue Test1", true, result, element);
        UnitTests.processTest("testTFStringIsValue 0 targets", "{Bob}", scene.targets.toString(), element);

    }

    static void testTFYouAreNotMe(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfYouAreMe();
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFYouAreMe Test1", true, result, element);
        UnitTests.processTest("testTFYouAreMe 0 targets", "{Alice}", scene.targets.toString(), element);
        filter.not = true;
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFYouAreNotMe Test1", true, result, element);
        UnitTests.processTest("testTFYouAreNotMe 0 targets", "{Bob, Eve, Carol}", scene.targets.toString(), element);

    }

    //this is to catch a bug where multiple filteres weren't working, and the order they were run in mattered.
    //originally i'd look for bob, then loook for "someone without a secret message" then only return that
    //but if i ran it the other way i'd instead target bob regardless of if he had a secret message
    //both are wrong
    static void testTFNameIsValueAndStringDoesntExist(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringExists("secretMessage")..not=true;
        TargetFilter filter2 = new KeepIfNameIsValue("Bob");
        scene.targetFilters = [filter2, filter];
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Test1", true, result, element);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist 1 targets", "{Bob}", scene.targets.toString(), element);

        scene.targetFilters = [filter, filter2];
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result2 = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Reverse TEst", true, result2, element);
        UnitTests.processTest("testTFNameIsValueAndStringDoesntExist Reverse 1 targets", "{Bob}", scene.targets.toString(), element);

    }

    static void testTFStringContainsValue(Element element) {
        Scenario scenario = Scenario.testScenario();
        Scene scene = new Scene("Alice Sends", "Alice sends a secret message to Bob.","");
        TargetFilter filter = new KeepIfStringContainsValue("secretMessage","carol");
        scene.targetFilters.add(filter);
        scenario.entitiesReadOnly.first.addScene(scene);
        bool result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test1", false, result, element);
        UnitTests.processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);



        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Carol kind of sucks.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test2", true, result, element);
        UnitTests.processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","Actually carol is great.");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test3", true, result, element);
        UnitTests.processTest("testTFStringContainsValue 1 targets", "{Bob}", scene.targets.toString(), element);

        scenario.entitiesReadOnly[1].setStringMemory("secretMessage","the eagle strikes at midnight");
        result = scene.checkIfActivated(scenario.entitiesReadOnly);
        UnitTests.processTest("testTFStringContainsValue Test3", false, result, element);
        UnitTests.processTest("testTFStringContainsValue 0 targets", "{}", scene.targets.toString(), element);
    }
}