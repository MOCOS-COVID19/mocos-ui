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
    }
    KernelEnablingButton {
        isEnabled: transmissionProbabilities.isHouseholdKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isHouseholdKernelEnabled = isEnabled
            householdFactorField.enabled = isEnabled
        }
    }
    Label { text: "Constant:" }
    DoubleNumField {
        id: constantFactorField
        targetValue: transmissionProbabilities.constant
        enabled: transmissionProbabilities.isConstantKernelEnabled
        onTargetValueChanged: transmissionProbabilities.constant = targetValue
    }
    KernelEnablingButton {
        isEnabled: transmissionProbabilities.isConstantKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isConstantKernelEnabled = isEnabled
            constantFactorField.enabled = isEnabled
        }
    }
    Label { text: "Hospital:" }
    DoubleNumField {
        id: hospitalFactorField
        targetValue: transmissionProbabilities.hospital
        enabled: transmissionProbabilities.isHospitalKernelEnabled
        onTargetValueChanged: transmissionProbabilities.hospital = targetValue
    }
    KernelEnablingButton {
        isEnabled: transmissionProbabilities.isHospitalKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isHospitalKernelEnabled = isEnabled
            hospitalFactorField.enabled = isEnabled
        }
    }
    Label { text: "Friendship:" }
    DoubleNumField {
        id: friendshipKernelField
        targetValue: transmissionProbabilities.friendship
        enabled: transmissionProbabilities.isFriendshipKernelEnabled
        onTargetValueChanged: transmissionProbabilities.friendship = targetValue
    }
    KernelEnablingButton {
        isEnabled: transmissionProbabilities.isFriendshipKernelEnabled
        onAfterClicked: {
            transmissionProbabilities.isFriendshipKernelEnabled = isEnabled
            friendshipKernelField.enabled = isEnabled
        }
    }
}
