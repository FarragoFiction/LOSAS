import 'dart:html';

import 'scripts/Game.dart';

void main() {
  Element output = querySelector("#output");
  Game game = new Game();
  game.display(output);

}
