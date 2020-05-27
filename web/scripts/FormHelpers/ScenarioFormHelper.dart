
import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../Scenario.dart';
import '../Scene.dart';
import 'GenericFormHelper.dart';
import 'SceneFormHelper.dart';

class ScenarioFormHelper {

    TextAreaElement dataStringElement;
    Scenario scenario;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;
    Element introHolder;
    Element outroHolder;

    ScenarioFormHelper([this.scenario]) {
        this.scenario ??= makeNewScenario();
    }

    static makeNewScenario() {
        return  new Scenario("Sample Scenario","Describe what kind of story this is telling, and what sorts of characters you can build in it.","???",13);
    }

    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()
            ..setInnerHtml(
                "Scenarios are everything needed to tell a given story. It contains both stand alone scenes meant to be the start/end of the story, as well as the various prepacks that will be used to build entities within it. <br><br>Ideally, the prepacks should be designed for a specific scenario and all reference the same memory keys.<br><br>An example of a scenario is SBURB, which contains various prepacks to let you assigned class, aspect, moon, interests and species to entities. <br><br>Another example is Hogwartz, which might assign one of the four Houses, Student, Teacher and Villain status to entities.")
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

    void handleScenes(Element holder, String label, List<Scene> sceneArray, Lambda handleCallBack, Action renderCallBack,String instruction) {
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
        renderScenes(scenario.frameScenes, introHolder);

    }

    void renderOutroScenes() {
        renderScenes(scenario.stopScenes, outroHolder);
    }

    void renderScenes(List<Scene> scenes, Element element) {
        scenes.forEach((Scene s) async {
            SceneFormHelper helper = new SceneFormHelper(s);
            helper.callback = syncDataStringToScenario;
            await helper.makeBuilder(element);
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