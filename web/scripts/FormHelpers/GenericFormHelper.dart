import 'dart:html';

import 'package:CommonLib/Utility.dart';

void testForm(Element parent) {
  attachInputElement(parent, "Test1", "Bumble",
      (e) => window.alert("test1 event fired with e of ${e.target.value}"));
  attachInputElement(parent, "Test2", "Bee",
      (e) => window.alert("test2 event fired with e of ${e.target.value}"));
  attachNumberInputElement(parent, "Test3", 13,
      (e) => window.alert("test3 event fired with e of ${e.target.value}"));
  attachCheckInputElement(parent, "Test4", true,
      (e) => window.alert("test4 event fired with e of ${e.target.checked}"));
}

Element attachInputElement(
    Element parent, String label, String value, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final InputElement inputElement = new InputElement()..value = value;
  holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}

Element attachAreaElement(
    Element parent, String label, String value, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final TextAreaElement inputElement = new TextAreaElement()..value = value;
  holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}

Element attachNumberInputElement(
    Element parent, String label, num value, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final NumberInputElement inputElement = new NumberInputElement()
    ..value = "$value";
  holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}

Element attachCheckInputElement(
    Element parent, String label, bool value, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final CheckboxInputElement inputElement = new CheckboxInputElement();
  if (value) {
    inputElement.checked = true;
  }
  holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}
