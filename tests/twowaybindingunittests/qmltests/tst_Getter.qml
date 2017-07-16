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
        name: "Getter"
        when: windowShown

        QtObject {
            id: source
            property int value : 1
        }

        QtObject {
            id: tmp
            property int value : 3
        }

        Getter {
            id: getter
            source: source
            property: "value"
        }

        function test_getter() {
            compare(getter.value, 1);
            source.value = 2;
            compare(getter.value, 2);

            getter.source = tmp;
            compare(getter.value, 3);

            source.value = 4;
            compare(getter.value, 3);

        }
    }
}
