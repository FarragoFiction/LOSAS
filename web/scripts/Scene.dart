import "dart:html";
import 'ActionEffects/ActionEffect.dart';
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
import 'Util.dart';
//TODO scenes have optional background imagery
//TODO have scene know how to handle procedural text replacement STRINGMEMORY.secretMessage would put the value of the secret message in there, or null, for example
//TODO stretch goal, can put these scripting tags in as input for filters and effects, too. "your best friend is now me" or hwatever.
class Scene {
    static String TARGETSTRINGMEMORYTAG ="[TARGET.STRINGMEMORY.";
    static String TARGETNUMMEMORYTAG ="[TARGET.NUMMEMORY.";
    static String OWNERSTRINGMEMORYTAG ="[OWNER.STRINGMEMORY.";
    static String OWNERNUMMEMORYTAG ="[OWNER.NUMMEMORY.";
    Element container;
    Entity owner;
    //target everything that meets this condition, or just a single one?
    bool targetOne = false;
    String beforeFlavorText;
    String afterFlavorText;
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


    Scene(this.name, this.beforeFlavorText, this.afterFlavorText);

    String debugString() {
        return "Scene $name TargetOne: $targetOne Filters: ${targetFilters.map((TargetFilter f) => f.debugString())}, Effects ${effects.map((ActionEffect f) => f.debugString())}";
    }

    String get proccessedBeforeText => processText(beforeFlavorText);
    String get proccessedAfterText => processText(afterFlavorText);


    String processText(String text) {
        text = processTargetStringTags(text);
        text = processTargetNumTags(text);
        text = processOwnerStringTags(text);
        text = processOwnerNumTags(text);
        //look [ and ] are reserved characters here. deal with it.
        text = text.replaceAll("]","");
        return text;
    }

    String processTargetStringTags(String text) {
        List<String> tags = Util.getTagsForKey(text, TARGETSTRINGMEMORYTAG);
        for(Entity target in finalTargets) {
            tags.forEach((String tag) =>text = text.replaceAll("$TARGETSTRINGMEMORYTAG$tag","${target.getStringMemory(tag)}"));
        }
        return text;
    }

    String processTargetNumTags(String text) {
        List<String> tags = Util.getTagsForKey(text, TARGETNUMMEMORYTAG);
        for(Entity target in finalTargets) {
            tags.forEach((String tag) =>text = text.replaceAll("$TARGETNUMMEMORYTAG$tag","${target.getNumMemory(tag)}"));
        }
        return text;
    }

    String processOwnerStringTags(String text) {
        List<String> tags = Util.getTagsForKey(text, OWNERSTRINGMEMORYTAG);
        tags.forEach((String tag) =>text = text.replaceAll("$OWNERSTRINGMEMORYTAG$tag","${owner.getStringMemory(tag)}"));
        return text;
    }

    String processOwnerNumTags(String text) {
        List<String> tags = Util.getTagsForKey(text, OWNERNUMMEMORYTAG);
        tags.forEach((String tag) =>text =text.replaceAll("$OWNERNUMMEMORYTAG$tag","${owner.getNumMemory(tag)}"));
        return text;
    }



    Element render(int debugNumber) {
        container = new DivElement()..classes.add("scene");
        SpanElement beforeSpan= new SpanElement()..setInnerHtml(proccessedBeforeText);
        applyEffects(); //that way we can talk about things before someone died and after, or whatever
        SpanElement afterSpan = new SpanElement()..setInnerHtml(" $proccessedAfterText");
        container.append(beforeSpan);
        container.append(afterSpan);

        //TODO need to render the owner on the left and the targets on the right, text is above? plus name labels underneath
        //rendering should happen AFTER apply effects.
        //wait, no what if its lightly animated? two renders, one before and one after, cycles between them
        return container;
    }

    void applyEffects() {
        for(final ActionEffect e in effects) {
            e.applyEffect(this);
        }
        //TODO capture the state of the scenario after this, for time shit
    }

    bool checkIfActivated(List<Entity> entities) {
        targets.clear();
        targets = new Set.from(entities);
        if(targetFilters.isEmpty) {
            targets = new Set<Entity>.from(entities);
            return true;
        }

        for(TargetFilter tc in targetFilters) {
            targets = new Set<Entity>.from(tc.filter(this,targets.toList()));
        }
        return targets.isNotEmpty;
    }
}