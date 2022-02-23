///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "media.h"
#include <iostream>

namespace  {
    QString songName = "<Song>";
    QString artistName = "<Artist>";
    QString albumName = "<Album>";
    QString artName = "<Art>";
    float durationTime = 1.0;
}

Media::Media(QObject *parent) : QObject(parent)
{
    mSong = songName;
    mArtist = artistName;
    mAlbum = albumName;
    mArt = artName;
    mDuration = durationTime;
}

Media::Media(const QString &song, const QString &artist, const QString &album, const QString &art, const float &duration, QObject *parent)
    : QObject(parent),
      mSong(song),
      mArtist(artist),
      mAlbum(album),
      mArt(art),
      mDuration(duration)
{

}

Media::~Media()
{

}

bool Media::event(QEvent *event)
{
    Q_UNUSED(event);
}

bool Media::eventFilter(QObject *watched, QEvent *event)
{
    Q_UNUSED(watched);
    Q_UNUSED(event);
}

QString Media::song() const
{
    return mSong;
}

QString Media::artist() const
{
    return mArtist;
}

QString Media::album() const
{
    return mAlbum;
}

QString Media::art() const
{
    return mArt;
}

float Media::duration() const
{
    return mDuration;
}

void Media::setSong(QString song)
{
    mSong = song;
}

void Media::setArtist(QString artist)
{
    mArtist = artist;
}

void Media::setAlbum(QString album)
{
    mAlbum = album;
}

void Media::setArt(QString art)
{
    mArt = art;
}

void Media::setDuration(float duration)
{
    mDuration = duration;
}

void Media::onSongPlay()
{
    std::cout << "Playing " << std::endl;
}

void Media::onSongPause()
{
    std::cout << "Pause " <<  std::endl;
}

void Media::onSongBack()
{
    std::cout << "Back" << std::endl;
}

void Media::onSongNext()
{
    std::cout << "Next" << std::endl;
}

