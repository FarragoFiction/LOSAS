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

    StreamSubscription<KeyboardEvent> keyListener;

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