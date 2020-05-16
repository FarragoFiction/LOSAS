import 'dart:html';
import '../Generator.dart';
import 'GenericFormHelper.dart';

abstract class StringGeneratorFormHelper {

    static TextAreaElement dataStringElement;
    static InputElement keyElement;
    static StringGenerator generator;
    static Element wordsElement;
    static InputElement addWordElement;


    static void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        generator = new StringGenerator("sampleKey",["hello","world"]);
        DivElement instructions = new DivElement()..setInnerHtml("A string generator is how an individual entity handles random words or phrases. <br><br>Example include varying reactions to situations, generating consorts for a given land, or generating the name of a beloved pet.<br><br>NOTE: Scripting tags such as a scene target's name are valid here." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${generator.toDataString()}", (e) => syncDataStringToGenerator(e));
        keyElement = attachInputElement(formHolder, "Key:", "${generator.key}", (e)
        {
            generator.key = e.target.value;
            syncDataStringToGen();
        });

        handleWords(formHolder);
    }

    static void handleWords(Element parent) {
        if(wordsElement == null) {
            wordsElement = new Element.div()..classes.add("subholder");
            parent.append(wordsElement);
        }
        wordsElement.text = "";
        Element header = HeadingElement.h1()..text = "Possible Word/Phrases:";
        wordsElement.append(header);
        renderWords();

        ButtonElement button = new ButtonElement()..text = "Add";

        TextAreaElement input = attachAreaElement(wordsElement, "Add Word/Phrase:", "", (e)
        {
            button.text = "Add ${e.target.value}";

        });
        wireUpScripting(input, wordsElement);

        button.onClick.listen((Event e) {
            generator.possibleValues.add( input.value);
            syncDataStringToGen();
            handleWords(null);
        });
        wordsElement.append(button);


    }

    static void renderWords() {
        DivElement container = new DivElement();
        wordsElement.append(container);
        for(String word in generator.possibleValues) {
            DivElement holder = new DivElement()..style.padding="3px"..style.display="inline-block";
            container.append(holder);
            DivElement wordElement = new DivElement()..text = word..style.display="inline-block";
            holder.append(wordElement);
            ButtonElement remove = new ButtonElement()..text = "x"..classes.add("x");
            holder.append(remove);
            remove.onClick.listen((Event e ) {
                generator.possibleValues.remove(word);
                syncDataStringToGen();
                handleWords(null);
            });
        }
    }

    static void syncDataStringToGen() {
        print("syncing datastring to generator");
        dataStringElement.value = generator.toDataString();
    }

    static void syncDataStringToGenerator(e) {
        print("syncing gen to datastring");
        try {
            generator.loadFromDataString(e.target.value);
        }catch(e) {
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        keyElement.value = generator.key;
        handleWords(null);

    }

}