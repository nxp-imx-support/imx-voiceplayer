///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "media.h"

///////////////////////////////////////////////////////////////////////////////
//
//! \class     Media
//!     This class exposes a Media Audio Track List
//! 		wrap around the list of objects
//! 		handles QML initialization
///////////////////////////////////////////////////////////////////////////////

class MediaListWrapper : public QObject
{
    Q_OBJECT
public:
    explicit MediaListWrapper(QObject *parent = nullptr);
    bool initialize();

    Q_INVOKABLE QList<QObject *> getMediaList() const;
    void setMediaList(const QList<QObject *> &value);

signals:


private:

    void populateMediaListData();

    QList<QObject*> MediaList;
    QQmlApplicationEngine Engine;
};

