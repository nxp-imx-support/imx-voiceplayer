///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "medialistwrapper.h"
#include <QDebug>
#include <QQmlContext>
#include <iostream>

///////////////////////////////////////////////////////////////////////////////
MediaListWrapper::MediaListWrapper(QObject *parent) : QObject(parent)
  , MediaIndex(0)
{
    populateMediaListData();
}

///////////////////////////////////////////////////////////////////////////////
bool MediaListWrapper::initialize()
{
    resetModel();
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    Engine.load(url);
    if(Engine.rootObjects().isEmpty())
        return false;
    return true;
}

QList<QObject *> MediaListWrapper::getMediaList() const
{
    return MediaList;
}

void MediaListWrapper::onPlay()
{
    qDebug() << "test";
    std::cout << "onPlay: " << MediaIndex;

}

void MediaListWrapper::onPause()
{
    std::cout << "onPause: " << MediaIndex;

}

void MediaListWrapper::onBack()
{
    if(not((MediaIndex -1) < 0 ))
        MediaIndex--;
    std::cout << "onBack: " << MediaIndex;
}

void MediaListWrapper::onNext()
{
    if(not((MediaIndex +1 ) > MediaList.length()) )
        MediaIndex++;
    std::cout << "onNext: " << MediaIndex;
}

void MediaListWrapper::setMediaList(const QList<QObject *> &value)
{
    MediaList = value;
}

void MediaListWrapper::setMediaTrack(const QObject &media)
{
    // TODO:
    //MediaList.append(media));
    //MediaIndex = MediaList.lenght();
}

void MediaListWrapper::populateMediaListData()
{
    MediaList.append(new Media("SongSample", "ArtistSample", "AlbumSample", "ArtSample", 4.00));
}

// TODO: this approach is constly because model is reloaded on any change, must be called
// once a new MediaList Data is set (new BT device is paired and Media is transferd)
void MediaListWrapper::resetModel()
{
    Engine.rootContext()->setContextProperty("Wrapper", this);
    Engine.rootContext()->setContextProperty("MediaModel", QVariant::fromValue(MediaList));
}
