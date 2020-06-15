import 'dart:html';

abstract class Util {
    //I expect there to be things that look like TARGET.STRINGMEMORY.secretMessage
    //given a text, and a key that looks like TARGET.STRINGMEMORY but as a regexp
    //i expect to return [secretMessage]
    static List<String> getTagsForKey(String text,RegExp key, ) {
        List<String> ret = <String>[];
        dynamic matches = key.allMatches(text);
        for (Match m in matches) {
            print(m.group);
            String match = m.group(0);
            if(match != null){
                RegExp reg = new RegExp(r"[^.]*.[.]*]");
                dynamic submatches = reg.allMatches(match);
                for(Match m2 in submatches){
                    String match2 = m2.group(0);
                    print(match2);
                    ret.add(match2.replaceAll("]",""));
                }

            }
            print(match);

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