//sentient objects have memory and can take actions
import 'DataObject.dart';
import 'Entity.dart';
import 'Scene.dart';

abstract class SentientObject extends ArchivePNGObject {
    static const String NAMEKEY = "name";
    Map<String,String> _stringMemory = new Map<String,String>();
    //overrides prepacks and shit
    Map<String,String> _initStringMemory = new Map<String,String>();
    Map<String,String> get readOnlyStringMemory => new Map<String,String>.from(_stringMemory);
    Map<String,dynamic> get debugMemory => new Map<String,dynamic>.from(_stringMemory)..addAll(_numMemory);
    Map<String,num> _numMemory = new Map<String, num>();
    //overrides prepacks and shit
    Map<String,num> _initialNumMemory = new Map<String, num>();
    //once active, these will be checked each tick
    List<Scene> _scenes = new List<Scene>();
    List<Scene> get readOnlyScenes => new List<Scene>.from(_scenes);


    Map<String,num> get readOnlyNumMemory => new Map<String,num>.from(_numMemory);

    void clear() {
        _stringMemory.clear();
        _numMemory.clear();
        _scenes.clear();
    }

    void addScene(Scene scene) {
        scene.owner = this;
        _scenes.add(scene);
    }

    void addSceneFront(Scene scene) {
        scene.owner = this;
        _scenes.insert(0,scene);
    }

    //if no scene can be performed, thems the breaks kids
    Scene performScene(List<Entity> everyone) {
        for(Scene scene in _scenes) {
            if(scene.checkIfActivated(everyone)){
                return scene;
            }
        }
    }

    bool hasStringKey(String key) => _stringMemory.containsKey(key);
    bool hasNumKey(String key) => _numMemory.containsKey(key);

    String getStringMemory(String key) {
        return _stringMemory[key];
    }

    String removeStringMemoryKey(String key) {
        return _stringMemory.remove(key);
    }

    void setStringMemory(String key, String value) {
        if(key == NAMEKEY) {
            name = value;
        }
        _stringMemory[key] = value;
    }

    void setInitStringMemory(String key, String value) {
        _initStringMemory[key] = value;
    }


    num getNumMemory(String key) {
        if(_numMemory.containsKey(key)){
            return _numMemory[key];
        }else{
            return 0; //null isn't a real thing for numbers for display purposes.
        }
    }

    void setNumMemory(String key, num value) {
        _numMemory[key] = value;
    }

    void setInitNumMemory(String key, num value) {
        _initialNumMemory[key] = value;
    }


    //not as simple as just calling remove because it might be a clone
    void removeScene(Scene scene) {
        scene.owner = null;
        List<Scene> toRemove = new List<Scene>();
        _scenes.forEach((Scene s)
        {
            if(s.toDataString() == scene.toDataString()){
                toRemove.add(s);
            }
        });
        toRemove.forEach((Scene item) => _scenes.remove(item));

    }

    bool hasScene(Scene s) {
        for(Scene s2 in _scenes) {
            if(s2.toDataString() == s.toDataString()){
                return true;
            }
        }
        return false;
    }

    void overRideOtherMemory() {
        for(String key in _initStringMemory.keys) {
            setStringMemory(key, _initStringMemory[key]);
        }

        for(String key in _initialNumMemory.keys) {
            setNumMemory(key, _initialNumMemory[key]);
        }
    }

    @override
    Future<void> loadFromSerialization(Map<String,dynamic > serialization) async{
        if(serialization.containsKey("_initStringMemory")){
            _initStringMemory = new Map<String,String>.from(serialization["_initStringMemory"]);
        }

        if(serialization.containsKey("_initialNumMemory")){
            _initialNumMemory = new Map<String,num>.from(serialization["_initialNumMemory"]);
        }
    }

    @override
    Map<String,dynamic > getSerialization() {
        Map<String,dynamic> ret = new Map<String,dynamic>();
        ret["_initStringMemory"] = _initStringMemory;
        ret["_initialNumMemory"] = _initialNumMemory;
        return ret;
    }
}