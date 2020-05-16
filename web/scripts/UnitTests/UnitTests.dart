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
        final Scene bedeacon = new Scene.fromDataString("Be Deacon:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCBGsAygEE1ACWxkoEMADoADjKEhaDZmTESpshUtR0wMlgEkZhOHXdgyAHoAOTgmBB9zIzghC1ooUiFsKFYZbBQoBAhsQWx2RGwAMQAbMAA3RAAVbAAPHlQAbVYAdWC5PCM1SrwPYIBxAFk5AdY8AE0jGTA6bABdAAIYMEJ5nDImHEx52El5hsqNPD65Ss7u3sHh0YmpmYXCJeLi+YFseYARAEVeYPnl+YA7tgnkZLOB2FAqCVylVavUQPtDsdTl0ev0hiNxpNpnN5kwVjI4ACPt9gqDaLd0qgAEJvd4kMiyMEJBBJKCFJjFSERFANUBQACeJipIAA0thsCYPOw8G5ML5ghA6K8ECIiIRKksZGCygh8QBrMAodhgYrEClweoms05EBMOgmRAJGRQZqITCEFDAAC+tHtjoQzqgiuVVE9yFATBkJmgZVN2T4RgArN7ffyhSLxZLpdplmoyNg0prJANJBQiAA1ePpWi6g1G5DW80gQn1TLZP0Op1uV3u8OgQgFtLvSRgNSZKMWVBqeCW+YeLuQl3FAXIAD6G-mwQALB4hDAhKyREJCkIAJxCABSNQ0IhgGlFAC8NHIAaKwGM5Agxu9WAAmMYAGENBqNBgn1IQviEQC-zke9ijoT4AAUPGpOgAHYagAVVFDR3hET5AIGDQkyEal9W3AAtAZCkAyiAQ0TATzkSi6FowCxkfQCTmKA5gOCKBijGDwAUopDPm0OANCFDxAOwbjmjkLCNAANg0DRtwFGAPGaIQ-0o-UajkABHAQPArEQsNYNBCGaF99QARlYd44Eoy8mAGA53goy8hDwQDmjUOQNHYT5DkvfUPDgfyYALR99wrBy4DgLCmEKQhRUKMZKIEalPjgakNBgQhPmaGo-yOBiBjwXgGPeTBgupCtCHUgAObAKw0akoArMiHOaER9Xax9gmwMpqXeMYhG0YLmkqfVErQBjKgADUIaj3hMFrCgcirRQ8dTimKvBVBgQDyMfAVKlYR99UwNTPkqAFiggCt0MogBqMgVorM8yD-G6-2pXhWDPNBWA8NQhEo2qyEAjwBiEEjL3eJhgiEFTqTIbdaN4T43yQsYAGZWGpP9tH1ORqQciAZAc6lCAGQizyJkwzzKGQaMIQgHJgKBMigM99TIR80A0AEPE+eLL0IYIYHQsW6EvYDWCTVq6GpJCyH1dgRHQv9mgOis8GaTABmpM9iiTZTxZkDR0OKCaYAFDwXLPQpqUA4IMAGQCwGMoRHyQjTlc+GQ8G0UUBFexjLzGCQsLkVgsLgPpeDoTbWrGT4sK9z4PZEDwk3eTQNGCS8yBqAEYEwGBtxuz4ICYGpzt4ea-w8Jg5BW4zCEQ7cEDgDxC40MBn1FbQxjGYGam0ByTBMR9sDGERRSEAxKkILDtD6LuAW0CB8fU3VPjoFo5FFLDKI9uB0L6YztBWz5RRMbRgg0Wm6D6GQanQrrmgZsEAEKleCUQiLlfU2hmjYH1h9AAtH+MolQOIDTGOwYomBWYAlYJ8fCl41CFABNuF6zQDAVhUoQHSPhlLaFYEwSGNRqQQD-AVFaooHJYSvIJQgcCoCPkIDUCAoN9QaEotSNAK0yAOQBMBakfRKitV4LwR8AhwKFEfOwYIhBAIyAZkjEAvo7RdkDD2EMKp+yplmLQPI7A9BQHDHyEAgphTKDUMkFyTxxx6nMIUQedABgCgGNgOgiABRgn9N2F0boEAei9PQYJoTxRhNQGQCACAECFigB44oXjJyAS1EIScLkiChFgJOAxnYAxBjMWGL0hi6yEENMaU0xA0xOIzMoDQC9CyYFyeYSocBfGyB4JUyJvYYn9hAIQKAiAwBJCScoSkYJpneKEAMrpwpFDKC+D8CpRiqmmKVOYuptY9SNIbE2bAbTnEihfIxXpQ4az7LGdE2JEYpmPJHAkPpU4QAzmSlAeci5MkrnXJuHce4DxHhPOeK8N47wPmfK+d8n5vy-gAsBUC4FIKfGgrBeCiEUJoUwjhPCBEiIkTIhRaitF6KMWYqxdinFuKVF4hofiglhKiXEpJaSUo5IKSUqpdSmltK6X0oZEyZkLJWRsnZOQjlnKuXcp5PCPk-IBSCiFMKeAIpRRinFBKSUUppQyllHKeUCpFRKmVCqfQqo1Tqg1LqzU2odS6j1PqA0hrYBGmNCaU0ZoaDmgtByS0NCrXWgMTa21dp4H2odY6p1zr6kutdW690NCPWeq9d6X0fp-QBo+IGIMwYQyhjDAEcMEZIyTCjNGGMsY40AnjAmxNSbk0ptTWm9NGbM1ZuzTm6UeZ8wFkLEWYsJZSyvLLeWitlYaFVurTW2tdb60NhoY2ptzaW2tupAEdsHZOxdm7D2XsfZ+wDkHEOgEw4RyjjHTAccE5JxTmnDOJgs45zzgXIuJd1Ll0rtXWu9dHyN2bq3dundu6937oPYeB0x4PkntPXgs956L2XqvdeEBN7b13q+A+R8NAnzPopS+19qS33vo-Z+r936f2-r-EQDFRQAjlhAKBYFMBoDGIjFSj4ibYCJkTD6DkVJjGQTUAQ7xWpZDPKTAUojKKikbjNQUDlBRlArGdByxRAK1t4P5Q2wQ-wOQfEmZoxl9TUi0RzM8EBMB0GCDUImJVyKDBZitDQB05BjDKI+SolQtF-k+CtYIrU-wAgCH0JTGg9kRJMS6GpPIIz1LOU0xsLSrnUHTC41ABAQllGwBoJ4fRCxUEkIgQghREALNGUl8ZbzQBJDSAgKrCAFmoAyQEBw2pDGJeqUc2paXTn1maTaa5HTUD3PK21jr4TjFBleZM1rlWZkIC+WOCc5hlA9f0NIGQYK1xbl3EIByQgTBCHcFjWSZAPDDHeH0DQ3nihJH3lNKjNUpLaEAqwYKlFPjUmUsULQuCbM1E+PqLCf9KIClajI4icsurGSU-ne7K1WAaDTp8RGRKHK+UKHINSrBijGWCHZZoFZmgqUKJgDQl44ACDIEpkQ2cP5Iw8BAFSlE5BMBUkTakAoVrPcKHgAQ25eAZIGYJPAQgBSXjQB4AwApRSiggCYMAZ4BgAkIB9OAYw6CURMGMP8UArsQGMnIIQnwTCXkoEeCAQF3h2REEmdSCWluHNDKln0Y3zkTdabMb0QA");
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

