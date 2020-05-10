/*
    A scene form has the various scene information, as well as 0 or more triggers and actions (like sburbsim) which are nested forms.
    triggers and action subforms render themselves from their hashes.
 */
import 'dart:html';

import 'package:LoaderLib/Loader.dart';

import '../ActionEffects/ActionEffect.dart';
import '../Scene.dart';
import '../TargetFilters/TargetFilter.dart';
import 'GenericFormHelper.dart';

/*
    TODO have a simple scene builder that syncs name, before and after flavor text
    ability to set targetOne
    ability to pick bg image from list
    ability to add/remove filters/effects
 */
abstract class SceneFormHelper {
    static String imageListSource = "http://farragofiction.com/LOSASE/images/BGs/list.php";
    static String musicListSource = "http://farragofiction.com/LOSASE/Music/list.php";

    static Scene scene;
    static TextAreaElement dataStringElement;
    static InputElement nameElement;
    static SelectElement bgElement;
    static ImageElement bgPreviewElement;
    static SelectElement bgMusicElement;
    static AudioElement bgMusicPreviewElement;
    static InputElement authorElement;
    static TextAreaElement beforeTextElement;
    static TextAreaElement afterTextElement;
    static CheckboxInputElement targetOneElement;
    static Element filterHolder;
    static Element actionHolder;

    static void makeSceneBuilder(Element parent) async {
        DivElement formHolder = new DivElement()..classes.add("formHolder");
        parent.append(formHolder);
        scene = new Scene("Example Scene","The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name]. JR NOTE: make this insertable.","The text AFTER things happen. Any changes will reflect here, such as new names, or whatever.");
        DivElement instructions = new DivElement()..setInnerHtml("A Scene is the basic unit of AI for LOSAS. Scenes are how entities change the simulation, and the other entities within it.<br><br>Each tick of the simulation, each entity checks their list of scenes in order. The first scene to find at least one target is rendered to the screen, and its effects, if any, are applied.")..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${scene.toDataString()}", (e) => syncSceneToDataString(e));
        nameElement = attachInputElement(formHolder, "Scene Name:", "${scene.name}", (e)
        {
            scene.name = e.target.value;
            syncDataStringToScene();
        });


        authorElement = attachInputElement(formHolder, "Author:", "${scene.author}", (e)
        {
            scene.author = e.target.value;
            syncDataStringToScene();
        });

        await setupBGS(formHolder);
        await setupBGMusics(formHolder);

        beforeTextElement = attachAreaElement(formHolder, "Before Text:", "${scene.beforeFlavorText}", (e)
        {
            scene.beforeFlavorText = e.target.value;
            syncDataStringToScene();
        });

        afterTextElement = attachAreaElement(formHolder, "After Text:", "${scene.afterFlavorText}", (e)
        {
            scene.afterFlavorText = e.target.value;
            syncDataStringToScene();
        });

        targetOneElement = attachCheckInputElement(formHolder, "Single Target", scene.targetOne, (e)
        {
            scene.targetOne = e.target.checked;
            syncDataStringToScene();
        });

        makeFilters(formHolder);
        makeActions(formHolder);

    }

    static void setupBGS(Element formHolder) async {
        List<String> options = new List<String>();
        Map<String,dynamic> results = await Loader.getResource(imageListSource,format: Formats.json );
        for(String folder in results["folders"].keys) {
            for(String file in results["folders"][folder]["files"]) {
                if (file.contains("png")) options.add("$folder/$file");
            }
        }
        String selected = options.first;
        scene.bgLocationEnd = options.first;
        bgPreviewElement = new ImageElement();
        bgPreviewElement.src = "${Scene.bgLocationFront}$selected";
        formHolder.append(bgPreviewElement);
        bgElement = attachDropDownElement(formHolder, "BG Image:", options, selected, (e)
        {
            scene.bgLocationEnd = e.target.value;
            bgPreviewElement.src = "${scene.bgLocation}";
            syncDataStringToScene();
        });
    }

    static void setupBGMusics(Element formHolder) async {
        List<String> options = new List<String>();
        options.add("None");
        Map<String,dynamic> results = await Loader.getResource(musicListSource,format: Formats.json );
        for(String folder in results["folders"].keys) {
            print("checking folder $folder");
            for(String file in results["folders"][folder]["files"]) {
                if (file.contains("ogg")) options.add("$folder/$file");
            }
        }
        String selected = options.first;
        bgMusicPreviewElement = new AudioElement()..loop=true..controls=true..autoplay=true;
        bgMusicPreviewElement.src = "${Scene.musicLocationFront}$selected";
        formHolder.append(bgMusicPreviewElement);
        bgMusicElement = attachDropDownElement(formHolder, "BG Music:", options, selected, (e)
        {
            scene.musicLocationEnd = e.target.value;
            bgMusicPreviewElement.src = "${scene.musicLocation}";
            syncDataStringToScene();
        });
    }

    //rerenders every sync
    static void makeFilters(Element parent) {

        if(filterHolder == null) {
            filterHolder = new DivElement()
                ..classes.add("subholder");
            parent.append(filterHolder);
        }
        filterHolder.text = "";
        Element header = HeadingElement.h1()..text = "Add TargetFilters";
        filterHolder.append(header);
        Element desc = new DivElement()..text = "Control what sorts of entities are valid targets of this scene (if there are no valid targets, the scene will not trigger).";
        filterHolder.append(desc);
        TargetFilter.setExamples();
        List<String> options = new List.from(TargetFilter.exampleOfAllFilters.map((TargetFilter f) => f.type));
        String selected = options.first;
        ButtonElement button = new ButtonElement()..text = "Add $selected";

        SelectElement select = attachDropDownElement(filterHolder,"FilterTypes:", options,selected,(e) {
            button.text = "Add ${e.target.value}";
            selected = e.target.value;
        });
        filterHolder.append(button);
        renderFilters();
        button.onClick.listen((Event e) {
            scene.targetFilters.add(TargetFilter.makeNewFromString(selected));
            makeFilters(null);
        });

    }

    //rerenders every sync
    static void makeActions(Element parent) {
        if (actionHolder == null) {
            actionHolder = new DivElement()
                ..classes.add("subholder");
            parent.append(actionHolder);
        }
        actionHolder.text = "";

        Element header = HeadingElement.h1()
            ..text = "Add ActionEffects";
        actionHolder.append(header);
        Element desc = new DivElement()
            ..text = "Controls the post trigger effects on the valid targets or owner.";
        actionHolder.append(desc);
        ActionEffect.setExamples();
        List<String> options = new List.from(ActionEffect.exampleOfAllEffects.map((
            ActionEffect f) => f.type));
        String selected = options.first;
        ButtonElement button = new ButtonElement()..text = "Add $selected";
        SelectElement select = attachDropDownElement(actionHolder,"ActionTypes:", options,options.first,(e) {
            button.text = "Add ${e.target.value}";
            selected = e.target.value;
        });
        actionHolder.append(button);
        button.onClick.listen((Event e) {
            scene.effects.add(ActionEffect.makeNewFromString(selected));
            makeActions(null);
        });
        renderActions();
    }

    static void syncDataStringToScene() {
        print("syncing datastring to scene");
        dataStringElement.value = scene.toDataString();
    }

    static void syncSceneToDataString(e) {
        print("syncing scene to datastring");
        try {
            scene.loadFromDataString(e.target.value);
        }catch(e) {
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this.");
        }
        nameElement.value = scene.name;
        authorElement.value = scene.author;
        beforeTextElement.value = scene.beforeFlavorText;
        afterTextElement.value = scene.afterFlavorText;
        targetOneElement.checked = scene.targetOne;
        doBGS();
        doMusic();
        makeFilters(null);
        makeActions(null);
    }

    static void doBGS() {
        bgPreviewElement.src = "${scene.bgLocation}";
        bgElement.options.forEach((OptionElement option) => option.selected = option.value ==scene.bgLocationEnd);
    }

    static void doMusic() {
        print("scene music location is ${scene.musicLocation}");
        bgMusicPreviewElement.src = "${scene.musicLocation}";
        print("selected options is  ${bgMusicElement.selectedOptions}");
        bgMusicElement.options.forEach((OptionElement option) => option.selected = option.value ==scene.musicLocationEnd);
    }

    static void renderFilters() {

        if(scene.targetFilters.isEmpty) return;
        DivElement container = new DivElement();
        filterHolder.append(container);
        for(TargetFilter f in scene.targetFilters) {
            renderOneFilter(container,f);
        }
    }

    static void renderOneFilter(Element parent, TargetFilter item) {
        DivElement container = new DivElement()..classes.add("tinyholder");
        Element header = HeadingElement.h3()..text = item.type;
        Element instructions = new DivElement()..text = "When searching for targets, keep one ${item.explanation}"..classes.add("instructions");
        container.append(header);
        container.append(instructions);
        parent.append(container);

        CheckboxInputElement vriskaElement = attachCheckInputElement(container, "Apply to Self,Not Target", item.vriska, (e)
        {
            item.vriska = e.target.checked;
            syncDataStringToScene();
        });

        CheckboxInputElement notElement = attachCheckInputElement(container, "Invert Filter", item.not, (e)
        {
            item.not = e.target.checked;
            syncDataStringToScene();
        });

        for(String key in item.importantWords.keys) {
            attachInputElement(container, "$key:", "${item.importantWords[key]}", (e)
            {
                item.importantWords[key] = e.target.value;
                syncDataStringToScene();
            });
        }

        for(String key in item.importantNumbers.keys) {
            attachNumberInputElement(container, "$key:", item.importantNumbers[key], (e)
            {
                item.importantNumbers[key] = num.parse(e.target.value);
                syncDataStringToScene();
            });
        }
    }

    static void renderOneAction(Element parent, ActionEffect item) {
        DivElement container = new DivElement()..classes.add("tinyholder");
        Element header = HeadingElement.h3()..text = item.type;
        Element instructions = new DivElement()..text = "${item.explanation}"..classes.add("instructions");
        container.append(header);
        container.append(instructions);
        parent.append(container);

        CheckboxInputElement vriskaElement = attachCheckInputElement(container, "Apply to Self,Not Target", item.vriska, (e)
        {
            item.vriska = e.target.checked;
            syncDataStringToScene();
        });

        for(String key in item.importantWords.keys) {
            attachInputElement(container, "$key:", "${item.importantWords[key]}", (e)
            {
                item.importantWords[key] = e.target.value;
                syncDataStringToScene();
            });
        }

        for(String key in item.importantNumbers.keys) {
            attachNumberInputElement(container, "$key:", item.importantNumbers[key], (e)
            {
                item.importantNumbers[key] = num.parse(e.target.value);
                syncDataStringToScene();
            });
        }
    }

    static void renderActions() {
        if(scene.effects.isEmpty) return;
        DivElement container = new DivElement()..classes.add("subholder");
        Element header = HeadingElement.h2()
            ..text = "Existing ActionEffects";
        container.append(header);
        actionHolder.append(container);
        for(ActionEffect a in scene.effects) {
            renderOneAction(container,a);
        }

    }



}