import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.0
import QtCharts 2.2

Window {
    id: dailyInfectionsWindow
    title: "Daily Infected"
    width: 640
    height: 360

    function saveChart(filename) {
        chartView.grabToImage(function(result){
                result.saveToFile(filename)
            },
            Qt.size(widthField.targetValue, heightField.targetValue))
    }

    FileDialog {
        id: chartSaveDialog
        folder: shortcuts.home
        selectExisting: false
        sidebarVisible: true
        nameFilters: [ "PNG files (*.png)" ]
        onAccepted: {
            var FILE_PREFIX = "file://"
            let path = fileUrl.toString()
            if (path.startsWith(FILE_PREFIX)) {
                path = path.substr(FILE_PREFIX.length, path.length)
            }
            dailyInfectionsWindow.saveChart(path)
        }
    }

    Row {
        id: savePanel
        Button {
            id: saveButton
            text: "Save"
            enabled: false
            onClicked: {
                chartSaveDialog.visible = true
            }
        }
        Label {
            text: "Width:"
            anchors.verticalCenter: widthField.verticalCenter
        }
        IntNumField {
            id: widthField
            bottomValue: 1
            targetValue: chartView.width
            readOnly: maintainOutputSizeCheckBox.checked
            width: 100
        }
        Label {
            text: "Height:"
            anchors.verticalCenter: heightField.verticalCenter
        }
        IntNumField {
            id: heightField
            bottomValue: 1
            targetValue: chartView.height
            readOnly: maintainOutputSizeCheckBox.checked
            width: 100
        }
        CheckBox {
            id: maintainOutputSizeCheckBox
            checked: true
            onCheckedChanged: {
                if (checked) {
                    widthField.targetValue = Qt.binding(function(){ return chartView.width })
                    heightField.targetValue = Qt.binding(function(){ return chartView.height })
                } else {
                    widthField.targetValue = chartView.width
                    heightField.targetValue = chartView.height
                }
            }
            text: "Maintain Chart Size"
        }
    }

    ChartView {
        id: chartView
        anchors.top: savePanel.bottom
        width: parent.width
        height: 300
        anchors.bottom: parent.bottom
        antialiasing: true

        ValueAxis {
            id: axisY
            gridVisible: true
            tickCount: 5
            min: 0
            max: 1
        }

        ValueAxis {
            id: axisX
            gridVisible: true
            tickCount: 1
            min: 0
            max: 1
        }
    }

    Connections {
        target: projectHandler
        function onUpdateDailyInfectionsChartBegin(filename) {
            var DEFAULT_TITLE = "Daily Infected "
            dailyInfectionsWindow.title = DEFAULT_TITLE + filename
            axisY.max = 1
            axisX.max = 1
            chartView.removeAllSeries()
        }

        function onAddDailyInfectionSeries(name, series) {
            axisX.max = Math.max(axisX.max, series.length-1)
            var line = chartView.createSeries(ChartView.SeriesTypeLine, name, axisX, axisY)
            for (let i=0; i<series.length; ++i) {
                line.append(i, series[i])
                axisY.max = Math.max(axisY.max, series[i])
            }
            projectHandler.addNextDailyInfectionSeries()
        }

        function onUpdateDailyInfectionsChartDone() {
            saveButton.enabled = chartView.count > 0
        }
    }
}
