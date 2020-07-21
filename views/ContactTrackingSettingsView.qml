import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Probability:" }
    DoubleNumField {
        id: probabilityInputField
        focus: true
        topValue: 1.0
        targetValue: contactTracking.probability
        onAfterEditingFinished: contactTracking.probability = targetValue
        KeyNavigation.tab: backwardDetectionDelayInputField
    }
    Label { text: "Backward detection delay:" }
    DoubleNumField {
        id: backwardDetectionDelayInputField
        targetValue: contactTracking.backwardDetectionDelay
        onAfterEditingFinished: contactTracking.backwardDetectionDelay = targetValue
        KeyNavigation.tab: forwardDetectionDelayInputField
    }
    Label { text: "Forward detection delay:" }
    DoubleNumField {
        id: forwardDetectionDelayInputField
        targetValue: contactTracking.forwardDetectionDelay
        onAfterEditingFinished: contactTracking.forwardDetectionDelay = targetValue
        KeyNavigation.tab: testingTimeInputField
    }
    Label { text: "Testing time:" }
    DoubleNumField {
        id: testingTimeInputField
        targetValue: contactTracking.testingTime
        onAfterEditingFinished: contactTracking.testingTime = targetValue
        KeyNavigation.tab: probabilityInputField
    }

    Connections {
        target: contactTracking
        onProbabilityChanged: {
            probabilityInputField.text = contactTracking.probability
        }
        onBackwardDetectionDelayChanged: {
            backwardDetectionDelayInputField.text = contactTracking.backwardDetectionDelay
        }
        onForwardDetectionDelayChanged: {
            forwardDetectionDelayInputField.text = contactTracking.forwardDetectionDelay
        }
        onTestingTimeChanged: {
            testingTimeInputField.text = contactTracking.testingTime
        }
    }
}
