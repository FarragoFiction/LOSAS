import "dart:html";

import 'Entity.dart';
//TODO scenes have optional background imagery
class Scene {
    Element container;
    //TODO when an entity is about to begin ticking, make sure they are marked as the owner of their scenes
    Entity owner;
    String flavorText;
    String name;
    Scene(this.name, this.flavorText);

    void display(Element parent) {
        container = new DivElement()..classes.add("scene")..setInnerHtml(flavorText);
        parent.append(container);
    }
}