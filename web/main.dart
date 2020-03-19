import 'dart:html';

import 'scripts/Game.dart';
import 'scripts/Scenario.dart';

//single global var so keyboard controls can handle it even if we change scenarios, future me might wanna rethink this
Scenario scenario;

void main() {
  Element output = querySelector("#output");
  scenario = Scenario.testScenario();
  Game game = new Game(scenario);
  game.testDisplay(output);
  wireUpKeyBoardcontrols();
}

void wireUpKeyBoardcontrols() {
  window.onKeyPress.listen((KeyboardEvent e) {
    if(e.keyCode == KeyCode.LEFT) {
      scenario.goLeft();
    }else if(e.keyCode == KeyCode.RIGHT) {
      scenario.goRight();
    }
  });
}
