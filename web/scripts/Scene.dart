import "dart:html";
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
//TODO scenes have optional background imagery
class Scene {
    Element container;
    //TODO when an entity is about to begin ticking, make sure they are marked as the owner of their scenes
    Entity owner;
    //target everything that meets this condition, or just a single one?
    bool targetOne = false;
    String flavorText;
    String name;
    List<TargetFilter> targetFilters = new List<TargetFilter>();
    Set<Entity> targets = new Set<Entity>();

    Set<Entity> get finalTargets {
        if(targets == null || targets.isEmpty) return new Set<Entity>();
        if(targetOne) {
            return new Set<Entity>()..add(targets.first);
        }else {
            return targets;
        }
    }
    Scene(this.name, this.flavorText);

    void display(Element parent) {
        container = new DivElement()..classes.add("scene")..setInnerHtml(flavorText);
        parent.append(container);
    }

    bool checkIfActivated(List<Entity> entities) {
        targets.clear();
        if(targetFilters.isEmpty) {
            targets = new Set<Entity>.from(entities);
            return true;
        }

        for(TargetFilter tc in targetFilters) {
            targets = new Set<Entity>.from(tc.filter(this,entities));
        }
        print("found targets $targets");
        return targets.isNotEmpty;
    }
}