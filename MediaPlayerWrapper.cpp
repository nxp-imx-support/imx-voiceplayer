///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "MediaPlayerWrapper.h"
#include <QDebug>
#include <QQmlContext>
#include <iostream>
#include <QProcess>

///////////////////////////////////////////////////////////////////////////////
MediaPlayerWrapper::MediaPlayerWrapper(QObject *parent) : QObject(parent)
  , MediaIndex(0)
  , Seekable(true)
  , MediaTime(0.0)
  , CurrentMedia(new MediaTrackInfo())
  , ConsoleProcess(new QProcess())
  , BtEnabled(true)
{
    QProcess process;
    process.startDetached("/bin/sh", QStringList()<< "/opt/Btplayer/bin/bt-init.sh");
    process.waitForFinished();

    // Using Bt as default source
    QString source = BtEnabled ? "Bluetooth" : "USB";
    ConsoleProcess->startDetached("/bin/sh", QStringList()<< "/opt/Btplayer/bin/bt-usb.sh" << source);
    ConsoleProcess->waitForFinished();


    BtProcess = new QProcess();
    BtProcess->start("/usr/bin/bluetooth-player");

    qDebug() << "trying to connected media player";
    BtPlayer = new MediaPlayerProxy();

    QObject::connect(BtPlayer, &MediaPlayerProxy::MediaTrackInfoSignal,
            this, &MediaPlayerWrapper::setMediaTrack);
}

MediaPlayerWrapper::~MediaPlayerWrapper()
{
    BtProcess->write("quit");
    BtProcess->waitForFinished();
    delete BtProcess;
    delete BtPlayer;
    delete ConsoleProcess;
}

///////////////////////////////////////////////////////////////////////////////
bool MediaPlayerWrapper::initialize()
{
    resetModel();
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    Engine.load(url);
    if(Engine.rootObjects().isEmpty())
        return false;
    return true;
}

QList<QObject *> MediaPlayerWrapper::getMediaList() const
{
    return MediaList;
}

void MediaPlayerWrapper::onPlay()
{
    if (BtProcess)
    {
        qDebug() << "onPlay";
        BtPlayer->play();
    }
}

void MediaPlayerWrapper::onPause()
{
    if (BtProcess)
    {
        qDebug() << "onPause";
        BtPlayer->pause();
    }
}

void MediaPlayerWrapper::onStop()
{
    if (BtProcess)
    {
        qDebug() << "onStop";
        BtPlayer->stop();
    }
}

void MediaPlayerWrapper::onNext()
{
    if (BtProcess)
    {
        qDebug() << "onNext";
        BtPlayer->next();
    }
}

void MediaPlayerWrapper::onBluetoothEnabled()
{
    qDebug() << "Bt enabled: ..." << (BtEnabled ? "true" : "false");
    if(BtEnabled)
    {
        qDebug() << "Bt start...";
        ConsoleProcess->startDetached("/bin/sh", QStringList()<< "/opt/BtPlayer/bin/connect.sh");
        ConsoleProcess->waitForFinished();
        return;
    }
    qDebug() << "Bt restarted";
}

void MediaPlayerWrapper::onBluetoothDisabled()
{
    if(BtEnabled)
    {
        BtEnabled = false;
    }
}

int MediaPlayerWrapper::PlayingState()
{
    return m_PlayingState;
}

void MediaPlayerWrapper::SetPlayingState(const int value)
{
    m_PlayingState = value;
}

void MediaPlayerWrapper::playingStateChanged()
{
}

double MediaPlayerWrapper::PlayerMediaTime()
{
    return MediaTime;
}

void MediaPlayerWrapper::SetPlayerMediaTime(const double mediaTime)
{
    MediaTime = mediaTime;
}

bool MediaPlayerWrapper::PlayerSeekable()
{
    return Seekable;
}

void MediaPlayerWrapper::SetPlayerSeekable(const bool value)
{
    Seekable = value;
}

void MediaPlayerWrapper::setPlaybackRate(double value)
{
    playbackRate = value;
}

void MediaPlayerWrapper::setMediaList(const QList<QObject *> &value)
{
    MediaList = value;
}

void MediaPlayerWrapper::setMediaTrack(const MediaTrackInfo &media)
{
    // TODO:
    //Q_UNUSED(media);
    qDebug() << __func__;
    setArtist(media.artist());
    setAlbum(media.album());
    setTitle(media.song());
    setDuration(media.duration());
    //MediaList.append(media));
    //MediaIndex = MediaList.lenght();
}

void MediaPlayerWrapper::populateMediaListData()
{
   // MediaList.append(new Media("SongSample", "ArtistSample", "AlbumSample", "ArtSample", 4.00));
}

QString MediaPlayerWrapper::title() const
{
    return mSong;
}

QString MediaPlayerWrapper::artist() const
{
    return mArtist;
}

QString MediaPlayerWrapper::album() const
{
    return mAlbum;
}

float MediaPlayerWrapper::duration() const
{
    return mDuration;
}

void MediaPlayerWrapper::setTitle(QString song)
{
    mSong = song;
    emit titleChanged();
}

void MediaPlayerWrapper::setArtist(QString artist)
{
    mArtist = artist;
    emit artistChanged();
}

void MediaPlayerWrapper::setAlbum(QString album)
{
    mAlbum = album;
    emit albumChanged();
}

void MediaPlayerWrapper::setDuration(float duration)
{
    mDuration = duration;
    emit durationChanged();
}
// TODO: this approach is constly because model is reloaded on any change, must be called
// once a new MediaList Data is set (new BT device is paired and Media is transferd)
void MediaPlayerWrapper::resetModel()
{
    Engine.rootContext()->setContextProperty("MediaPlayerWrapper", this);
    Engine.rootContext()->setContextProperty("MediaTrackInfo", CurrentMedia);
    //Engine.rootContext()->setContextProperty("MediaModel", QVariant::fromValue(MediaList));
}
