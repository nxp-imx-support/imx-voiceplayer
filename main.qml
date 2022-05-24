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

    PlaybackControl {
        id: playbackControl
        
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
