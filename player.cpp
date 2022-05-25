///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "player.h"
#include <iostream>



Player::Player(QObject *parent)
    : QObject(parent),
    CurrentMedia()
{
    /*
  songName = CurrentMedia.GetSong();
  artistName = CurrentMedia.GetArtist();
  albumName = CurrentMedia.GetAlbum();
  duration = CurrentMedia.GetDuration();*/
  mpSongName = "<Song>";
  mpArtistName = "<Artist>";
  mpAlbumName = "<Album>";
  mpDurationMsec = 10.0;
}

Player::~Player()
{
}

bool Player::event(QEvent *event)
{
    Q_UNUSED(event);
}

bool Player::eventFilter(QObject *watched, QEvent *event)
{
    Q_UNUSED(watched);
    Q_UNUSED(event);
}

void Player::play()
{
    std::cout << "Playing " << std::endl;
    //QProcess process;
    //process.startDetached("/bin/sh", QStringList()<< "/home/root/usb_uac_ptc.sh");
}

void Player::pause()
{
    std::cout << "Pause " <<  std::endl;
}

void Player::next()
{
    std::cout << "Next" << std::endl;
}

void Player::back()
{
    std::cout << "Back" << std::endl;
}

void Player::setmpSongName(QString) {}
void Player::setmpArtistName(QString) {}
void Player::setmpAlbumName(QString) {}
void Player::setmpDuration(float) {}
QString Player::getmpSongName()
{
    return mpSongName;
}

QString Player::getmpArtistName()
{
    return mpAlbumName;
}

QString Player::getmpAlbumName()
{
    return mpAlbumName;
}

float Player::getmpDuration()
{
    return mpDurationMsec;
}
/*
void Player::mpsongNameChanged(){}
void Player::mpartistNameChanged(){}
void Player::mpalbumNameChanged(){}
void Player::mpdurationChanged(){}
*/
