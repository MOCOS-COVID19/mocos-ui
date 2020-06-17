import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Household:" }
    DoubleNumField {
        targetValue: contactTracking.probability
        onTargetValueUpdated: contactTracking.probability = targetValue
    }
    Label { text: "Constant:" }
    DoubleNumField {
        targetValue: contactTracking.backward_detection_delay
        onTargetValueUpdated: contactTracking.backward_detection_delay = targetValue
    }
    Label { text: "Hospital:" }
    DoubleNumField {
        targetValue: contactTracking.forward_detection_delay
        onTargetValueUpdated: contactTracking.forward_detection_delay = targetValue
    }
    Label { text: "Friendship:" }
    DoubleNumField {
        targetValue: contactTracking.testing_time
        onTargetValueUpdated: contactTracking.testing_time = targetValue
    }
}
