import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 3
    columnSpacing: 10

    Label { text: "Household:" }
    DoubleNumField {
        id: householdFactorField
        focus: true
        targetValue: transmissionProbabilities.household
        enabled: transmissionProbabilities.isHouseholdKernelEnabled
        onAfterEditingFinished: transmissionProbabilities.household = targetValue
        KeyNavigation.tab: constantFactorField
    }
    KernelEnablingButton {
        id: householdKernelEnablingButton
        isEnabled: transmissionProbabilities.isHouseholdKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isHouseholdKernelEnabled = isEnabled
            householdFactorField.enabled = isEnabled
        }
        KeyNavigation.tab: constantKernelEnablingButton
    }
    Label { text: "Constant:" }
    DoubleNumField {
        id: constantFactorField
        targetValue: transmissionProbabilities.constant
        enabled: transmissionProbabilities.isConstantKernelEnabled
        onAfterEditingFinished: transmissionProbabilities.constant = targetValue
        KeyNavigation.tab: hospitalFactorField
    }
    KernelEnablingButton {
        id: constantKernelEnablingButton
        isEnabled: transmissionProbabilities.isConstantKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isConstantKernelEnabled = isEnabled
            constantFactorField.enabled = isEnabled
        }
        KeyNavigation.tab: hospitalKernelEnablingButton
    }
    Label { text: "Hospital:" }
    DoubleNumField {
        id: hospitalFactorField
        targetValue: transmissionProbabilities.hospital
        enabled: transmissionProbabilities.isHospitalKernelEnabled
        onAfterEditingFinished: transmissionProbabilities.hospital = targetValue
        KeyNavigation.tab: friendshipKernelField
    }
    KernelEnablingButton {
        id: hospitalKernelEnablingButton
        isEnabled: transmissionProbabilities.isHospitalKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isHospitalKernelEnabled = isEnabled
            hospitalFactorField.enabled = isEnabled
        }
        KeyNavigation.tab: friendshipKernelEnablingButton
    }
    Label { text: "Friendship:" }
    DoubleNumField {
        id: friendshipKernelField
        targetValue: transmissionProbabilities.friendship
        enabled: transmissionProbabilities.isFriendshipKernelEnabled
        onAfterEditingFinished: transmissionProbabilities.friendship = targetValue
        KeyNavigation.tab: householdKernelEnablingButton
    }
    KernelEnablingButton {
        id: friendshipKernelEnablingButton
        isEnabled: transmissionProbabilities.isFriendshipKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isFriendshipKernelEnabled = isEnabled
            friendshipKernelField.enabled = isEnabled
        }
        KeyNavigation.tab: householdFactorField
    }

    Component.onDestruction: {
        transmissionProbabilities.isHouseholdKernelEnabled = transmissionProbabilities.household !== 0
        transmissionProbabilities.isConstantKernelEnabled = transmissionProbabilities.constant !== 0
        transmissionProbabilities.isHospitalKernelEnabled = transmissionProbabilities.hospital !== 0
        transmissionProbabilities.isFriendshipKernelEnabled = transmissionProbabilities.friendship !== 0
    }

    Connections {
        target: transmissionProbabilities
        function onHouseholdChanged() {
            householdFactorField.targetValue = transmissionProbabilities.household
            householdFactorField.text = transmissionProbabilities.household
        }
        function onConstantChanged() {
            constantFactorField.targetValue = transmissionProbabilities.constant
            constantFactorField.text = transmissionProbabilities.constant
        }
        function onHospitalChanged() {
            hospitalFactorField.targetValue = transmissionProbabilities.hospital
            hospitalFactorField.text = transmissionProbabilities.hospital
        }
        function onFriendshipChanged() {
            friendshipKernelField.targetValue = transmissionProbabilities.friendship
            friendshipKernelField.text = transmissionProbabilities.friendship
        }
    }
}
