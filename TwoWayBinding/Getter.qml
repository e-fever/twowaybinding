import QtQuick 2.0

Object {

    property var source: null

    property string property: ""

    property var value: null

    function _read() {
        if (source && property !== "") {
            value = source[property];
        }
    }

    function _capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    function _propertyChangedSignal(sig) {
        return "on" + _capitalizeFirstLetter((sig)) + "Changed";
    }

    function _updateSource() {
        if (priv.prevSource && priv.prevProperty !== "") {
            priv.prevSource[_propertyChangedSignal(priv.prevProperty)].disconnect(_read);
        }

        priv.prevSource = source;
        priv.prevProperty = property;

        if (source && property !== "") {
            source[_propertyChangedSignal(property)].connect(_read);
        }
    }

    onSourceChanged: {
        _updateSource();
        _read();
    }

    QtObject {
        id: priv
        property var prevSource: null;
        property var prevProperty: null;
    }

    Component.onCompleted: {
        _updateSource();
        _read();
    }
}
