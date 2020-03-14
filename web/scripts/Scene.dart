import "dart:html";
class Scene {
    Element container;
    String flavorText;
    String name;
    Scene(this.name, this.flavorText);

    void display(Element parent) {
        container = new DivElement()..classes.add("scene")..setInnerHtml(flavorText);
        parent.append(container);
    }
}