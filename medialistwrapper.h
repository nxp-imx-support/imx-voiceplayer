///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include "media.h"

///////////////////////////////////////////////////////////////////////////////
//
//! \class     MediaListWrapper
//!     This class exposes a Media Audio Track List
//! 		wrap around the list of media objects
//! 		handles QML initialization
///////////////////////////////////////////////////////////////////////////////

class MediaListWrapper : public QObject
{
    Q_OBJECT
public:
    explicit MediaListWrapper(QObject *parent = nullptr);
    bool initialize();

    Q_INVOKABLE QList<QObject *> getMediaList() const;
    Q_INVOKABLE void onPlay();
    Q_INVOKABLE void onPause();
    Q_INVOKABLE void onBack();
    Q_INVOKABLE void onNext();
    Q_INVOKABLE void onBluetoothEnabled();

    void setMediaList(const QList<QObject *> &value);
    void setMediaTrack(const QObject &media);

signals:


private:

    void populateMediaListData();
    void resetModel();

    QList<QObject*> MediaList;
    QQmlApplicationEngine Engine;
    int MediaIndex;
};

