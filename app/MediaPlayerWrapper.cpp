/****************************************************************************
**
** Copyright 2022-2023 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#include "MediaPlayerWrapper.h"
#include <QDebug>
#include <QQmlContext>
#include <iostream>
#include <QProcess>
#include <QFile>


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
    process.startDetached("/bin/sh", QStringList()<< "/home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/bt-init.sh");
    process.waitForFinished();

    // Using Bt as default source
    //QString source = BtEnabled ? "Bluetooth" : "USB";

    MQThread = new MQueueThread();
    MQThread->start(QThread::HighPriority);

    BtProcess = new QProcess();
    BtProcess->start("/usr/bin/bluetooth-player");


    QObject::connect(MQThread,&MQueueThread::emitMacAddress,
            this, &MediaPlayerWrapper::setMacAdrees);

    QFile file("/home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/device.txt");
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QTextStream in(&file);
    setDevice(in.readLine());
}

///////////////////////////////////////////////////////////////////////////////
MediaPlayerWrapper::~MediaPlayerWrapper()
{
    BtProcess->write("quit");
    BtProcess->waitForFinished();
    
    if (system("bluetoothctl disconnect") < 0)
    	qDebug() << "BTCtl disconnection fail";
    if (system("killall btp_vit") < 0)
	qDebug() << "VIT termination fail";
    if (system("sh Restore_AFEConfig.sh") <0)
        qDebug() << "AFE restore fail";
        
    delete BtProcess;
    delete Player;
    delete ConsoleProcess;
}

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
        Player->play();
        Player->volume();
    }
}

void MediaPlayerWrapper::onPause()
{
    if (BtProcess)
    {
        qDebug() << "onPause";
        Player->pause();
    }
}

void MediaPlayerWrapper::onStop()
{
    if (BtProcess)
    {
        qDebug() << "onStop";
        Player->stop();
    }
}

void MediaPlayerWrapper::onNext()
{
    if (BtProcess)
    {
        qDebug() << "onNext";
        Player->next();
    }
}

void MediaPlayerWrapper::volumeUp()
{
        qDebug() << __func__;
        Player->volumeUp();

}

void MediaPlayerWrapper::volumeDown()
{
        qDebug() << __func__;
        Player->volumeDown();

}

void MediaPlayerWrapper::onBluetoothEnabled()
{
    qDebug() << "Bt start...";
    ConsoleProcess->startDetached("/bin/sh", QStringList()<< "/home/root/.nxp-demo-experience/scripts/multimedia/imx-voiceplayer/connect.sh");
    ConsoleProcess->waitForFinished();
    qDebug() << "Bt restarted";
    BtEnabled = true;
}

void MediaPlayerWrapper::onBluetoothDisabled()
{
    if (system("bluetoothctl disconnect") < 0)
        qDebug() << "Bluetooth disabled fail";	
    BtEnabled = false;
}

int MediaPlayerWrapper::PlayingState()
{
    return m_PlayingState;
}

void MediaPlayerWrapper::SetPlayingState(const int value)
{
    m_PlayingState = value;
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
    qDebug() << __func__;
    setArtist(media.artist());
    setAlbum(media.album());
    setTitle(media.song());
    setDuration(media.duration());
}

void MediaPlayerWrapper::setMediaTrackPosition(const quint32 position)
{
    mPosition = position;
    emit positionChanged();
}

void MediaPlayerWrapper::setMacAdrees(QString mac)
{
    mMac = mac;
    qDebug() << "MD MAC: " << mMac;


    qDebug() << "trying to connected media player";
    Player = new MediaPlayerProxy(mMac);

    QObject::connect(Player, &MediaPlayerProxy::MediaTrackInfoSignal,
            this, &MediaPlayerWrapper::setMediaTrack);
    QObject::connect(Player, &MediaPlayerProxy::MediaTrackVolumeSignal,
            this, &MediaPlayerWrapper::setVolume);
    QObject::connect(Player, &MediaPlayerProxy::MediaTrackPositionSignal,
            this, &MediaPlayerWrapper::setPosition);
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

QString MediaPlayerWrapper::device() const
{
    return mDevice;
}

float MediaPlayerWrapper::duration() const
{
    return mDuration;
}

int MediaPlayerWrapper::position() const
{
    return mPosition;
}

int MediaPlayerWrapper::volume() const
{
    return mVolume;
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

void MediaPlayerWrapper::setPosition(int position)
{
    mPosition = position;
    emit positionChanged();
}

void MediaPlayerWrapper::setVolume(int volume)
{
    qDebug() << __func__ << mVolume << " to " << volume ;
    if(volume != mVolume)
    {
        mVolume = volume;
        emit volumeChanged();
    }
}

void MediaPlayerWrapper::setDevice(QString device)
{
    mDevice = "i.MX-MultimediaPlayer";
    emit deviceChanged();

}
// TODO: this approach is constly because model is reloaded on any change, must be called
// once a new MediaList Data is set (new BT device is paired and Media is transferd)
void MediaPlayerWrapper::resetModel()
{
    Engine.rootContext()->setContextProperty("MediaPlayerWrapper", this);
    Engine.rootContext()->setContextProperty("MediaTrackInfo", CurrentMedia);
}
