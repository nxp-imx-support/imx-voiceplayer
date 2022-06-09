
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: root

    height: menuBar.height

    signal closePlayer

    function loadUrl(url) {
        mediaPlayer.stop()
        mediaPlayer.source = url
        mediaPlayer.play()
    }

    function closeOverlays(){
        metadataInfo.visible = false;
        audioTracksInfo.visible = false;
        videoTracksInfo.visible = false;
        subtitleTracksInfo.visible = false;
    }

    function showOverlay(overlay){
        closeOverlays();
        overlay.visible = true;
    }

    Popup {
        id: urlPopup
        anchors.centerIn: Overlay.overlay

        RowLayout {
            id: rowOpenUrl
            Label {
                text: qsTr("URL:");
            }

            TextInput {
                id: urlText
                focus: true
                Layout.minimumWidth: 400
                wrapMode: TextInput.WrapAnywhere
                Keys.onReturnPressed: { loadUrl(text); urlText.text = ""; urlPopup.close() }
            }

            Button {
                text: "Load"
                onClicked: { loadUrl(urlText.text); urlText.text = ""; urlPopup.close() }
            }
        }
        onOpened: { urlPopup.forceActiveFocus() }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            mediaPlayer.stop()
            mediaPlayer.source = fileDialog.currentFile
            mediaPlayer.play()
        }
    }

    Popup {
        id: btPopup
        anchors.centerIn: Overlay.overlay
        RowLayout {
            id: btStartScan

            Label {
                text: qsTr("Bluetooth Src");
            }
            Switch {
                id: btOn
                checked: true
                onClicked:
                {
                   if (btOn.checked)
                       return MediaPlayerWrapper.onBluetoothEnabled()
                   return MediaPlayerWrapper.onBluetoothDisabled()
                }
            }
            Label {
                text: btOn.checked ? "On" : "Off"
            }
        }
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: qsTr("&Source")
            Action {
                text: qsTr("&File")
                onTriggered: fileDialog.open()
            }
            Action {
                text: qsTr("&USB");
                onTriggered: urlPopup.open()
            }
            Action {
                text: qsTr("&Bluetooth")
                onTriggered: btPopup.open()
            }
            Action {
                text: qsTr("&Exit");
                onTriggered: closePlayer()
            }
        }

        Menu {
            title: qsTr("&View")
            Action {
                text: qsTr("Metadata")
                onTriggered: showOverlay(metadataInfo)
            }
        }

        Menu {
            title: qsTr("&Tracks")
            Action {
                text: qsTr("Audio")
                onTriggered: showOverlay(audioTracksInfo)
            }
            Action {
                text: qsTr("Video")
                onTriggered: showOverlay(videoTracksInfo)
            }
            Action {
                text: qsTr("Subtitles")
                onTriggered: showOverlay(subtitleTracksInfo)
            }
        }
    }
}
