import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    property var client: null
    property var tempSubscription: null

    function addMessage(payload) {
        receiveMessageText.append(payload)
    }

    GridLayout {
        anchors.margins: 8
        anchors.fill: parent
        columns: 4
        enabled: client.connected
        id: topicLayout

        Label {
            Layout.columnSpan: 1
            text: "Topic:"
        }

        TextField {
            Layout.columnSpan: 2
            id: subField
            selectByMouse: true
            placeholderText: "<Subscription topic>"
            Layout.fillWidth: true
        }

        Button {
            Layout.columnSpan: 1
            id: subButton
            text: tempSubscription === null ? "Subscribe" : "Unsubscribe"
            onClicked: {
                if (subField.text.length === 0) {
                    console.log("No topic specified to subscribe to.")
                } else {
                    if (tempSubscription === null) {
                        tempSubscription = client.subscribe(subField.text)
                        tempSubscription.messageReceived.connect(addMessage)
                    } else {
                        tempSubscription.destroy()
                        tempSubscription = null
                    }
                }
            }
        }

        ScrollView {
            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 4
            TextArea {
                implicitHeight: parent.height
                implicitWidth: parent.width
                id: receiveMessageText
                readOnly: true
            }
        }
    }

    Component.onDestruction: {
        if (tempSubscription != null) {
            tempSubscription.destroy()
            tempSubscription = null
        }
    }
}
