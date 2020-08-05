import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Usage:" }
    DoubleNumField {
        id: usageInputField
        focus: true
        topValue: 1.0
        targetValue: phoneTracking.usage
        onAfterEditingFinished: phoneTracking.usage = targetValue
        KeyNavigation.tab: detectionDelayInputField
    }
    Label { text: "Detection delay:" }
    DoubleNumField {
        id: detectionDelayInputField
        targetValue: phoneTracking.detectionDelay
        onAfterEditingFinished: phoneTracking.detectionDelay = targetValue
        KeyNavigation.tab: usageByHouseholdInputField
    }
    Label { text: "Usage by household:" }
    CheckBox {
        id: usageByHouseholdInputField
        checkState: phoneTracking.usageByHousehold ? Qt.Checked : Qt.Unchecked
        onCheckStateChanged: {
            phoneTracking.usageByHousehold = checkState === Qt.Checked
        }

        KeyNavigation.tab: usageInputField
    }

    Connections {
        target: phoneTracking
        onUsageChanged: usageInputField.text = phoneTracking.usage
        onDetectionDelayChanged: detectionDelayInputField.text = phoneTracking.detectionDelay
        onUsageByHouseholdChanged: {
            usageByHouseholdInputField.checkState = phoneTracking.usageByHousehold ? Qt.Checked : Qt.Unchecked
        }
    }
}
