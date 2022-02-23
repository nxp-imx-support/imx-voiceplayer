///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QList>
#include <QObject>
#include "media.h"

///////////////////////////////////////////////////////////////////////////////
//!
//! \class     Player
//!     This class exposes the main functionality of Media Audio Player
//!
//!
///////////////////////////////////////////////////////////////////////////////

class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString SongName READ getmpSongName WRITE setmpSongName NOTIFY mpsongNameChanged)
    Q_PROPERTY(QString ArtistName READ getmpArtistName WRITE setmpArtistName NOTIFY mpartistNameChanged)
    Q_PROPERTY(QString AlbumName READ getmpAlbumName WRITE setmpAlbumName NOTIFY mpalbumNameChanged)
    Q_PROPERTY(float  DurationMsec READ getmpDuration WRITE setmpDuration NOTIFY mpdurationChanged)

public:
    explicit Player(QObject *parent = nullptr);
    ~Player();

    bool event(QEvent *event);
    bool eventFilter(QObject *watched, QEvent *event);

signals:
    void mpsongNameChanged();
    void mpartistNameChanged();
    void mpalbumNameChanged();
    void mpdurationChanged();

public slots:

    void play();
    void pause();
    void next();
    void back();
    void setmpSongName(QString);
    void setmpArtistName(QString);
    void setmpAlbumName(QString);
    void setmpDuration(float);
    QString getmpSongName();
    QString getmpArtistName();
    QString getmpAlbumName();
    float getmpDuration();


private:

    QList<Media> MediaList;
    Media CurrentMedia;
    QString mpSongName;
    QString mpArtistName;
    QString mpAlbumName;
    float mpDurationMsec;

};
