/*
TODO:
//first have the list of generators to initialize (can just be like generators string input)
//display a warning if the initial keys aren't found in any generators we got

probably easier to just have scenes/generators be nested builders.
//for each scene/generator render a builder thingy
//and if you load the prepack from datastring wipe everything out and rerender
 */

import 'dart:html';

import '../Generator.dart';
import '../Prepack.dart';
import 'GenericFormHelper.dart';
import 'NumGeneratorFormHelper.dart';
import 'StringGeneratorFormHelper.dart';

class PrepackBuilder {
    Prepack prepack;
    TextAreaElement dataStringElement;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;
    Element initializerElement;
    Element stringGeneratorElement;
    Element numGeneratorElement;

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
        DivElement instructions = new DivElement()..setInnerHtml("A prepack is the basic buildling block of LOSAS, defining the scenes, generators and initializations a character will have. <br><Br>A given Entity can have multiple prepacks, as an example in a SBURB Scenario a character might have the following prepacks: Knight, Mind, Derse, Athletics, Music, GodDestiny, Player, GoldBlood, Lamia.<br><br>A good prepack should be very focused in terms of content.  The Player prepack, as an example, should have only the generic things any player should be able to do (generic side quests, kissing dead players, etc)." )..classes.add("instructions");
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
        handleStringGenerators(formHolder);
        handleNumGenerators(formHolder);

    }
    void handleStringGenerators(Element parent) {
        if(stringGeneratorElement == null) {
            stringGeneratorElement = new Element.div()..classes.add("subholder");
            parent.append(stringGeneratorElement);
        }
        stringGeneratorElement.text = "";
        Element header = HeadingElement.h1()..text = "Associated Generators:";
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
        Element header = HeadingElement.h1()..text = "Associated Generators:";
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
            helper.makeBuilder(stringGeneratorElement);
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

    void renderWords() {
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

    void syncDataStringToPrepack() {
        print("syncing datastring to generator");
        dataStringElement.value = prepack.toDataString();
    }

    void syncPrepackToDataString(e) {
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
        handleStringGenerators(null);
    }
}