import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../DataStringHelper.dart';
import '../Prepack.dart';
import "UnitTests.dart";
abstract class EntityTests {
    static void run(Element element) {
        testSerialization(element);
    }

    static void testSerialization(element) async {
        //do one specific example.
        final Entity alice = new Entity("Alice",[],13,"Alice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true;
        final Prepack prepack2 = new Prepack("Bastard","For absolute Bastards.","jadedResearcher",["reaction"], [Generator.fromDataString("reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAIkadFwK2+49LYGZIt5K+Rc6MgIACa2AO7Y4gIh7Ioq6lr0zCz6hiZmlja2AFbigfbImFxSvri20BB8CNjhccpqmtopaUam5lZ2AGZFAly26Ni2qMEQLnwQI-kQtgAWEADk-X58AUGhINYAvkA")],[new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCCYzCETlTACANtlYIwZPQHoAEkwBu2AHQAHGUJC0GzMmIlTZCpajpgZFgBJNTg6QKMTAFkEAH0AKSoEAE9YqIDMRBs4ISdaKFIhbChWGWwUdjAdYkFsdkRsADEdMEtEABVsAA8eVABtVgB1ADk5PBsAZXa8IOGAcSi5KNY8AE0bGTA6bABdAAJCOy3CPYC9gAFsaxTZW2dwdigqZtaO7t6QPvaAQTw5uXak2mswWSxW602232pGwexkcCgezsejAxEwNj27UoyT2MFasNRzCEZUwe1gTBOAxGYyBM3mi2Waxsh2wZCYRH2sFhUigej2cHYewA5AAhVEFBCYIUYqmjcZTOmgxnrBAkMheGQ7DFmWFkMLI4rYHQ4ypMapkuB7CSq-kIPYohAyU4yHF6QiEWSEGz3SHlVCXa7JW73CVFKCNM1PBCEFB9UBQZJ2P0gADS2GwdiC7FWcAg31VUXKtEsCApAGswBUqjUQPDelAEBBsLQmHQ7IgCjIoINEJgY8hgABfFttjsBKDDCB0ARUftDwc7Wh1disqD9uMgBNJ5TfOxJxQTBuqITtOCNBCyHgj9sITvd3tzkCEKCIMBFNPJZS++7P0uOU+7vuvggGKz6kKSIDDioo63uOk7TrOKBDsWpaEBWKANk2C6DkAA")],[]);
        final Scene scene = new Scene("The End", "Now that alice has sent [TARGET.NUMMEMORY.secretMessageCount] messages, the cycle of messages ends.","The End.")..targetOne=true;
        prepack2.scenes.add(scene);
        alice.prepacks.add(prepack2);
        Map<String, dynamic> serialization = await alice.getSerialization();
        print("entity serialization is $serialization");
        final Entity loaded = new Entity.empty(13);
        await loaded.loadFromSerialization(serialization);
        UnitTests.processTest("Loaded Entity should have exactly one prepacks initially.", 1, loaded.prepacks.length,element);
        testInit(element);


    }

    static void testInit(element) {
        final Entity alice = new Entity(null,[],13,"DefinitelyNotAlice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true;
        UnitTests.processTest("testInit: Before init, alice should have the name of her doll, which is DefinitelyNotAlice", "DefinitelyNotAlice", alice.name,element);

        alice.setInitStringMemory("name","Doop");
        alice.setInitStringMemory("reaction","not a bastards reaction");
        alice.setInitNumMemory("strength",13);
        final Prepack prepack2 = new Prepack("Bastard","For absolute Bastards.","jadedResearcher",["reaction"], [Generator.fromDataString("reaction:___ N4Ig1gpgniBcICcIEMDGAXAlgewHYgBoR0oAHCOEAZQBUAlASQDkBxQkU7AZy8wCMANhABqyAQFcIXOAG0QMgPIB1JgFE6AOlqNWAWVW6FdAJobcyALYQAugAIkadFwK2+49LYGZIt5K+Rc6MgIACa2AO7Y4gIh7Ioq6lr0zCz6hiZmlja2AFbigfbImFxSvri20BB8CNjhccpqmtopaUam5lZ2AGZFAly26Ni2qMEQLnwQI-kQtgAWEADk-X58AUGhINYAvkA")],[new Scene.fromDataString("@everyone:___ N4IghgrgLgFg9gJxALhAKzAEwKaYErYDO2YCAxjNkgDQgC2EhAlmQPIBm7xUKADLQCMA5gBk4ZMFCZwAdgFEZmFCCYzCETlTACANtlYIwZPQHoAEkwBu2AHQAHGUJC0GzMmIlTZCpajpgZFgBJNTg6QKMTAFkEAH0AKSoEAE9YqIDMRBs4ISdaKFIhbChWGWwUdjAdYkFsdkRsADEdMEtEABVsAA8eVABtVgB1ADk5PBsAZXa8IOGAcSi5KNY8AE0bGTA6bABdAAJCOy3CPYC9gAFsaxTZW2dwdigqZtaO7t6QPvaAQTw5uXak2mswWSxW602232pGwexkcCgezsejAxEwNj27UoyT2MFasNRzCEZUwe1gTBOAxGYyBM3mi2Waxsh2wZCYRH2sFhUigej2cHYewA5AAhVEFBCYIUYqmjcZTOmgxnrBAkMheGQ7DFmWFkMLI4rYHQ4ypMapkuB7CSq-kIPYohAyU4yHF6QiEWSEGz3SHlVCXa7JW73CVFKCNM1PBCEFB9UBQZJ2P0gADS2GwdiC7FWcAg31VUXKtEsCApAGswBUqjUQPDelAEBBsLQmHQ7IgCjIoINEJgY8hgABfFttjsBKDDCB0ARUftDwc7Wh1disqD9uMgBNJ5TfOxJxQTBuqITtOCNBCyHgj9sITvd3tzkCEKCIMBFNPJZS++7P0uOU+7vuvggGKz6kKSIDDioo63uOk7TrOKBDsWpaEBWKANk2C6DkAA")],[]);
        alice.prepacks.add(prepack2);
        alice.init();
        UnitTests.processTest("testInit: After init, alice should have the overrideen name Doop", "Doop", alice.name,element);
        UnitTests.processTest("testInit: After init, alice should have the overrideen strength of 13 ", 13, alice.getNumMemory("strength"),element);
        UnitTests.processTest("testInit: After init, alice should have overrideen reaction", "not a bastards reaction", alice.getStringMemory("reaction"),element);



    }
}