import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Usage:" }
    DoubleNumField {
        topValue: 1.0
        targetValue: phoneTracking.usage
        onTargetValueChanged: phoneTracking.usage = targetValue
    }
    Label { text: "Detection delay:" }
    DoubleNumField {
        targetValue: phoneTracking.detectionDelay
        onTargetValueChanged: phoneTracking.detectionDelay = targetValue
    }
    Label { text: "Testing delay:" }
    DoubleNumField {
        targetValue: phoneTracking.testingDelay
        onTargetValueChanged: phoneTracking.testingDelay = targetValue
    }
}