/*
TODO:
//first have the list of generators to initialize (can just be like generators string input)
//display a warning if the initial keys aren't found in any generators we got

probably easier to just have scenes/generators be nested builders.
//for each scene/generator render a builder thingy
//and if you load the prepack from datastring wipe everything out and rerender
 */

import 'dart:html';

import '../Prepack.dart';
import 'GenericFormHelper.dart';

abstract class PrepackBuilder {
    static Prepack prepack;
    static TextAreaElement dataStringElement;
    static InputElement nameElement;
    static InputElement authorElement;
    static TextAreaElement descElement;
    static Element initializerElement;



    static void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        prepack = new Prepack("Sample Prepack","Describe what kind of character would have this prepack, and what this prepack does.","???",[],[],[]);
        DivElement instructions = new DivElement()..setInnerHtml("A prepack is the basic buildling block of LOSAS, defining the scenes, generators and initializations a character will have. <br><Br>A given Entity can have multiple prepacks, as an example in a SBURB Scenario a character might have the following prepacks: Knight, Mind, Derse, Athletics, Music, GodDestiny, Player.<br><br>A good prepack should be very focused in terms of content.  The Player prepack, as an example, should have only the generic things any player should be able to do (generic side quests, kissing dead players, etc)." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${prepack.toDataString()}", (e) => syncPrepackToDataString(e));
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

    }

    static void handleInitializers(Element parent) {
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

    static void renderWords() {
        DivElement container = new DivElement();
        initializerElement.append(container);
        for(String word in prepack.initialKeysToGenerate) {
            DivElement holder = new DivElement()..style.padding="3px"..style.display="inline-block";
            container.append(holder);
            DivElement wordElement = new DivElement()..text = word..style.display="inline-block";
            holder.append(wordElement);
            ButtonElement remove = new ButtonElement()..text = "x"..classes.add("x");
            holder.append(remove);
            remove.onClick.listen((Event e ) {
                prepack.initialKeysToGenerate.remove(word);
                syncDataStringToPrepack();
                handleInitializers(null);
            });
        }
    }

    static void syncDataStringToPrepack() {
        print("syncing datastring to generator");
        dataStringElement.value = prepack.toDataString();
    }

    static void syncPrepackToDataString(e) {
        print("syncing gen to datastring");
        prepack.loadFromDataString(e.target.value);

        try {
            prepack.loadFromDataString(e.target.value);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        authorElement.value = prepack.author;
        nameElement.value = prepack.name;
        descElement.value = prepack.description;
        handleInitializers(null);
    }
}