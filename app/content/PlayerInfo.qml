/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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

Item {
    id: root
    implicitWidth: 200

    Frame {

        id: frameRoot
        anchors.fill: parent
        padding: 15

        background: Rectangle {
            color: "lightgray"
            opacity: 0.7
        }

        Text {
            id: showPlayerInfo
            visible: true
            font.italic: true
            font.pixelSize: 10
            text: qsTr("Help -> PlayerInfo \n     to show this view")
        }

        Text {
            x: 0
            y: 52
            visible: true
            font.pixelSize: 7
            text: qsTr("Connect to: ");
        }
        Text {
            id: deviceName
            x: 45
            y: 52
            visible: true
            font.pixelSize: 7
            text: MediaPlayerWrapper.device
        }

        Rectangle
        {
            x:0
            y:65
            width: 200
            height: 300
            anchors.top: deviceName.bottom
            anchors.topMargin: 7
            color: 'transparent'
            /*color: 'teal'
            Image {
                x: 0
                y: layout.height/2
                source: "../rsc/voice.png"
                sourceSize.width: 50
                sourceSize.height: 60
            }*/
            Text {
                id: deviceConnected
                x: 10
                y: 10
                visible: true
                font.bold:true
                font.pointSize: 6
                text:
                "WakeWord supported :"+
                    "\n    'HEY NXP'\n"+
                "Voice commands supported :"+
                    "\n    PLAY MUSIC"+
                    "\n    PAUSE"+
                    "\n    PREVIOUS SONG"+
                    "\n    NEXT SONG"+
                    "\n    VOLUME UP"+
                    "\n    VOLUME DOWN"+
                "\n    MUTE"+
                "\n    STOP"+
                "\n    STOP PLAYER"
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
