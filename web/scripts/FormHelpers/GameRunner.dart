import 'dart:html';

import 'package:ImageLib/Encoding.dart';
import 'package:LoaderLib/Loader.dart';

import '../Scenario.dart';
import 'GenericFormHelper.dart';

class GameRunner {
    Element archiveUploaderHolder;
    Scenario scenario;
    int seed = 13;
    Element container;

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
        ButtonElement button = new ButtonElement()..text = "Run Batshit Mode";
        archiveUploaderHolder.append(button);
        button.onClick.listen((Event e) {
            archiveUploaderHolder.remove();
            scenario.curtainsUp(container);
        });
    }

}