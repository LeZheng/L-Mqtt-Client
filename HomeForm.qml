import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import Qt.labs.settings 1.1

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("L Mqtt Client")

    property var sessionMap: new Object
    property var currentIndex: 0
    property var currentSessionForm: sideLoader.active ? sideLoader.item : mainLoader.item

    property var model: ListModel {
        id: sessionModel
        ListElement {
            host: "47.98.104.64"
            port: "1883"
            clientId: "a-1d251c10-a772-476e-98b7-e0b50329"
            username: "ObJ4mEJRrnyVY6H6osW6"
            password: "904be5db50b8935e7fb3a7ecacf1f18493764ab377537d3bc5683641e6bd3961"
        }
        ListElement {
            host: "47.98.104.64"
            port: "1883"
            clientId: "w-YYOYovCH8cB02VxH3WAa"
            username: "uoo514-YYOYovCH8cB02VxH3WAa"
            password: "2a1fbf4d2b4482200d89ea7bbd1e4d161fe504c5"
        }
    }

    Settings {
        id: sessionSetting
        property var sessions: []
    }

    Component.onCompleted: {
        if (sessionSetting.sessions.length > 0) {
            model.clear()
        }
        for (var i = 0; i < sessionSetting.sessions.length; i++) {
            model.append(JSON.parse(sessionSetting.sessions[i]))
        }
    }

    Component.onDestruction: {
        var sesssionArray = []
        for (var i = 0; i < model.count; i++) {
            sesssionArray.push(JSON.stringify(model.get(i)))
        }
        sessionSetting.sessions = sesssionArray
    }

    function changeCurrentSession() {
        currentIndex = window.currentSessionForm.currentIndex
        if (currentIndex < model.count) {
            var session = model.get(currentIndex)
            var currentClientId = session.clientId
            if (sessionMap.hasOwnProperty(currentClientId)) {
                for (var i = 0; i < sessionLayout.count; i++) {
                    if (sessionMap[currentClientId] === sessionLayout.children[i]) {
                        sessionLayout.currentIndex = i
                        break
                    }
                }
            } else {
                addSession(session)
            }
            titleLabel.text = currentClientId
        }
    }

    function addSession(session) {
        var sessionForm = Qt.createComponent("SessionForm.qml").createObject(
                    sessionLayout, {
                        "sessionInfo": session
                    })
        sessionMap[session.clientId] = sessionForm
    }

    header: ToolBar {
        contentHeight: menuButton.implicitHeight

        ToolButton {
            id: menuButton
            icon.source: "img/menu"
            icon.color: "white"
            visible: sideLoader.active
            onClicked: {
                drawer.open()
            }
        }

        Label {
            id: titleLabel
            anchors.centerIn: parent
        }
    }

    Drawer {
        id: drawer
        width: window.width > window.height ? window.width * 0.33 : window.width * 0.66
        height: window.height

        Loader {
            id: sideLoader
            anchors.fill: parent
            active: window.width < 960
            asynchronous: true
            source: "SessionListForm.qml"
            visible: status == Loader.Ready

            onLoaded: {
                currentSessionForm = sideLoader.item
                sideLoader.item.sessionModel = model
                sideLoader.item.currentIndex = currentIndex
            }
        }

        Connections {
            target: sideLoader.item
            onCurrentIndexChanged: changeCurrentSession()
            onSessionAdded: addSession(session)
        }
    }

    SplitView {
        id: contentView
        anchors.fill: parent

        Loader {
            id: mainLoader
            SplitView.minimumWidth: 200
            SplitView.preferredWidth: 320

            active: window.width >= 960
            asynchronous: true
            source: "SessionListForm.qml"
            visible: status == Loader.Ready

            onLoaded: {
                currentSessionForm = mainLoader.item
                mainLoader.item.sessionModel = model
                mainLoader.item.currentIndex = currentIndex
            }
        }

        Connections {
            target: mainLoader.item
            onCurrentIndexChanged: changeCurrentSession()
            onSessionAdded: addSession(session)
        }

        StackLayout {
            id: sessionLayout
            clip: true
            SplitView.minimumWidth: 200
        }
    }
}
