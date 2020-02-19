import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Universal 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.14

Item {
    id: root
    clip: true

    property var currentIndex: 0
    property var sessionModel: null

    signal sessionAdded(var session)

    ListView {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        id: sessionList
        model: sessionModel
        delegate: sessionItem
        currentIndex: root.currentIndex

        highlight: Rectangle {
            border.color: "lightsteelblue"
            border.width: 2
            color: "transparent"
            radius: 5
        }
        focus: true

        footerPositioning: ListView.OverlayFooter
        footer: Item {
            height: 40
            width: parent.width

            Button {
                anchors.fill: parent
                text: "add session"
                icon.source: "img/list-add"
                icon.color: "white"
                onClicked: {
                    addSessionDialog.open()
                }
            }
        }
    }

    Component {
        id: sessionItem
        Item {
            height: 40
            width: parent.width
            ToolButton {
                id: clientIdText
                anchors.fill: parent
                text: clientId

                onClicked: {
                    root.currentIndex = index
                }
            }
        }
    }

    Dialog {
        id: addSessionDialog
        title: "add mqtt session"

        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok | Dialog.Cancel
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }

        onAccepted: {
            var session = {
                "host": hostText.text,
                "port": portText.text,
                "clientId": clientIdText.text,
                "username": usernameText.text,
                "password": passwordText.text
            }
            sessionModel.append(session)
            root.sessionAdded(session)
        }

        onOpened: {
            hostText.text = "47.98.104.64"
            portText.text = "1883"
            clientIdText.text = "w-YYOYovCH8cB02VxH3WAa"
            usernameText.text = "uoo514-YYOYovCH8cB02VxH3WAa"
            passwordText.text = "2a1fbf4d2b4482200d89ea7bbd1e4d161fe504c5"
        }

        Item {
            implicitWidth: Screen.width - 60
            implicitHeight: 250
            ColumnLayout {
                clip: true
                anchors.fill: parent

                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40
                    Label {
                        Layout.minimumWidth: 100
                        text: "host:"
                    }
                    TextField {
                        id: hostText
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40
                    Label {
                        Layout.minimumWidth: 100
                        text: "port:"
                    }
                    TextField {
                        id: portText
                        validator: IntValidator {
                            bottom: 1000
                            top: 65535
                        }
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40
                    Label {
                        Layout.minimumWidth: 100
                        text: "client id:"
                    }
                    TextField {
                        id: clientIdText
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40

                    Label {
                        Layout.minimumWidth: 100
                        text: "username:"
                    }
                    TextField {
                        id: usernameText
                        Layout.fillWidth: true
                        selectByMouse: true
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumHeight: 40
                    Label {
                        Layout.minimumWidth: 100
                        text: "password:"
                    }
                    TextField {
                        id: passwordText
                        Layout.fillWidth: true
                        echoMode: TextInput.Password
                        selectByMouse: true
                    }
                }
            }
        }
    }
}
