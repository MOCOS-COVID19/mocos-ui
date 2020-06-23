import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Household:" }
    DoubleNumField {
        targetValue: transmissionProbabilities.household
        onTargetValueChanged: transmissionProbabilities.household = targetValue
    }
    Label { text: "Constant:" }
    DoubleNumField {
        targetValue: transmissionProbabilities.constant
        onTargetValueChanged: transmissionProbabilities.constant = targetValue
    }
    Label { text: "Hospital:" }
    DoubleNumField {
        targetValue: transmissionProbabilities.hospital
        onTargetValueChanged: transmissionProbabilities.hospital = targetValue
    }
    Label { text: "Friendship:" }
    DoubleNumField {
        targetValue: transmissionProbabilities.friendship
        onTargetValueChanged: transmissionProbabilities.friendship = targetValue
    }
}
