import "dart:html";
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
//TODO scenes have optional background imagery
class Scene {
    Element container;
    //TODO when an entity is about to begin ticking, make sure they are marked as the owner of their scenes
    Entity owner;
    String flavorText;
    String name;
    List<TargetFilter> targetConditions = new List<TargetFilter>();
    Set<Entity> targets = new Set<Entity>();
    Scene(this.name, this.flavorText);

    void display(Element parent) {
        container = new DivElement()..classes.add("scene")..setInnerHtml(flavorText);
        parent.append(container);
    }

    bool checkIfActivated(List<Entity> entities) {
        print("Trying to check if $name is activated");
        targets.clear();

        for(TargetFilter tc in targetConditions) {
            print("checking if $tc is met");
            targets = new Set<Entity>.from(tc.filter(this,entities));
        }
        return targetConditions.isNotEmpty && targets.isNotEmpty;
    }
}