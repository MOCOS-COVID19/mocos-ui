import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Number of trajectories:" }
    TextField {
        text: generalSettings.num_trajectories
        onEditingFinished: generalSettings.num_trajectories = parseInt(text)
        validator: IntValidator{ bottom: 0 }
    }
    Label { text: "Population path:" }
    TextField {
        text: generalSettings.population_path
        onEditingFinished: generalSettings.population_path = text
    }
    Label { text: "Detection mild probability:" }
    DoubleNumField {
        topValue: 1.0
        targetValue: generalSettings.detection_mild_probability
        onTargetValueUpdated: generalSettings.detection_mild_probability = targetValue
    }
    Label { text: "Stop simulation treshold:" }
    TextField {
        text: generalSettings.stop_simulation_threshold
        onEditingFinished: generalSettings.stop_simulation_threshold = parseInt(text)
        validator: IntValidator{ bottom: 0 }
    }
}
