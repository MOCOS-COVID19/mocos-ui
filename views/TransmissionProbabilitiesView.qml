import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 3
    columnSpacing: 10

    Label { text: "Household:" }
    DoubleNumField {
        id: householdFactorField
        targetValue: transmissionProbabilities.household
        enabled: transmissionProbabilities.isHouseholdKernelEnabled
        onTargetValueChanged: transmissionProbabilities.household = targetValue
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
        onTargetValueChanged: transmissionProbabilities.constant = targetValue
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
        onTargetValueChanged: transmissionProbabilities.hospital = targetValue
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
        onTargetValueChanged: transmissionProbabilities.friendship = targetValue
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
}
