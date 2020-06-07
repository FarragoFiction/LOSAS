import 'dart:html';
import 'package:CommonLib/Utility.dart';

import '../Generator.dart';
import 'GenericFormHelper.dart';

class NumGeneratorFormHelper {

    TextAreaElement dataStringElement;
    InputElement keyElement;
    NumGenerator generator;
    InputElement minElement;
    InputElement maxElement;
    Action callback;

    NumGeneratorFormHelper([this.generator]) {
        generator ??= makeTestGenerator();
    }

    static NumGenerator makeTestGenerator() {
        return new NumGenerator("sampleKey",-13,13);
    }


    void makeBuilder(Element parent,Lambda<NumGenerator> remove) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
        if(remove != null) {
            ButtonElement button = new ButtonElement()..classes.add("x")..text = "X";
            button.onClick.listen((Event e) => remove(generator));
            formHolder.append(button);
        }
        DivElement instructions = new DivElement()..setInnerHtml("A number generator is how an individual entity handles random numbers. <br><br>Example uses include 'generate a random number between 0 and 1 for the key 'chanceSuccess' or 'generate a random number between  and 13 for 'attack'.  <br><br>Since each entity has their own generators for a value they can produce very different behavior. A high strength character might generate an attack between 10 and 30, while a low strength might generate one between 1 and 3. <br><br>An entity can have multiple generators for the same value, in which case all have an equal chance of being used to generate a value.<br><br>Note: Numbers default to whole integers unless a decimal is included in the min/max." )..classes.add("instructions");
        formHolder.append(instructions);
        dataStringElement = attachAreaElement(formHolder, "DataString:", "${generator.toDataString()}", (e) => syncDataStringToGenerator(e));
        keyElement = attachInputElement(formHolder, "Key:", "${generator.key}", (e)
        {
            generator.key = e.target.value;
            syncDataStringToGen();
        });

        minElement = attachNumberInputElement(formHolder, "Min:", generator.min, (e)
        {
            generator.min = num.parse(e.target.value);
            syncDataStringToGen();
        });

        maxElement = attachNumberInputElement(formHolder, "Max:", generator.max, (e)
        {
            generator.max = num.parse(e.target.value);
            syncDataStringToGen();
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
            window.alert("Look. Don't waste this. Either copy and paste in a valid datastring, or don't touch this.");
        }
        keyElement.value = generator.key;
        minElement.value = "${generator.min}";
        maxElement.value = "${generator.max}";
        if(callback !=null) callback();


    }

}