///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QObject>
#include <QString>

///////////////////////////////////////////////////////////////////////////////
//
//! \class     Media
//!     This class exposes a Media Audio Track and its metadata
//!
///////////////////////////////////////////////////////////////////////////////

class MediaTrackInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString song READ song WRITE setSong NOTIFY songChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString album READ album WRITE setAlbum NOTIFY albumChanged)
    Q_PROPERTY(float duration READ duration WRITE setDuration NOTIFY durationChanged)

public:
    explicit MediaTrackInfo(QObject *parent = nullptr);
    MediaTrackInfo(const QString &song, const QString &artist, const QString &album, const QString &art, const float &duration, QObject * parent = nullptr);
    ~MediaTrackInfo();

    bool event(QEvent *event);
    bool eventFilter(QObject *watched, QEvent *event);

    QString song() const;
    QString artist() const;
    QString album() const;
    QString art() const;
    float duration() const;
    void setSong(QString song);
    void setArtist(QString artist);
    void setAlbum(QString album);
    void setArt(QString art);
    void setDuration(float duration);

    void onSongPlay();
    void onSongPause();
    void onSongBack();
    void onSongNext();

signals:
    void songChanged();
    void artistChanged();
    void albumChanged();
    void artChanged();
    void durationChanged();

private:
    QString mSong;
    QString mArtist;
    QString mAlbum;
    QString mArt;
    float mDuration;
};

