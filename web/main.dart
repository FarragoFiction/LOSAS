import 'dart:html';

import 'scripts/Game.dart';
import 'scripts/Scenario.dart';
import 'scripts/UnitTests/UnitTests.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

void main() async {
  await Doll.loadFileData();
  Element output = querySelector("#output");
  Game game = new Game( Scenario.testScenario());
  UnitTests.runTests(output);
}

