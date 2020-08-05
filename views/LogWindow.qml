import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0

Window {
    title: "Simulation Log"
    width: 640
    height: 360

    TextArea {
        id: logViewer
        wrapMode: Text.WordWrap
        text: ""
        readOnly: true
        anchors.fill: parent
    }

    Connections {
        target: simulationRunner
        onPrintSimulationMsg: {
            let newText = logViewer.text + msg
            logViewer.text = newText
        }
        onClearLog: logViewer.text = ""
    }
}
