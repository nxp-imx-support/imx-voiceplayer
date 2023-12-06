/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Copyright 2022 NXP
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
import com.nxp.voiceplayer 1.0

Item {
    id: root

    /*
    required property MediaPlayer mediaPlayer
    property alias muted: audio.muted
    property alias volume: audio.volume
    */
    //model: mediaPlayer
    //required property MediaPlayerMediaPlayerWrapper //mediaPlayerMediaPlayerWrapper
    property int mediaPlayerState: MediaPlayerWrapper.mediaPlayerState
    height: frame.height

    opacity: 1

    Behavior on opacity { NumberAnimation { duration: 300 }}

    function updateOpacity() {
        if (playbackControlHoover.hovered || mediaPlayerState != MediaPlayerWrapper.PlayingState)
            root.opacity = 1;
        else
            root.opacity = 1; // 0; TODO: enable opacity change when HoverHandle is fixed
    }

    /* TODO
    Connections {
        target: MediaPlayerWrapper
        function onPlaybackStateChanged() { updateOpacity() }
        //function onHasVideoChanged() { updateOpacity() }
    }
    */

    HoverHandler {
        id: playbackControlHoover
        margin: 50
        onHoveredChanged: updateOpacity()
    }

    Frame {
        id: frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        background: Rectangle {
            color: "white"
        }

        ColumnLayout {
            id: playbackControlPanel
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10


            PlaybackSeekControl {
                Layout.fillWidth: true
            //    mediaPlayer: root.mediaPlayer
            }

            RowLayout {
                id: playerButtons

                Layout.fillWidth: true

                PlaybackRateControl {
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 150
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //mediaPlayer: root.mediaPlayer
                }

                Item {
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.alignment: Qt.AlignCenter
                    id: controlButtons

                    RoundButton {
                        id: pauseButton
                        radius: 50.0
                        icon.source: "qrc:/rsc/pause.svg"
                        onClicked: MediaPlayerWrapper.onPause()
                    }

                    RoundButton {
                        id: playButton
                        radius: 50.0
                        text: "\u25B6";
                        onClicked: MediaPlayerWrapper.onPlay()

                    }

                    RoundButton {
                        id: stopButton
                        radius: 50.0
                        text: "\u25A0";
                        onClicked: MediaPlayerWrapper.onStop()
                    }


                    RoundButton {
                        id: nextButton
                        radius: 60.0
                        icon.source: "qrc:/rsc/forward-step.svg"
                        onClicked: MediaPlayerWrapper.onNext()
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                AudioControl {
                    id: audio
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 150
                    Layout.fillWidth: true
                    //mediaPlayer: root.mediaPlayer
                }
            }
        }
    }

    states: [
        State {
            name: "playing"
            when: mediaPlayerState == MediaPlayerWrapper.PlayingState
            PropertyChanges { target: pauseButton; visible: true}
            PropertyChanges { target: playButton; visible: false}
            PropertyChanges { target: stopButton; visible: true}
            PropertyChanges { target: nextButton; visible: true}
        },
        State {
            name: "stopped"
            when: mediaPlayerState == MediaPlayerWrapper.StoppedState
            PropertyChanges { target: pauseButton; visible: false}
            PropertyChanges { target: playButton; visible: true}
            PropertyChanges { target: stopButton; visible: false}
            PropertyChanges { target: nextButton; visible: true}
        },
        State {
            name: "paused"
            when: mediaPlayerState == MediaPlayerWrapper.PausedState
            PropertyChanges { target: pauseButton; visible: false}
            PropertyChanges { target: playButton; visible: true}
            PropertyChanges { target: stopButton; visible: true}
            PropertyChanges { target: nextButton; visible: true}
        }
    ]

}

