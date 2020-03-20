import 'dart:html';

import 'scripts/Game.dart';
import 'scripts/Scenario.dart';
import 'scripts/UnitTests/UnitTests.dart';

void main() {
  Element output = querySelector("#output");
  Game game = new Game( Scenario.testScenario());
  UnitTests.runTests(output);
}

