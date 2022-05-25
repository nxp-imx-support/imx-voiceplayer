//////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
//////////////////////////////////////////////////////////////////////////////

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import com.nxp.btplayer 1.0
import "content"

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("NXP Multimedia Player")

    Popup {
        id: mediaError
        anchors.centerIn: Overlay.overlay
        Text {
            id: mediaErrorText
        }
    }

    function convertDoubleToInt (x) {
        return x < 0 ? Math.ceil(x) : Math.floor(x);
    }




    Rectangle {
            width: root.width
            height: root.height/7

            Rectangle{
                id: stripe1
                anchors.top: parent.top
                color: "#f9b500"
                anchors.left: parent.left
                width: convertDoubleToInt(root.width * 0.2923)
                height: convertDoubleToInt(root.height * 0.008)
            }

            Rectangle{
                id: stripe2
                anchors.top: parent.top
                color: "#928647"
                anchors.left: stripe1.right
                width: convertDoubleToInt(root.width * 0.081)
                height: convertDoubleToInt(root.height * 0.008)
            }
            Rectangle{
                id: stripe3
                anchors.top: parent.top
                color: "#7bb1db"
                anchors.left: stripe2.right
                width: convertDoubleToInt(root.width * 0.2367)
                height: convertDoubleToInt(root.height * 0.008)
            }
            Rectangle{
                id: stripe4
                anchors.top: parent.top
                color: "#6d9b46"
                anchors.left: stripe3.right
                width: convertDoubleToInt(root.width * 0.1397)
                height: convertDoubleToInt(root.height * 0.008)
            }
            Rectangle{
                id: stripe5
                anchors.top: parent.top
                color: "#c9d200"
                anchors.left: stripe4.right
                anchors.right: parent.right
                height: convertDoubleToInt(root.height * 0.008)
            }
    }

    PlayerMenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right
        x: 10
        y: 10

        onClosePlayer: root.close()
    }

    PlaybackControl {
        id: playbackControl
        
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
