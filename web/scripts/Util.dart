abstract class Util {
    //I expect there to be things that look like TARGET.STRINGMEMORY.secretMessage
    //given a text, and a key that looks like TARGET.STRINGMEMORY
    //i expect to return [secretMessage]
    static List<String> getTagsForKey(String text, String key) {
        List<String> parts = text.split(key);
        return parts;
    }
}