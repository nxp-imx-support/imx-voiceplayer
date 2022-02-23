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
    //qmlRegisterType<Player>("com.nxp.btplayer", 1, 0, "mediaModel");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    MediaListWrapper mediaWrapper;
    if(!mediaWrapper.initialize())
        return -1;



    /*QQmlApplicationEngine engine;



    Player mPlayer;
    QList<QObject *> mediaList;
    mediaList.append(new Media("SongSample", "ArtistSample", "AlbumSample", "ArtSample", 4.00));
    //mediaList.append(new Media("SongSample1", "ArtistSample1", "AlbumSample1", "ArtSample1", 4.10));
    //mediaList.append(new Media("SongSample2", "ArtistSample2", "AlbumSample2", "ArtSample2", 4.20));
    //mediaList.append(new Media("SongSample3", "ArtistSample3", "AlbumSample3", "ArtSample3", 4.30));

    engine.rootContext()->setContextProperty("PlayerModel", QVariant::fromValue(&mPlayer));
    engine.rootContext()->setContextProperty("mediaModel", QVariant::fromValue(mediaList));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
*/
    return app.exec();
}

    /*if(engine.rootObjects().isEmpty())
        return -1;*/
