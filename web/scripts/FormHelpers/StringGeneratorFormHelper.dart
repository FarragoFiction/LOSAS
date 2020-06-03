import 'dart:html';
import 'package:CommonLib/Utility.dart';
import 'package:LoaderLib/Loader.dart';

import '../Generator.dart';
import '../Scene.dart';
import 'GenericFormHelper.dart';

class StringGeneratorFormHelper {

     TextAreaElement dataStringElement;
     InputElement keyElement;
     StringGenerator generator;
     Element wordsElement;
     InputElement addWordElement;
     Action callback;
     String imageListSource = "http://farragofiction.com/LOSASE/images/BGs/list.php";
     String musicListSource = "http://farragofiction.com/LOSASE/Music/list.php";
     SelectElement bgElement;
     ImageElement bgPreviewElement;
     SelectElement bgMusicElement;
     AudioElement bgMusicPreviewElement;

     StringGeneratorFormHelper([StringGenerator  this.generator]) {
             generator ??= makeTestGenerator();
     }

     static StringGenerator makeTestGenerator() {
         return new StringGenerator("sampleKey",["hello","world"]);
     }


     void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()..setInnerHtml("A string generator is how an individual entity handles random words or phrases. <br><br>Example include varying reactions to situations, generating consorts for a given land, or generating the name of a beloved pet. <br><br>You can also choose to add the location of bg music or images. This can be used to overwrite a scenes normal bg music or image with a character/situation appropriate one.<br><br>NOTE: Scripting tags such as a scene target's name are valid here." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${generator.toDataString()}", (e) => syncDataStringToGenerator(e));
        keyElement = attachInputElement(formHolder, "Key:", "${generator.key}", (e)
        {
            generator.key = e.target.value;
            syncDataStringToGen();
        });

        handleWords(formHolder);

    }

     void handleWords(Element parent) {
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
        setupBGS(wordsElement);
        setupBGMusics(wordsElement);


    }

     void renderWords() {
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

     void setupBGS(Element parent) async {
         DivElement holder = new DivElement()..classes.add("subholder");
         parent.append(holder);
         List<String> options = new List<String>();
         Map<String,dynamic> results = await Loader.getResource(imageListSource,format: Formats.json );
         for(String folder in results["folders"].keys) {
             for(String file in results["folders"][folder]["files"]) {
                 if (file.contains("png")) options.add("$folder/$file");
             }
         }
         String selected = options.first;
         bgPreviewElement = new ImageElement()..style.width="620px";
         bgPreviewElement.src = "${Scene.bgLocationFront}$selected";
         holder.append(bgPreviewElement);
         bgElement = attachDropDownElement(holder, "BG Image Value:", options, selected,  null);
         ButtonElement button = new ButtonElement()..text = "Add";
         holder.append(button);

         button.onClick.listen((Event e) {
             generator.possibleValues.add( bgElement.value);
             syncDataStringToGen();
             handleWords(null);
         });
     }

     void setupBGMusics(Element parent) async {
         DivElement holder = new DivElement()..classes.add("subholder");
         parent.append(holder);

         List<String> options = new List<String>();
         Map<String,dynamic> results = await Loader.getResource(musicListSource,format: Formats.json );
         for(String folder in results["folders"].keys) {
             print("checking folder $folder");
             for(String file in results["folders"][folder]["files"]) {
                 if (file.contains("ogg")) options.add("$folder/$file");
             }
         }
         String selected =options.first;
         bgMusicPreviewElement = new AudioElement()..loop=true..controls=true..autoplay=false;



         bgMusicPreviewElement.src = "${Scene.musicLocationFront}$selected";
         holder.append(bgMusicPreviewElement);
         bgMusicElement = attachDropDownElement(holder, "BG Music Value:", options, selected, null);

         ButtonElement button = new ButtonElement()..text = "Add";
         holder.append(button);

         button.onClick.listen((Event e) {
             generator.possibleValues.add( bgMusicElement.value);
             syncDataStringToGen();
             handleWords(null);
         });
     }



     void syncDataStringToGen() {
        print("syncing datastring to generator");
        dataStringElement.value = generator.toDataString();
        if(callback !=null) callback();
    }

     void syncDataStringToGenerator(e) {
        print("syncing gen to datastring");
        try {
            generator.loadFromDataString(e.target.value);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        keyElement.value = generator.key;
        handleWords(null);
        if(callback !=null) callback();

    }

}