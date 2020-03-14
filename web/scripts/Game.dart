import 'dart:html';

import 'Scene.dart';

class Game {
    Element container;

    void display(Element parent) {
        container = new DivElement()..classes.add("game");
        parent.append(container);
        Scene scene = new Scene("Hello World", "If you are seeing this a bare bones scene is working.");
        scene.display(container);
    }
}