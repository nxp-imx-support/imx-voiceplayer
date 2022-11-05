/****************************************************************************
**
** Copyright 2022 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#include "MediaPlayerProxy.h"
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDebug>
#include <iostream>

const uint VOLMIN = 0;
const uint VOLSTP = 10;
const uint VOLMAX = 100;

namespace
{
    const QString playerObjPath = "/org/bluez/hci0/dev_";
    const QString player = "/player0";
    const QString transport = "/fd0";
}

MediaPlayerProxy::MediaPlayerProxy(QString macAddress):
    CurrentMedia(new MediaTrackInfo()),
    MDMacAddress(macAddress)
{
    if(not MDMacAddress.isEmpty())
    {
        initMediaPlayer();
    }
}

void MediaPlayerProxy::initMediaPlayer()
{
    QString mediaPlayer = playerObjPath + MDMacAddress + player;
    QString mediaTransport = playerObjPath + MDMacAddress + transport;
    QString mediaDevice = playerObjPath + MDMacAddress;

    qDebug() << __func__ << "\n"
             << " " << mediaPlayer << "\n"
             << " " << mediaTransport << "\n"
             << " " << mediaDevice << "\n";

    MediaPlayer = new org::bluez::MediaPlayer1("org.bluez", mediaPlayer,
                           QDBusConnection::systemBus(), this);

    MediaTransport = new org::bluez::MediaTransport1("org.bluez", mediaTransport,
                           QDBusConnection::systemBus(), this);

    Device = new org::bluez::Device1("org.bluez", mediaDevice,
                           QDBusConnection::systemBus(), this);

    MediaPlayerProperties = new org::freedesktop::DBus::Properties("org.bluez", MediaPlayer->path(),
                           QDBusConnection::systemBus(), this);

    MediaTransportProperties = new org::freedesktop::DBus::Properties("org.bluez", MediaTransport->path(),
                          QDBusConnection::systemBus(), this);

    DeviceProperties = new org::freedesktop::DBus::Properties("org.bluez", Device->path(),
                                                              QDBusConnection::systemBus(), this);

    QObject::connect(MediaPlayerProperties, &org::freedesktop::DBus::Properties::PropertiesChanged,
                     this, &MediaPlayerProxy::propertyChanged);

    QObject::connect(MediaTransportProperties, &org::freedesktop::DBus::Properties::PropertiesChanged,
                     this, &MediaPlayerProxy::propertyTransportChanged);

    QObject::connect(DeviceProperties, &org::freedesktop::DBus::Properties::PropertiesChanged,
                     this, &MediaPlayerProxy::propertyDeviceChanged);
    startTimer(1000);
}

MediaPlayerProxy::~MediaPlayerProxy()
{
}

void MediaPlayerProxy::play()
{
    MediaPlayer->Play();
}

void MediaPlayerProxy::pause()
{
    MediaPlayer->Pause();
}

void MediaPlayerProxy::next()
{
    MediaPlayer->Next();
}

void MediaPlayerProxy::stop()
{
    MediaPlayer->Stop();
}

void MediaPlayerProxy::volume()
{
    m_volume = MediaTransport->volume();
    emit MediaTrackVolumeSignal(m_volume);
}

void MediaPlayerProxy::setVolume(const int volume)
{
    qDebug() << __func__ << ": " << volume;
    MediaTransportProperties->setProperty("Volume",QVariant(m_volume));
}

void MediaPlayerProxy::volumeUp()
{
    if((m_volume + VOLSTP) <= VOLMAX)
    {
        m_volume += VOLSTP;
        MediaTransportProperties->setProperty("Volume",QVariant(m_volume));
        emit MediaTrackVolumeSignal(m_volume);
    }
}

void MediaPlayerProxy::volumeDown()
{
    if((m_volume - VOLSTP) >= VOLMIN)
    {
        m_volume -= VOLSTP;
        MediaTransportProperties->setProperty("Volume",QVariant(m_volume));
        emit MediaTrackVolumeSignal(m_volume);
    }
}

void MediaPlayerProxy::device()
{
    QVariant device = DeviceProperties->property("Name");
    qDebug() << "device: " << device.toString();
    //emit MediaDeviceNameSignal(d_name);

}

void MediaPlayerProxy::propertyChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated)
{
    qDebug() << __func__;
    if (interface != "org.bluez.MediaPlayer1") {

        qDebug() << interface;
        return;
    }

    if (d_name.length() == 0)
        device();

    QVariantMap::const_iterator i;
    for (i = changed.constBegin(); i != changed.constEnd(); ++i) {
        const QVariant &value = i.value();
        const QString &property = i.key();
        qDebug() << property << "," << value.toString();

        if (property == QLatin1String("Status")) {
            if(value.toString() == "paying")
                initMediaPlayerProperties();
        }
        if (property == QLatin1String("Position")) {
            m_position = value.toUInt();
            qDebug() << "position: " << value.toUInt();
            emit MediaTrackPositionSignal(m_position);

        }
        if (property == QLatin1String("Track")) {

            QVariantMap properties = qdbus_cast<QVariantMap>(value);
            m_title = properties.value(QStringLiteral("Title")).toString();
            m_artist = properties.value(QStringLiteral("Artist")).toString();
            m_album = properties.value(QStringLiteral("Album")).toString();
            m_genere = properties.value(QStringLiteral("Genere")).toString();
            m_numberOfTracks = properties.value(QStringLiteral("NumberOfTracks")).toUInt();
            m_trackNumber = properties.value(QStringLiteral("TrackNumber")).toUInt();
            m_duration = properties.value(QStringLiteral("Duration")).toUInt();

            qDebug() << "TrackInfo: "<< m_title << " " << m_artist << " " << m_album << " "
                   << m_genere << " " << m_numberOfTracks << " " << m_trackNumber << " " << m_duration;


            CurrentMedia.setSong(m_title);
            CurrentMedia.setAlbum(m_album);
            CurrentMedia.setArtist(m_artist);
            CurrentMedia.setDuration(m_duration);

            emit MediaTrackInfoSignal(CurrentMedia);
        }
    }

    for (const QString &property : invalidated) {
        qDebug() << __func__ << ": " << property;
    }

}

void MediaPlayerProxy::propertyTransportChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated)
{
    Q_UNUSED(invalidated);
    if (interface != "org.bluez.MediaTransport1") {
        return;
    }

    QVariantMap::const_iterator i;
    for (i = changed.constBegin(); i != changed.constEnd(); ++i) {
        const QVariant &value = i.value();
        const QString &property = i.key();

        if (property == QLatin1String("Volume")) {
            qDebug() << property << "," << value.toString();
            m_volume = value.toUInt();
            emit MediaTrackVolumeSignal(m_volume);
        } else if (property == QLatin1String("State")) {
            qDebug() << property << "," << value.toString();
        }
    }

}

void MediaPlayerProxy::propertyDeviceChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated)
{
    Q_UNUSED(invalidated);
    if (interface != "org.bluez.Device1") {
        return;
    }

    QVariantMap::const_iterator i;
    for (i = changed.constBegin(); i != changed.constEnd(); ++i) {
        const QVariant &value = i.value();
        const QString &property = i.key();

        if (property == QLatin1String("Name")) {
            qDebug() << property << "," << value.toString();
        }
    }

}

void MediaPlayerProxy::initMediaPlayerProperties()
{
    m_title = MediaPlayer->property("Title").toString();
    m_artist = MediaPlayer->property("Artist").toString();
    m_album = MediaPlayer->property("Album").toString();
    m_duration = MediaPlayer->property("Duration").toUInt();

    qDebug() << "TrackInfo: "<< m_title << " " << m_artist << " " << m_album << " "
             << " " << m_duration;

    CurrentMedia.setSong(m_title);
    CurrentMedia.setAlbum(m_album);
    CurrentMedia.setArtist(m_artist);
    CurrentMedia.setDuration(m_duration);

    emit MediaTrackInfoSignal(CurrentMedia);

}
