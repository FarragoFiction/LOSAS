
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
                "Scenarios are everything needed to tell a given story. It contains both stand alone scenes meant to be the start/end of the story, as well as the various prepacks that will be used to build entities within it. <br><br>Ideally, the prepacks should be designed for a specific scenario and all reference the same memory keys.<br><br>An example of a scenario is SBURB, which contains various prepacks to let you assigned class, aspect, moon, interests and species to entities. <br><br>Another example is Hogwartz, which might assign one of the four Houses, Student, Teacher and Villain status to entities.")
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