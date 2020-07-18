import 'dart:convert';

import '../Entity.dart';
import '../Scene.dart';
import '../SentientObject.dart';
import 'KeepIfHasSceneThatSerializesToValue.dart';
import 'KeepIfNameIsValue.dart';
import 'KeepIfNumExists.dart';
import 'KeepIfNumIsGreaterThanValue.dart';
import 'KeepIfNumIsGreaterThanValueFromMemory.dart';
import 'KeepIfNumIsValue.dart';
import 'KeepIfRandomNumberLessThan.dart';
import 'KeepIfStringContainsValue.dart';
import 'KeepIfStringExists.dart';
import 'KeepIfStringIsValue.dart';
import 'KeepIfYouAreMe.dart';
/*
    TODOPILE:
    random value (how did sburbsim do this)
    has scene that serializes to X
 */
abstract class TargetFilter {
    List<String> get knownKeys => [];

    //should I invert my value?
    bool not = false;
    //should I apply my condition to myself, rather than my targets? (i.e. if I meet the condition I allow all targets to pass through to the next condition).
    bool vriska = false;
    //is this filter actually meant to check the scenario instead of targets?
    bool scenario = false;
    bool conditionForKeep(SentientObject actor, SentientObject possibleTarget);
    Map<String,String> importantWords = new Map<String,String>();
    Map<String, num> importantNumbers = new Map<String,num>();
    //each subclass MUST implement this
    String type;
    String explanation;
    //useful for generating forms and serialization
    static List<TargetFilter> exampleOfAllFilters;

    TargetFilter(this.importantWords, this.importantNumbers);
    TargetFilter makeNewOfSameType();
    String debugString() {
        return "Filter: ${runtimeType} $importantWords, $importantNumbers, Vriska: $vriska Not: $not";
    }

    Map<String,dynamic> getSerialization() {
        Map<String,dynamic> ret = new Map<String,dynamic>();
        ret["type"] = type;
        ret["vriska"] = vriska;
        ret["scenario"] = scenario;
        ret["not"] = not;
        ret["importantWords"] = importantWords;
        ret["importantNumbers"] = importantNumbers;
        return ret;
    }

    static TargetFilter makeNewFromString(String type){
        //first, figure out what sub type it is
        //then call that ones
        setExamples();
        for(TargetFilter filter in exampleOfAllFilters) {
            if(filter.type == type) {
                TargetFilter newFilter =  filter.makeNewOfSameType();
                return newFilter;
            }
        }
        throw "What kind of filter is ${type}";

    }

    static TargetFilter fromSerialization(Map<String,dynamic> serialization){
        //first, figure out what sub type it is
        //then call that ones
        setExamples();
        String type = serialization["type"];
        for(TargetFilter filter in exampleOfAllFilters) {
            if(filter.type == type) {
                TargetFilter newFilter =  filter.makeNewOfSameType();
                newFilter.importantWords = new Map<String,String>.from(serialization["importantWords"]);
                newFilter.importantNumbers = new Map<String,num>.from(serialization["importantNumbers"]);
                newFilter.vriska = serialization["vriska"];
                newFilter.scenario = serialization.containsKey("scenario")? serialization["scenario"] : false;

                newFilter.not = serialization["not"];
                return newFilter;
            }
        }
        throw "What kind of filter is ${type}";

    }

    static void setExamples() {
        exampleOfAllFilters ??= <TargetFilter>[new KeepIfYouAreMe(), new KeepIfHasSceneThatSerializesToValue(null), new KeepIfStringIsValue(null,null), new KeepIfStringExists(null),new KeepIfStringContainsValue(null,null),new KeepIfRandomNumberLessThan(null),new KeepIfNumIsValue(null,null),new KeepIfNumIsGreaterThanValueFromMemory(null,null),new KeepIfNumIsGreaterThanValue(null,null), new KeepIfNumExists(null),new KeepIfNameIsValue(null)];
    }


    List<SentientObject> filter(Scene scene, List<SentientObject> readOnlyEntities) {
        List<SentientObject> entities = new List<SentientObject>.from(readOnlyEntities);
        print("checking if ${scene.name} should activate, entities is $entities");
        if(not) {
            if(vriska) {
                //reject all if my condition isn't met
                if(conditionForKeep(scene.owner,scene.owner)) entities.clear();
            }else if(scenario) {
                if(conditionForKeep(scene.owner,scene.scenario)) entities.clear();
            }else {
                entities.removeWhere((SentientObject item) => conditionForKeep(scene.owner,item));
            }

        }else {
            if(vriska) {
                //reject all if my condition is met
                if(!conditionForKeep(scene.owner,scene.owner)) entities.clear();
            }else if(scenario) {
                if(!conditionForKeep(scene.owner,scene.scenario)) entities.clear();

            }else {
                entities.removeWhere((SentientObject item) => !conditionForKeep(scene.owner,item));
            }
        }
        return entities;
    }

}