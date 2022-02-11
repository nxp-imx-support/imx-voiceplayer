/****************************************************************************
**
** Copyright 2022 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#include "MediaTrackInfo.h"
#include <iostream>

namespace  {
    QString songName = "<Song>";
    QString artistName = "<Artist>";
    QString albumName = "<Album>";
    QString artName = "<Art>";
    float durationTime = 1.0;
}

MediaTrackInfo::MediaTrackInfo(QObject *parent) : QObject(parent)
{
    mSong = songName;
    mArtist = artistName;
    mAlbum = albumName;
    mArt = artName;
    mDuration = durationTime;
}

MediaTrackInfo::MediaTrackInfo(const QString &song, const QString &artist, const QString &album, const QString &art, const float &duration, QObject *parent)
    : QObject(parent),
      mSong(song),
      mArtist(artist),
      mAlbum(album),
      mArt(art),
      mDuration(duration)
{

}

MediaTrackInfo::~MediaTrackInfo()
{

}

QString MediaTrackInfo::song() const
{
    return mSong;
}

QString MediaTrackInfo::artist() const
{
    return mArtist;
}

QString MediaTrackInfo::album() const
{
    return mAlbum;
}

QString MediaTrackInfo::art() const
{
    return mArt;
}

float MediaTrackInfo::duration() const
{
    return mDuration;
}

void MediaTrackInfo::setSong(QString song)
{
    mSong = song;
    emit songChanged();
}

void MediaTrackInfo::setArtist(QString artist)
{
    mArtist = artist;
    emit artistChanged();
}

void MediaTrackInfo::setAlbum(QString album)
{
    mAlbum = album;
    emit albumChanged();
}

void MediaTrackInfo::setArt(QString art)
{
    mArt = art;
}

void MediaTrackInfo::setDuration(float duration)
{
    mDuration = duration;
    emit durationChanged();
}

void MediaTrackInfo::onSongPlay()
{
    std::cout << "Playing " << std::endl;
}

void MediaTrackInfo::onSongPause()
{
    std::cout << "Pause " <<  std::endl;
}

void MediaTrackInfo::onSongBack()
{
    std::cout << "Back" << std::endl;
}

void MediaTrackInfo::onSongNext()
{
    std::cout << "Next" << std::endl;
}

