// Form is a object that bind its values from another object.
import QtQuick 2.0
import QuickFlux 1.1
import Backpressure 1.0

Object {
    id: form

    /// It is emitted only if the object is modifed manualy (not from bind source)
    signal userChanges();

    function dehydrate() {
        return Hydrate.dehydrate(form);
    }

    function rehydrate(snapshot) {
        return Hydrate.rehydrate(form, snapshot);
    }

    function sync(source) {
        if (priv.properties === undefined) {
            priv.updateProperties();
        }

        for (var i in priv.properties) {
            if (source.hasOwnProperty(i)) {
                form[i] = source[i];
            }
        }
    }

    function bind(source, prop) {
        priv.source = source;
        if (prop === undefined) {
            prop = "";
        }

        priv.sourceProperty = prop;

        priv.disableChanged = true;
        _apply();
        priv.disableChanged = false;

        _listen();
    }

    function _apply() {
        if (priv.sourceProperty !== "") {
            sync(priv.source[priv.sourceProperty]);
        } else {
            sync(priv.source);
        }
    }

    function _capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    function _propertyChangedSignal(prop) {
        return "on" + _capitalizeFirstLetter(prop) + "Changed";
    }

    function _listen() {
        if (priv.sourceProperty !== "") {
            var sig = _propertyChangedSignal(priv.sourceProperty);
            priv.source[sig].connect(function() {
                priv.disableChanged = true;
                _apply();
                priv.disableChanged = false;
            });
            return;
        }

        // If sourceProperty is absent
        for (var i in priv.properties) {
            if (!priv.source.hasOwnProperty(i)) {
                continue;
            }

            (function(p) {
                var sig = "on" + _capitalizeFirstLetter(p) + "Changed";
                priv.source[sig].connect(function() {
                    priv.disableChanged = true;
                    form[p] = priv.source[p];
                    priv.disableChanged = false;
                });
            })(i);
        }
    }

    QtObject {
        id: priv

        /// The form's own properties
        property var properties;

        /// The source object
        property var source;

        property string sourceProperty: ""

        /// Should it disable to emit the userChanges signal?
        property bool disableChanged: false;

        property var changed: Backpressure.debounce(form, 0, function() {
           form.userChanges();
        });

        function updateProperties() {
            priv.properties = Hydrate.dehydrate(form);
            for (var i in priv.properties) {
                var sig = "on" + _capitalizeFirstLetter(i) + "Changed";
                form[sig].connect(function() {
                    if (!priv.disableChanged) {
                        priv.changed();
                    }
                });
            }
        }
    }

    onUserChanges: {
        if (form.hasOwnProperty("clean")) {
            form.clean();
        }
    }

    Component.onCompleted: {
        if (priv.properties === undefined) {
            priv.updateProperties();
        }
    }
}
