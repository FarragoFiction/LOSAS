/*
    A scene form has the various scene information, as well as 0 or more triggers and actions (like sburbsim) which are nested forms.
    triggers and action subforms render themselves from their hashes.
 */
import 'dart:html';

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
    static Scene scene;
    static TextAreaElement dataStringElement;
    static InputElement nameElement;
    static TextAreaElement beforeTextElement;
    static TextAreaElement afterTextElement;
    static CheckboxInputElement targetOneElement;
    static Element filterHolder;
    static Element actionHolder;

    static void makeSceneBuilder(Element parent) {
        DivElement formHolder = new DivElement()..classes.add("formHolder")..text = "TODO need a button to add markup to before and after flavor text, as well as a preview of it with replacement stuff, also nested filters/effects";
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
        List<String> options = TargetFilter.exampleOfAllFilters.map((TargetFilter f) => f.type);
        String selected = options.first;
        ButtonElement button = new ButtonElement()..text = "Add $selected";

        SelectElement select = attachDropDownElement(filterHolder,"FilterTypes:", options,selected,(e) {
            button.text = "Add ${e.target.value}";
            selected = e.target.value;
        });
        filterHolder.append(button);
        renderFilters();
        button.onClick.listen((Event e) {
            print("imma let you finish, but just so you know, scene.targetFilters is a ${scene.targetFilters.runtimeType}");
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
        List<String> options = ActionEffect.exampleOfAllEffects.map((
            ActionEffect f) => f.type);
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
        beforeTextElement.value = scene.beforeFlavorText;
        afterTextElement.value = scene.afterFlavorText;
        targetOneElement.checked = scene.targetOne;
        makeFilters(null);
        makeActions(null);
        //TODO HANDLE LOADING FILTERS/ACTIONS
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
        DivElement container = new DivElement()..classes.add("subholder")..text = "TODO ${item.type}";
        parent.append(container);
        //todo go through hashes

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