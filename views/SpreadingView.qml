import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.0

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Alpha:" }
    DoubleNumField {
        id: alphaInputField
        focus: true
        targetValue: spreading.alpha
        onAfterEditingFinished: spreading.alpha = targetValue
        KeyNavigation.tab: x0InputField
    }
    Label { text: "x0:" }
    DoubleNumField {
        id: x0InputField
        targetValue: spreading.x0
        onAfterEditingFinished: spreading.x0 = targetValue
        KeyNavigation.tab: truncationInputField
    }
    Label { text: "Truncation:" }
    DoubleNumField {
        id: truncationInputField
        targetValue: spreading.truncation
        color: spreading.isTruncationAcceptable ? "black" : "red"
        onAfterEditingFinished: spreading.truncation = targetValue
        KeyNavigation.tab: alphaInputField
    }
}
