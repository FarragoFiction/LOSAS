import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../DataStringHelper.dart';
import '../Prepack.dart';
import "UnitTests.dart";
abstract class PrepackTests {
    static void run(Element element) {
        Prepack prepack = new Prepack("Bastard","For absolute Bastards.","jadedResearcher",["reaction"], [Generator.fromDataString("reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAIkadFwK2+49LYGZIt5K+Rc6MgIACa2AO7Y4gIh7Ioq6lr0zCz6hiZmlja2AFbigfbImFxSvri20BB8CNjhccpqmtopaUam5lZ2AGZFAly26Ni2qMEQLnwQI-kQtgAWEADk-X58AUGhINYAvkA")],[new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCCYzCETlTACANtlYIwZPQHoAEkwBu2AHQAHGUJC0GzMmIlTZCpajpgZFgBJNTg6QKMTAFkEAH0AKSoEAE9YqIDMRBs4ISdaKFIhbChWGWwUdjAdYkFsdkRsADEdMEtEABVsAA8eVABtVgB1ADk5PBsAZXa8IOGAcSi5KNY8AE0bGTA6bABdAAJCOy3CPYC9gAFsaxTZW2dwdigqZtaO7t6QPvaAQTw5uXak2mswWSxW602232pGwexkcCgezsejAxEwNj27UoyT2MFasNRzCEZUwe1gTBOAxGYyBM3mi2Waxsh2wZCYRH2sFhUigej2cHYewA5AAhVEFBCYIUYqmjcZTOmgxnrBAkMheGQ7DFmWFkMLI4rYHQ4ypMapkuB7CSq-kIPYohAyU4yHF6QiEWSEGz3SHlVCXa7JW73CVFKCNM1PBCEFB9UBQZJ2P0gADS2GwdiC7FWcAg31VUXKtEsCApAGswBUqjUQPDelAEBBsLQmHQ7IgCjIoINEJgY8hgABfFttjsBKDDCB0ARUftDwc7Wh1disqD9uMgBNJ5TfOxJxQTBuqITtOCNBCyHgj9sITvd3tzkCEKCIMBFNPJZS++7P0uOU+7vuvggGKz6kKSIDDioo63uOk7TrOKBDsWpaEBWKANk2C6DkAA")]);
        Entity entity = new Entity("myserty",[],null);

        UnitTests.processTest("Prepack Test: Entity, preinitialization should have no generators.", 0, entity.readOnlyGenerators.keys.length, element);
        UnitTests.processTest("Prepack Test: Entity, preinitialization should have no scenes.", 0, entity.readOnlyScenes.length, element);

        entity.prepacks.add(prepack);
        entity.processPrepacks(new Random());
        UnitTests.processTest("Prepack Test: Entity, post initialization should have 1 generator.", 1, entity.readOnlyGenerators.keys.length, element);
        UnitTests.processTest("Prepack Test: Entity, preinitialization should have 1 scene.", 1, entity.readOnlyScenes.length, element);

        testSerialization(element);

    }

    static void testSerialization(element) {
        //do one specific example.
        Prepack prepack = new Prepack("Bastard","For absolute Bastards.","jadedResearcher",["reaction"], [Generator.fromDataString("reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAIkadFwK2+49LYGZIt5K+Rc6MgIACa2AO7Y4gIh7Ioq6lr0zCz6hiZmlja2AFbigfbImFxSvri20BB8CNjhccpqmtopaUam5lZ2AGZFAly26Ni2qMEQLnwQI-kQtgAWEADk-X58AUGhINYAvkA")],[new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCCYzCETlTACANtlYIwZPQHoAEkwBu2AHQAHGUJC0GzMmIlTZCpajpgZFgBJNTg6QKMTAFkEAH0AKSoEAE9YqIDMRBs4ISdaKFIhbChWGWwUdjAdYkFsdkRsADEdMEtEABVsAA8eVABtVgB1ADk5PBsAZXa8IOGAcSi5KNY8AE0bGTA6bABdAAJCOy3CPYC9gAFsaxTZW2dwdigqZtaO7t6QPvaAQTw5uXak2mswWSxW602232pGwexkcCgezsejAxEwNj27UoyT2MFasNRzCEZUwe1gTBOAxGYyBM3mi2Waxsh2wZCYRH2sFhUigej2cHYewA5AAhVEFBCYIUYqmjcZTOmgxnrBAkMheGQ7DFmWFkMLI4rYHQ4ypMapkuB7CSq-kIPYohAyU4yHF6QiEWSEGz3SHlVCXa7JW73CVFKCNM1PBCEFB9UBQZJ2P0gADS2GwdiC7FWcAg31VUXKtEsCApAGswBUqjUQPDelAEBBsLQmHQ7IgCjIoINEJgY8hgABfFttjsBKDDCB0ARUftDwc7Wh1disqD9uMgBNJ5TfOxJxQTBuqITtOCNBCyHgj9sITvd3tzkCEKCIMBFNPJZS++7P0uOU+7vuvggGKz6kKSIDDioo63uOk7TrOKBDsWpaEBWKANk2C6DkAA")]);

        Map<String, dynamic> serialization = prepack.getSerialization();

        final Prepack recoveredPrepack = new Prepack.fromSerialization(serialization);
        print("JR NOTE: first serialization is $serialization");
        print("JR NOTE: second serialization is ${recoveredPrepack.getSerialization()}");

        UnitTests.processTest("Prepack can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestEffect",prepack.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",recoveredPrepack.getSerialization()), element);


    }
}