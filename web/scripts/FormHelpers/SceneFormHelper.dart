/*
    A scene form has the various scene information, as well as 0 or more triggers and actions (like sburbsim) which are nested forms.
    triggers and action subforms render themselves from their hashes.
 */
import 'dart:html';

import 'package:CommonLib/Utility.dart';
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
class SceneFormHelper {
    String imageListSource = "http://farragofiction.com/LOSASE/images/BGs/list.php";
    String musicListSource = "http://farragofiction.com/LOSASE/Music/list.php";

    Scene scene;
    TextAreaElement dataStringElement;
    InputElement nameElement;
    InputElement imageKeyElement;
    InputElement musicKeyElement;

    InputElement musicOffSetElement;
    SelectElement bgElement;
    ImageElement bgPreviewElement;
    SelectElement bgMusicElement;
    AudioElement bgMusicPreviewElement;
    InputElement authorElement;
    TextAreaElement beforeTextElement;
    Element debugTextElement;
    TextAreaElement afterTextElement;
    CheckboxInputElement targetOneElement;
    Element filterHolder;
    Element actionHolder;
    Action callback;

    SceneFormHelper([Scene this.scene]) {
        print("i just made a new sceneform helper with initial scene of $scene");
        scene ??= makeTestScene();
    }

    static Scene makeTestScene() {
        print("Making a brand new test scene");
        return new Scene("Example Scene","The text before things happen. Uses markup like this [TARGET.STRINGMEMORY.name].","The text AFTER things happen. Any changes will reflect here, such as new names, or whatever.");
    }


    void makeBuilder(Element parent, Lambda<Scene> remove) async {
        DivElement formHolder = new DivElement()..classes.add("formHolder");
        parent.append(formHolder);
        if(remove != null) {
            ButtonElement button = new ButtonElement()..classes.add("x")..text = "X";
            button.onClick.listen((Event e) => remove(scene));
            formHolder.append(button);
        }
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


        targetOneElement = attachCheckInputElement(formHolder, "Single Target", scene.targetOne, (e)
        {
            scene.targetOne = e.target.checked;
            syncDataStringToScene();
        });
        wireUpDebug(formHolder);


        DivElement beforeTextHolder = new DivElement()..classes.add("subholder");
        formHolder.append(beforeTextHolder);


        beforeTextElement = attachAreaElement(beforeTextHolder, "Before Text:", "${scene.beforeFlavorText}", (e)
        {
            scene.beforeFlavorText = e.target.value;
            syncDataStringToScene();
        });

        wireUpScripting(beforeTextElement, beforeTextHolder);

        DivElement afterTextHolder = new DivElement()..classes.add("subholder");
        formHolder.append(afterTextHolder);
        afterTextElement = attachAreaElement(afterTextHolder, "After Text:", "${scene.afterFlavorText}", (e)
        {
            scene.afterFlavorText = e.target.value;
            syncDataStringToScene();
        });

        wireUpScripting(afterTextElement, afterTextHolder);
        await setupBGS(formHolder);
        await setupBGMusics(formHolder);



        makeFilters(formHolder);
        makeActions(formHolder);

    }

    void wireUpDebug(Element parent) {
        if(debugTextElement == null) {
            debugTextElement = new DivElement()..classes.add("subholder");
            parent.append(debugTextElement);
        }
        print("doing new tags");
        debugTextElement.text = "Tags Identified in Text, Filters, And Actions: ${scene.allMemoryKeys.toList()}";
    }



     void setupBGS(Element parent) async {
        DivElement holder = new DivElement()..classes.add("subholder");
        parent.append(holder);
        Element header = HeadingElement.h1()..text = "BG Image:";
        holder.append(header);
        List<String> options = new List<String>();
        Map<String,dynamic> results = await Loader.getResource(imageListSource,format: Formats.json );
        for(String folder in results["folders"].keys) {
            for(String file in results["folders"][folder]["files"]) {
                if (file.contains("png")) options.add("$folder/$file");
            }
        }
        String selected = scene.bgLocationEnd;
        selected ??= options.first;
        scene.bgLocationEnd = options.first;
        bgPreviewElement = new ImageElement()..style.width="620px";
        bgPreviewElement.src = "${Scene.bgLocationFront}$selected";
        holder.append(bgPreviewElement);
        bgElement = attachDropDownElement(holder, "BG Image:", options, selected, (e)
        {
            scene.bgLocationEnd = e.target.value;
            bgPreviewElement.src = "${scene.bgLocation}";
            syncDataStringToScene();
        });
        DivElement instructions = new DivElement()..setInnerHtml("Optionally, you can add a memory key here.<br><br> If the owner of the scene has it, they will use the background stored in that key. If the owner does NOT they will default to whatever image this scene has set. (WARNING: IF A VALID IMAGE LOCATION IS NOT STORED THERE YOU WILL GET A BLANK BG.)<br><br>Use cases include procedurally displaying a players land in a SBURB setting, or their moon.")..classes.add("instructions");
        holder.append(instructions);
        imageKeyElement = attachInputElement(holder, "Image Key:", "${scene.bgLocationEndKey}", (e)
        {
            scene.bgLocationEndKey = e.target.value;
            syncDataStringToScene();
        });


    }

     void setupBGMusics(Element parent) async {
        DivElement holder = new DivElement()..classes.add("subholder");
        parent.append(holder);
        Element header = HeadingElement.h1()..text = "BG Music:";
        holder.append(header);

        List<String> options = new List<String>();
        options.add(Scene.NOBGMUSIC);
        Map<String,dynamic> results = await Loader.getResource(musicListSource,format: Formats.json );
        for(String folder in results["folders"].keys) {
            print("checking folder $folder");
            for(String file in results["folders"][folder]["files"]) {
                if (file.contains("ogg")) options.add("$folder/$file");
            }
        }
        String selected = scene.musicLocationEnd;
        selected ??= options.first;
        bgMusicPreviewElement = new AudioElement()..loop=true..controls=true..autoplay=true;



        bgMusicPreviewElement.src = "${Scene.musicLocationFront}$selected";
        holder.append(bgMusicPreviewElement);
        bgMusicElement = attachDropDownElement(holder, "BG Music:", options, selected, (e)
        {
            scene.musicLocationEnd = e.target.value;
            bgMusicPreviewElement.src = "${scene.musicLocation}";
            syncDataStringToScene();
        });

        DivElement instructions = new DivElement()..setInnerHtml("Optionally, you can add a memory key here.<br><br> If the owner of the scene has it, they will use the music stored in that key. If the owner does NOT they will default to whatever background music this scene has set. (WARNING: IF A VALID MUSIC LOCATION IS NOT STORED THERE YOU WILL GET NO MUSIC.)<br><br>Use cases include procedurally showing a characters theme song or leitmotif.")..classes.add("instructions");
        holder.append(instructions);
        musicKeyElement = attachInputElement(holder, "Music Key:", "${scene.musicLocationEndKey}", (e)
        {
            scene.musicLocationEndKey = e.target.value;
            syncDataStringToScene();
        });
        //TODO offset stuff doesn't seem to work consistently, not all songs are seekable?
        /*musicOffSetElement = attachNumberInputElement(holder, "Music Offset (seconds): ", 0,(e) {
            scene.musicOffset = num.parse(e.target.value);
            syncDataStringToScene();
        });
        ButtonElement button = new ButtonElement()..text = "Get OffSet From Preview Current Time";
        button.onClick.listen((Event e) {
            musicOffSetElement.value = "${bgMusicPreviewElement.currentTime}";
            scene.musicOffset = num.parse(musicOffSetElement.value);
            syncDataStringToScene();
        });
        holder.append(button);
        */
    }

    //rerenders every sync
     void makeFilters(Element parent) {

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
     void makeActions(Element parent) {
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

     void syncDataStringToScene() {
        print("syncing datastring to scene callback is $callback");
        wireUpDebug(null);
        dataStringElement.value = scene.toDataString();
        if(callback !=null) callback();

     }

     void syncSceneToDataString(e) {
        print("syncing scene to datastring");
        try {
            scene.loadFromDataString(e.target.value);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this.");
        }
        nameElement.value = scene.name;
        authorElement.value = scene.author;
        musicKeyElement.value = scene.musicLocationEndKey;
        imageKeyElement.value = scene.bgLocationEndKey;
        beforeTextElement.value = scene.beforeFlavorText;
        afterTextElement.value = scene.afterFlavorText;
        targetOneElement.checked = scene.targetOne;
        doBGS();
        doMusic();
        makeFilters(null);
        makeActions(null);
        wireUpDebug(null);
        if(callback !=null) callback();

     }

     void doBGS() {
        bgPreviewElement.src = "${scene.bgLocation}";
        bgElement.options.forEach((OptionElement option) => option.selected = option.value ==scene.bgLocationEnd);
    }

     void doMusic() {
        bgMusicPreviewElement.src = "${scene.musicLocation}";
        //musicOffSetElement.value = "${scene.musicOffset}";
        bgMusicPreviewElement.currentTime = scene.musicOffset;
        print("selected options is  ${bgMusicElement.selectedOptions}");
        bgMusicElement.options.forEach((OptionElement option) => option.selected = option.value ==scene.musicLocationEnd);
    }

     void renderFilters() {

        if(scene.targetFilters.isEmpty) return;
        DivElement container = new DivElement();
        filterHolder.append(container);
        for(TargetFilter f in scene.targetFilters) {
            renderOneFilter(container,f);
        }
    }

     void renderOneFilter(Element parent, TargetFilter item) {
        DivElement container = new DivElement()..classes.add("tinyholder");
        Element header = HeadingElement.h3()..text = item.type;
        ButtonElement remove = new ButtonElement()..text = "Remove?"..style.display="inline-block"..style.marginLeft="415px";
        Element instructions = new DivElement()..text = "When searching for targets, keep one ${item.explanation}"..classes.add("instructions");
        container.append(header);
        header.append(remove);
        container.append(instructions);
        parent.append(container);

        remove.onClick.listen((Event e) {
            scene.targetFilters.remove(item);
            syncDataStringToScene();
            makeFilters(null);
        });

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

     void renderOneAction(Element parent, ActionEffect item) {
        DivElement container = new DivElement()..classes.add("tinyholder");
        Element header = HeadingElement.h3()..text = item.type;
        ButtonElement remove = new ButtonElement()..text = "Remove?"..style.display="inline-block"..style.marginLeft="415px";

        Element instructions = new DivElement()..text = "${item.explanation}"..classes.add("instructions");
        container.append(header);
        header.append(remove);
        container.append(instructions);
        parent.append(container);

        remove.onClick.listen((Event e) {
            scene.effects.remove(item);
            syncDataStringToScene();
            makeActions(null);
        });

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

     void renderActions() {
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