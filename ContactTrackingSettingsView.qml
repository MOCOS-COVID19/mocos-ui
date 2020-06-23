import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Probability:" }
    DoubleNumField {
        topValue: 1.0
        targetValue: contactTracking.probability
        onTargetValueChanged: contactTracking.probability = targetValue
    }
    Label { text: "Backward detection delay:" }
    DoubleNumField {
        targetValue: contactTracking.backward_detection_delay
        onTargetValueChanged: contactTracking.backward_detection_delay = targetValue
    }
    Label { text: "Forward detection delay:" }
    DoubleNumField {
        targetValue: contactTracking.forward_detection_delay
        onTargetValueChanged: contactTracking.forward_detection_delay = targetValue
    }
    Label { text: "Testing time:" }
    DoubleNumField {
        targetValue: contactTracking.testing_time
        onTargetValueChanged: contactTracking.testing_time = targetValue
    }
}
