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
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: root

    required property PlayerInfo playerInfo
    height: menuBar.height

    signal closePlayer

    function loadUrl(url) {
        mediaPlayer.stop()
        mediaPlayer.source = url
        mediaPlayer.play()
    }

    function closeOverlays(){
        playerInfo.visible = false;
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

    Dialog {
        id: aboutDemoRoot
        width: 350
        height: 200
        anchors.centerIn: Overlay.overlay
        title: qsTr("i.MX Multimedia Player Licensing")
        standardButtons: Dialog.Ok
        modal: true
        visible: false

       RowLayout {
            id: layout
            anchors.fill: parent
            spacing: 10

            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: 100
                Layout.minimumHeight: 100
                color: "transparent"

                Label {
                    x: 0
                    y: 14
                    font.pointSize: 7
                    wrapMode: Text.WordWrap
                    font.bold: true
                        text: qsTr("QT Interface:");
                }
                Label {
                    x: 0
                    y: 28
                    font.pointSize:7
                    wrapMode: Text.WordWrap
                    text: qsTr("The Qt Company Ltd. (BSD-3-Clause)");
                }
                Label {
                    x: 0
                    y: 42
                    font.pointSize:7
                    wrapMode: Text.WordWrap
                    text: qsTr("Uses Qt libraries under LGPL-3.0-only License");
                }
                Label {
                    x: 0
                    y: 60
                    anchors.centerIn: parent.height
                    font.italic: true
                    font.pointSize:7
                    color: 'gray'
                    text: "Copyright 2022-2023 NXP"
                    }
            }
       }
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: qsTr("&Home")
            Action {
                text: qsTr("&Exit");
                onTriggered: closePlayer()
            }
        }

        Menu {
            title: qsTr("&Help")
            Action {
                text: qsTr("&PlayerInfo")
                onTriggered: showOverlay(playerInfo)
            }
            Action {
                text: qsTr("&About")
                onTriggered: aboutDemoRoot.open()
            }
        }   
    }
}
