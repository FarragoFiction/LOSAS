import "dart:html";
import 'ActionEffects/ActionEffect.dart';
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
//TODO scenes have optional background imagery
//TODO have scene know how to handle procedural text replacement STRINGMEMORY.secretMessage would put the value of the secret message in there, or null, for example
//TODO stretch goal, can put these scripting tags in as input for filters and effects, too. "your best friend is now me" or hwatever.
class Scene {
    Element container;
    //TODO when an entity is about to begin ticking, make sure they are marked as the owner of their scenes
    Entity owner;
    //target everything that meets this condition, or just a single one?
    bool targetOne = false;
    String flavorText;
    String name;
    List<TargetFilter> targetFilters = new List<TargetFilter>();
    List<ActionEffect> effects = new List<ActionEffect>();
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

    String debugString() {
        return "Scene $name TargetOne: $targetOne Filters: ${targetFilters.map((TargetFilter f) => f.debugString())}, Effects ${effects.map((ActionEffect f) => f.debugString())}";
    }

    Element render(int debugNumber) {
        container = new DivElement()..classes.add("scene")..setInnerHtml("$debugNumber $flavorText");
        //TODO need to render the owner on the left and the targets on the right, text is above? plus name labels underneath
        return container;
    }

    void applyEffects() {
        print("I ($name) am going to apply my effects to ${targets}");
        for(final ActionEffect e in effects) {
            e.applyEffect(this);
        }
    }

    bool checkIfActivated(List<Entity> entities) {
        targets.clear();
        targets = new Set.from(entities);
        //TODO shuffle the entities
        print("TODO shuffle entities");
        if(targetFilters.isEmpty) {
            targets = new Set<Entity>.from(entities);
            return true;
        }

        print("targets before filters are $targets");
        for(TargetFilter tc in targetFilters) {
            targets = new Set<Entity>.from(tc.filter(this,targets.toList()));
            print("targets after filter $tc are $targets");

        }
        return targets.isNotEmpty;
    }
}