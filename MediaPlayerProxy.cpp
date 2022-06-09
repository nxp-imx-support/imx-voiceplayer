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



MediaPlayerProxy::MediaPlayerProxy(QObject *parent):
    QObject(parent),
    CurrentMedia()
{
    MediaPlayer = new org::bluez::MediaPlayer1("org.bluez", "/org/bluez/hci0/dev_AC_6C_90_04_7C_62/player0",
                           QDBusConnection::systemBus(), this);

    MediaPlayerProperties = new org::freedesktop::DBus::Properties("org.bluez", MediaPlayer->path(),
                           QDBusConnection::systemBus(), this);

    QObject::connect(MediaPlayerProperties, &org::freedesktop::DBus::Properties::PropertiesChanged,
                     this, &MediaPlayerProxy::propertyChanged);

    /*
    MediaPlayer->connect("org.bluez", "/org/bluez/hci0/dev_AC_6C_90_04_7C_62/player0",
                         org::freedesktop::DBus::Properties,
                         QStringLiteral("PropertiesChanged"),
                         this,
                         SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));

    DBusConnection::orgBluez().connect(Strings::orgBluez(),
                                       path,
                                       Strings::orgFreedesktopDBusProperties(),
                                       QStringLiteral("PropertiesChanged"),
                                       this,
                                       SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));
    */

    /*
    QDBusInterface iface("org.bluez.MediaPlayer1", "/usr/bin/bluetooth-player", "/MediaPlayer1",
                         QDBusConnection::sessionBus(), this);
    */
    /************************************************
     * TEST Session bus
    /// [1] Get a connection to the session bus.*/
    QDBusConnection             bus = QDBusConnection::sessionBus();

    /// [2] Create an interface to it
    QDBusConnectionInterface    *busIF = bus.interface();

    /// [3] Register as a service with the interface name
  /*      QString ifName = "org.bluez.MediaPlayer1";
        busIF->registerService(ifName,
                               QDBusConnectionInterface::ReplaceExistingService,
                               QDBusConnectionInterface::AllowReplacement);
  */
        /// [4] See who is on the bus
        QDBusReply<QStringList> serviceNames = busIF->registeredServiceNames();
        qDebug() << bus.name() << "knows the following Services:" << serviceNames.value();

/*
        /// [5] Register to receive a "ping" request. Note similar to QObject::connect(..)
        QString service = "";
        QString path = "";
        QString name = "ping";
        bus.connect(service, path, ifName, name, this, SLOT(showHelp(QString)));

        /// [6] Send a Ping Message
        QDBusMessage    msg = QDBusMessage::createSignal("/", ifName, name);
        msg << "Hello World!";
        bus.send(msg);
*/


    startTimer(1000);
}

MediaPlayerProxy::~MediaPlayerProxy()
{
}

/*bool MediaPlayerProxy::event(QEvent *event)
{
    Q_UNUSED(event);
    /*if(MediaPlayer->isValid())
        qDebug() << "MediaPlayer connected";
    else
        qDebug() << "MediaPlayer disconnected";
}

bool MediaPlayerProxy::eventFilter(QObject *watched, QEvent *event)
{
    Q_UNUSED(watched);
    Q_UNUSED(event);
}*/

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



void MediaPlayerProxy::propertyChanged(const QString &interface, const QVariantMap &changed, const QStringList &invalidated)
{
    qDebug() << __func__;
    if (interface != "org.bluez.MediaPlayer1") {

        qDebug() << interface;
        return;
    }

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


void MediaPlayerProxy::setmpSongName(QString) {}
void MediaPlayerProxy::setmpArtistName(QString) {}
void MediaPlayerProxy::setmpAlbumName(QString) {}
void MediaPlayerProxy::setmpDuration(float) {}
QString MediaPlayerProxy::getmpSongName()
{
    return "";
}

QString MediaPlayerProxy::getmpArtistName()
{
    return "";
}

QString MediaPlayerProxy::getmpAlbumName()
{
    return "";
}

float MediaPlayerProxy::getmpDuration()
{
    return 0.0;
}

void MediaPlayerProxy::showHelp(QString msg)
{
    /// [8] Show the received ping message
    qDebug() << __FUNCTION__ << "Ping:" << msg;
}
