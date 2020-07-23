import "dart:html";
import 'ActionEffects/ActionEffect.dart';
import 'DataObject.dart';
import 'DataStringHelper.dart';
import 'Generator.dart';
import 'Scenario.dart';
import 'SentientObject.dart';
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
import 'Util.dart';
//TODO scenes have optional background imagery
//TODO have scene know how to handle procedural text replacement STRINGMEMORY.secretMessage would put the value of the secret message in there, or null, for example
//TODO stretch goal, can put these scripting tags in as input for filters and effects, too. "your best friend is now me" or hwatever.
class Scene extends DataObject {
    static final NOBGMUSIC = "None";
    String author = "???";
    static int stageWidth = 980;
    static int stageHeight = 600;
    String bgLocationEnd;
    String musicLocationEnd;
    //the two keys are for overriding the default image with something custom to the owner. both are optional.
    //expect something like "land" or "moon" or "house commonroom" or whatever.
    String bgLocationEndKey = "";
    String musicLocationEndKey = "";
    //TODO this is implemented, but harder than i thought to get a file to start playing at time x without preloading it.
    num musicOffset = 0;

    static String bgLocationFront = "images/BGs/";
    //a metal box on LOSAS
    static String musicLocationFront = "Music/";

    DivElement stageHolder;
    CanvasElement beforeCanvas;
    CanvasElement afterCanvas;
    static String TARGETSTRINGMEMORYTAG ="[TARGET.STRINGMEMORY.";
    static String TARGETNUMMEMORYTAG ="[TARGET.NUMMEMORY.";
    static String OWNERSTRINGMEMORYTAG ="[OWNER.STRINGMEMORY.";
    static String OWNERNUMMEMORYTAG ="[OWNER.NUMMEMORY.";
    static RegExp TARGETSTRINGMEMORYREGEXP = new RegExp(r"\[TARGET.STRINGMEMORY[.][^\]]*]");
    static RegExp TARGETNUMMEMORYREGEXP = new RegExp(r"\[TARGET.NUMMEMORY[.][^\]]*]");
    static RegExp OWNERSTRINGMEMORYREGEXP = new RegExp(r"\[OWNER.STRINGMEMORY[.][^\]]*]");
    static RegExp OWNERNUMMEMORYREGEXP = new RegExp(r"\[OWNER.NUMMEMORY[.][^\]]*]");

    Element container;
    String get bgLocation {
        if(bgLocationEndKey.isNotEmpty && owner != null && owner.hasStringKey(bgLocationEndKey)) {
            return "$bgLocationFront${owner.getStringMemory(bgLocationEndKey)}";
        }else {
            return "$bgLocationFront$bgLocationEnd";
        }
    }
    String get musicLocation {
        if(musicLocationEndKey.isNotEmpty && owner != null && owner.hasStringKey(musicLocationEndKey)) {
            return "$musicLocationFront${owner.getStringMemory(musicLocationEndKey)}";
        }else {
            return "$musicLocationFront$musicLocationEnd";
        }
    }
    Scenario scenario;
    SentientObject owner; //can be null, in the case of intro/outro scenes.
    //target everything that meets this condition, or just a single one?
    bool targetOne = false;
    String beforeFlavorText;
    String afterFlavorText;
    @override
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

    Scene.fromDataString(String dataString){
        Map<String,dynamic> serialization = DataStringHelper.serializationFromDataString(dataString);
        loadFromSerialization(serialization);
    }

    Scene.fromSerialization(Map<String,dynamic> serialization){
        loadFromSerialization(serialization);
    }

    Set<String>get allMemoryKeys {
        final Set<String> ret = new Set<String>();
        for(final TargetFilter filter in targetFilters) {
            ret.addAll(filter.knownKeys);
        }

        for(final ActionEffect effect in effects) {
            ret.addAll(effect.knownKeys);
        }
        for(final String text in [beforeFlavorText, afterFlavorText]) {
            ret.addAll(
                Util.getTagsForKey(text, TARGETSTRINGMEMORYREGEXP));

            ret.addAll(
                Util.getTagsForKey(text, TARGETNUMMEMORYREGEXP));

            ret.addAll(
                Util.getTagsForKey(text, OWNERSTRINGMEMORYREGEXP));

            ret.addAll(Util.getTagsForKey(text, OWNERNUMMEMORYREGEXP));

        }

        return ret;

    }


    String toString() => name;

    String toDataString() {
        return DataStringHelper.serializationToDataString(name,getSerialization());
    }

    Future<void> loadFromDataString(String dataString) async {
        loadFromSerialization(DataStringHelper.serializationFromDataString(dataString));
    }

    Future<void>  loadFromSerialization(Map<String,dynamic> serialization) {
        author = serialization["author"];
        targetOne = serialization["targetOne"];
        beforeFlavorText = serialization["beforeFlavorText"];
        bgLocationEnd = serialization["bgLocationEnd"];
        musicLocationEnd = serialization["musicLocationEnd"];
        bgLocationEndKey = serialization.containsKey("bgLocationEndKey")? serialization["bgLocationEndKey"]: "";
        musicLocationEndKey = serialization.containsKey("musicLocationEndKey")? serialization["musicLocationEndKey"]: "";
        musicLocationEnd ??= Scene.NOBGMUSIC;

        afterFlavorText = serialization["afterFlavorText"];
        name = serialization["name"];
        musicOffset = serialization["musicOffset"];
        musicOffset ??= 0;

        targetFilters = new List.from((serialization["targetFilters"] as List).map((subserialization) => TargetFilter.fromSerialization(subserialization)));
        effects = new List.from((serialization["effects"] as List).map((subserialization) => ActionEffect.fromSerialization(subserialization)));
    }

    Map<String,dynamic> getSerialization() {
        Map<String,dynamic> ret = new Map<String,dynamic>();
        ret["author"] = author;
        ret["musicOffset"] = musicOffset;
        ret["bgLocationEnd"] = bgLocationEnd;
        ret["musicLocationEnd"] = musicLocationEnd;
        ret["musicLocationEnd"] ??= Scene.NOBGMUSIC;
        ret["targetOne"] = targetOne;
        ret["beforeFlavorText"] = beforeFlavorText;
        ret["bgLocationEndKey"] = bgLocationEndKey;
        ret["musicLocationEndKey"] = musicLocationEndKey;
        ret["afterFlavorText"] = afterFlavorText;
        ret["name"] = name;
        ret["targetFilters"] = targetFilters.map((TargetFilter filter) => filter.getSerialization()).toList();
        ret["effects"] = effects.map((ActionEffect effect) => effect.getSerialization()).toList();
        return ret;
    }
    String debugString() {
        return "Scene $name TargetOne: $targetOne Filters: ${targetFilters.map((TargetFilter f) => f.debugString())}, Effects ${effects.map((ActionEffect f) => f.debugString())}";
    }

    String get className => ("${name}-${author}").replaceAll(new RegExp(r"\s+\b|\b\s"),"");

    String get proccessedBeforeText => processText(beforeFlavorText);
    String get proccessedAfterText => processText(afterFlavorText);


    String processText(String text, [int round =0]) {
        String originalText = "$text";
        text = processTargetStringTags(text);
        text = processTargetNumTags(text);
        if(owner != null) {
            text = processOwnerStringTags(text);
            text = processOwnerNumTags(text);
        }
        //max of three times, but if at any point nothing has changed, just finish off, no more recursion.
        if(round < 3 && text != originalText) {
            text = processText(text, round+1);
        }else {
            //look [ and ] are reserved characters here. deal with it.
            text = text.replaceAll("]", "");
        }
        return text;
    }

    String processTargetStringTags(String text) {
        List<String> tags = Util.getTagsForKey(text, TARGETSTRINGMEMORYREGEXP);
        for(String tag in tags) {
            String replacement = "";
            for(Entity entity in finalTargets) {
                if(entity == finalTargets.first) {
                    replacement = entity.getStringMemory(tag);
                }else if(finalTargets.length > 1 && entity !=finalTargets.last) {
                    replacement = "$replacement, ${entity.getStringMemory(tag)}";
                }else {
                    replacement = "$replacement, and ${entity.getStringMemory(tag)}";
                }
            }
            text = text.replaceAll("$TARGETSTRINGMEMORYTAG$tag","$replacement");
        }
        return text;
    }

    String processTargetNumTags(String text) {
        List<String> tags = Util.getTagsForKey(text, TARGETNUMMEMORYREGEXP);
        for(String tag in tags) {
            String replacement = "";
            for(Entity entity in finalTargets) {
                if(entity == finalTargets.first) {
                    replacement = "${entity.getNumMemory(tag)}";
                }else if(finalTargets.length > 1 && entity !=finalTargets.last) {
                    replacement = "$replacement, ${entity.getNumMemory(tag)}";
                }else {
                    replacement = "$replacement, and ${entity.getNumMemory(tag)}";
                }
            }
            text = text.replaceAll("$TARGETNUMMEMORYTAG$tag","$replacement");
        }
        return text;
    }

    String processOwnerStringTags(String text) {
        List<String> tags = Util.getTagsForKey(text, OWNERSTRINGMEMORYREGEXP);
        tags.forEach((String tag) =>text = text.replaceAll("$OWNERSTRINGMEMORYTAG$tag","${owner.getStringMemory(tag)}"));
        return text;
    }

    String processOwnerNumTags(String text) {
        List<String> tags = Util.getTagsForKey(text, OWNERNUMMEMORYREGEXP);
        tags.forEach((String tag) =>text =text.replaceAll("$OWNERNUMMEMORYTAG$tag","${owner.getNumMemory(tag)}"));
        return text;
    }



    Future<Element> render(int debugNumber)async  {
        container = new DivElement()..classes.add("scene")..classes.add(className);
        stageHolder = new DivElement()..classes.add("stageholder");
        stageHolder.style.width ="${stageWidth}px";
        stageHolder.style.height ="${stageHeight}px";
        container.append(stageHolder);
        await renderStageFrame(true);
        SpanElement beforeSpan= new SpanElement()..setInnerHtml(proccessedBeforeText);

        applyEffects(); //that way we can talk about things before someone died and after, or whatever

        await renderStageFrame(false);
        final SpanElement afterSpan = new SpanElement()..setInnerHtml(" $proccessedAfterText");

        //TODO have simple css animations that switch between before and after stage every second (i.e. put them as the bg of the on screen element);
        final DivElement narrationDiv = new DivElement()..classes.add("narration");

        narrationDiv.append(beforeSpan);
        narrationDiv.append(afterSpan);


        container.append(narrationDiv);
        //always do this, never know when people will want to debug their shit
        attachDebugElement(container, scenario, className);
        return container;
    }

    static void attachDebugElement(Element parent, Scenario scenario, String className) {
        DivElement debug = new DivElement()..classes.add("void")..classes.add("debug")..classes.add(className)..setInnerHtml("<h2>$className</h2>");
        List<SentientObject> objects = new List.from(scenario.entitiesReadOnly)..insert(0,scenario);
        for(SentientObject entity in objects) {
            DivElement entityElement = new DivElement()..classes.add("debugEntity");
            String activeText = (entity is Entity)? "Active: ${entity.isActive}" : "Scenario is Always Active";
            Element header = new HeadingElement.h3()..text = "${entity.name}: $activeText";
            entityElement.append(header);
            String activationeText = (entity is Entity)? "ActivationScenes: ${entity.readOnlyActivationScenes.join(",")}" : "";

            DivElement scenes = new DivElement()..text = "Scenes: ${entity.readOnlyScenes.join(",")}, $activationeText}";
            debug.append(entityElement);
            entityElement.append(scenes);
            TableElement stringMemoryElement = new TableElement();
            entityElement.append(stringMemoryElement);
            TableRowElement tr = new TableRowElement();
            stringMemoryElement.append(tr);
            Element th = new Element.th()..text = "String Memory Key";
            tr.append(th);
            Element th2 = new Element.th()..text = "Memory Value After Scene";
            tr.append(th2);
            Map<String,String> stringMemory = entity.readOnlyStringMemory;
            for(String key in stringMemory.keys) {
                TableRowElement tr_key = new TableRowElement();
                stringMemoryElement.append(tr_key);
                Element td = new Element.td()..text = key;
                tr_key.append(td);
                Element td2 = new Element.td()..text = "${stringMemory[key]}";
                tr_key.append(td2);
            }

            TableElement numMemoryElement = new TableElement();
            entityElement.append(numMemoryElement);
            TableRowElement tr2 = new TableRowElement();
            numMemoryElement.append(tr2);
            Element th4 = new Element.th()..text = "NumMemory Key";
            tr2.append(th4);
            Element th3 = new Element.th()..text = "Memory Value After Scene";
            tr2.append(th3);

            Map<String,num> numMemory = entity.readOnlyNumMemory;
            for(String key in numMemory.keys) {
                TableRowElement tr_key = new TableRowElement();
                numMemoryElement.append(tr_key);
                Element td = new Element.td()..text = key;
                tr_key.append(td);
                Element td2 = new Element.td()..text = "${numMemory[key]}";
                tr_key.append(td2);
            }

            TableElement generatorElement = new TableElement();
            entityElement.append(generatorElement);
            TableRowElement tr2g = new TableRowElement();
            generatorElement.append(tr2g);
            Element th4g = new Element.th()..text = "Generator Key";
            tr2g.append(th4g);
            Element th3g = new Element.th()..text = "Generator Values Post Scene";
            tr2g.append(th3g);

            if(entity is Entity) {
                Map<String, List<Generator>> generators = entity
                    .readOnlyGenerators;
                for (String key in generators.keys) {
                    TableRowElement tr_key = new TableRowElement();
                    generatorElement.append(tr_key);
                    Element td = new Element.td()
                        ..text = key;
                    tr_key.append(td);

                    Iterable<String> values = generators[key].map((
                        Generator g) => g.values());
                    Element td2 = new Element.td()
                        ..setInnerHtml("${values.join("")}");
                    tr_key.append(td2);
                }
            }

        }
        parent.append(debug);
    }


    //asyncly renders to the element, lets the canvas go on screen asap
    Future<Null> renderStageFrame(bool before) async {
        CanvasElement canvas = new CanvasElement(width: stageWidth, height: stageHeight);
        if(before) {
            beforeCanvas = canvas;
        }else {
            afterCanvas = canvas;
        }
        if(owner != null) {
            await renderOwner(canvas);
            await renderTargets(canvas.width-400,250,finalTargets.toList(), canvas);
            //don't add a bg to a start/end scene, the point is its not got the illusion going yet.
            //thats why its still a shadow
            canvas.style.background = "url('${bgLocation}')";

        }else {
            canvas.classes.add("shadows");
            await renderTargets(canvas.width-400, 0,scenario.entitiesReadOnly, canvas);
        }
        if(!before) {
            setupAnimations();
        }
    }

    void setupAnimations() {
        CanvasElement bg = new CanvasElement(width: stageWidth*2, height: stageHeight);
        bg.context2D.drawImage(beforeCanvas, 0,0);
        bg.context2D.drawImage(afterCanvas, stageWidth, 0);
        if(owner == null) {
            stageHolder.classes.add("shadows");
            stageHolder.style.backgroundImage="url(${bg.toDataUrl()})";
        }else {
            stageHolder.style.backgroundImage="url(${bg.toDataUrl()}),url('${bgLocation}'";
        }
        stageHolder.classes.add("frameAnimation");
        stageHolder.classes.add("stage");
    }

    Future<Null> renderTargets(int startX, int maxX, List<Entity> renderTargets, CanvasElement canvas) async {
        int yRow = 0;
        int distanceBetweenDolls = 100; //todo calculate consistent number?
        int currentX = startX;
        for(Entity target in renderTargets) {
          if(target != owner){
              CanvasElement targetCanvas = await target.canvas;
              if(targetCanvas != null && target.facingRightByDefault) {
                  targetCanvas = Util.turnwaysCanvas(targetCanvas);
                  canvas.context2D.drawImage(targetCanvas, currentX,  canvas.height-targetCanvas.height+yRow);
              }else {
                  canvas.context2D.drawImage(targetCanvas, currentX,  canvas.height-targetCanvas.height+yRow);
              }
              currentX += -1*distanceBetweenDolls;
              if(currentX < maxX) {
                  currentX = startX;
                  yRow += distanceBetweenDolls;
              }
          }

      }
    }

    Future renderOwner(CanvasElement canvas) async {
        if(owner is Entity) {
            CanvasElement ownerCanvas = await (owner as Entity).canvas;
            if (ownerCanvas != null && !(owner as Entity).facingRightByDefault) {
                ownerCanvas = Util.turnwaysCanvas(ownerCanvas);
                canvas.context2D.drawImage(
                    ownerCanvas, 0, canvas.height - ownerCanvas.height);
            } else {
                canvas.context2D.drawImage(
                    ownerCanvas, 0, canvas.height - ownerCanvas.height);
            }
        }
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