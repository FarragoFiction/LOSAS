
import 'dart:html';

import '../Entity.dart';
import '../Game.dart';
import 'GenericFormHelper.dart';

class CharBuilder {
    static String fileKey = "${GameUI.dataPngFolder}${Entity.dataPngFile}";
    Entity entity;
    TextAreaElement dataStringElement;
    InputElement nameElement;
    Element dollHolder;
    CheckboxInputElement activeElement;


    CharBuilder([this.entity]) {
        this.entity ??= makeNewEntity();
    }

    static makeNewEntity() {
        return new Entity("Alice",[],"Alice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true..facingRightByDefault=false;
    }

    void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        DivElement instructions = new DivElement()
            ..setInnerHtml(
                "A character is the basic unit of LOSAS. Whether a main character or a side one, they do things in the story and have things done to them.  They have a variety of traits which control their behavior.")
            ..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(
            formHolder, "DataString:", "${entity.toDataString()}", (e) =>
            syncEntityToDataString(e.target.value));
        nameElement =
            attachInputElement(formHolder, "Name:", "${entity.name}", (e) {
                print("name is going to be ${e.target.value}");
                entity.name = e.target.value;
                syncDataStringToEntity();
            });

        activeElement = attachCheckInputElement(formHolder, "Spawns Active", entity.isActive, (e)
        {
            entity.isActive = e.target.checked;
            syncDataStringToEntity();
        });
        handleDolls(formHolder);
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
        CanvasElement canvas = await entity.canvas;
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