import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

abstract class DollTests {

    static void run(Element element) {
        renderDollTest(element);
    }

    static Future<Null> renderDollTest(Element element) async {
        Doll doll = new PigeonDoll();
        CanvasElement canvas = await doll.getNewCanvas();
        element.append(canvas);
    }


}