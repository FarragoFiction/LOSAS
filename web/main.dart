import 'dart:html';

import 'package:CommonLib/NavBar.dart';

import 'scripts/FormHelpers/NumGeneratorFormHelper.dart';
import 'scripts/FormHelpers/PrepackBuilder.dart';
import 'scripts/FormHelpers/ScenarioFormHelper.dart';
import 'scripts/FormHelpers/SceneFormHelper.dart';
import 'scripts/FormHelpers/StringGeneratorFormHelper.dart';
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
    await new SceneFormHelper().makeBuilder(output,null);
  }else if(Uri.base.queryParameters['mode'] == "numGeneratorBuilder") {
    await new NumGeneratorFormHelper().makeBuilder(output,null);
  }else if(Uri.base.queryParameters['mode'] == "stringGeneratorBuilder") {
    await new StringGeneratorFormHelper().makeBuilder(output,null);
  }else if(Uri.base.queryParameters['mode'] == "prepackBuilder") {
    await new PrepackBuilder().makeBuilder(output);
  }else if(Uri.base.queryParameters['mode'] == "scenarioBuilder") {
    await new ScenarioFormHelper().makeBuilder(output);
  }else {
    GameUI game = new GameUI(Scenario.testScenario());
    UnitTests.runTests(output);
  }
}

void debugLinks(Element parent) {
  addDebugLink(parent, "index.html", "Tests");
  addDebugLink(parent, "${window.location.href}?seerOfVoid=true", "seerOfVoid");
  addDebugLink(parent, "${window.location.href}?mode=sceneBuilder", "SceneBuilder");
  addDebugLink(parent, "${window.location.href}?mode=stringGeneratorBuilder", "StringGeneratorBuilder");
  addDebugLink(parent, "${window.location.href}?mode=numGeneratorBuilder", "NumGeneratorBuilder");
  addDebugLink(parent, "${window.location.href}?mode=prepackBuilder", "PrepackBuilder");
  addDebugLink(parent, "${window.location.href}?mode=scenarioBuilder", "ScenarioBuilder");


}

void addDebugLink(Element parent, String url, String text) {
  AnchorElement anchor = new AnchorElement(href: url)..text = "| $text |"..style.padding="5px";
  parent.append(anchor);

}

