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
        name: "Form_bindProperty"
        when: windowShown

        Form {
            id: form
            property int value: 1
        }

        QtObject {
            id: store
            property var object: ({
                value: 2
            })
        }

        SignalSpy {
            id: changedSpy
            target: form
            signalName: "userChanges"
        }

        function test_bind_property() {
            compare(changedSpy.count, 0);
            compare(form.value, 1);
            form.bind(store, "object");

            compare(form.value, 2);
            compare(changedSpy.count, 0);
            wait(100);
            compare(changedSpy.count, 0);

            store.object = {
                value: 3
            };

            compare(form.value, 3);
            wait(100);
            compare(changedSpy.count, 0);

            form.value = 4;
            compare(changedSpy.count, 0);
            wait(100);
            compare(changedSpy.count, 1);
        }
    }
}
