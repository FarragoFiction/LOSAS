
import 'dart:html';

import 'package:CommonLib/Utility.dart';
import 'package:ImageLib/Encoding.dart';
import 'package:LoaderLib/Loader.dart';

import '../Game.dart';
import '../Prepack.dart';
import '../Scenario.dart';
import '../Scene.dart';
import 'GenericFormHelper.dart';
import 'SceneFormHelper.dart';

class ScenarioFormHelper {
    static String fileKey = "${GameUI.dataPngFolder}${Prepack.dataPngFile}";
    TextAreaElement dataStringElement;
    Scenario scenario;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;
    Element introHolder;
    Element outroHolder;
    Element prepackHolder;

    ScenarioFormHelper([this.scenario]) {
        this.scenario ??= makeNewScenario();
    }

    static makeNewScenario() {
        return  new Scenario("Sample Scenario","???","Describe what kind of story this is telling, and what sorts of characters you can build in it.",13);
    }

    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()
            ..setInnerHtml(
                "Scenarios are everything needed to tell a given story. It contains both stand alone scenes meant to be the start/end of the story, as well as the various prepacks that will be used to build entities within it. <br><br>Ideally, the prepacks should be designed for a specific scenario and all reference the same memory keys.<br><br>An example of a scenario is SBURB, which contains various prepacks to let you assigned class, aspect, moon, interests and species to entities. <br><br>Another example is Hogwartz, which might assign one of the four Houses, Student, Teacher and Villain status to entities as prepacks.")
            ..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(
            formHolder, "DataString:", "${scenario.toDataString()}", (e) =>
            syncScenarioToDataString(e.target.value));

        nameElement = attachInputElement(formHolder, "Name:", "${scenario.name}", (e)
        {
            scenario.name = e.target.value;
            syncDataStringToScenario();
        });

        authorElement = attachInputElement(formHolder, "Author:", "${scenario.author}", (e)
        {
            scenario.author = e.target.value;
            syncDataStringToScenario();
        });

        descElement = attachAreaElement(formHolder, "Description:", "${scenario.description}", (e)
        {
            scenario.description = e.target.value;
            syncDataStringToScenario();
        });

        handleIntroScenes(formHolder);
        handleOutroScenes(formHolder);
        handlePrepacks(formHolder);
    }

    void handlePrepacks(Element parent) {
        if(prepackHolder == null) {
            prepackHolder = new Element.div()..classes.add("subholder");
            parent.append(prepackHolder);
        }
        prepackHolder.text = "";
        Element header = HeadingElement.h1()..text = "Associated Prepacks:";
        DivElement instructions = new DivElement()..setInnerHtml("The prepacks you add here will be the *only* prepacks available for characters in this scenario to be created from. They should use similar memory keys and flow well together, having been created specifically for this scenario. <br><br>NOTE: Prepacks can *only* be added from ArchiveImage, as prepacks are represented as images to the Observer. Thems the breaks.")..classes.add("instructions");
        prepackHolder.append(header);
        prepackHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, loadPrepackFromImage,caption: "Load Prepack From Archive Image");
        prepackHolder.append(uploadElement);
    }
    Future loadPrepackFromImage(ArchivePng png, String fileName) async {
        DivElement processing = new DivElement()..text = "processing";
        prepackHolder.append(processing);
        //yes i could use the build in dataobject loader but that wouldn't get me a datastring directly
        String dataString = await png.getFile(fileKey);
        processing.remove();
        if(dataString != null) {
            try {
                scenario.prepacks.add(new Prepack.fromDataString(dataString));
                syncDataStringToScenario();
                handlePrepacks(null);
            }catch(e) {
                window.console.error(e);
                window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
            }

        }
    }


    void handleIntroScenes(Element parent) {
        if(introHolder == null) {
            introHolder = new Element.div()..classes.add("subholder");
            parent.append(introHolder);
        }
        handleScenes(introHolder,"Intro",scenario.frameScenes, handleIntroScenes, renderIntroScenes, "Scenarios have a list of possible intro scenes (complete with shadow graphics). <br>Examples might be a different opening for an all troll session vs an all human one, vs a mixed one. ");


    }

    void handleOutroScenes(Element parent) {
        if(outroHolder == null) {
            outroHolder = new Element.div()..classes.add("subholder");
            parent.append(outroHolder);
        }
        handleScenes(outroHolder,"Outro",scenario.stopScenes, handleOutroScenes, renderOutroScenes, "Scenarios have optional ending conditions (such as party wipes) that can trigger at any time. If no ending happens, eventually the simulation will time out (possibly abruptly). ");
    }

    void handleScenes(Element holder, String label, List<Scene> sceneArray, Lambda<Element> handleCallBack, Action renderCallBack,String instruction) {
        holder.text = "";
      Element header = HeadingElement.h1()..text = "Associated ${label} Scenes:";
      DivElement instructions = new DivElement()..setInnerHtml(instruction)..classes.add("instructions");
        holder.append(header);

        holder.append(instructions);



      Scene s = SceneFormHelper.makeTestScene();
      attachAreaElement(holder, "Add Scene From DataString:", "${s.toDataString()}", (e)
      {
          try {
              s.loadFromDataString(e.target.value);
          }catch(e) {
              window.console.error(e);
              window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
          }

      });

      ButtonElement button = new ButtonElement()..text = "Add ${label} Scene";
        holder.append(button);
      button.onClick.listen((Event e) {
          sceneArray.add(s);
          syncDataStringToScenario();
          handleCallBack(null);
      });

      renderCallBack();
    }

    void renderIntroScenes() {
        renderScenes(scenario.frameScenes, introHolder, removeIntroScene);
    }

    void removeIntroScene(Scene s) {
        scenario.frameScenes.remove(s);
        syncDataStringToScenario();
        handleIntroScenes(null);
    }

    void removeOutroScene(Scene s) {
        scenario.stopScenes.remove(s);
        syncDataStringToScenario();
        handleOutroScenes(null);
    }

    void renderOutroScenes() {
        renderScenes(scenario.stopScenes, outroHolder, removeOutroScene);
    }

    void renderPrepacks() {
        scenario.prepacks.forEach((Prepack p)
        {
            prepackHolder.append(new DivElement()..text = "todo ${p.name} each should be p small, 50 wide? also display name, and have x button to remove");

        });
    }

    void renderScenes(List<Scene> scenes, Element element, Lambda<Scene> remove) {
        scenes.forEach((Scene s) async {
            SceneFormHelper helper = new SceneFormHelper(s);
            helper.callback = syncDataStringToScenario;
            await helper.makeBuilder(element,remove);
        });
    }



    void syncDataStringToScenario() {
        dataStringElement.value = scenario.toDataString();
    }

    void syncScenarioToDataString(String dataString) {
        print("syncing gen to datastring");
        scenario.loadFromDataString(dataString);

        try {
            scenario.loadFromDataString(dataString);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        authorElement.value = scenario.author;
        nameElement.value = scenario.name;
        descElement.value = scenario.description;
        handleIntroScenes(null);
        handleOutroScenes(null);
    }

}