///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "medialistwrapper.h"
#include <QDebug>
#include <QQmlContext>
#include <iostream>
#include <QProcess>

///////////////////////////////////////////////////////////////////////////////
MediaListWrapper::MediaListWrapper(QObject *parent) : QObject(parent)
  , MediaIndex(0)
  , Seekable(true)
  , MediaTime(0.0)
{
    populateMediaListData();
    m_PlayingState = stopedState;
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
    qDebug() << "onPlay";
    std::cout << "onPlay: " << MediaIndex;

    QProcess process;
    process.startDetached("/bin/sh", QStringList()<< "/home/root/test.sh HEADPHONE");
    emit onPlaybackStateChange();

}

void MediaListWrapper::onPause()
{
    qDebug() << "onPause";
    std::cout << "onPause: " << MediaIndex;
    emit onPlaybackStateChange();

}

void MediaListWrapper::onBack()
{
    qDebug() << "onBack";
    if(not((MediaIndex -1) < 0 ))
        MediaIndex--;
    std::cout << "onBack: " << MediaIndex;
    emit onPlaybackStateChange();
}

void MediaListWrapper::onNext()
{
    qDebug() << "onNext";
    if(not((MediaIndex +1 ) > MediaList.length()) )
        MediaIndex++;
    std::cout << "onNext: " << MediaIndex;
    emit onPlaybackStateChange();
}

void MediaListWrapper::onBluetoothEnabled()
{
    qDebug() << "Bt start scanning...";
    mDeviceDiscovery = new DeviceDiscovery();

    if(mDeviceDiscovery)
    {
        mDeviceDiscovery->startScan();
    }

}

int MediaListWrapper::PlayingState()
{
    return m_PlayingState;
}

void MediaListWrapper::SetPlayingState(const int value)
{
    m_PlayingState = value;
}

void MediaListWrapper::playingStateChanged()
{
}

double MediaListWrapper::PlayerMediaTime()
{
    return MediaTime;
}

void MediaListWrapper::SetPlayerMediaTime(const double mediaTime)
{
    MediaTime = mediaTime;
}

bool MediaListWrapper::PlayerSeekable()
{
    return Seekable;
}

void MediaListWrapper::SetPlayerSeekable(const bool value)
{
    Seekable = value;
}

void MediaListWrapper::setPlaybackRate(double value)
{
    playbackRate = value;
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
    Engine.rootContext()->setContextProperty("MediaPlayerWrapper", this);
    Engine.rootContext()->setContextProperty("MediaModel", QVariant::fromValue(MediaList));
}
