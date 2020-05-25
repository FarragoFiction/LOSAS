import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'Entity.dart';
import 'Scenario.dart';
import 'Scene.dart';
import 'UnitTests/UnitTests.dart';

class Game {
    static String dataPngFolder = "LOSAS/";
    Element container;
    Scenario scenario;
    bool readyForNextScene = true;
    ButtonElement fullStoryButton;
    DivElement fullstory;
    //which scene are we on
    int currentSceneIndex = 0;
    AudioElement bgMusic = new AudioElement()..loop=false;
    //you can go forward and back through all scenes easily.
    List<Element> sceneElements = new List<Element>();
    List<AudioElement> audioElements = new List<AudioElement>();
    //seriously if NOTHING HAPPENS for 13 ticks in a row, lets just call it
    int numberTriesForScene = 0;
    int maxNumberTriesForScene = 13;
    StreamSubscription<KeyboardEvent> keyListener;
    bool theEnd = false;
    List<Entity> _entities = new List<Entity>();
    List<Entity> get entitiesReadOnly  => _entities;

    //the person in the spotlight is on screen right now
    Entity spotLightEntity;
    //if not entities are active on spawn, nothing can happen. I advise having at least an invisible entity, like "Skaia".
    List<Entity> get activeEntitiesReadOnly => _entities.where((Entity entity) =>entity.isActive).toList();


    //all possible entitites for this
      Game(Scenario this.scenario) {
    }


    void setup(Element parent) {
        container = new DivElement()..classes.add("game");
        container.append(bgMusic);
        parent.append(container);
        wireUpKeyBoardControls();
        renderNavigationArrows();
    }

    void teardown() {
        keyListener.cancel();
    }

    void curtainsUp(Element parent) {
        print("curtains are going up");
        scenario.game = this;
        print("made a new game");
        setup(parent);
        initializeEntities();
        print("setup the game");
        lookForNextScene();
        print("looked for a scene");
    }


    //unlike sburbsim this doesn't just tick infinitely. instead it renders a button for next.
    //if you try to page to the right and the scene doesn't exist and we aren't ended, do this
    //first you check all your entities
    //then you check your stop scenes
    //then you repeat
    void lookForNextScene() {
        if(theEnd) return;
        game.readyForNextScene = false;
        if(game.sceneElements.length == 0){
            Scene introduction = getIntroduction();
            if(introduction != null) {
                game.showScene(introduction);
                return;
            }
        }
        //could be some amount of randomness baked in
        if(numberTriesForScene > maxNumberTriesForScene) {
            window.alert("something has gone wrong, went $numberTriesForScene loops without anything happening");
        }
        Scene spotlightScene;
        List<Entity> entitiesToCheck = null;
        if(spotLightEntity != null) {
            entitiesToCheck = entitiesReadOnly.sublist(entitiesReadOnly.indexOf(spotLightEntity)+1);
        }else {
            //every time we get to the start of entities, we shuffle so its not so samey
            _entities.shuffle(rand);
            entitiesToCheck = entitiesReadOnly;
        }
        spotlightScene = checkEntitiesForScene(entitiesToCheck);
        if(spotlightScene != null) {
            game.showScene(spotlightScene);
        }else {
            print("Time to check stop scenes");
            spotlightScene = checkStopScenes();
            if(spotlightScene == null) {
                numberTriesForScene ++;
                spotLightEntity = null;
                lookForNextScene();
            }else {
                theEnd = true;
                game.showScene(spotlightScene);
            }
        }
    }

    Scene checkStopScenes() {
        for(final Scene scene in stopScenes) {
            scene.scenario ??=this;
            print("checking stop scene $scene with activeEntities $activeEntitiesReadOnly, btw the scene has these filters ${scene.targetFilters}");
            final bool active = scene.checkIfActivated(activeEntitiesReadOnly);
            print("was the stop scene activated: $active, the targets are ${scene.finalTargets}");
            if(active){
                return  scene;
            }
        }
        return null;
    }

    Scene checkEntitiesForScene(List<Entity> entitiesToCheck) {
        Scene ret;
        for(final Entity e in entitiesToCheck) {
            if(e.isActive) {
                //yes it includes yourself, what if you're gonna buff your party or something
                ret = e.performScene(activeEntitiesReadOnly);
                if(ret != null) {
                    spotLightEntity = e;
                    ret.scenario ??=this;
                    return ret;
                }
            }else{
                ret = e.checkForActivationScenes(activeEntitiesReadOnly);
                if(ret != null) {
                    spotLightEntity = e;
                    ret.scenario ??=this;
                    return ret;
                }
            }
        }
        return null;
    }

    //if no scenes trigger, no introduction
    Scene getIntroduction() {
        for(final Scene scene in frameScenes) {
            final bool active = scene.checkIfActivated(activeEntitiesReadOnly);
            if(active){
                return  scene;
            }
        }
        return null;
    }

    void initializeEntities() {
        _entities.forEach((Entity e) => e.processPrepacks(rand));
    }

    void addEntity(Entity entity) {
        _entities.add(entity);
        entity.scenario = this;
    }



    void debugScenario() {
        entitiesReadOnly.forEach((Entity e)=> print(e.debugString()));
    }


    void wireUpKeyBoardControls() {
        keyListener = window.onKeyDown.listen((KeyboardEvent e) {
            print("noticed a keypress of code ${e.keyCode}");
            if(e.keyCode == KeyCode.LEFT) {
                goLeft();
            }else if(e.keyCode == KeyCode.RIGHT) {
                goRight();
            }
        });
    }

    void renderNavigationArrows() {
        String rightArrow ='<svg class = "arrow" id = "right-arrow" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13 7v-6l11 11-11 11v-6h-13v-10z"/></svg>';
        String leftArrow = '<svg class = "arrow" id = "left-arrow" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13 7v-6l11 11-11 11v-6h-13v-10z"/></svg>';
        DivElement rightArrowDiv = new DivElement()..setInnerHtml(rightArrow, treeSanitizer: NodeTreeSanitizer.trusted)..classes.add("arrow");
        DivElement leftArrowDiv = new DivElement()..setInnerHtml(leftArrow, treeSanitizer: NodeTreeSanitizer.trusted)..classes.add("arrow");
        container.append(leftArrowDiv);
        container.append(rightArrowDiv);
        rightArrowDiv.onClick.listen((Event e) {
            goRight();
        });

        leftArrowDiv.onClick.listen((Event e) {
            goLeft();
        });
    }

    //useful for pdfs and reviews of interesting stories
    void displayAll() {
          print("displaying all ${sceneElements.length} scenes");
        if(sceneElements.isNotEmpty) {
            sceneElements[currentSceneIndex - 1].remove();
            audioElements[currentSceneIndex - 1].pause();
        }
        if(fullstory == null) {
            fullstory = new DivElement()..classes.add("fullstory");
            sceneElements.forEach((Element element) =>
                fullstory.append(element));
        }
        container.append(fullstory);
    }

    void showScene(Scene spotlightScene)async {
        scenario.numberTriesForScene = 0;
        Element sceneElement = await spotlightScene.render(sceneElements.length);
        sceneElements.add(sceneElement);
        AudioElement audio = new AudioElement()..loop=true;
        if(spotlightScene.musicLocationEnd != Scene.NOBGMUSIC) {
            audio.src = spotlightScene.musicLocation;
        }
        audioElements.add(audio);
        audio.play();
        container.append(sceneElement);
        readyForNextScene = true;
    }

    void renderCurrentScene() {
        container.append(sceneElements[currentSceneIndex]);
        audioElements[currentSceneIndex].play();
    }

    void goRight() {
        if(!readyForNextScene) return;
        currentSceneIndex ++;
        if(currentSceneIndex >= sceneElements.length && scenario.theEnd) {
            currentSceneIndex += -1; //take that back plz
            fullStoryWire();
        }else if(currentSceneIndex >= sceneElements.length && !scenario.theEnd) {
            if(sceneElements.isNotEmpty) {
                sceneElements[currentSceneIndex - 1].remove();
                audioElements[currentSceneIndex - 1].pause();
            }
            scenario.lookForNextScene();
        }else {
            if(sceneElements.isNotEmpty) {
                sceneElements[currentSceneIndex - 1].remove();
                audioElements[currentSceneIndex - 1].pause();
            }
            renderCurrentScene();
        }

    }

    void fullStoryWire() {
      if(fullStoryButton == null) {
          fullStoryButton = new ButtonElement()
              ..text = "View Full Story?";
          fullStoryButton.onClick.listen((Event e) {
              if (fullStoryButton.text == "Display Scene View?") {
                  fullstory.remove();
                  fullStoryButton.text = "View Full Story?";
                  renderCurrentScene();
              } else {
                  fullStoryButton.text = "Display Scene View?";
                  displayAll();
              }
          });
      }
      container.append(fullStoryButton);
    }

    void goLeft() {
        if(!readyForNextScene) return;
        sceneElements[currentSceneIndex].remove();
        audioElements[currentSceneIndex].pause();

        currentSceneIndex += -1;
        if(currentSceneIndex < 0) {
            currentSceneIndex = 0;
        }
        renderCurrentScene();
    }



}