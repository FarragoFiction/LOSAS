import 'dart:html';

import 'scripts/Game.dart';
import 'scripts/Scenario.dart';

void main() {
  Element output = querySelector("#output");
  Game game = new Game( Scenario.testScenario());
  game.testDisplay(output);
}

