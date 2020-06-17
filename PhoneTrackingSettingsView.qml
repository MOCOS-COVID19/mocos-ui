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
        onTargetValueUpdated: phoneTracking.usage = targetValue
    }
    Label { text: "Detection delay:" }
    DoubleNumField {
        targetValue: phoneTracking.detection_delay
        onTargetValueUpdated: phoneTracking.detection_delay = targetValue
    }
    Label { text: "Testing delay:" }
    DoubleNumField {
        targetValue: phoneTracking.testing_delay
        onTargetValueUpdated: phoneTracking.testing_delay = targetValue
    }
}
