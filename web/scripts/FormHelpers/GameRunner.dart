import 'dart:html';

import 'package:ImageLib/Encoding.dart';
import 'package:LoaderLib/Loader.dart';

import '../Entity.dart';
import '../Prepack.dart';
import '../Scenario.dart';
import 'GenericFormHelper.dart';

class GameRunner {
    Element archiveUploaderHolder;
    Scenario scenario;
    int seed = 13;
    Element container;
    Element charHolder;

    void makeUglyRunner(Element parent) {
        container =parent;
        Element seedElement = attachNumberInputElement(parent, "Seed:", 13, (e)
        {
            seed = num.parse(e.target.value);
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
        displayChars(container);
        ButtonElement button = new ButtonElement()..text = "Run Batshit Mode";
        archiveUploaderHolder.append(button);
        button.onClick.listen((Event e) {
            archiveUploaderHolder.remove();
            scenario.curtainsUp(container);
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
        for(Entity char in scenario.entitiesReadOnly) {
            drawOneChar(char, charHolder);
        }

    }

    Future<void> drawOneChar(Entity char,Element parent) async {
        DivElement ce = new DivElement()..classes.add("char_preview");
        parent.append(ce);
        CanvasElement canvas = await char.canvas;
        ce.append(canvas);
        DivElement name = new DivElement()..text = char.name..classes.add("char_name");
        ce.append(name);

        for(Prepack p in char.prepacks) {
            DivElement pelement = new DivElement()..classes.add("prepack_pellet")..text = p.name;
            ce.append(pelement);
        }
    }

}