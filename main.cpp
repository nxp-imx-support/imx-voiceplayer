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
#include "MQueueThread.h"


int main(int argc, char *argv[])
{
    std::cout << "Start MediaPlayer..." << std::endl;
    qmlRegisterType<MediaPlayerProxy>("com.nxp.btplayer", 1, 0, "PlayerModel");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    MQueueThread* mqThread = new MQueueThread();
    MediaPlayerWrapper mediaPlayer;

    QObject::connect(mqThread,&MQueueThread::emitMacAddress,&mediaPlayer, &MediaPlayerWrapper::setMacAdrees);
    //connect(workerThread, &WorkerThread::finished, workerThread, &QObject::deleteLater);
    mqThread->start(QThread::HighPriority);

    if(!mediaPlayer.initialize())
        return -1;

    return app.exec();
}
