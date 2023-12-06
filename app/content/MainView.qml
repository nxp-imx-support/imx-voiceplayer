/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Copyright 2022-2023 NXP
** 
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import com.nxp.voiceplayer 1.0

Window {
    id: root
    width: 640
    height: 480
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - heigh / 2
    visible: true
    title: qsTr("i.MX Multimedia Player")

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
        x: 0
        y: 4
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right
        playerInfo: playerInfo
        onClosePlayer: root.close()
    }

    TapHandler {
        onTapped: {
            playerInfo.visible = false
        }
    }

    Rectangle {
        x: root.width/10
        y: root.height/3
        width: 400
        height: 150

        Image {
            id: image
            x: 10
            y: 10
            width: 100
            height: 100
            source: "qrc:/rsc/bluetooth.svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: title
            x: 140
            y: 28
            width: 129
            height: 16
            text: MediaPlayerWrapper.title
            font.pixelSize: 12
        }

        Text {
            id: artist
            x: 140
            y: 50
            width: 129
            height: 16
            text: MediaPlayerWrapper.artist
            font.pixelSize: 12
        }

        Text {
            id: album
            x: 140
            y: 72
            width: 124
            height: 16
            text: MediaPlayerWrapper.album
            font.pixelSize: 12
        }
    }

    PlayerInfo {
        id: playerInfo
        visible: true
        x: 404
        y: 0
        width: 221
        height: 300
        anchors.right: parent.right
        anchors.top: menuBar.bottom
        anchors.rightMargin: 15
        anchors.topMargin: 13
    }

    PlaybackControl {
        id: playbackControl
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Component.onCompleted:
    {
       root.show()
    }
}
