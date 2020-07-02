import QtQuick 2.0
import QtQuick.Controls 2.4

ToolButton {
    id: householdEnableButton
    function getTextBasedOnKernelEnabled() {
        if (isEnabled) {
            return "Disable"
        } else {
            return "Enable"
        }
    }

    property bool isEnabled: true
    signal afterClicked()

    text: getTextBasedOnKernelEnabled()
    onIsEnabledChanged: text = getTextBasedOnKernelEnabled()

    onClicked: {
        isEnabled = !isEnabled
        afterClicked()
    }
}
