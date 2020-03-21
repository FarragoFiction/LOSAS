import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

abstract class DollTests {

    static void run(Element element) {
        renderDollTest(element);
    }

    static Future<Null> renderDollTest(Element element) async {
        Doll doll =Doll.loadSpecificDoll("Test%3A___A5GAAAAAAAAAAAAAAAAAAAAKjLg%3D");
        CanvasElement canvas = await doll.getNewCanvas();
        element.append(canvas);
    }


}