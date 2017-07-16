import QtQuick 2.0
import QuickFlux 1.1
import QtTest 1.0
import Testable 1.0
import TwoWayBinding 1.0

Item {
    id: window
    height: 640
    width: 480

    TestCase {
        name: "Form"
        when: windowShown

        Form {
            id: form
            property string resizeToWidth
        }

        QtObject {
            id: store

            property string resizeToWidth: ""

            property string resizeToHeight: ""

            property string resizeUnit: "px"

            property int rotation: 0
        }

        SignalSpy {
            id: changedSpy
            target: form
            signalName: "userChanges"
        }

        function test_bind() {
            compare(changedSpy.count, 0);
            compare(form.resizeToWidth, "");
            form.bind(store);
            store.resizeToWidth = "100";
            compare(form.resizeToWidth, "100");
            wait(100);
            compare(changedSpy.count, 0);

            form.resizeToWidth = "120";
            wait(100);
            compare(changedSpy.count, 1);
        }        
    }
}
