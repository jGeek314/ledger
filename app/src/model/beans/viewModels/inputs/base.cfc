component accessors="true" {
    property name="value";
    property name="name";

    public component function init() {
        return this;
    }

    public string function getType(){
        return 'input';
    }
}