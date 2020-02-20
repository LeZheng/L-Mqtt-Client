import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import MqttClient 1.0

Item {
    id: root
    width: parent.width
    height: parent.height

    property var sessionInfo: new Object

    Component.onCompleted: {
        client.connectToHost()
    }

    MqttClient {
        id: client
        hostname: root.sessionInfo.host
        port: root.sessionInfo.port
        clientId: root.sessionInfo.clientId
        username: root.sessionInfo.username
        password: root.sessionInfo.password

        onMessageReceived: {
            teConsole.append("receive topic[%1] message[%2]".arg(
                                 topic.name).arg(String(message)))
        }

        onConnected: {
            teConsole.append("connected to %1:%2".arg(hostname).arg(port))
        }

        onDisconnected: {
            teConsole.append("disconnect to %1:%2".arg(hostname).arg(port))
        }
    }

    Component {
        id: tabComponent

        TabButton {}
    }
    RowLayout {
        height: 50
        width: parent.width
        id: headerLayout

        ToolButton {
            id: connectButton
            Layout.fillHeight: true
            Layout.minimumWidth: 120
            text: client.state == MqttClient.Connected ? "Disconnect" : "Connect"
            icon.source: client.state == MqttClient.Connected ? "img/disconnect" : "img/connect"
            icon.color: "white"
            onClicked: {
                if (client.state == MqttClient.Connected) {
                    client.disconnectFromHost()
                } else {
                    client.connectToHost()
                }
            }
        }

        TabBar {
            id: headTabBar
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ToolButton {
            id: addButton
            Layout.fillHeight: true
            Layout.preferredWidth: height
            icon.source: "img/add"
            icon.color: "white"

            onClicked: {
                addMenu.popup(addButton)
            }
        }

        Menu {
            id: addMenu
            Action {
                text: "add Publisher"
                onTriggered: {
                    var form = Qt.createComponent(
                                "PublisherForm.qml").createObject(formsView, {
                                                                      "client": client
                                                                  })
                    formsView.addItem(form)
                    var button = tabComponent.createObject(headTabBar, {
                                                               "text": "publisher"
                                                           })
                    headTabBar.addItem(button)
                    button.checked = true
                }
            }
            Action {
                text: "add Subscriber"
                onTriggered: {
                    var form = Qt.createComponent(
                                "SubscriberForm.qml").createObject(formsView, {
                                                                       "client": client
                                                                   })
                    formsView.addItem(form)
                    var button = tabComponent.createObject(headTabBar, {
                                                               "text": "subscriber"
                                                           })
                    headTabBar.addItem(button)
                    button.checked = true
                }
            }

            enter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 180
                }
                PropertyAnimation {
                    property: "height"
                    from: 0
                    to: addMenu.height
                    duration: 180
                }
            }
            exit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1.0
                    to: 0.0
                    duration: 180
                }
            }
        }
    }

    SwipeView {
        id: formsView
        clip: true
        height: 300
        width: parent.width
        anchors.top: headerLayout.bottom
        anchors.bottom: bottomRect.top
        currentIndex: headTabBar.currentIndex
        interactive: true

        onCurrentIndexChanged: {
            headTabBar.currentIndex = currentIndex
        }
    }

    Item {
        id: bottomRect
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height / 3

        ColumnLayout {
            anchors.margins: 8
            anchors.fill: parent

            Label {
                id: labelConsole
                Layout.alignment: Qt.AlignLeft
                anchors.leftMargin: 8
                text: "Console"
            }

            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                TextArea {
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    id: teConsole
                    selectByMouse: true
                    readOnly: true
                    focus: false
                }
            }
        }
    }
}
