import QtQuick 2.0
import QtQuick.Controls 2.0

TextField {
    property alias bottomValue: valueValidator.bottom
    property alias topValue: valueValidator.top
    property real targetValue: 0

    selectByMouse: true
    text: targetValue

    validator: IntValidator{ id: valueValidator }

    onEditingFinished: {
        targetValue = parseInt(text)
    }
}
