/*
    A scene form has the various scene information, as well as 0 or more triggers and actions (like sburbsim) which are nested forms.
    triggers and action subforms render themselves from their hashes.
 */
import 'dart:html';

import 'package:CommonLib/Utility.dart';

abstract class SceneFormHelper {

    //actually lets test something weird
    static void testForm(Element parent) {
        attachInputElement(parent, "Test1", "Bumble", (e) => window.alert("test1 event fired with e of ${e.target.value}"));
        attachInputElement(parent, "Test2", "Bee", (e) => window.alert("test2 event fired with e of ${e.target.value}"));
        attachNumberInputElement(parent, "Test3", 13, (e) => window.alert("test3 event fired with e of ${e.target.value}"));
        attachCheckInputElement(parent, "Test4", true, (e) => window.alert("test4 event fired with e of ${e.target.checked}"));

    }

    static void attachInputElement(Element parent, String label, String value, Lambda callback) {
        DivElement ret = new DivElement()..classes.add("formElement");
        final LabelElement labelElement = new LabelElement()..text = label;
        final InputElement inputElement = new InputElement()..value = value;
        ret.append(labelElement);
        ret.append(inputElement);
        parent.append(ret);
        inputElement.onInput.listen((Event e) => callback(e));
    }

    static void attachNumberInputElement(Element parent, String label, num value, Lambda callback) {
        DivElement ret = new DivElement()..classes.add("formElement");
        final LabelElement labelElement = new LabelElement()..text = label;
        final NumberInputElement inputElement = new NumberInputElement()..value = "$value";
        ret.append(labelElement);
        ret.append(inputElement);
        parent.append(ret);
        inputElement.onInput.listen((Event e) => callback(e));
    }

    static void attachCheckInputElement(Element parent, String label, bool value, Lambda callback) {
        DivElement ret = new DivElement()..classes.add("formElement");
        final LabelElement labelElement = new LabelElement()..text = label;
        final CheckboxInputElement inputElement = new CheckboxInputElement();
        if(value) {
            inputElement.checked = true;
        }
        ret.append(labelElement);
        ret.append(inputElement);
        parent.append(ret);
        inputElement.onInput.listen((Event e) => callback(e));
    }
}