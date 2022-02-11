/****************************************************************************
**
** Copyright 2022 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#pragma once

#include <mqueue.h>
#include <QThread>
#include <QString>

#define QUEUE_NAME_APP "/bt_queue"
#define MAX_SIZE 1024
#define QUEUE_PERMISIIONS 0664
#define MAX_MESSAGES 10
#define MAX_MSG_SIZE 256

///////////////////////////////////////////////////////////////////////////////
//
//! \class     MQueue Thread
//!     This class provides the MAC address once a device is connected to
//!     the system.
//!
///////////////////////////////////////////////////////////////////////////////
class MQueueThread : public QThread
{
    Q_OBJECT
public:

    MQueueThread();

    void initMqueue(void);
    void run() override;

signals:

    void emitMacAddress(QString mac);

private:

    struct mq_attr attr;
    mqd_t mq;

};
