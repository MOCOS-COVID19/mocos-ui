import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

Item {
    GroupBox {
        title: "Cardinalities"

        GridLayout {
            columns: 2
            columnSpacing: 10

            Label { text: "Infectious:" }
            TextField {
                text: initialConditions.cardinalities.infectious
                onEditingFinished: initialConditions.cardinalities.infectious = parseInt(text)
                validator: IntValidator{ bottom: 0 }
            }
        }
    }
}
