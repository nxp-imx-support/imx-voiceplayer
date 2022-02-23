///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import com.nxp.btplayer 1.0
//import QtQuick.Controls.Material 2.3
//import QtQml.Models 2.12
//import QtQml 2.12


Window {
    visible: true
    width: 640
    height: 480
    color: "black";
    title: qsTr("BT Player")

    ListView {
        id: mListView
        anchors.fill: parent
        model: MediaModel
        delegate: Rectangle {
            //color: "gray"
            width: parent.width
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                TextField{
                    text : song
                    Layout.fillWidth: false
                }
                TextField{
                    text : artist
                    Layout.fillWidth: false
                }
                TextField{
                    text : album
                    Layout.fillWidth: false
                }
           }
           MouseArea {
                anchors.fill: parent
              Row {
                id: controller;
                anchors.top: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.topMargin: 300;
                spacing: 4;

                Button {
                    width: 100;
                    height: 50;
                    text: "Back"
                    id: buttonBack
                    onClicked: Wrapper.onBack()
                    //onClicked:
                    //icon.name: "buttonBack";
                    //icon.source: "img/back.png";
                    //onClicked: if(player.seekable)player.seek(player.position - 5000);
                }
                Button {
                    width: 100;
                    height: 50;
                    text: "Play"
                    id: buttonPlay
                    onClicked: Wrapper.onPlay()
                    //onClicked:
                    //icon.name: "buttonPlay";
                    //icon.source: "img/play.png";
                    //onClicked: if(player.seekable)player.seek(player.position - 5000);
                }
                Button {
                    width: 100;
                    height: 50;
                    text: "Pause"
                    id: buttonPause
                    onClicked: Wrapper.onPause()
                    //onClicked: PlayerModel.pause()
                    //icon.name: "buttonPause";
                    //icon.source: "img/pause.png";
                    //onClicked: if(player.seekable)player.seek(player.position - 5000);
                }
                Button {
                    width: 100;
                    height: 50;
                    text: "Next"
                    id: buttonForward
                    onClicked: Wrapper.onNext()
                    //onClicked: PlayerModel.next()
                    //icon.name: "buttonForward";
                    //icon.source: "img/forward.png";
                    //onClicked: if(player.seekable)player.seek(player.position - 5000);
                }
            }
           }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            //Qt.quit();
        }

        ListView {
            //model: PlayerModel
            anchors.fill: parent

            //color: "black";
            delegate: Rectangle {
            Text {
                anchors.centerIn: parent
                text: "NXP BT Player"
                color: "white";
                anchors.verticalCenterOffset: -204
                anchors.horizontalCenterOffset: -250
            }
            Text {
                //anchors.centerIn: parent
                color: "gray"
                anchors.verticalCenterOffset: -204
                anchors.horizontalCenterOffset: -270
                //text: getmpSongName //SongName
            }
            }
            /*Rectangle
            {
                width: parent.width
                //required property string PlayerModel.mpSongName: "song";


            }*/

        }


    }
}
