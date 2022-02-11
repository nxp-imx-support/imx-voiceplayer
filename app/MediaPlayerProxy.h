/****************************************************************************
**
** Copyright 2022 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#pragma once

#include <QList>
#include <QObject>
#include "device1_interface.h"
#include "mediaplayer1_interface.h"
#include "MediaTrackInfo.h"
#include "mediatransport1_interface.h"
#include "properties_interface.h"

///////////////////////////////////////////////////////////////////////////////
//!
//! \class     Player
//!     This class exposes the main functionality of Bluez APIs, it's a
//!     PlayerProxy to interact with bluez services via dbus
//!
///////////////////////////////////////////////////////////////////////////////

class MediaPlayerProxy : public QObject
{
    Q_OBJECT

public:
    MediaPlayerProxy(QString macAddress);
    ~MediaPlayerProxy();

signals:
    void MediaTrackInfoSignal(const MediaTrackInfo &media);
    void MediaTrackPositionSignal(const quint32 position);
    void MediaTrackVolumeSignal(const quint32 volume);
    void MediaDeviceNameSignal(const QString name);


public slots:
    void play();
    void pause();
    void next();
    void stop();
    void volume();
    void setVolume(const int volume);
    void volumeUp();
    void volumeDown();
    void device();
    void propertyChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated);
    void propertyTransportChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated);
    void propertyDeviceChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated);

private:

    void initMediaPlayer();
    void initMediaPlayerProperties();


    // Track Information this shall be imported to a new TrackInfo class
    QString d_name = "";
    QString m_title;
    QString m_artist;
    QString m_album;
    QString m_genere;
    quint32 m_numberOfTracks;
    quint32 m_trackNumber;
    quint32 m_duration;
    quint32 m_position;
    quint32 m_volume;

    MediaTrackInfo CurrentMedia;
    QString MDMacAddress;

    org::bluez::MediaPlayer1 *MediaPlayer;
    org::bluez::MediaTransport1 *MediaTransport;
    org::bluez::Device1 *Device;
    org::freedesktop::DBus::Properties *MediaPlayerProperties;
    org::freedesktop::DBus::Properties *MediaTransportProperties;
    org::freedesktop::DBus::Properties *DeviceProperties;

};

