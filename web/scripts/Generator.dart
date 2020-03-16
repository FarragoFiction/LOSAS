//there should be an effect to set a string or num to a generated value, that ALSO takes in a backup default value if the entity can't find one.
import 'package:CommonLib/Random.dart';

import 'Entity.dart';

abstract class Generator {

    String key;
    Generator(this.key);
    dynamic generateValue(Random rand);
}

class StringGenerator extends Generator {
    List<String> possibleValues = new List<String>();
    StringGenerator(String key,this.possibleValues, ) : super(key);

  @override
  dynamic generateValue(Random rand) {
    return rand.pickFrom(possibleValues);
  }

}

class NumGenerator extends Generator {
    num max;
    num min;
  NumGenerator(String key,this.min, this.max) : super(key);

  @override
  dynamic generateValue(Random rand) {
    //shitty hack to detect if int even in javascript
    if(min == min.floor() && max == max.floor()) {
        return rand.nextIntRange(min,max);
    }else {
       return rand.nextDoubleRange(min,max);
    }
  }

}