
import 'dart:html';

import '../Scenario.dart';
import 'GenericFormHelper.dart';

class ScenarioFormHelper {

    TextAreaElement dataStringElement;
    Scenario scenario;
    InputElement nameElement;
    InputElement authorElement;
    TextAreaElement descElement;

    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()
            ..setInnerHtml(
                "A prepack (prepackaged set) is the basic buildling block of LOSAS, defining the scenes, generators and initializations a character will have. A prepack will be known as a 'Trait' to the regular Observers to protect their delicate sanity. <br><Br>A given Entity can have multiple prepacks, as an example in a SBURB Scenario a character might have the following prepacks: Knight, Mind, Derse, Athletics, Music, GodDestiny, Player, GoldBlood, Lamia.<br><br>A good prepack should be very focused in terms of content.  The Player prepack, as an example, should have only the generic things any player should be able to do (generic side quests, kissing dead players, etc).<Br><br>Note: You can either create generators and scenes in the stand alone builders and load them here by datastring, or you can create them inline here.")
            ..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(
            formHolder, "DataString:", "${scenario.toDataString()}", (e) =>
            syncScenarioToDataString(e.target.value));
    }



    void syncDataStringToScenario() {
        dataStringElement.value = scenario.toDataString();
    }

    void syncScenarioToDataString(String dataString) {
        print("syncing gen to datastring");
        scenario.loadFromDataString(dataString);

        try {
            scenario.loadFromDataString(dataString);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        authorElement.value = scenario.author;
        nameElement.value = scenario.name;
        descElement.value = scenario.description;
    }

}