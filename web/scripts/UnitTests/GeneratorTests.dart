import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../DataStringHelper.dart';
import "UnitTests.dart";
abstract class GeneratorTests {
    static void run(Element element) {
        Generator stringGenerator = new StringGenerator("testString",["hello","world"]);
        Generator intGenerator = new NumGenerator("testInt", -10,10);
        Generator doubleGenerator = new NumGenerator("testDouble",-1.01,1.01);

        String generatedString = stringGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick one of two strings, picked $generatedString", true, generatedString=="hello" || generatedString=="world", element);

        num generatedInt = intGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick number between -10 and 10, picked $generatedInt", true, generatedInt >=-10 && generatedInt <=10, element);

        num generatedDouble = doubleGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick number between -1.01 and 1.01, picked $generatedDouble", true, generatedDouble >=-1.01 && generatedDouble <=1.01, element);

        testSerialization(element);

    }

    static void testSerialization(element) {
        //do one specific example.
        final Generator numGen = new NumGenerator("secretNumber",13,133);
        final Generator stringGen = new StringGenerator("secretWord",<String>["hello","world"]);

        Map<String, dynamic> numSerialization = numGen.getSerialization();
        Map<String, dynamic> stringSerialization = stringGen.getSerialization();

        final Generator recoveredNum = Generator.fromSerialization(numSerialization);
        final Generator recoveredString = Generator.fromSerialization(stringSerialization);

        UnitTests.processTest("String Generator can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestEffect",stringGen.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",recoveredString.getSerialization()), element);

        UnitTests.processTest("Num Generator can be serialized to and from datastring",DataStringHelper.serializationToDataString("TestEffect",numGen.getSerialization()), DataStringHelper.serializationToDataString("TestEffect",recoveredNum.getSerialization()), element);

    }
}