import 'dart:html';

import "UnitTests.dart";
abstract class GeneratorTests {
    static void run(Element element) {
        Generator stringGenerator = new StringGenerator("test",["hello","world"]);
    }
}