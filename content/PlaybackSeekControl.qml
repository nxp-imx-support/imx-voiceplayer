import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.nxp.btplayer 1.0

Item {
    id: root
    implicitHeight: 20

    RowLayout {
        anchors.fill: parent

        Text {
            id: mediaTime
            Layout.minimumWidth: 50
            Layout.minimumHeight: 18
            horizontalAlignment: Text.AlignRight
            text: {
                var m = Math.floor(MediaPlayerWrapper.duration / 60000)
                var ms = (MediaPlayerWrapper.duration / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }
        }

        Slider {
            id: mediaSlider
            Layout.fillWidth: true
            enabled: MediaPlayerWrapper.seekable
            to: 1.0
            value: MediaPlayerWrapper.position / MediaPlayerWrapper.duration

            onMoved: MediaPlayerWrapper.setPosition(value * MediaPlayerWrapper.duration)
        }
    }
}
