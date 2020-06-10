import 'dart:html';

abstract class Util {
    //I expect there to be things that look like TARGET.STRINGMEMORY.secretMessage
    //given a text, and a key that looks like TARGET.STRINGMEMORY
    //i expect to return [secretMessage]
    static List<String> getTagsForKey(String text, String key) {
        List<String> ret = new List<String>();
        List<String> parts = text.split(key);
        if(parts.length == 1) return []; //if you couldn't split the key aint in there.
        for(String part in parts) {
            List<String> subParts = part.split("]");
            if(subParts.length > 1) {
                ret.add(subParts[0]);
            }
        }
        return ret;
    }

    static turnwaysCanvas(CanvasElement canvas) {
        CanvasElement containingCanvas = new CanvasElement(width: canvas.width, height: canvas.height);
        containingCanvas.context2D.translate(containingCanvas.width, 0);
        containingCanvas.context2D.scale(-1, 1);
        containingCanvas.context2D.drawImage(canvas,0,0);
        return containingCanvas;
    }
}