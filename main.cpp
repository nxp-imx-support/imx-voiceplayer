///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <iostream>
#include "MediaPlayerProxy.h"
#include "MediaPlayerWrapper.h"


int main(int argc, char *argv[])
{
    std::cout << "Start MediaPlayer..." << std::endl;
    qmlRegisterType<MediaPlayerProxy>("com.nxp.btplayer", 1, 0, "PlayerModel");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    MediaPlayerWrapper mediaPlayer;
    if(!mediaPlayer.initialize())
        return -1;

    return app.exec();
}
