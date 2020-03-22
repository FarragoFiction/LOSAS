import "dart:html";
import 'ActionEffects/ActionEffect.dart';
import 'Scenario.dart';
import "TargetFilters/TargetFilter.dart";
import 'Entity.dart';
import 'Util.dart';
//TODO scenes have optional background imagery
//TODO have scene know how to handle procedural text replacement STRINGMEMORY.secretMessage would put the value of the secret message in there, or null, for example
//TODO stretch goal, can put these scripting tags in as input for filters and effects, too. "your best friend is now me" or hwatever.
class Scene {
    //TODO let people sign their work
    String author;
    int stageWidth = 980;
    int stageHeight = 600;
    String bgLocationEnd;
    static String TARGETSTRINGMEMORYTAG ="[TARGET.STRINGMEMORY.";
    static String TARGETNUMMEMORYTAG ="[TARGET.NUMMEMORY.";
    static String OWNERSTRINGMEMORYTAG ="[OWNER.STRINGMEMORY.";
    static String OWNERNUMMEMORYTAG ="[OWNER.NUMMEMORY.";
    Element container;
    //TODO let people upload their own backgrounds.
    String get bgLocation => "images/BGs/$bgLocationEnd";
    Scenario scenario;
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
        List<String> tags = Util.getTagsForKey(text, TARGETSTRINGMEMORYTAG);
        for(String tag in tags) {
            String replacement = "";
            for(Entity entity in finalTargets) {
                if(finalTargets.length > 1 && entity !=finalTargets.last) {
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
        List<String> tags = Util.getTagsForKey(text, TARGETNUMMEMORYTAG);
        for(String tag in tags) {
            String replacement = "";
            for(Entity entity in finalTargets) {
                if(finalTargets.length > 1 && entity !=finalTargets.last) {
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
        final CanvasElement beforeStage = new CanvasElement(width: stageWidth, height: stageHeight);
        renderStage(beforeStage);
        SpanElement beforeSpan= new SpanElement()..setInnerHtml(proccessedBeforeText);

        applyEffects(); //that way we can talk about things before someone died and after, or whatever

        final CanvasElement afterStage = new CanvasElement(width: stageWidth, height: stageHeight);
        renderStage(afterStage);
        final SpanElement afterSpan = new SpanElement()..setInnerHtml(" $proccessedAfterText");

        //TODO have simple css animations that switch between before and after stage every second (i.e. put them as the bg of the on screen element);
        final DivElement narrationDiv = new DivElement()..classes.add("narration");
        narrationDiv.append(beforeSpan);
        narrationDiv.append(afterSpan);
        container.append(beforeStage);
        container.append(narrationDiv);

        return container;
    }

    //asyncly renders to the element, lets the canvas go on screen asap
    //TODO render name underneath birb
    Future<Null> renderStage(CanvasElement canvas) async {
        canvas.classes.add("stage");
        print("I'm going to render to this canvas owner is $owner and targets are $finalTargets");
        if(owner != null) {
            await renderOwner(canvas);
            await renderTargets(canvas.width-400,250,finalTargets.toList(), canvas);
            //don't add a bg to a start/end scene, the point is its not got the illusion going yet.
            //thats why its still a shadow
            if(bgLocationEnd != null) canvas.style.background="url('${bgLocation}')";
        }else {
            canvas.classes.add("shadows");
            await renderTargets(canvas.width-400, 0,scenario.entitiesReadOnly, canvas);
        }
    }

    Future<Null> renderTargets(int startX, int maxX, List<Entity> renderTargets, CanvasElement canvas) async {
        int yRow = 0;
        int distanceBetweenDolls = 100; //todo calculate consistent number?
        int currentX = startX;
        for(Entity target in renderTargets) {
          if(target != owner){
              print("I have targets and i'm going to render them to this stage");
              CanvasElement targetCanvas = await target.canvas;
              //todo put them in a neat little pile, render them at a set size
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
      print("my owner is not null)");
      CanvasElement ownerCanvas = await owner.canvas;
      if(ownerCanvas != null && !owner.facingRightByDefault) {
          ownerCanvas = Util.turnwaysCanvas(ownerCanvas);
          canvas.context2D.drawImage(ownerCanvas, 0, canvas.height-ownerCanvas.height);
      }else {
          canvas.context2D.drawImage(ownerCanvas, 0,  canvas.height-ownerCanvas.height);
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