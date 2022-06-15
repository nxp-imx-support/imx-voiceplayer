///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "MediaPlayerProxy.h"
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDebug>
#include <iostream>

const uint VOLMIN = 0;
const uint VOLSTP = 10;
const uint VOLMAX = 100;


MediaPlayerProxy::MediaPlayerProxy(QObject *parent):
    QObject(parent),
    CurrentMedia()
{
    MediaPlayer = new org::bluez::MediaPlayer1("org.bluez", "/org/bluez/hci0/dev_AC_6C_90_04_7C_62/player0",
                           QDBusConnection::systemBus(), this);

    MediaTransport = new org::bluez::MediaTransport1("org.bluez", "/org/bluez/hci0/dev_AC_6C_90_04_7C_62/fd0",
                           QDBusConnection::systemBus(), this);

    Device = new org::bluez::Device1("org.bluez", "/org/bluez/hci0/dev_AC_6C_90_04_7C_62",
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
    //qDebug() << MediaTransport->state();
    //qDebug() << m_volume;
    emit MediaTrackVolumeSignal(m_volume);
}

void MediaPlayerProxy::volumeUp()
{
    if((m_volume + VOLSTP) <= VOLMAX)
    {
        m_volume += VOLSTP;
        MediaTransportProperties->setProperty("Volume",QVariant(m_volume));
    }
}

void MediaPlayerProxy::volumeDown()
{
    if((m_volume - VOLSTP) >= VOLMIN)
    {
        m_volume -= VOLSTP;
        MediaTransportProperties->setProperty("Volume",QVariant(m_volume));
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
/*
        if (property == QLatin1String("Name")) {
            PROPERTY_CHANGED(m_name, toString, nameChanged);
        } else if (property == QLatin1String("Equalizer")) {
            PROPERTY_CHANGED2(m_equalizer, stringToEqualizer(value.toString()), equalizerChanged);
        } else if (property == QLatin1String("Repeat")) {
            PROPERTY_CHANGED2(m_repeat, stringToRepeat(value.toString()), repeatChanged);
        } else if (property == QLatin1String("Shuffle")) {
            PROPERTY_CHANGED2(m_shuffle, stringToShuffle(value.toString()), shuffleChanged);
        } else if (property == QLatin1String("Status")) {
            PROPERTY_CHANGED2(m_status, stringToStatus(value.toString()), statusChanged);
        } else if (property == QLatin1String("Position")) {
            PROPERTY_CHANGED(m_position, toUInt, positionChanged);
        } else*/
        if (property == QLatin1String("Track")) {

            //m_valid = !property.isEmpty();

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
            //m_track = variantToTrack(value);
            //Q_EMIT q.lock()->trackChanged(m_track);
        }
        else if (property == QLatin1String("Position")) {
            m_position = value.toUInt();
            emit MediaTrackPositionSignal(m_position);

                    //PROPERTY_CHANGED(m_position, toUInt, positionChanged);
        }
    }

    for (const QString &property : invalidated) {
        qDebug() << property;
        /*
        if (property == QLatin1String("Name")) {
            PROPERTY_INVALIDATED(m_name, QString(), nameChanged);
        } else if (property == QLatin1String("Equalizer")) {
            PROPERTY_INVALIDATED(m_equalizer, MediaPlayer::EqualizerOff, equalizerChanged);
        } else if (property == QLatin1String("Repeat")) {
            PROPERTY_INVALIDATED(m_repeat, MediaPlayer::RepeatOff, repeatChanged);
        } else if (property == QLatin1String("Shuffle")) {
            PROPERTY_INVALIDATED(m_shuffle, MediaPlayer::ShuffleOff, shuffleChanged);
        } else if (property == QLatin1String("Status")) {
            PROPERTY_INVALIDATED(m_status, MediaPlayer::Error, statusChanged);
        } else if (property == QLatin1String("Position")) {
            PROPERTY_INVALIDATED(m_position, 0, positionChanged);
        } else if (property == QLatin1String("Track")) {
            m_track = variantToTrack(QVariant());
            Q_EMIT q.lock()->trackChanged(m_track);
        }
        */
    }

}

void MediaPlayerProxy::propertyTransportChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated)
{
    qDebug() << __func__;
    /*if (interface != "org.bluez.MediaTransport1") {

        return;
    }*/

    qDebug() << interface;
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
    QVariantMap::const_iterator i;
    for (i = changed.constBegin(); i != changed.constEnd(); ++i) {
        const QVariant &value = i.value();
        const QString &property = i.key();

        if (property == QLatin1String("Name")) {
            qDebug() << property << "," << value.toString();
        }
    }

}
