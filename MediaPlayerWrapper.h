///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QObject>
#include <QProcess>
#include <QQmlApplicationEngine>
#include "MediaTrackInfo.h"
#include "MediaPlayerProxy.h"

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
    Q_PROPERTY(int mediaPlayerState READ PlayingState WRITE SetPlayingState CONSTANT)//NOTIFY playingStateChanged)
    Q_PROPERTY(double position READ PlayerMediaTime WRITE SetPlayerMediaTime NOTIFY PlayerMediaTimeChanged)
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
    Q_INVOKABLE void onBluetoothEnabled();
    Q_INVOKABLE void onBluetoothDisabled();

    // Player State
    Q_INVOKABLE int PlayingState();
    Q_INVOKABLE void SetPlayingState(const int value);
    Q_INVOKABLE void playingStateChanged();

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

    // Metadata update
    void setTitle(QString title);
    void setArtist(QString artist);
    void setAlbum(QString album);
    void setDuration(float duration);
    QString title() const;
    QString artist() const;
    QString album() const;
    float duration() const;

signals:
    void onPlaybackStateChange();
    void PlayerMediaTimeChanged();
    void PlayerSeekChanged();

    void titleChanged();
    void artistChanged();
    void albumChanged();
    void durationChanged();

private:

    void populateMediaListData();
    void resetModel();

    QList<QObject*> MediaList;
    QQmlApplicationEngine Engine;
    int m_PlayingState;
    int MediaIndex;
    bool Seekable;
    long int position;
    double playbackRate;
    double MediaTime;
    MediaTrackInfo* CurrentMedia;

    QProcess* BtProcess;
    QProcess* ConsoleProcess;
    MediaPlayerProxy* BtPlayer;
    bool BtEnabled;



    QString mSong;
    QString mArtist;
    QString mAlbum;
    QString mArt;
    float mDuration;
};

