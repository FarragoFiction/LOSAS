abstract class Util {
    //I expect there to be things that look like TARGET.STRINGMEMORY.secretMessage
    //given a text, and a key that looks like TARGET.STRINGMEMORY
    //i expect to return [secretMessage]
    static List<String> getTagsForKey(String text, String key) {
        List<String> ret = new List<String>();
        List<String> parts = text.split(key);
        for(String part in parts) {
            List<String> subParts = part.split("]");
            if(subParts.length > 1) {
                ret.add(subParts[0]);
            }
        }
        return ret;
    }
}