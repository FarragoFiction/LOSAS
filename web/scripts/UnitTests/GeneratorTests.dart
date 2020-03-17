import 'dart:html';

import 'package:CommonLib/Random.dart';

import "UnitTests.dart";
abstract class GeneratorTests {
    static void run(Element element) {
        Generator stringGenerator = new StringGenerator("testString",["hello","world"]);
        Generator intGenerator = new NumGenerator("testInt", -10,10);
        Generator doubleGenerator = new NumGenerator("testDouble",-1.01,1.01);

        String generatedString = stringGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick one of two strings, picked $generatedString", true, generatedString=="hello" || generatedString=="world", element);

        num generatedInt = intGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick number between 0 and 10, picked $generatedInt", true, generatedInt >=-10 && generatedInt <=10, element);

        num generatedDouble = doubleGenerator.generateValue(new Random(13));
        UnitTests.processTest("Generator should pick number between 0 and 1, picked $generatedDouble", true, generatedDouble >=-1.01 && generatedDouble <=1.01, element);


    }
}