
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
    Element prepackHolder;


    CharBuilder([this.entity]) {
        this.entity ??= makeNewEntity();
    }

    static makeNewEntity() {
        return new Entity("Alice",[],13,"Alice%3A___A5G_5sA8JL__4cAf39_cnJyLpYA%3D")..isActive = true;
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



        activeElement = attachCheckInputElement(formHolder, "Spawns Active", entity.isActive, (e)
        {
            entity.isActive = e.target.checked;
            syncDataStringToEntity();
        });
        handleDolls(formHolder);
        handlePrepacks(formHolder);
    }

    void handlePrepacks(Element parent) {
        if(parent !=null) {
            prepackHolder = new DivElement();
            parent.append(prepackHolder);
        }
        prepackHolder.text = "";
        renderPrepacks(prepackHolder);
    }

    void renderPrepacks(Element parent) {
        for(Prepack p in entity.prepacks) {
            DivElement pelement = new DivElement()..classes.add("prepack_pellet")..text = p.name;
            parent.append(pelement);
            ButtonElement remove = new ButtonElement()..text = "x"..classes.add("x")..style.display="inline-block";
            pelement.append(remove);
            remove.onClick.listen((Event e ) {
                entity.prepacks.remove(p);
                entity.init();
                handleDolls(null);
                syncDataStringToEntity();
                handlePrepacks(null);
            });
        }
        DivElement pelement = new DivElement()..classes.add("prepack_pellet")..text = "+"..classes.add("plus");
        parent.append(pelement);
        pelement.onClick.listen((Event e) {
            renderPrepackPicker(parent);
        });
    }

    void renderPrepackPicker(Element parent) {
        Element popup = new DivElement()..classes.add("popup");
        Element header = HeadingElement.h1()..text = "Add prepack to ${entity.name}:";
        popup.append(header);
        parent.append(popup);
        for(Prepack p in entity.scenario.prepacks) {
            print('rendering prepack ${p.name}');
            DivElement sub = new DivElement()..style.display = "inline-block";
            DivElement text = new DivElement()..text = p.name;
            popup.append(sub);

            try {
                CanvasElement element = p.externalForm.canvas
                    ..classes.add("prepack-icon");
                sub.append(element);

            }catch(e) {
                window.alert("some kind of error displaying prepack, are you sure it had an image?");
            }
            sub.append(text);
            sub.onClick.listen((Event e) {
                popup.remove();
                entity.prepacks.add(p);
                entity.init();
                handleDolls(null);
                handlePrepacks(null);
                syncDataStringToEntity();
            });
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
        CanvasElement canvas = await entity.thumbnail;
        nameElement.value = entity.name;
        syncDataStringToEntity();
        dollHolder.append(canvas);
        attachAreaElement(
            dollHolder, "DollString:", "${entity.dollstring}", (e){
                print("going to change doll string to ${e.target.value}");
            entity.setDollStringAndOriginal(e.target.value);
            handleDolls(null);
            syncDataStringToEntity();
        });
    }



    void syncDataStringToEntity() {
        dataStringElement.value = entity.toDataStringWithoutImage();
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
        handlePrepacks(null);

    }

}