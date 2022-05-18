///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <iostream>
#include "media.h"
#include "player.h"
#include "medialistwrapper.h"

int main(int argc, char *argv[])
{
    std::cout << "Start btplayer..." << std::endl;
    qmlRegisterType<Player>("com.nxp.btplayer", 1, 0, "PlayerModel");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    MediaListWrapper mediaWrapper;
    if(!mediaWrapper.initialize())
        return -1;

    return app.exec();
}
