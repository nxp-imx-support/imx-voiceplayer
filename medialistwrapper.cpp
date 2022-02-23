///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#include "medialistwrapper.h"

///////////////////////////////////////////////////////////////////////////////
MediaListWrapper::MediaListWrapper(QObject *parent) : QObject(parent)
{
    populateMediaListData();
}

///////////////////////////////////////////////////////////////////////////////
bool MediaListWrapper::initialize()
{
    Engine.rootContext()->setContextProperty("MediaModel", QVariant::fromValue(MediaList));
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    Engine.load(url);
    if(Engine.rootObjects().isEmpty())
        return false;
    return true;
}

QList<QObject *> MediaListWrapper::getMediaList() const
{
    return MediaList;
}

void MediaListWrapper::setMediaList(const QList<QObject *> &value)
{
    MediaList = value;
}

void MediaListWrapper::populateMediaListData()
{
    MediaList.append(new Media("SongSample", "ArtistSample", "AlbumSample", "ArtSample", 4.00));
}
