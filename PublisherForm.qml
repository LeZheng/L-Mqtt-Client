import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property var client: null
    GridLayout {
        id: rootLayout
        enabled: client.connected
        anchors.fill: parent
        anchors.margins: 8
        columns: 4

        Label {
            text: "Topic:"
        }

        TextField {
            id: pubField
            selectByMouse: true
            Layout.fillWidth: true
            Layout.columnSpan: rootLayout.columns - 1
            placeholderText: "<Publication topic>"
        }

        Label {
            text: "QoS:"
        }

        ComboBox {
            id: qosItems
            Layout.fillWidth: true
            Layout.columnSpan: 2
            editable: false
            model: [0, 1, 2]
        }

        CheckBox {
            id: retain
            checked: false
            text: "Retain"
        }

        Label {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            text: "Message:"
        }

        Button {
            id: pubButton
            Layout.columnSpan: 1
            Layout.minimumWidth: 100
            text: "Publish"
            onClicked: {
                if (pubField.text.length === 0) {
                    console.log("No payload to send. Skipping publish...")
                } else {
                    client.publish(pubField.text, msgField.text,
                                   qosItems.currentText, retain.checked)
                }
            }
        }

        ScrollView {
            clip: true
            Layout.columnSpan: rootLayout.columns
            Layout.fillWidth: true
            Layout.fillHeight: true

            TextArea {
                id: msgField
                selectByMouse: true
                implicitHeight: parent.height
                implicitWidth: parent.width
                placeholderText: "<Publication message>"
            }
        }
    }
}
