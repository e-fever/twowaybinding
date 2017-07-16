import QtQuick 2.0

Object {
    id: component

    property var source: null

    property string sourceProperty: ""

    property var target: null

    property string targetProperty: ""

    property bool when: true

    property bool _enabled: false;

    Binding {
        target: component.target
        property: targetProperty
        value: sourceGetter.value
        when: _enabled && component.when
    }

    Binding {
        target: component.source
        property: sourceProperty
        value: targetGetter.value
        when: _enabled && component.when
    }

    Getter {
        id: sourceGetter
        source: component.source
        property: sourceProperty
    }

    Getter {
        id: targetGetter
        source: component.target
        property: targetProperty
    }

    Component.onCompleted: {
        if (source && target && sourceProperty !== "" && targetProperty !== "") {
            target[targetProperty] = source[sourceProperty];
        }
        _enabled = true;
    }
}
