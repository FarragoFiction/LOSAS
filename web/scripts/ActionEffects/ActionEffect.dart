import 'package:CommonLib/Random.dart';

import '../Entity.dart';
import '../Scene.dart';
import 'AEAddNum.dart';
import 'AEAddNumFromMyMemory.dart';
import 'AEAddNumFromYourMemory.dart';
import 'AEAppendString.dart';
import 'AEAppendStringFront.dart';
import 'AECopyNumFromTarget.dart';
import 'AECopyNumToTarget.dart';
import 'AECopyStringFromTarget.dart';
import 'AECopyStringToTarget.dart';
import 'AESetDollStringFromMyMemory.dart';
import 'AESetDollStringFromYourMemory.dart';
import 'AESetNum.dart';
import 'AESetNumGenerator.dart';
import 'AESetString.dart';
import 'AESetStringGenerator.dart';
import 'AEUnAppendString.dart';
import 'AEUnSetString.dart';

/*
    TODO Pile:
     add serialied scene
     forget memory key at random
 */
abstract class ActionEffect {
    //are we applying this to my targets, or to myself?
    bool vriska = false;
    //each subclass MUST implement this
    String type;
    String explanation;
    Map<String,String> importantWords = new Map<String,String>();
    Map<String, num> importantNumbers = new Map<String,num>();
    //useful for generating forms and serialization
    static List<ActionEffect> exampleOfAllEffects;


    ActionEffect(this.importantWords, this.importantNumbers);
    ActionEffect makeNewOfSameType();

    static ActionEffect fromSerialization(Map<String,dynamic> serialization){
        //first, figure out what sub type it is
        //then call that ones
        setExamples();
        String type = serialization["type"];
        for(ActionEffect effect in exampleOfAllEffects) {
            if(effect.type == type) {
                ActionEffect newEffect =  effect.makeNewOfSameType();
                newEffect.importantWords = serialization["importantWords"];
                newEffect.importantNumbers = serialization["importantNumbers"];
                return newEffect;
            }
        }
        throw "What kind of effect is ${type}";

    }

    static void setExamples() {
      exampleOfAllEffects ??= <ActionEffect>[new AEUnSetString(null),new AEUnAppendString(null,null),new AESetStringGenerator(null,null),new AESetString(null,null),new AESetNumGenerator(null,null),new AESetNum(null,null),new AESetDollStringFromYourMemory(null),new AESetDollStringFromMyMemory(null),new AECopyStringToTarget(null,null),new AECopyStringFromTarget(null,null),new AECopyNumToTarget(null,null),new AECopyNumFromTarget(null,null),new AEAppendStringFront(null,null),new AEAppendString(null,null),new AEAddNum(null,null), new AEAddNumFromYourMemory(null,null),new AEAddNumFromMyMemory(null,null)];
    }

    void effectEntities(Entity effector, List<Entity> entities);

    Map<String,dynamic> getSerialization() {
        Map<String,dynamic> ret = new Map<String,dynamic>();
        ret["type"] = type;
        ret["importantWords"] = importantWords;
        ret["importantNumbers"] = importantNumbers;
        ret["vriska"] = vriska;
        return ret;
    }


    String debugString() {
        return "Effect: ${runtimeType} $importantWords, $importantNumbers , Vriska: $vriska";
    }


    void applyEffect(Scene scene) {
        List<Entity> targets;
        if(vriska) {
            targets = new List<Entity>();
            targets.add(scene.owner);
        }else {
            targets = new List.from(scene.finalTargets);
        }
        effectEntities(scene.owner,targets);
    }

}