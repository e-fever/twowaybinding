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
        name: "TwoWayBinding"
        when: windowShown

        QtObject {
            id: sourceObject
            property int value : 1
        }

        QtObject {
            id: targetObject
            property int value : 2
        }

        QtObject {
            id: tmpObject
            property int value: 4
        }

        TwoWayBinding {
            id: binding
            source: sourceObject
            sourceProperty: "value"

            target: targetObject
            targetProperty: "value"
        }

        function test_twoWayBinding() {
            compare(sourceObject.value, 1);
            compare(targetObject.value, 1);

            sourceObject.value = 2;
            compare(sourceObject.value, 2);
            compare(targetObject.value, 2);

            targetObject.value = 3;
            compare(sourceObject.value, 3);
            compare(targetObject.value, 3);

            binding.when = false;
            binding.source = tmpObject;
            binding.when = true;
            compare(sourceObject.value, 3);
            compare(tmpObject.value, 3);
            compare(targetObject.value, 3);

            targetObject.value = 4
            compare(sourceObject.value, 3);
            compare(tmpObject.value, 4);
            compare(targetObject.value, 4);

            tmpObject.value = 5
            compare(sourceObject.value, 3);
            compare(tmpObject.value, 5);
            compare(targetObject.value, 5);
        }
    }
}
