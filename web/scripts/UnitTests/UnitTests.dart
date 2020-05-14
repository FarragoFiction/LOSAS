/*
we are fucking doings this right. for each target filter, action effect, etc we make we are going to fucking test this.
 */
import 'dart:html';
import '../ActionEffects/AEAddNum.dart';
import '../ActionEffects/AEAddNumFromYourMemory.dart';
import '../ActionEffects/AEAppendString.dart';
import '../ActionEffects/AEAppendStringFront.dart';
import '../ActionEffects/AECopyNumFromTarget.dart';
import '../ActionEffects/AECopyStringToTarget.dart';
import '../ActionEffects/AESetDollStringFromMyMemory.dart';
import '../ActionEffects/AESetNum.dart';
import '../ActionEffects/AESetNumGenerator.dart';
import '../ActionEffects/AESetString.dart';
import '../ActionEffects/AESetStringGenerator.dart';
import '../ActionEffects/AEUnAppendString.dart';
import '../ActionEffects/AEUnSetString.dart';
export '../ActionEffects/ActionEffect.dart';
import '../ActionEffects/ActionEffect.dart';
import '../DataStringHelper.dart';
import '../Entity.dart';
import '../Generator.dart';
import '../TargetFilters/KeepIfNumIsGreaterThanValueFromMemory.dart';
import '../TargetFilters/KeepIfRandomNumberLessThan.dart';
import '../TargetFilters/KeepIfYouAreMe.dart';
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


    static void runDisplayTest(Element element) async {
        Scenario scenario = Scenario.testScenario();

        setupAliceSendsMessage(scenario);

        setupEveEvesdrops(scenario);

        setupCarol(scenario);

        bobReceivesMessage(scenario);

        aliceStopsAfterEnoughMessages(scenario);

        djcottonball(scenario);
        theDeacon(scenario);
        scenario.curtainsUp(querySelector("#output"));
    }

    static void theDeacon(Scenario scenario) {
        Entity deacon = new Entity("The Deacon of Madness", "DQ0N:___DYSQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDKklg=")..isActive = true;
        scenario.addEntity(deacon);
        final Scene bedeacon = new Scene.fromDataString("Be Deacon:___ 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-V+79P7f1-rhABQDnygPAZAro0DYHwI0Ig5BHBUHoMwRAbB108EEKijIYhpCpDkModQ2h9C9yMOYaw9hnDuG8P4YI4RojxGSOkcqWR8jFHKMIKo9RfitEWiKfSH0pSdkVLLFUg5gx7RAA");
        deacon.addScene(bedeacon);
    }

    static void djcottonball(Scenario scenario) {
      Entity dj = (new Entity("DJ Cotton Ball","DJ+Cottonball%3A___FhL_AAD8_Pzy8vL_AAD_AQCtAAEAAAAAAAD_AAAAAAAAAAAxMTPTAACuAAAAAAAxMTNJSUk0kxs%3D")..facingRightByDefault=true..isActive=true);
      scenario.addEntity(dj);
      final Scene atEveryone = new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBALXgAvMDAB0AB1RFcUMAgIBTKGVQaUAMzAYAzhtob9iDQDEMYAG6ISGgB5RiAbTIB1AHKcAJVlBEgCASV8AcQBZTmiyAIBNWVQwAFsNAF0AAmN5dONssFRsgAENew0EAE8ODVkacH0oKtsHJ1d3ZBAPEmEAyM4SYNCImLiE5NSMnLUNbNQ4KGz5DA0wUx5ZbJIYDWrsmAd5jeNWAl0ebNhWQq8-QJHwqNj4pNk8jUZWDWMc2HmbCga2ycH02QA5AAhDaqBA8CHbe7+IIhZ7jN5TdJZbKGVgma5wbLMBD1RrTPTdcqVGp1RpwzRQaz4loIYwoDygKDVeSUkAAaQ0GnkYX0iTgEGEpOielw9gQtwA1mADEZTLhFl0oAgIGYQKw0vJEKpUFBvIgeOzkMAAL64A1GhAmqC+CBpPBVK22m2ZXAWfRfKBWzkgbm84jCeS83iCbWsJQkODWBAcdz2w3G4pmi1ekDGKCIMCaQXVYgUxr5hUJuCR6N8bow-NqK4gO36jNOrOu92elC2uUK4zKlDa3U+m1AA");
      dj.addScene(atEveryone);
    }

    //the scenario ends after 8 secret messages have been sent.
    static void aliceStopsAfterEnoughMessages(Scenario scenario) {
      Scene finalScene = new Scene("The End", "Now that alice has sent [TARGET.NUMMEMORY.secretMessageCount] messages, the cycle of messages ends.","The End.")..targetOne=true;
      finalScene.bgLocationEnd = "AlternianCliff.png";
      finalScene.scenario = scenario;
      //if anyone has this greater than 5
      TargetFilter filter6 = new KeepIfNumIsGreaterThanValue("secretMessageCount",13);
      finalScene.targetFilters.add(filter6);
      scenario.stopScenes.add(finalScene);
    }

    //if bob has a secret message, bob reads it, and clears it out.
    static void bobReceivesMessage(Scenario scenario) {
      Scene scene3 = new Scene.fromDataString("Bob Reads:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbECCGKAFMEqVmFQAJVgDdhAZwB0AB1RFcUMAgLCoZVMJRQEEYbWEAzRMIBiGMLMQlhADyjEAQnDwACBMJgPAq+MKwhALaKCmC6Sr4A5ADaZADqAHKcAEpKAMokWQCS6QDiALKcZWRZAJpKCsKMAVBl0bHCALoJ8TTgliII9o7Obh7IICkZ2XkFxeWV1XUBYIxsHB3YvrCsqADWIWB4cNBbMMK+6BF4or6TmTnpAKplFVW1SgiSPHAR6RBXog2p2EqF8jAwgQQITCkTauhCxygSl6qDAUS8Pl8WUCwV6Wh0elsrCEogUKCSoCgAE8VEZxgBpYTCFSFSy5Ew7AicVzhKBk3CyBDhXZgFCWMAYBq4VBwMbiyXmECsCIqRBaVBQVKIXHIUBRCKIKmMqnEBpNPStBQxXQgAC+uGVqoQ6qgfwBUJQwFt9spNLpIEZzNZNWO-ACrV6guFouQ8qlIBlcol8cdaskmu1ZN19qVKrTGrd1w92dtGxAVksjT55N9tOIj1QDSg7KF6l6qed6a1CB1euEBoQRuEJvGZualutRhzHZdhdJnpzUYUIuMpmEPpA1Lr41yehbnJKINELEQ7bznY13d7IF0hk+UEQxuIy1W7FQvR4VkgQgAahKzMQUjnKqCh8qcATnNc2hktO56zv8RZZl6ApCsuMYmGYG5bv6u6uv8h53ieSAOnBXaZp6ID6oaT7jJ8vA-HOSCwU68HukhICfuKmBQH+GAAcgACMAkAMyLqhK7IBh64dLaQA");
      scenario.entitiesReadOnly[1].addScene(scene3);
    }

    //        //if bob has a secret message, eve reads it.
    static void setupEveEvesdrops(Scenario scenario) {
      Scene scene2 = new Scene.fromDataString("Eve Intercepts:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbECCGKAFMEqVmH4QEiMACFEwsBlYBnQSLESAdAAdURXFDAICwqGVTCUUBBGG1hAM0UAxDGABuiEsIAeUMScnsIABGqhqqhwcLqsBqEcoQp4AOSqoQC2wqqqYGbaNOBOmu5ePv6ByCAA2mQA6gBynABK2gDKJC0Ako0A4gCynANkLQCa2ghKjGwcALraoQASopHMvMqhCCzxBOEZdU2t2o0AqgNDI+Paqus8yi07BnNFqGDZQSGh3aiajMK6KCqIrGUzmVysISiYHIGqgKAAT101mqAGlhADuk52rZdpw-GogUVPAg1ABrMAoJzKVQOEDRKrUjC03CsTK6RDGX71RA8GGgbKZRAI9EI4i0xhTKADHJ5MwgAC+rPZnLAv0aEEyeGhKGACqV8KRKJA6MxTka72E3VUADVlPZiaTVBSqTS6QzXcy6WyOQguVAeQg+bqQPFdNA7RgHdUUorlb7-RqtTrkHqFXNcM4nMIZjC4SBEciBDweI1hAB3JMkOD4wm7Io+1Xc3n8kCC4Wi8V3B5PIhK0Mqv1qqBJ7UIVvoTLV-gllAARn7JPJlOQtnsBoLRuI7XMONJBj6wis2ygiAbg-9geDqZAZmPLEQneqUzAM3YqCKPGckCEkejIHaGAwgiW41XuFQAC9hB4UI2GyDIwCySEVA4OMBwTYdRxTPVcCXZ0VzXYR0wVIA");
      scenario.entitiesReadOnly[2].addScene(scene2);
    }

    static void setupCarol(Scenario scenario) {
        final Entity carol = scenario.entitiesReadOnly.last;
        final Scene carolActivates = new Scene.fromDataString("Carol activates:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgBGA5iiACoDyAImyLYwDJwyYKAEs4AOwCi4zMwDi8CABsA9DEjiouAPrqlSgO5gAngDoADuKa0AthEIiyAoaInTZqDDnxES5SggqBtgiCJhgNnQi2JqmcAzWIFCkDNhQbOLYKABmYErEvNjZiNgAYkpgAG6ILNgAHlDMkpXYAASE5ggkmIStsG1oEI7GrQxwhA7mfXCtAMKkcEqmPODZWgjlVTX1jajzCIutQuIA5FCtdNhK0S2tAILXZG0ivclKANYiVu0wIudgdDg0FaAVMrQAypRWu9xHADL0ANosO54OSSFimcEsPAASQAcnIALKSQlsPAATVM4gi2AAuq0Xq1hO1juElK0EMIvgxWgi2AB1PGSPCmPEAVUJxNJFNMhFZeUJ2BsiGMtOWtGpNiyewW7LAZFElWERBWyQQqSgpRESnWhBQCNAUGM5m1IAA0thsOYcdk8RAbDjCHIusaECx1OIAGp5CBZWiVBAvd5gHJ5AogWG7XL5bC0EQ2cyIZKafmIHooUBa5UIYzvbDGZhysAyPJ4LlWEAAXzzBaLzagfsiVDtyFAX3M0CNSljKAAjJ3O7TaEVstgDSOHUlna7wWlB3IYlRhIgVvnCwhi1BS2ER5WlSqPQ3UJyZHAbIPLkhuyAz33NB-hwrEAcFyZQoGjadtQAZm-BMkxTZBs2IbtHW3ZhZjgcxjEHUoDhsFgUjSU9ewvftr3LUckkoUJB0fRt5SUNtRA7WxjHBKBEDAVI6NQJsWyURVqwbb9f1I-9-U-W9YMTQhk1THNF07IA");

        //TODO add a random element to this
        final Scene carolFumes = new Scene.fromDataString("Carol fumes:___ N4IghgrgLgFg9gJxALgHYQDYYDQgLYQDOAlgMYDyAZpYQKZQoAMuARgOYAycpYUxcqAKKoAJihABxeJgD0MSKii0RAfUJxKYAHQAHVGxC4CJUlx58BwschAArMCOUAlWnTAJSMWghkB3WsQIImB4LMS0ilpwbAa4UO5s9OSotCiaGHSstJSItABiGGAAbogAKrQAHgw2ANqlAIJOEoKlWgDKpU4AkgByEgCygv3kTgCaWqghtAC6AASEOgi0DoSztEURs3i5s7YQZACes2xwhCQ6s1BwswDC7nAYWobglEoIBcVlldUgdwgPs0oEDwrlmNXIAHUeoInFoegBVfqDYZjLQIMCiOB4HrAljeOY6ODERSEbCzFjQWZwSkaWbwXxbDEHAD8swAEt5AcDaLN0Xx9LNiKtwVCYXDEciRuMgSCnLxiWxpmSMSJ5l5ZgBrVBwXzChpNFrtTq9AZDKUTKZzIWzXjzHiiMAYXnygUi6GwhFIs2owj24IYfq0bYIA7TJ64SYg8R-AEy1zPeIIRJQPLEDBvQgoGqgKAHHSpGwAaVotB0XUoOLwggqQqgmdwRQQQo1YDSjsyIG11XSHeIeEJCHiighiBEmeQoBBwYOGtoB3EvpVjrl-IMAF9cH2B0OoJW8Qhx8A1xuc3mCyBi6Xy5WuoQJEteN5SvJUAA1R0QfL-PCB6fPRvNq2yA9rQEZwN27agSAW6IDuI5BIe+BBogBzFgcHDZD8i4OhgK4Ks8U4obOBxOMQbAwFhfqOr+KEgBu0H9rBGK7ri3iHseSogNklC0KQdZZqe+biG09CVhIETeLwiDPDBg7MfBY4oJOyEhmh4jopi2KsUg9GyTue5sUpICOJomBQO+GCfigADM9EAYQLYoFACCfieIC5kJNj1CIIiVnk36lAk9ClHA1a1vhm6MXJw6joheAHDRqlznkiCpgeUDeSIiD1KIbRXOiiTiHGeH6M8BzUggiWoXOIWZepKpYgZOmRduzFNexDZNg5QHOa52CCeeNxwDoBx+QFQUMC1TExQhRmwAECCVmpNjYf6JWxPgBx5YgYCJMtICrdRKnzrpUX6dpHUgPZjnAZBa7TGuQA");
        carol.addScene(carolFumes);
        carol.addActivationScene(carolActivates);
    }

    //if bob does not have a secret message, alice sends a message to bob.
    // this sets his secretMessage string and increments his secretMessageCounter
    static void setupAliceSendsMessage(Scenario scenario) {
       Scene scene = new Scene.fromDataString("Alice Sends:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbECCGKAFMEqVmFQAxOAQIBPQSLETpiYQGcoAOgAOqIrihgEBYVDKphKKAgjDawgGbqpGMADdEJYQA8oAhisjA4ABDCerAahGsKoUKEA2mQA6gBynABK2mkAqgCy+Zz5ZJkAmtqxjAjm+ZoaYGYAwnAQ8QC6oQC29Y2a2DFxPBqhYKFWAO6D1ebdvWahUHChAEJweNo04E7Kbp7efgHIIADKMMLjcCIjGufhYCOocFOx8UmpGdl5hcWlFVU1KB1DQNZqtDqLK5gDBzEF9DSbXCoMA9QLBC4nIYaLbGUzmKSsISibHIRKgKDyXTWY4AaWEwl0AEknGkUcJGRoAGrQ+xbDwIVgaADWYBQTmhsSRVzFEocIFYXV0iGM8RSiGGKFAUV00G5GF5xzWeBAAF9cAqlQgVVA0hAunhiZqTWbyZTqSA6QzmSdbFECJxfIKoNjcPzBSKZRhJSAnkdbPZzYrlZIoGqEBrkKAel1EPI6fJiADavNrGb5UmrSnbfbHZnne1cM4nMJGMGUGSQBSqcRMVAfQKDABxOKiFiILYW5Oq9Uk0BmKwIMcIfOFluA4Gg4QURc7LY8ZyQIR6g0gJomOAwsB4DQX6DCeQxCCMIUI02Jy3W6sOhCzsth4Wisg8bCC6nZusQLS6PI-Z+iQcAkCYZgBO+U6pjOmqducrAIDBBgrscRZAiWWxdNBSyLmY+EgIRG59NuYC7mWk6VvEX61sAf4CgBkaxKBXbuvwPA8GkwgTNWcEBkGfoThW1pphmWbCDmCB5veq4zERcJgm0ARMbJVZ2t+s4xnacGCXwyAAIyceGgHASa7QmkAA");
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

