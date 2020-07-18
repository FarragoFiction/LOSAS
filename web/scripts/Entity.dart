/*
    TODO entities have string and int memory
    they have scenes and introscenes
    they have generators
    they have a dollstring and an originalDollString

 */
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

import 'DataObject.dart';
import 'Generator.dart';
import 'Prepack.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'SentientObject.dart';

class Entity extends SentientObject {
    static const String CURRENTDOLLKEY = "currentDollStringChangingDoesNothing";
    static const String ORIGINALDOLLKEY = "originalDollString";
    static const String ORIGINALNAMEKEY = "originalName";
    static const String SPECIESKEY = "species";
    static String dataPngFile = "entity.txt";


    //TODO most chars will be generated randomly but if someone wants to say "i made this" sure why not
    String author;
    @override
    String name;
    int initial_seed = 13;
    //todo load this from doll type
    static bool defaultFaceRight =true;
    bool get facingRightByDefault => _doll != null? _doll.facesRight : defaultFaceRight;
    int maxCanvasWidth  =400;
    List<Prepack> prepacks;

    Doll _doll;
    //used whefther doll or not
    CanvasElement cachedCanvas;
    CanvasElement cachedThumbnail;
    Scenario scenario;
    Random rand;


    //a generator will create a value for a given key and store it in either string memory or num memory based on what it is.
    Map<String, List<Generator>> _generators = new Map<String, List<Generator>>();
    Map<String, List<Generator>> get readOnlyGenerators => new Map<String, List<Generator>>.from(_generators);
    bool isActive = false;

    //before activation, these will be checked each tick, will activate once fired, you don't need to do this explicitly
    List<Scene> _activationScenes = new List<Scene>();

    List<Scene> get readOnlyActivationScenes => new List<Scene>.from(_activationScenes);

    Entity(this.name, this.prepacks, this.initial_seed, optionalDollString) {
        setStringMemory(SentientObject.NAMEKEY,this.name);
        rand = new Random(initial_seed);
        setStringMemory(ORIGINALNAMEKEY,this.name);
        if(optionalDollString != null) {
            setDollStringAndOriginal(optionalDollString);
        }
    }

    Entity.empty(this.initial_seed){
        rand = new Random(initial_seed);
    }


    Entity.fromDataString(String dataString){
        loadFromDataString(dataString);
    }

    Entity.fromSerialization(Map<String, dynamic> serialization){
        loadFromSerialization(serialization);
    }

    @override
    void clear() {
        super.clear();
        rand = new Random(initial_seed);
        cachedCanvas = null;
        cachedThumbnail = null;
        _activationScenes.clear();
        _doll = new PigeonDoll()..rand=rand..randomize();
    }

    void init() {
        clear();
        processPrepacks();
        overRideOtherMemory();
        if(name == null) {
            setStringMemory(SentientObject.NAMEKEY, _doll.dollName);
        }
    }

    void processPrepacks() {
        List<int> possibleDollTypes = <int>[];
        for(Prepack p in prepacks) {
            if(p.suggestedDollType != null) possibleDollTypes.add(p.suggestedDollType);
            processSinglePrepack(p);
        }

        if(possibleDollTypes.isNotEmpty) {
            randomDollOfType(rand.pickFrom(possibleDollTypes));
        }

    }

    //mostly used as an action effect, if you want someone to, say, no longer count as a magical girl this is your function
    void unprocessSinglePrepack(Prepack p) {
        for(Generator g in p.generators) {
            removeGenerator(g);
        }

        for(Scene s in p.scenes) {
            removeScene(s);
        }

        for(Scene s in p.activation_scenes) {
            removeActivationScene(s);
        }
    }

    void processSinglePrepack(Prepack p) {
      for(Generator g in p.generators) {
          addGenerator(g);
          if(p.initialKeysToGenerate.contains(g.key)){
              //let god sort it out. if somehow you have both string and num generators keyed to the same value just...figure it out.
              if(g is StringGenerator){
                  generateStringValueForKey(rand, g.key, "null");
              }else if(g is NumGenerator) {
                  generateNumValueForKey(rand, g.key, 0);
              }
          }
      }
      for(Scene s in p.scenes) {
          addScene(s);
      }
      for(Scene s in p.activation_scenes) {
          addActivationScene(s);
      }
    }

    Future<Null> generateName() async{
        await _doll.setNameFromEngine();
        setStringMemory(SentientObject.NAMEKEY,_doll.dollName);
    }

    void randomDollOfType(int type) {
        Doll doll = Doll.randomDollOfType(type);
        doll.rand = rand;
        doll.randomize();
        setDollStringAndOriginal(doll.toDataBytesX());
    }

    //does set original
    void setDollStringAndOriginal(optionalDollString) {
      setStringMemory(ORIGINALDOLLKEY,optionalDollString);
      setStringMemory(CURRENTDOLLKEY,optionalDollString);
      setInitStringMemory(ORIGINALDOLLKEY,optionalDollString);
      setInitStringMemory(CURRENTDOLLKEY,optionalDollString);

      _doll = Doll.loadSpecificDoll(optionalDollString);
      invalidateCaches();
      setStringMemory(SPECIESKEY,_doll.name);
    }

    @override
    String toString() {
        return name;
    }

    void invalidateCaches() {
        cachedCanvas = null;
        cachedThumbnail = null;
    }

    void restoreDollToOriginal() {
        setNewDoll(getStringMemory("originalDollString"));
    }

    void hatch() {
        print("attempting to hatch $name");
        if(_doll is HatchableDoll) {
            print("$name is hatchable");
            Doll hatched_chick = (_doll as HatchableDoll).hatch();
            setNewDoll(hatched_chick.toDataBytesX());
        }
    }

    bool hasPrepack(Prepack p) {
        for(Generator g in p.generators) {
            bool found = hasGenerator(g);
            if(!found) return false;
        }
        for(Scene s in p.scenes) {
            bool found = hasScene(s);
            if(!found) return false;        }
        for(Scene s in p.activation_scenes) {
            bool found = hasActivationScene(s);
            if(!found) return false;        }
        //if i haven't said no yet, this counts
        return true;
    }

    bool hasActivationScene(Scene s) {
        for(Scene s2 in _activationScenes) {
            if(s2.toDataString() == s.toDataString()){
                return true;
            }
        }
        return false;
    }



    bool hasGenerator(Generator g) {
        if(!_generators.containsKey(g.key)) {
            return false;
        }
       for(Generator g2 in _generators[g.key]) {
          if(g2.toDataString() == g.toDataString()){
              return true;
          }
      }
       return false;
    }

    //doesn't override original
    void setNewDoll(String dollString) {
        print("trying to set new doll of $dollString for $name");
        if(dollString != getStringMemory("currentDollString") && dollString != null && dollString.isNotEmpty) {

            try{
                Doll testDoll = Doll.loadSpecificDoll(dollString);
                setStringMemory(CURRENTDOLLKEY,dollString);
                //forces a reload later.
                invalidateCaches();
                _doll = testDoll;
            }catch(e) {
                print("Exception Caught: $e");
            }

        }
    }

    String get dollstring => _doll.toDataBytesX();

    Future<CanvasElement> get canvas async {
        if(cachedCanvas == null) {
            if(name == null || name.trim().isEmpty) setStringMemory(SentientObject.NAMEKEY,_doll.dollName);
            print("setting canvas for $name, their doll name is ${_doll.dollName}");
            CanvasElement fullSizeCanvas = await _doll.getNewCanvas();
            int newWidth = maxCanvasWidth;
            int newHeight = ((maxCanvasWidth/fullSizeCanvas.width*fullSizeCanvas.height)).round();
            if(newHeight > Scene.stageHeight) {
                newHeight = Scene.stageHeight;
                newWidth = ((newHeight/fullSizeCanvas.height)*fullSizeCanvas.width).round();
            }
            cachedCanvas = new CanvasElement(width: newWidth, height: newHeight);
            cachedCanvas.context2D.drawImageScaled(fullSizeCanvas,0,0, newWidth, newHeight);
        }
        return cachedCanvas;
    }

    Future<CanvasElement> get thumbnail async {
        if(cachedThumbnail == null || name.isEmpty) {
            print("setting canvas for $name, their doll name is ${_doll.dollName}");
            if(name == null || name.trim().isEmpty) setStringMemory(SentientObject.NAMEKEY,_doll.dollName);
            CanvasElement fullSizeCanvas = await _doll.getNewCanvas();
            int newWidth = 100;
            int newHeight = ((100/fullSizeCanvas.width*fullSizeCanvas.height)).round();
            if(newHeight > Scene.stageHeight) {
                newHeight = Scene.stageHeight;
                newWidth = ((newHeight/fullSizeCanvas.height)*fullSizeCanvas.width).round();
            }
            cachedThumbnail = new CanvasElement(width: newWidth, height: newHeight);
            cachedThumbnail.context2D.drawImageScaled(fullSizeCanvas,0,0, newWidth, newHeight);
        }
        return cachedThumbnail;
    }

    void addGenerator(Generator generator) {
        if(_generators.containsKey(generator.key)){
            _generators[generator.key].add(generator);
        }else{
            _generators[generator.key] = <Generator>[generator];
        }
    }

    void removeGenerator(Generator generator) {
        if(_generators.containsKey(generator.key)){
            List<Generator> toRemove = new List<Generator>();
            _generators[generator.key].forEach((Generator g)
            {
                if(g.toDataString() == generator.toDataString()){
                    toRemove.add(g);
                }
            });
           toRemove.forEach((Generator item) => _generators[generator.key].remove(item));
        }
    }

    void removeGeneratorsForKey(String key) {
        _generators.remove(key);
    }

    bool hasStringGeneratorWithKey(String key) {
        return _generators[key].where((Generator g) => g is StringGenerator).length > 0;
    }

    bool hasNumGeneratorWithKey(String key) {
        return _generators[key].where((Generator g) => g is NumGenerator).length > 0;

    }

    //TODO check if this key is in the blacklist
    //(this will be important for characters imported from wigglersim/creditsim so their stats aren't overriden)
    void generateStringValueForKey(Random rand, String key, String defaultValue){
        if(_generators.containsKey(key)){
            setStringMemory(key,rand.pickFrom(_generators[key].where((Generator g) => g is StringGenerator)).generateValue(rand));
        }else{
           setStringMemory(key, defaultValue);
        }
    }

    void generateNumValueForKey(Random rand, String key, num defaultValue){
        if(_generators.containsKey(key)){
            setNumMemory(key,rand.pickFrom(_generators[key].where((Generator g) => g is NumGenerator)).generateValue(rand));
        }else{
            setNumMemory(key, defaultValue);
        }
    }



    //not as simple as just calling remove because it might be a clone
    void removeActivationScene(Scene scene) {
        scene.owner = null;
        List<Scene> toRemove = new List<Scene>();
        _activationScenes.forEach((Scene s)
        {
            if(s.toDataString() == scene.toDataString()){
                toRemove.add(s);
            }
        });
        toRemove.forEach((Scene item) => _activationScenes.remove(item));

    }



    void addActivationScene(Scene scene) {
        scene.owner = this;
        _activationScenes.add(scene);
    }

    String debugString() {
        return "Entity Name: $name, Memory: $debugMemory, Scenes: ${readOnlyActivationScenes.map((Scene s)=> s.debugString())}";
    }

    Scene checkForActivationScenes(List<Entity> everyone, Scenario givenScenario) {
        for(Scene scene in _activationScenes) {
            scene.scenario ??= givenScenario;
            if(scene.checkIfActivated(everyone)){
                isActive = true;
                return scene;
            }
        }
    }



  @override
  Future<void> loadFromSerialization(Map<String,dynamic > serialization) async{
      super.loadFromSerialization(serialization);
      name = serialization["name"];
      setDollStringAndOriginal(serialization[ORIGINALDOLLKEY]);
      isActive = serialization["isActive"];
      prepacks = new List<Prepack>();
      for(Map<String,dynamic> subserialization in serialization["prepacks"]) {
          print("loading a subserialization");
          final Prepack p = new Prepack.empty();
          await p.loadFromSerialization(subserialization);
          prepacks.add(p);
      }
  }

  @override
  Map<String,dynamic > getSerialization() {
      Map<String,dynamic> ret = super.getSerialization();
      ret["name"] = name;
      ret[ORIGINALDOLLKEY] = _doll.toDataBytesX();
      ret["isActive"] =isActive;
      ret["prepacks"] = prepacks.map((Prepack p) => p.getSerialization()).toList();
      return ret;
  }

}