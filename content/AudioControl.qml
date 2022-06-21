
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property bool muted: false
    property real volume: volumeSlider.value/100.

    implicitHeight: buttons.height

    RowLayout {
        anchors.fill: parent

        Item {
            id: buttons

            width: muteButton.implicitWidth
            height: muteButton.implicitHeight

            RoundButton {
                id: muteButton
                radius: 50.0
                icon.source: muted ? "qrc:/rsc/Mute_Icon.svg" : "qrc:/rsc/Speaker_Icon.svg"
                onClicked: { muted = !muted }
            }
        }

        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            enabled: true
            to: 127.0
            value: MediaPlayerWrapper.volume
            onMoved: MediaPlayerWrapper.setVolume(value)
                /*{if( value > MediaPlayerWrapper.volume)
                {
                    console.log("value: ", value, "Wrapper.volume: ", MediaPlayerWrapper.volume);
                    return MediaPlayerWrapper.volumeUp()
                }
                return MediaPlayerWrapper.volumeDown()
            }*/

        }
    }
}
