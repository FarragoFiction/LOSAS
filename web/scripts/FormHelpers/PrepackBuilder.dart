/*
TODO:
//first have the list of generators to initialize (can just be like generators string input)
//display a warning if the initial keys aren't found in any generators we got

probably easier to just have scenes/generators be nested builders.
//for each scene/generator render a builder thingy
//and if you load the prepack from datastring wipe everything out and rerender
 */

import 'dart:html';

import 'package:LoaderLib/Loader.dart';
import "package:ImageLib/Encoding.dart";
import '../Game.dart';
import '../Generator.dart';
import '../Prepack.dart';
import '../Scene.dart';
import 'GenericFormHelper.dart';
import 'NumGeneratorFormHelper.dart';
import 'SceneFormHelper.dart';
import 'StringGeneratorFormHelper.dart';

class PrepackBuilder {
    static String fileKey = "${GameUI.dataPngFolder}${Prepack.dataPngFile}";
    Prepack prepack;
    TextAreaElement dataStringElement;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;
    Element initializerElement;
    Element stringGeneratorElement;
    Element numGeneratorElement;
    Element sceneElement;
    Element archiveSaveButton;
    Element imageUploaderHolder;
    Element archiveUploaderHolder;


    PrepackBuilder([this.prepack]) {
        this.prepack ??= makeNewPrepack();
    }

    static makeNewPrepack() {
        return  new Prepack("Sample Prepack","Describe what kind of character would have this prepack, and what this prepack does.","???",[],[],[]);
    }



    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()..setInnerHtml("A prepack (prepackaged set) is the basic buildling block of LOSAS, defining the scenes, generators and initializations a character will have. A prepack will be known as a 'Trait' to the regular Observers to protect their delicate sanity. <br><Br>A given Entity can have multiple prepacks, as an example in a SBURB Scenario a character might have the following prepacks: Knight, Mind, Derse, Athletics, Music, GodDestiny, Player, GoldBlood, Lamia.<br><br>A good prepack should be very focused in terms of content.  The Player prepack, as an example, should have only the generic things any player should be able to do (generic side quests, kissing dead players, etc).<Br><br>Note: You can either create generators and scenes in the stand alone builders and load them here by datastring, or you can create them inline here." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${prepack.toDataString()}", (e) => syncPrepackToDataString(e.target.value));
        handleImageUpload(formHolder);
        nameElement = attachInputElement(formHolder, "Name:", "${prepack.name}", (e)
        {
            prepack.name = e.target.value;
            syncDataStringToPrepack();
        });

        authorElement = attachInputElement(formHolder, "Author:", "${prepack.author}", (e)
        {
            prepack.author = e.target.value;
            syncDataStringToPrepack();
        });

        descElement = attachAreaElement(formHolder, "Description:", "${prepack.description}", (e)
        {
            prepack.description = e.target.value;
            syncDataStringToPrepack();
        });

        handleInitializers(formHolder);
        handleStringGenerators(formHolder);
        handleNumGenerators(formHolder);
        handleScenes(formHolder);
    }

    //for datapngs
    void handleImageUpload(Element parent) {
        imageUploaderHolder =new DivElement()..classes.add("instructions");
        parent.append(imageUploaderHolder);
        DivElement instructions = new DivElement()..setInnerHtml(" You can upload any image to store your prepack into here. Smaller filesizes will be faster/easier. (Note any changes to the datastring will require you to reupload the image)." )..style.marginBottom="30px";
        imageUploaderHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, handleWritingPrepackToPng, caption: "Upload Image to Contain Prepack");
        imageUploaderHolder.append(uploadElement);

       handleLoadingPrepackFromImage(parent);

    }

    void handleWritingPrepackToPng(ArchivePng png, String fileName) async {
        //doing it this way in case theres data already in it. don't copy to context.
        archiveSaveButton = new DivElement()..text = "Processing...";
        imageUploaderHolder.append(archiveSaveButton);
        await png.archive.setFile(fileKey, prepack.toDataString());
        clearArchiveDownload();
        archiveSaveButton = FileFormat.saveButton(ArchivePng.format, ()=> png, filename: ()=>"${prepack.name}.png", caption: "Download Prepack Archive Image (Be Patient)");
        imageUploaderHolder.append(archiveSaveButton);
        //TODO if ppl complain about having to reupload their image cache it and have a button explicitly for reexporting. not worth it rn
    }

    //any time the datastring gets changed the download link gets nuked
    void clearArchiveDownload() {
        if(archiveSaveButton != null ) archiveSaveButton.remove();
    }

    Future handleLoadingPrepackFromImage(Element parent) {
        archiveUploaderHolder =new DivElement()..classes.add("instructions");
        parent.append(archiveUploaderHolder);
        //by getting the upload this way we can maintain any data already in it (so in theory you could have a char, scenario AND prepack all in the same image
        DivElement instructions = new DivElement()..setInnerHtml("If you have an image with a prepack stored in it, you can load it here." )..style.marginBottom="30px";;
        archiveUploaderHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, syncPrepackToImage,caption: "Load Prepack From Image");
        archiveUploaderHolder.append(uploadElement);


    }

    Future syncPrepackToImage(ArchivePng png, String fileName) async {
        DivElement processing = new DivElement()..text = "processing";
        archiveUploaderHolder.append(processing);
        String dataString = await png.getFile(fileKey);
        processing.remove();
        if(dataString != null) syncPrepackToDataString(dataString);
    }

    void handleStringGenerators(Element parent) {
        if(stringGeneratorElement == null) {
            stringGeneratorElement = new Element.div()..classes.add("subholder");
            parent.append(stringGeneratorElement);
        }
        stringGeneratorElement.text = "";
        Element header = HeadingElement.h1()..text = "Associated Word/Phrase Generators:";
        DivElement instructions = new DivElement()..setInnerHtml("Whenever a character needs to generate a random word or phrase, they will look to their prepacks. ")..classes.add("instructions");
        stringGeneratorElement.append(header);

        stringGeneratorElement.append(instructions);



        StringGenerator g = StringGeneratorFormHelper.makeTestGenerator();
         attachAreaElement(stringGeneratorElement, "Add StringGenerator From DataString:", "${g.toDataString()}", (e)
        {
            try {
                g.loadFromDataString(e.target.value);
            }catch(e) {
                window.console.error(e);
                window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
            }

        });

         ButtonElement button = new ButtonElement()..text = "Add String Generator";
         stringGeneratorElement.append(button);
         button.onClick.listen((Event e) {
             prepack.generators.add(g);
             syncDataStringToPrepack();
             handleStringGenerators(null);
        });

        renderStringGenerators();

    }

    void handleNumGenerators(Element parent) {
        if(numGeneratorElement == null) {
            numGeneratorElement = new Element.div()..classes.add("subholder");
            parent.append(numGeneratorElement);
        }
        numGeneratorElement.text = "";
        Element header = HeadingElement.h1()..text = "Associated Number Generators:";
        DivElement instructions = new DivElement()..setInnerHtml("Whenever a character needs to generate a random number, they will look to their prepacks. ")..classes.add("instructions");
        numGeneratorElement.append(header);

        numGeneratorElement.append(instructions);



        NumGenerator g = NumGeneratorFormHelper.makeTestGenerator();
        attachAreaElement(numGeneratorElement, "Add NumGenerator From DataString:", "${g.toDataString()}", (e)
        {
            try {
                g.loadFromDataString(e.target.value);
            }catch(e) {
                window.console.error(e);
                window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
            }

        });

        ButtonElement button = new ButtonElement()..text = "Add String Generator";
        numGeneratorElement.append(button);
        button.onClick.listen((Event e) {
            prepack.generators.add(g);
            syncDataStringToPrepack();
            handleNumGenerators(null);
        });

        renderNumGenerators();

    }

    void handleScenes(Element parent) {
        if(sceneElement == null) {
            sceneElement = new Element.div()..classes.add("subholder");
            parent.append(sceneElement);
        }
        sceneElement.text = "";
        Element header = HeadingElement.h1()..text = "Associated Scenes:";
        DivElement instructions = new DivElement()..setInnerHtml("The scenes a character has access to from their prepack. ")..classes.add("instructions");
        sceneElement.append(header);

        sceneElement.append(instructions);



        Scene s = SceneFormHelper.makeTestScene();
        attachAreaElement(sceneElement, "Add Scene From DataString:", "${s.toDataString()}", (e)
        {
            try {
                s.loadFromDataString(e.target.value);
            }catch(e) {
                window.console.error(e);
                window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
            }

        });

        ButtonElement button = new ButtonElement()..text = "Add Scene";
        sceneElement.append(button);
        button.onClick.listen((Event e) {
            prepack.scenes.add(s);
            syncDataStringToPrepack();
            handleScenes(null);
        });

        renderScenes();

    }

    void renderStringGenerators() {
        prepack.generators.where((Generator g) => g is StringGenerator).forEach((Generator sg) {
            StringGeneratorFormHelper helper = new StringGeneratorFormHelper(sg);
            helper.callback = syncDataStringToPrepack;
            helper.makeBuilder(stringGeneratorElement);
        });
    }

    void renderNumGenerators() {
        prepack.generators.where((Generator g) => g is NumGenerator).forEach((Generator ng) {
            NumGeneratorFormHelper helper = new NumGeneratorFormHelper(ng);
            helper.callback = syncDataStringToPrepack;
            helper.makeBuilder(numGeneratorElement);
        });
    }

    void renderScenes() {
        prepack.scenes.forEach((Scene s) async {
            SceneFormHelper helper = new SceneFormHelper(s);
            helper.callback = syncDataStringToPrepack;
            await helper.makeBuilder(sceneElement);
        });
    }

    void handleInitializers(Element parent) {
        if(initializerElement == null) {
            initializerElement = new Element.div()..classes.add("subholder");
            parent.append(initializerElement);
        }
        initializerElement.text = "";
        Element header = HeadingElement.h1()..text = "Initial Generator Keys:";
        DivElement instructions = new DivElement()..setInnerHtml("When a scenario starts, all entities will check their prepacks for what generators should generate even before a single scene triggers. <br><br>This allows things like 'all characters begin with strength, dexterity, charisma and constitution' ")..classes.add("instructions");
        initializerElement.append(header);

        initializerElement.append(instructions);

        renderWords();

        ButtonElement button = new ButtonElement()..text = "Add";

        TextAreaElement input = attachAreaElement(initializerElement, "Add Word/Phrase:", "", (e)
        {
            button.text = "Add ${e.target.value}";

        });

        button.onClick.listen((Event e) {
            prepack.initialKeysToGenerate.add( input.value);
            syncDataStringToPrepack();
            handleInitializers(null);
        });
        initializerElement.append(button);


    }

    bool orphanInitializer(String word) {
        for(Generator gen in prepack.generators) {
            if(gen.key == word) return false;
        }
        return true;
    }

    void renderWords() {
        DivElement container = new DivElement();
        bool displayWarning = false;
        initializerElement.append(container);
        for(String word in prepack.initialKeysToGenerate) {
            DivElement holder = new DivElement()..style.padding="3px"..style.display="inline-block";
            container.append(holder);
            DivElement wordElement = new DivElement()..text = word..style.display="inline-block";
            if(orphanInitializer(word)) {
                wordElement.text = "${wordElement.text} (*)";
                displayWarning = true;
            }
            holder.append(wordElement);
            ButtonElement remove = new ButtonElement()..text = "x"..classes.add("x");
            holder.append(remove);
            remove.onClick.listen((Event e ) {
                prepack.initialKeysToGenerate.remove(word);
                syncDataStringToPrepack();
                handleInitializers(null);
            });
        }

        if(displayWarning) {
            DivElement warning = new DivElement()..text = "WARNING: KEYS MARKED WITH A (*) ARE NOT FOUND IN THIS PREPACK'S GENERATORS. THEY MAY INITIALIZE WITH A NULL VALUE IF NO OTHER GENERATOR DEFINES THEM. KNOWN KEYS ARE ${prepack.generators.map((Generator g) => g.key).join(",")}";
            container.append(warning);
        }
    }

    void syncDataStringToPrepack() {
        print("syncing datastring to generator, scenes is ${prepack.scenes.join(",")}");
        dataStringElement.value = prepack.toDataString();
        clearArchiveDownload();
    }

    void syncPrepackToDataString(String dataString) {
        print("syncing gen to datastring");
        prepack.loadFromDataString(dataString);

        try {
            prepack.loadFromDataString(dataString);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        print("after loading i have scenes ${prepack.scenes.join(",")}");
        authorElement.value = prepack.author;
        nameElement.value = prepack.name;
        descElement.value = prepack.description;
        handleInitializers(null);
        handleStringGenerators(null);
        handleNumGenerators(null);
        handleScenes(null);
    }
}