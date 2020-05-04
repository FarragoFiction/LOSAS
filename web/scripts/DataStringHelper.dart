import 'dart:convert';

import 'dart:html';

import 'package:CommonLib/Compression.dart';

abstract class DataStringHelper {
    static String labelPattern = ":___ ";

    static String serializationToDataString(String label, Map<String,dynamic> serialization) {
        print("attempting to serialize $label that is $serialization");
        //first turn serialization into json
        String json = jsonEncode(serialization);
        try {
            return "${label.replaceAll(',','')}$labelPattern${LZString.compressToEncodedURIComponent(json)}";
        }catch(e) {
            print(e);
            window.alert("Error Saving Data. Are there any special characters in there? $json} $e");
        }
    }

    static Map<String,dynamic> serializationFromDataString(String dataString) {
        List<String> parts = dataString.split("$labelPattern");
        //print("parts are $parts");
        if(parts.length > 1) {
            dataString = parts[1];
        }
        String rawJSON = LZString.decompressFromEncodedURIComponent(dataString);
        return jsonDecode(rawJSON);
    }
}