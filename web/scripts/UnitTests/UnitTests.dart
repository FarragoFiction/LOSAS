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


    static void runDisplayTest(Element element) {
        Scenario scenario = Scenario.testScenario();

        setupAliceSendsMessage(scenario);

        setupEveEvesdrops(scenario);

        setupCarol(scenario);

        bobReceivesMessage(scenario);

        aliceStopsAfterEnoughMessages(scenario);

        djcottonball(scenario);
        theDeacon(scenario);
        print("JR get ready to slurp:");
        for(Entity e in scenario.entitiesReadOnly) {
            List<String> ret= e.readOnlyScenes.map((Scene s ) => DataStringHelper.serializationToDataString(s.name,s.getSerialization()));
            print("Name: ${e.name} has ${e.readOnlyScenes.length} scenes.");
            print(ret.join(","));
        }
        scenario.curtainsUp(querySelector("#output"));
    }

    static void theDeacon(Scenario scenario) {
        Entity deacon = new Entity("The Deacon of Madness", "DQ0N:___DYSQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDKklg=")..isActive = true;
        scenario.addEntity(deacon);
        final Scene bedeacon = new Scene.fromDataString("Be Deacon:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbF1kAygEFBACQCmjKBDAA6AA6oiuKGAQEJUMqgkooCCBNoSAZogkAxDGABuiEhIAeUYgG0yAdQBynAEpygiR+AJLeAOIAspyRZH4AmnKoYAC2EgC6AAQwYADOmTxSrIU8mbAsmW4kwn7hnCSBwWFRMXGJyWlZuTlYmXgSmRQAigAM3pl5mQDuElhyNOCmUBII1nYOzq7IIFU1dQ1BoRHRsQlJqRmZrPmocFODo97zuB162wBCAxQSYIwcC2oNFpLKwMMsELkUG5QFAAJ4KN4gADSEgkChCpj8YF4cBS3ggKX6CDoElyuRIOVQC1sCGuAGswChTGAMLljCBbltmaz2awUgpEGpUFBPIgeJDkMAAL64PkChBCqD4wkrCWgVioBTQWwsowoEZyACsUql6VwZlMUigEuhIDhCOIgi0FDgWEEBg1BEsCFxkVhkQkKUQsIWcsF2JFYrVIDSQYQsJRIe2jAgCAQEmFLrdHuUAGFKQRPS7Sd44LBPSAZSAwwqI8qiWqqzT6YzkNy2TKYfDEcIFAjeO7acoSHBvRxXLL+eHhaKEOKUKBclBEGBNIniK8FkuhwQR73+3xtsMxpXJ-LFfXVQum7TcgymSyO+kpUA");
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
        final Scene carolActivates = new Scene("Carol activates","Eve spreads the juicy gossip to Carol.","Carol can't believe Alice is talking shit about her. She knows [TARGET.STRINGMEMORY.name] is at scandal rating [OWNER.NUMMEMORY.scandalMemory].");
        TargetFilter carolFilter = new KeepIfNumIsGreaterThanValue("scandalRating",1);
        carolActivates.targetFilters.add(carolFilter);
        ActionEffect effect = new AESetNumGenerator("randomNumber",3)..vriska=true;
        ActionEffect rememberScandalRating = new AECopyNumFromTarget("scandalRating","scandalMemory");
        ActionEffect rememberScandalRating2 = new AECopyNumFromTarget("scandalRating","scandalMemory");
        carolActivates.effects.add(rememberScandalRating2);
        carolActivates.bgLocationEnd = "AlternianBeachHivestem.png";

        ActionEffect aggregate = new AEAddNumFromYourMemory("fumeRating","randomNumber")..vriska=true;

        //TODO add a random element to this
        final Scene carolFumes = new Scene.fromDataString("Carol fumes:___ N4IghgrgLgFg9gJxALgHYQDYYDQgEYDmKIAKgPIAiZIuhAMnAMZhQCWcqAoqgCbECCGKAFMEqVmBIQEUDMMEixEgHQAHVEVxQwCAsKhlUwlADMwGAM7Dawk4mEAxDGABuiEsIAeUYgG0S-ABKAOKcJMoAyiSBAJIAcsEAspyJZIEAmsqoYAC2wgC6AAQWqgjCYDwWhcIuwqiFOfaFAFYQrIwAnoUEcBYWrKqFUHCFAMI6cBjKNOAmik6u7l4+yCDjCJOFJhB5Vb5kAOpxnIHKcQCqicmpGcoIYLxwOXE7eKJFqnCsqFAW2IV4aCFOBAuAmQrwADuDQeHQA-IUABKiLY7YSFe5sDSFVh7Q7HU4XK4pNKZbZ5QIsb4EfL-B48YowdEAa1QcEhewCITCkWi8SSJNu2TyRVxhRYxWYvHMGKp2P2RxOZ0u11JygsUp45kSwkaCA6+WmuGFxlW6025OEFhm2l0+gcrCEomtyF8oCgHVUppAAGlhMJVDETC8cpxPLjfjMXAhccywKZzFZjXAVmZLNYQKwcp8ZA8oAdEJUUKA8nqOszhB1iBr6eZKViiABfXBZnPaH4ht4IF3ARvN92e71+gNBkMxCzBMosUQkGAPABq5ggjg2OR1ZajMYscYT6eTqcTGdbiHb+cLPZApcQHT9HTothWIBr0ow9epMyv+orHUCrAIMEfZ8tQwddrxAZtM2zE8807Z1iz7WkQFsExhEYSNXQHL1iAifQQ2COpRBYRAZmPXMfgLBAi2QEtdWvW9iHuR5nleURwJbKCyKgWDu2LEAeFsSAhEXDBlxQABmCDo1jeNkCgBBl37EAPSw1Z+B4HgQwcVcSB0PQoBIOAwwjd92LbPMKKoksOlA-VbwcRAHW7KA1J4RB+F4CJhnuPRiEtN8NBmDoQQQGyb0rAyXIY+knm4tjILMjsWJ46jJK3HdZPk4RFOU71RjgVQOk07TdP0EiONPCyL1gYRWAQEN6NWIC6zlTRLw6TzEDAPQGqfTVtVo-U4tI09uJ7VLpN3KxG3yRsgA");
        carol.addScene(carolFumes);
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

