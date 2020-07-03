import QtQuick 2.0
import QtQuick.Controls 2.4

Button {
    id: householdEnableButton
    function getTextBasedOnKernelEnabled() {
        if (isEnabled) {
            return "Disable"
        } else {
            return "Enable"
        }
    }

    function handleClicked() {
        isEnabled = !isEnabled
        afterClicked()
    }

    property bool isEnabled: true
    signal afterClicked()

    text: getTextBasedOnKernelEnabled()
    onIsEnabledChanged: text = getTextBasedOnKernelEnabled()

    onClicked: handleClicked()
    Keys.onEnterPressed: handleClicked()
    Keys.onReturnPressed: handleClicked()
}
