import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../Scene.dart';

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
 void wireUpScripting(TextAreaElement target, Element parent) {
    SelectElement dropdown = attachDropDownElement(parent,"",[Scene.TARGETSTRINGMEMORYTAG,Scene.TARGETNUMMEMORYTAG,Scene.OWNERSTRINGMEMORYTAG,Scene.OWNERNUMMEMORYTAG],Scene.TARGETSTRINGMEMORYTAG,null);
    TextInputElement text = attachInputElement(parent,null,"variableName",null);
    text.parent.style.display = "inline-block";
    dropdown.parent.style.display = "inline-block";
    ButtonElement button = new ButtonElement()..text = "Insert ScriptTag"..style.display = "inline-block";
    parent.append(button);
    button.onClick.listen((Event e) {
      target.value = "${target.value} ${dropdown.options[dropdown.selectedIndex].value}${text.value}]";
      target.dispatchEvent(new Event("input"));
    });
}

Element attachInputElement(
    Element parent, String label, String value, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final InputElement inputElement = new InputElement()..value = value;
  if(label != null) holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  if(callback!=null)inputElement.onInput.listen((Event e) => callback(e));
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
  if(callback!=null) inputElement.onInput.listen((Event e) => callback(e));
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
  if(callback!=null) inputElement.onInput.listen((Event e) => callback(e));
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
  if(callback!=null) inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}

Element attachDropDownElement(
    Element parent, String label, List<String> values, String selected, Lambda callback) {
  DivElement holder = new DivElement()..classes.add("formElement");
  final LabelElement labelElement = new LabelElement()..text = label;
  final SelectElement inputElement = new SelectElement();

  for(String s in values) {
    if(s == selected) {
      OptionElement option = new OptionElement()..value = s..text = s..selected=true;
      inputElement.append(option);
    }else {
      OptionElement option = new OptionElement()..value = s..text = s..selected=false;
      inputElement.append(option);
    }
  }

  holder.append(labelElement);
  holder.append(inputElement);
  parent.append(holder);
  if(callback!=null) inputElement.onInput.listen((Event e) => callback(e));
  return inputElement;
}