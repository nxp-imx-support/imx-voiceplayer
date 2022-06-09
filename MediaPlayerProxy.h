///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QList>
#include <QObject>
#include "MediaTrackInfo.h"
#include "mediaplayer1_interface.h"
#include "properties_interface.h"

///////////////////////////////////////////////////////////////////////////////
//!
//! \class     Player
//!     This class exposes the main functionality of Bluez Player, it's a
//!     PlayerProxy to interact with bluetooth-player tool via dbus
//!
///////////////////////////////////////////////////////////////////////////////

class MediaPlayerProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString SongName READ getmpSongName WRITE setmpSongName NOTIFY mpsongNameChanged)
    Q_PROPERTY(QString ArtistName READ getmpArtistName WRITE setmpArtistName NOTIFY mpartistNameChanged)
    Q_PROPERTY(QString AlbumName READ getmpAlbumName WRITE setmpAlbumName NOTIFY mpalbumNameChanged)
    Q_PROPERTY(float  DurationMsec READ getmpDuration WRITE setmpDuration NOTIFY mpdurationChanged)

public:
    explicit MediaPlayerProxy(QObject *parent = nullptr);
    ~MediaPlayerProxy();

    //bool event(QEvent *event);
    //bool eventFilter(QObject *watched, QEvent *event);

signals:
    void mpsongNameChanged();
    void mpartistNameChanged();
    void mpalbumNameChanged();
    void mpdurationChanged();

    void MediaTrackInfoSignal(const MediaTrackInfo &media);

public slots:

    void play();
    void pause();
    void next();
    void stop();
    void setmpSongName(QString);
    void setmpArtistName(QString);
    void setmpAlbumName(QString);
    void setmpDuration(float);
    QString getmpSongName();
    QString getmpArtistName();
    QString getmpAlbumName();
    float getmpDuration();

    void showHelp(QString msg);


    void propertyChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated);
private:

    QString m_path;
    QString m_name;
    /*MediaPlayer::Equalizer m_equalizer;
    MediaPlayer::Repeat m_repeat;
    MediaPlayer::Shuffle m_shuffle;
    MediaPlayer::Status m_status;
    quint32 m_position;*/

    // Track Information this shall be imported to a new TrackInfo class
    QString m_title;
    QString m_artist;
    QString m_album;
    QString m_genere;
    quint32 m_numberOfTracks;
    quint32 m_trackNumber;
    quint32 m_duration;


    org::bluez::MediaPlayer1 *MediaPlayer;
    org::freedesktop::DBus::Properties *MediaPlayerProperties;
    MediaTrackInfo CurrentMedia;

};
