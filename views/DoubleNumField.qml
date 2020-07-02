import QtQuick 2.0
import QtQuick.Controls 2.0

TextField {
    property real bottomValue: 0.0
    property real topValue: +Infinity
    property real targetValue: 0.0

    selectByMouse: true
    text: floatValueToText(targetValue)
    inputMethodHints: Qt.ImhFormattedNumbersOnly

    function floatValueToText(num) {
        if (num == num.toFixed(0)) {
            return num.toFixed(1)
        }
        else {
            return num
        }
    }

    onEditingFinished: {
        let num = parseFloat(text)
        if ( isNaN(num) ) {
            text = floatValueToText(targetValue)
            return
        }
        if (num < bottomValue || num > topValue) {
            text = floatValueToText(targetValue)
            return
        }
        targetValue = num
        text = floatValueToText(targetValue)
    }

    onEnabledChanged: {
        if (enabled) {
            text = floatValueToText(targetValue)
        }
        else {
            text = "0.0"
        }
    }
}
