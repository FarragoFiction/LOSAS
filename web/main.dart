import 'dart:html';

import 'scripts/FormHelpers/SceneFormHelper.dart';
import 'scripts/Game.dart';
import 'scripts/Scenario.dart';
import 'scripts/UnitTests/UnitTests.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

void main() async {
  await Doll.loadFileData();

  Element output = querySelector("#output");
  //TODO modes for all builders, testing and then actually playing
  if(Uri.base.queryParameters['mode'] == "sceneBuilder") {
    await SceneFormHelper.makeSceneBuilder(output);
  }else {
    Game game = new Game(Scenario.testScenario());
    UnitTests.runTests(output);
  }
}

