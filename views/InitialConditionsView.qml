import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Infectious:" }
    IntNumField {
        id: infectiousNumField
        focus: true
        targetValue: initialConditions.cardinalities.infectious
        onAfterEditingFinished: initialConditions.cardinalities.infectious = targetValue
        bottomValue: 0
        KeyNavigation.tab: infectiousNumField
    }

    Connections {
        target: initialConditions.cardinalities
        onInfectiousChanged: infectiousNumField.text = initialConditions.cardinalities.infectious
    }
}
