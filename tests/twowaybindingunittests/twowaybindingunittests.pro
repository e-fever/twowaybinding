QT       += testlib qml

TARGET = twowaybinding
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES +=     main.cpp     tests.cpp

DEFINES += SRCDIR=\\\"$$PWD/\\\"
DEFINES += QUICK_TEST_SOURCE_DIR=\\\"$$PWD/\\\"

ROOTDIR = $$PWD/../../

include(vendor/vendor.pri)
include($$ROOTDIR/twowaybinding.pri)

DISTFILES +=     qpm.json     \
    qmltests/tst_Getter.qml \
    qmltests/tst_Form.qml \
    qmltests/tst_TwoWayBinding.qml \
    qmltests/tst_Form_bind_property.qml \
    ../../qpm.json

HEADERS +=     tests.h
