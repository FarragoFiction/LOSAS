import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../DataStringHelper.dart';
import '../Prepack.dart';
import "UnitTests.dart";
abstract class ScenarioTests {
    static void run(Element element) {
        testSerialization(element);
    }

    static void testSerialization(element) async {
        //do one specific example.
        Prepack prepack2 = new Prepack("Bastard","For absolute Bastards.","jadedResearcher",["reaction"], [Generator.fromDataString("reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAIkadFwK2+49LYGZIt5K+Rc6MgIACa2AO7Y4gIh7Ioq6lr0zCz6hiZmlja2AFbigfbImFxSvri20BB8CNjhccpqmtopaUam5lZ2AGZFAly26Ni2qMEQLnwQI-kQtgAWEADk-X58AUGhINYAvkA")],[new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCCYzCETlTACANtlYIwZPQHoAEkwBu2AHQAHGUJC0GzMmIlTZCpajpgZFgBJNTg6QKMTAFkEAH0AKSoEAE9YqIDMRBs4ISdaKFIhbChWGWwUdjAdYkFsdkRsADEdMEtEABVsAA8eVABtVgB1ADk5PBsAZXa8IOGAcSi5KNY8AE0bGTA6bABdAAJCOy3CPYC9gAFsaxTZW2dwdigqZtaO7t6QPvaAQTw5uXak2mswWSxW602232pGwexkcCgezsejAxEwNj27UoyT2MFasNRzCEZUwe1gTBOAxGYyBM3mi2Waxsh2wZCYRH2sFhUigej2cHYewA5AAhVEFBCYIUYqmjcZTOmgxnrBAkMheGQ7DFmWFkMLI4rYHQ4ypMapkuB7CSq-kIPYohAyU4yHF6QiEWSEGz3SHlVCXa7JW73CVFKCNM1PBCEFB9UBQZJ2P0gADS2GwdiC7FWcAg31VUXKtEsCApAGswBUqjUQPDelAEBBsLQmHQ7IgCjIoINEJgY8hgABfFttjsBKDDCB0ARUftDwc7Wh1disqD9uMgBNJ5TfOxJxQTBuqITtOCNBCyHgj9sITvd3tzkCEKCIMBFNPJZS++7P0uOU+7vuvggGKz6kKSIDDioo63uOk7TrOKBDsWpaEBWKANk2C6DkAA")],[]);
        Scene scene = new Scene("The End", "Now that alice has sent [TARGET.NUMMEMORY.secretMessageCount] messages, the cycle of messages ends.","The End.")..targetOne=true;
        Scenario toTest = new Scenario("Test","TestAuthor","TestDesc",13);
        toTest.prepacks.add(prepack2);
        toTest.stopScenes.add(scene);
        toTest.frameScenes.add(scene);
        Map<String, dynamic> serialization = await toTest.getSerialization();
        print("Scenario unit test datastring is \n\n${toTest.toDataString()}");
        toTest.toDataString();
        Scenario scenario = new Scenario.empty();
        await scenario.loadFromDataString(toTest.toDataString());
        UnitTests.processTest("Loaded scenario should have exactly one prepack.", 1, scenario.prepacks.length,element);

        final Scenario recovered = Scenario.empty();
        await recovered.loadFromSerialization(serialization);


        UnitTests.processTest("Scenario can be serialized to (${toTest.prepacks.length} prepacks and from ${recovered.prepacks.length} prepacks datastring",DataStringHelper.serializationToDataString("TestEffect",toTest.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",recovered.getSerialization()), element);



    }
}