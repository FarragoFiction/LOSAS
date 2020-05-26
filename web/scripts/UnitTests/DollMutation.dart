/*
    TODO defines a set of layer/palette changes to make to a given doll.
    TODO can be procedural (i.e. class provides layer data and aspect provides palette data)

    for now just stubbing this out so i don't forget my thoughts. useful for when you want "current doll string but eyes are closed"
    or "current dollstring but they are in their dream jammies"
 */

import 'package:CommonLib/Colours.dart';

class DollMutation {
    //this mutation ONLY applys to dolls of this type
    int dollType;
    List<PaletteMutation> paleteMutations;
    List<LayerMutation> layerMutations;


}

class LayerMutation {
    // example of denizen rendering layer, 0 is back List<SpriteLayer>  get renderingOrderLayers => <SpriteLayer>[back,core,body,face,mouth,eyes,other];
    int renderingOrderIndex;
    int value;
}

class PaletteMutation {
    //use copyPalette from Doll. either overrides it or adds it depending.
    String paletteKey;
    Colour value;

}