import 'dart:html';
import 'GenericFormHelper.dart';

abstract class NumGeneratorFormHelper {

    static void makeBuilder(Element parent) async {
        DivElement formHolder = new DivElement()
            ..classes.add("formHolder");
        parent.append(formHolder);
    }

}