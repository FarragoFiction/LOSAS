import 'dart:html';

import 'package:ImageLib/Encoding.dart';
import 'package:LoaderLib/Loader.dart';

import '../Entity.dart';
import '../Prepack.dart';
import '../Scenario.dart';
import 'CharBuilder.dart';
import 'GenericFormHelper.dart';

class GameRunner {
    Element archiveUploaderHolder;
    Scenario scenario;
    int seed = 13;
    Element container;
    Element charHolder;
    Element factsHolder;

    void makeUglyRunner(Element parent) {
        container =parent;
        Element seedElement = attachNumberInputElement(parent, "Seed:", 13, (e)
        {
            seed = num.parse(e.target.value);
            //TODO this should only happen if no custom chars have been added. okay?
            scenario.nukeTheOldSeed(seed);
            displayChars(null);
        });
        handleLoadingScenarioFromImage();

    }

    Future<void> handleLoadingScenarioFromImage() {
        archiveUploaderHolder =new DivElement()..classes.add("instructions");
        container.append(archiveUploaderHolder);
        //by getting the upload this way we can maintain any data already in it (so in theory you could have a char, scenario AND prepack all in the same image
        DivElement instructions = new DivElement()..setInnerHtml("If you have an image with a scenario stored in it, you can load it here." )..style.marginBottom="30px";;
        archiveUploaderHolder.append(instructions);
        Element uploadElement = FileFormat.loadButton(ArchivePng.format, syncScenarioToImage,caption: "Load Scenario From Image");
        archiveUploaderHolder.append(uploadElement);
    }

    Future<void> syncScenarioToImage(ArchivePng png, String fileName) async {
        DivElement processing = new DivElement()..text = "processing";
        archiveUploaderHolder.append(processing);

        processing.remove();
        scenario = Scenario.empty();
        await scenario.loadFromArchive(png);
        scenario.seed = seed;
        archiveUploaderHolder.append(scenario.externalForm.canvas);
        displayFacts(container);
        displayChars(container);
        ButtonElement button = new ButtonElement()..text = "Run Batshit Mode";
        archiveUploaderHolder.append(button);
        button.onClick.listen((Event e) {
            archiveUploaderHolder.remove();
            scenario.curtainsUp(container);
        });
    }

    Future<void> displayFacts(Element parent) async {
        if(factsHolder == null) {
            factsHolder = new Element.div()..classes.add("subholder");
            parent.append(factsHolder);
        }
        factsHolder.text = "";
        Element header = HeadingElement.h1()..text = "${scenario.name} by ${scenario.author}";

        DivElement instructions = new DivElement()..setInnerHtml(scenario.description)..classes.add("instructions");
        factsHolder.append(header);
        factsHolder.append(instructions);
        Element header2 = HeadingElement.h2()..text = "Associated Traits:";
        factsHolder.append(header2);

        scenario.prepacks.forEach((Prepack p)
        {
            print('rendering prepack ${p.name}');
            DivElement sub = new DivElement()..style.display = "inline-block";
            DivElement text = new DivElement()..text = p.name;
            factsHolder.append(sub);

            try {
                CanvasElement element = p.externalForm.canvas
                    ..classes.add("prepack-icon");
                sub.append(element);
            }catch(e) {
                window.alert("some kind of error displaying prepack, are you sure it had an image?");
            }
            sub.append(text);
        });

    }

    //TODO update this any time the seed  changes or a new scenario is uploaded
    Future<void> displayChars(Element parent) async {
        scenario.scenarioRunner.batshitchars();
        if(charHolder == null) {
            charHolder = new Element.div()..classes.add("subholder");
            parent.append(charHolder);
        }
        charHolder.text = "";
        Element header = HeadingElement.h1()..text = "Characters:";

        DivElement instructions = new DivElement()..setInnerHtml("Whether main characters or non, active at the start of the story or only after certain conditions are met, characters are the spotlight of any story. They cause things to happen, have their own goals and collide in beautifully stupid ways. <br><br>Note: Any unnamed characteres will draw from their traits to find a name, failing that, they will draw on their Doll for inspiration.")..classes.add("instructions");
        charHolder.append(header);
        charHolder.append(instructions);

        handleNewCharButton();

        for(Entity char in scenario.entitiesReadOnly) {
            drawOneChar(char, charHolder);
        }

    }

    void handleNewCharButton() {
       DivElement div = new DivElement();
       charHolder.append(div);
      Entity c = CharBuilder.makeNewEntity();
      attachAreaElement(div, "Add Char From DataString:", "${c.toDataString()}", (e)
      {
          try {
              c.loadFromDataString(e.target.value);
          }catch(e) {
              window.console.error(e);
              window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
          }

      });

      ButtonElement button = new ButtonElement()..text = "Add Char";
      div.append(button);
      button.onClick.listen((Event e) {
          scenario.addEntity(c,0);
          displayChars(null);
      });
    }

    Future<void> drawOneChar(Entity char,Element parent) async {
        DivElement ce = new DivElement()..classes.add("char_preview");
        parent.append(ce);
        CharBuilder cb = new CharBuilder(char);
        cb.makeBuilder(ce);
    }

}