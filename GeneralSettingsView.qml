import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4

GridLayout {
    columns: 2
    columnSpacing: 10

    Label { text: "Number of trajectories:" }
    IntNumField {
        targetValue: generalSettings.num_trajectories
        onTargetValueChanged: generalSettings.num_trajectories = targetValue
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
        onTargetValueChanged: generalSettings.detection_mild_probability = targetValue
    }
    Label { text: "Stop simulation treshold:" }
    IntNumField {
        targetValue: generalSettings.stop_simulation_threshold
        onTargetValueChanged: generalSettings.stop_simulation_threshold = targetValue
    }
}
