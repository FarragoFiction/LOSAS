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



    static void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        prepack = new Prepack("Sample Prepack","Describe what kind of character would have this prepack.","???",[],[],[]);
        DivElement instructions = new DivElement()..setInnerHtml("A prepack is the basic buildling block of LOSAS, defining the scenes, generators and initializations a character will have. <br><Br>A given Entity can have multiple prepacks, as an example in a SBURB Scenario a character might have the following prepacks: Knight, Mind, Derse, Athletics, Music, GodDestiny, Player.<br><br>A good prepack should be very focused in terms of content.  The Player prepack, as an example, should have only the generic things any player should be able to do (generic side quests, kissing dead players, etc)." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${prepack.toDataString()}", (e) => syncDataStringToGenerator(e));
        nameElement = attachInputElement(formHolder, "Name:", "${prepack.name}", (e)
        {
            prepack.name = e.target.value;
            syncDataStringToGen();
        });

    }

    static void syncDataStringToGen() {
        print("syncing datastring to generator");
        dataStringElement.value = prepack.toDataString();
    }

    static void syncDataStringToGenerator(e) {
        print("syncing gen to datastring");
        try {
            prepack.loadFromDataString(e.target.value);
        }catch(e) {
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
    }
}