import QtQuick 2.0
import QtQuick.Controls 2.0

TextField {
    property real bottomValue: 0.0
    property real topValue: +Infinity
    property real targetValue: 0.0
    signal targetValueUpdated()

    selectByMouse: true
    text: targetValue
    inputMethodHints: Qt.ImhFormattedNumbersOnly

    function setTargetValue(newValue) {

    }

    onEditingFinished: {
        let num = parseFloat(text)
        console.log(num)
        if ( isNaN(num) ) {
            text = targetValue
            return
        }
        if (num < bottomValue || num > topValue) {
            text = targetValue
            return
        }
        targetValue = num
        targetValueUpdated()
        if (num == num.toFixed(0)) {
            text = num.toFixed(1)
        }
        else {
            text = num
        }
    }
    //validator: RegExpValidator { regExp: /\d{1,1}(?:.\d{1,3})+$/ }
}
