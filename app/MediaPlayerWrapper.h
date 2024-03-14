/****************************************************************************
**
** Copyright 2022-2023 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#pragma once

#include <QObject>
#include <QProcess>
#include <QQmlApplicationEngine>
#include "MediaTrackInfo.h"
#include "MediaPlayerProxy.h"
#include "MQueueThread.h"

///////////////////////////////////////////////////////////////////////////////
//
//! \class     MediaPlayerWrapper
//!     This class exposes a Media Player App
//! 		Wrap around of media object
//! 		Handles QML initialization
//!         Handles Bluez bluetooth player tool
///////////////////////////////////////////////////////////////////////////////

class MediaPlayerWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString album READ album WRITE setAlbum NOTIFY albumChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(float duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(QString device READ device WRITE setDevice NOTIFY deviceChanged)


    Q_PROPERTY(int mediaPlayerState READ PlayingState WRITE SetPlayingState NOTIFY playingStateChanged)
    Q_PROPERTY(double position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(bool seekable READ PlayerSeekable WRITE SetPlayerSeekable NOTIFY PlayerSeekChanged)
public:
    explicit MediaPlayerWrapper(QObject *parent = nullptr);
    ~MediaPlayerWrapper();
    bool initialize();

    enum playingState
    {
        playingState,
        stopedState,
        pausedState,
    };

public slots:
    Q_INVOKABLE QList<QObject *> getMediaList() const;
    Q_INVOKABLE void onPlay();
    Q_INVOKABLE void onPause();
    Q_INVOKABLE void onStop();
    Q_INVOKABLE void onNext();
    Q_INVOKABLE void volumeUp();
    Q_INVOKABLE void volumeDown();
    Q_INVOKABLE void onBluetoothEnabled();
    Q_INVOKABLE void onBluetoothDisabled();

    // Player State
    Q_INVOKABLE int PlayingState();
    Q_INVOKABLE void SetPlayingState(const int value);
    //Q_INVOKABLE void playingStateChanged();

    // Player Media Time
    Q_INVOKABLE double PlayerMediaTime();
    Q_INVOKABLE void SetPlayerMediaTime(const double mediaTime);

    // Player Seek
    Q_INVOKABLE bool PlayerSeekable();
    Q_INVOKABLE void SetPlayerSeekable(const bool value);


    // Player Rate
    Q_INVOKABLE void setPlaybackRate(double value);


    void setMediaList(const QList<QObject *> &value);
    void setMediaTrack(const MediaTrackInfo &media);
    void setMediaTrackPosition(const quint32 position);

    // MAC Adress
    // Metadata update
    void setMacAdrees(QString mac);
    void setTitle(QString title);
    void setArtist(QString artist);
    void setAlbum(QString album);
    void setDuration(float duration);
    void setPosition(int position);
    void setVolume(int value);
    void setDevice(QString device);
    QString title() const;
    QString artist() const;
    QString album() const;
    QString device() const;
    float duration() const;
    int position() const;
    int volume() const;

signals:
    void onPlaybackStateChange();
    void PlayerMediaTimeChanged();
    void PlayerSeekChanged();

    void titleChanged();
    void artistChanged();
    void albumChanged();
    void deviceChanged();
    void durationChanged();
    void positionChanged();
    void volumeChanged();

    void playingStateChanged();

private:

    void populateMediaListData();
    void resetModel();

    QList<QObject*> MediaList;
    QQmlApplicationEngine Engine;
    int m_PlayingState;
    int MediaIndex;
    bool Seekable;
    double playbackRate;
    double MediaTime;
    MediaTrackInfo* CurrentMedia;

    QProcess* BtProcess;
    QProcess* ConsoleProcess;
    MediaPlayerProxy* Player;
    MQueueThread* MQThread;
    bool BtEnabled;


    QString mMac="";
    QString mSong="";
    QString mArtist="";
    QString mAlbum="";
    QString mArt="";
    QString mDevice="";
    float mDuration=0.0;
    quint32 mPosition=0;
    int mVolume=60;
};

