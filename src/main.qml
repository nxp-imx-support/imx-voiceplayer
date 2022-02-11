import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.12

// main window
Window {
    visible: true
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

	Rectangle {
		anchors.fill: parent
        color: "gray";
		Text {
			anchors.centerIn: parent
            text: "BT Player"
            anchors.verticalCenterOffset: -123
            anchors.horizontalCenterOffset: -195
        }

        Row {
            id: controller;
            anchors.top: parent.verticalCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.topMargin: 4;
            spacing: 4;

            Button {
                width: 100;
                height: 100;
                icon.name: "buttonBack";
                icon.source: "img/back.png";
                //onClicked: if(player.seekable)player.seek(player.position - 5000);
            }
            Button {
                width: 100;
                height: 100;
                icon.name: "buttonPlay";
                icon.source: "img/play.png";
                //onClicked: if(player.seekable)player.seek(player.position - 5000);
            }
            Button {
                width: 100;
                height: 100;
                icon.name: "buttonPause";
                icon.source: "img/pause.png";
                //onClicked: if(player.seekable)player.seek(player.position - 5000);
            }
            Button {
                width: 100;
                height: 100;
                icon.name: "buttonForward";
                icon.source: "img/forward.png";
                //onClicked: if(player.seekable)player.seek(player.position - 5000);
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
