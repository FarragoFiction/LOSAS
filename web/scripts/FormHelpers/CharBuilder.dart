
import 'dart:html';

import '../Entity.dart';
import '../Game.dart';
import '../Prepack.dart';
import '../Scenario.dart';
import 'GenericFormHelper.dart';

class CharBuilder {
    static String fileKey = "${GameUI.dataPngFolder}${Entity.dataPngFile}";
    Entity entity;
    //slurp these from any scenarios uploaded
    List<Prepack> prepacks = <Prepack>[];
    TextAreaElement dataStringElement;
    InputElement nameElement;
    Element dollHolder;
    CheckboxInputElement activeElement;
    Element scenarioElement;


    CharBuilder([this.entity]) {
        this.entity ??= makeNewEntity();
    }

    static makeNewEntity() {
        return new Entity("Alice",[],"Alice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true..facingRightByDefault=false;
    }

    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("charBuilder");
        parent.append(formHolder);
        dataStringElement = attachAreaElement(
            formHolder, "DataString:", "${entity.toDataString()}", (e) =>
            syncEntityToDataString(e.target.value));
        nameElement =
            attachInputElement(formHolder, "Name*: ", "${entity.name}", (e) {
                entity.name = e.target.value;
                entity.setInitStringMemory(Entity.NAMEKEY, entity.name);
                syncDataStringToEntity();
            });
        final DivElement note = new DivElement()..text = "* Note: Default name is the name for the current doll, may change if prepacks override this. ";
            formHolder.append(note);


        activeElement = attachCheckInputElement(formHolder, "Spawns Active", entity.isActive, (e)
        {
            entity.isActive = e.target.checked;
            syncDataStringToEntity();
        });
        handleDolls(formHolder);
        handlePrepacks(formHolder);
    }

    void handlePrepacks(Element parent) {
        //TODO allow this to have a button to add a new prepack from a drop down based on all prepacks available in entities scenario
        renderPrepacks(parent);
    }

    void renderPrepacks(Element parent) {
        for(Prepack p in entity.prepacks) {
            DivElement pelement = new DivElement()..classes.add("prepack_pellet")..text = p.name;
            parent.append(pelement);
        }
    }


    void handleDolls(Element parent) {
        if(dollHolder == null) {
            dollHolder = new Element.div()
                ..classes.add("subholder");
            parent.append(dollHolder);
        }
        dollHolder.text = "";
        displayDoll();


    }

    void displayDoll() async{
        print("cached canvas is ${entity.cachedCanvas}");
        CanvasElement canvas = await entity.thumbnail;
        dollHolder.append(canvas);
        attachAreaElement(
            dollHolder, "DollString:", "${entity.dollstring}", (e){
                print("going to change doll string to ${e.target.value}");
            entity.setDollString(e.target.value);
            handleDolls(null);
            syncDataStringToEntity();
        });
    }



    void syncDataStringToEntity() {
        dataStringElement.value = entity.toDataString();
        print("value is ${dataStringElement.value}");
    }

    void syncEntityToDataString(String dataString) async {
        print("syncing entity to datastring");
        try {
            await entity.loadFromDataString(dataString);
        }catch(e) {
            window.console.error(e);
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this. $e");
        }
        nameElement.value = entity.name;
        activeElement.checked = entity.isActive;
        handleDolls(null);

    }

}