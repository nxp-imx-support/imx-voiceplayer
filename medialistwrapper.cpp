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
    if (BtProcess)
    {
        qDebug() << "onPlay";
        BtProcess->write("play\n");
        BtProcess->waitForBytesWritten();
        BtProcess->readAllStandardOutput();

        BtProcess->write("show\n");
        BtProcess->waitForBytesWritten();
        QString metadata(BtProcess->readAllStandardOutput());
        qDebug() << metadata;

    }
}

void MediaListWrapper::onPause()
{
    if (BtProcess)
    {
        qDebug() << "onPause";
        BtProcess->write("pause\n");
        BtProcess->waitForBytesWritten();
    }
}

void MediaListWrapper::onStop()
{
    if (BtProcess)
    {
        qDebug() << "onStop";
        BtProcess->write("stop\n");
        BtProcess->waitForBytesWritten();
    }
}

void MediaListWrapper::onNext()
{
    if (BtProcess)
    {
        qDebug() << "onNext";
        BtProcess->write("next\n");
        BtProcess->waitForBytesWritten();
    }
}

void MediaListWrapper::onBluetoothEnabled()
{
    qDebug() << "Bt start..." << (BtEnabled ? "true" : "false");
    if(BtEnabled)
    {
        qDebug() << "Bt start...";
        BtProcess = new QProcess();
        BtProcess->start("/usr/bin/bluetooth-player");
        return;
    }
    qDebug() << "Bt already started";
}

void MediaListWrapper::onBluetoothDisabled()
{
    if(BtEnabled)
    {
        BtEnabled = false;
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
    Q_UNUSED(media);
    //MediaList.append(media));
    //MediaIndex = MediaList.lenght();
}

void MediaListWrapper::populateMediaListData()
{
   // MediaList.append(new Media("SongSample", "ArtistSample", "AlbumSample", "ArtSample", 4.00));
}

// TODO: this approach is constly because model is reloaded on any change, must be called
// once a new MediaList Data is set (new BT device is paired and Media is transferd)
void MediaListWrapper::resetModel()
{
    Engine.rootContext()->setContextProperty("MediaPlayerWrapper", this);
    Engine.rootContext()->setContextProperty("MediaModel", QVariant::fromValue(MediaList));
}
