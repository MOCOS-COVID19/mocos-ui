import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Infectious:" }
    IntNumField {
        targetValue: initialConditions.cardinalities.infectious
        onTargetValueChanged: initialConditions.cardinalities.infectious = targetValue
        bottomValue: 0
    }
}
