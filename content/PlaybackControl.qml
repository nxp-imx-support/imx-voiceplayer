
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.nxp.btplayer 1.0

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
                        text: "\u2016";
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
                        text: "\u23ED";
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

