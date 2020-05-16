//there should be an effect to set a string or num to a generated value, that ALSO takes in a backup default value if the entity can't find one.
import 'package:CommonLib/Random.dart';

import 'DataStringHelper.dart';
import 'Entity.dart';

abstract class Generator {

    String key;

    Generator(this.key);
    dynamic generateValue(Random rand);
    String values();
    Map<String,dynamic> getSerialization();
    void loadFromSerialization(Map<String,dynamic> serialization);

    void loadFromDataString(String dataString) {
        loadFromSerialization(DataStringHelper.serializationFromDataString(dataString));
    }
    String toDataString() {
        return DataStringHelper.serializationToDataString(key,getSerialization());
    }

    static Generator fromDataString(String dataString) {
        return fromSerialization(DataStringHelper.serializationFromDataString(dataString));
    }

    static Generator fromSerialization(Map<String,dynamic> serialization) {
        final String type = serialization["type"];
        if(type == StringGenerator.TYPE) {
            return new StringGenerator(null,null)..loadFromSerialization(serialization);
        }else if(type == NumGenerator.TYPE) {
            return new NumGenerator(null,null,null)..loadFromSerialization(serialization);
        }else {
            print("ERROR: UNKNOWN TYPE");
            return null;
        }
    }

}

class StringGenerator extends Generator {
    static final String TYPE = "STRING";
    List<String> possibleValues = new List<String>();
    StringGenerator(String key,this.possibleValues, ) : super(key);

  @override
  dynamic generateValue(Random rand) {
    return rand.pickFrom(possibleValues);
  }

  @override
  String values() {
    return "<li>${possibleValues.join("<li>")}";
  }

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["key"] = key;
      ret["type"] = TYPE;
      ret["possibleValues"] = possibleValues;
    return ret;
  }



  @override
  void loadFromSerialization(Map<String, dynamic> serialization) {
    key = serialization["key"];
    possibleValues = new List<String>.from(serialization["possibleValues"]);
  }

}

class NumGenerator extends Generator {
    static final String TYPE = "NUM";
    num max;
    num min;
  NumGenerator(String key,this.min, this.max) : super(key);

  @override
  dynamic generateValue(Random rand) {
    //shitty hack to detect if int even in javascript
    if(min == min.floor() && max == max.floor()) {
        return rand.nextIntRange(min,max);
    }else {
       return (rand.nextDoubleRange(min,max)*100).round()/100.0;
    }
  }

  @override
  String values() {
    return "<li>[$min, $max]";
  }

  @override
  Map<String, dynamic> getSerialization() {
      Map<String,dynamic> ret = new Map<String,dynamic>();
      ret["key"] = key;
      ret["type"] = TYPE;
      ret["min"] = min;
      ret["max"] = max;
      return ret;
  }



  @override
  void loadFromSerialization(Map<String, dynamic> serialization) {
      key = serialization["key"];
      min = serialization["min"];
      max = serialization["max"];

  }

}