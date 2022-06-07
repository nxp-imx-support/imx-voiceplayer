///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QObject>
#include <QProcess>
#include <QQmlApplicationEngine>

///////////////////////////////////////////////////////////////////////////////
//
//! \class     MediaListWrapper
//!     This class exposes a Media Audio Track List
//! 		wrap around the list of media objects
//! 		handles QML initialization
///////////////////////////////////////////////////////////////////////////////

class MediaListWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int mediaPlayerState READ PlayingState WRITE SetPlayingState CONSTANT)//NOTIFY playingStateChanged)
    Q_PROPERTY(double position READ PlayerMediaTime WRITE SetPlayerMediaTime NOTIFY PlayerMediaTimeChanged)
    Q_PROPERTY(bool seekable READ PlayerSeekable WRITE SetPlayerSeekable NOTIFY PlayerSeekChanged)
public:
    explicit MediaListWrapper(QObject *parent = nullptr);
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
    void setMediaTrack(const QObject &media);



signals:
    void onPlaybackStateChange();
    void PlayerMediaTimeChanged();
    void PlayerSeekChanged();


private:

    void populateMediaListData();
    void resetModel();

    QList<QObject*> MediaList;
    QQmlApplicationEngine Engine;
    int m_PlayingState;
    int MediaIndex;
    bool Seekable;
    int duration;
    long int position;
    double playbackRate;
    double MediaTime;

    QProcess* BtProcess;
    QProcess* ConsoleProcess;
    bool BtEnabled;
};

