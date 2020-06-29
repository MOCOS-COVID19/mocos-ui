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
        targetValue: contactTracking.backwardDetectionDelay
        onTargetValueChanged: contactTracking.backwardDetectionDelay = targetValue
    }
    Label { text: "Forward detection delay:" }
    DoubleNumField {
        targetValue: contactTracking.forwardDetectionDelay
        onTargetValueChanged: contactTracking.forwardDetectionDelay = targetValue
    }
    Label { text: "Testing time:" }
    DoubleNumField {
        targetValue: contactTracking.testingTime
        onTargetValueChanged: contactTracking.testingTime = targetValue
    }
}
