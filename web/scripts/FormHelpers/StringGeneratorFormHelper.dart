import 'dart:html';
import 'GenericFormHelper.dart';

abstract class StringGeneratorFormHelper {

    static void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
    }

}