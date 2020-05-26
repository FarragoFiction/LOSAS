import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../DataStringHelper.dart';
import '../Prepack.dart';
import "UnitTests.dart";
abstract class SceneTests {
    static void run(Element element) {
        testSerialization(element);
    }

    static void testSerialization(element) {
        //do one specific example.
        Scene scene = new Scene("The End", "Now that alice has sent [TARGET.NUMMEMORY.secretMessageCount] messages, the cycle of messages ends.","The End.")..targetOne=true;

        Map<String, dynamic> serialization = scene.getSerialization();

        final Scene recovered = new Scene.fromSerialization(serialization);

        UnitTests.processTest("Scene can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestEffect",recovered.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",recovered.getSerialization()), element);


    }
}