
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
    static String fileKey = "${GameUI.dataPngFolder}${Scenario.dataPngFile}";
    TextAreaElement dataStringElement;
    Scenario scenario;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;
    Element introHolder;
    Element outroHolder;
    Element prepackHolder;
    Element archiveSaveButton;
    Element imageUploaderHolder;
    Element archiveUploaderHolder;
    Element debugHelperElement;

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

        handleImageUpload(formHolder);


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
        handleDebugHelpers(formHolder);
    }

    //for datapngs
    void handleImageUpload(Element parent) {
        imageUploaderHolder =new DivElement()..classes.add("instructions");
        parent.append(imageUploaderHolder);
        DivElement instructions = new DivElement()..setInnerHtml(" You can upload any image to store your scenario into here. Smaller filesizes will be faster/easier. (Note any changes to the datastring will require you to reupload the image)." )..style.marginBottom="30px";
        imageUploaderHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, handleWritingScenarioToPng, caption: "Upload Image to Contain Scenario");
        imageUploaderHolder.append(uploadElement);

        handleLoadingScenarioFromImage(parent);

    }

    void handleWritingScenarioToPng(ArchivePng png, String fileName) async {
        //doing it this way in case theres data already in it. don't copy to context.
        archiveSaveButton = new DivElement()..text = "Processing...";
        imageUploaderHolder.append(archiveSaveButton);
        await png.archive.setFile(fileKey, scenario.toDataString());
        clearArchiveDownload();
        archiveSaveButton = FileFormat.saveButton(ArchivePng.format, ()=> png, filename: ()=>"${scenario.name}.png", caption: "Download Scenario Archive Image (Be Patient)");
        imageUploaderHolder.append(archiveSaveButton);
        //TODO if ppl complain about having to reupload their image cache it and have a button explicitly for reexporting. not worth it rn
    }

    Future handleLoadingScenarioFromImage(Element parent) {
        archiveUploaderHolder =new DivElement()..classes.add("instructions");
        parent.append(archiveUploaderHolder);
        //by getting the upload this way we can maintain any data already in it (so in theory you could have a char, scenario AND prepack all in the same image
        DivElement instructions = new DivElement()..setInnerHtml("If you have an image with a scenario stored in it, you can load it here." )..style.marginBottom="30px";;
        archiveUploaderHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, syncScenarioToImage,caption: "Load Scenario From Image");
        archiveUploaderHolder.append(uploadElement);
        syncDataStringToScenario();
    }

    Future syncScenarioToImage(ArchivePng png, String fileName) async {
        DivElement processing = new DivElement()..text = "processing";
        archiveUploaderHolder.append(processing);
        //yes i could use the build in dataobject loader but that wouldn't get me a datastring directly
        String dataString = await png.getFile(fileKey);
        processing.remove();
        if(dataString != null) syncScenarioToDataString(dataString);
    }


    //any time the datastring gets changed the download link gets nuked
    void clearArchiveDownload() {
        if(archiveSaveButton != null ) archiveSaveButton.remove();
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
        renderPrepacks();
    }
    Future loadPrepackFromImage(ArchivePng png, String fileName) async {
        print("IN FORM: I'm loading a prepack from image $fileName");
        DivElement processing = new DivElement()..text = "processing";
        prepackHolder.append(processing);
        Prepack prepack = new Prepack.empty();

        //yes i could use the build in dataobject loader but that wouldn't get me a datastring directly
            try {
                await prepack.loadFromArchive(png);
                print("IN FORM: the load completed");
                processing.remove();
                scenario.prepacks.add(prepack);
                print("IN FORM: actually loaded a prepack from the archive, added it to the scenario");
                syncDataStringToScenario();
                handlePrepacks(null);
            }catch(e) {
                window.console.error(e);
                window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
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
            print('rendering prepack ${p.name}');
            DivElement sub = new DivElement()..style.display = "inline-block";
            DivElement text = new DivElement()..text = p.name;
            prepackHolder.append(sub);

            try {
                CanvasElement element = p.externalForm.canvas
                    ..classes.add("prepack-icon");
                sub.append(element);
                sub.append(text);

                Element dse = attachAreaElement(sub, "DataString (changing this keeps current image):", "${p.toDataStringWithoutImage()}", (e)
                async {
                    try {
                        await p.loadFromDataString(e.target.value);
                        handlePrepacks(null);
                    }catch(e) {
                        window.console.error(e);
                        window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
                    }

                });
                sub.append(dse);

                ButtonElement remove = new ButtonElement()..text = "x"..classes.add("x")..style.display="block";
                sub.append(remove);
                remove.onClick.listen((Event e ) {
                    scenario.prepacks.remove(p);
                    syncDataStringToScenario();
                    handlePrepacks(null);
                });
            }catch(e) {
                window.alert("some kind of error displaying prepack, are you sure it had an image?");
            }
        });
    }

    void renderScenes(List<Scene> scenes, Element element, Lambda<Scene> remove) {
        scenes.forEach((Scene s) async {
            SceneFormHelper helper = new SceneFormHelper(s);
            helper.callback = syncDataStringToScenario;
            await helper.makeBuilder(element,remove);
        });
    }

    void handleDebugHelpers(Element parent) {
        if(debugHelperElement == null) {
            debugHelperElement = new DivElement()..classes.add("subholder");
            parent.append(debugHelperElement);
        }
        debugHelperElement.text = "";
        Element header = HeadingElement.h1()..text = "Memory Keys' Info:";
        DivElement instructions = new DivElement()..setInnerHtml("Here you can review all memory keys known by the scenario, separated into those referenced by generators, those referenced by scenes.<br><br>NOTE: will not catch errors such as thinking a key is a string when its a num or whatever. sorry.<br><br>NOTE: anything weird you do like nested keys or pointers or whatever won't show up here. Probably.")..classes.add("instructions");
        debugHelperElement.append(header);
        debugHelperElement.append(instructions);
        handleGenDebug(debugHelperElement);
        handleSceneDebug(debugHelperElement);

    }

    void handleGenDebug(Element parent) {
        Element debugHolder = new DivElement()..classes.add("subholder");
        parent.append(debugHolder);
        Element header = HeadingElement.h1()..text = "Generator Keys' Info:";
        DivElement instructions = new DivElement()..setInnerHtml("Any key a prepack initializes or generates.")..classes.add("instructions");
        debugHolder.append(header);
        debugHolder.append(instructions);
        final List<String> keys = new List.from(scenario.allGeneratorMemoryKeys)..sort();
        for(String key in keys) {
            DivElement div = new DivElement()..text = key..classes.add("memoryKey");
            debugHolder.append(div);
        }
    }

    void handleSceneDebug(Element parent) {
        Element debugHolder = new DivElement()..classes.add("subholder");
        parent.append(debugHolder);
        Element header = HeadingElement.h1()..text = "Scene Keys' Info:";
        DivElement instructions = new DivElement()..setInnerHtml("Any key a scene references in its text.")..classes.add("instructions");
        debugHolder.append(header);
        debugHolder.append(instructions);
        final List<String> keys = new List.from(scenario.allMemoryKeysRefScenes)..sort();
        for(String key in keys) {
            DivElement div = new DivElement()..text = key..classes.add("memoryKey");
            debugHolder.append(div);
        }
    }









    void syncDataStringToScenario() {
        dataStringElement.value = scenario.toDataStringWithoutImage();
    }

    Future<void> syncScenarioToDataString(String dataString) async{
        print("syncing gen to datastring");
        try {
            await scenario.loadFromDataString(dataString);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        authorElement.value = scenario.author;
        nameElement.value = scenario.name;
        descElement.value = scenario.description;
        handleIntroScenes(null);
        handleOutroScenes(null);
        handlePrepacks(null);
        handleDebugHelpers(null);
    }

}