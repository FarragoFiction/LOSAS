import 'dart:html';

import 'package:CommonLib/NavBar.dart';

import 'scripts/FormHelpers/SceneFormHelper.dart';
import 'scripts/Game.dart';
import 'scripts/Scenario.dart';
import 'scripts/UnitTests/UnitTests.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

void main() async {
  await Doll.loadFileData();
  handleVoid();

  Element output = querySelector("#output");
  debugLinks(output);

  //TODO modes for all builders, testing and then actually playing
  if(Uri.base.queryParameters['mode'] == "sceneBuilder") {
    await SceneFormHelper.makeSceneBuilder(output);
  }else {
    Game game = new Game(Scenario.testScenario());
    UnitTests.runTests(output);
  }
}

void debugLinks(Element parent) {
  AnchorElement seerOfVoid = new AnchorElement(href: "${window.location.href}?seerOfVoid=true")..text = "| seerOfVoid |";
  AnchorElement sceneBuilder = new AnchorElement(href: "${window.location.href}?mode=sceneBuilder")..text = "| sceneBuilder |";
  AnchorElement runTests = new AnchorElement(href: "${window.location.href}")..text = "| runTests |";
  parent.append(seerOfVoid);
  parent.append(sceneBuilder);
  parent.append(runTests);
}

