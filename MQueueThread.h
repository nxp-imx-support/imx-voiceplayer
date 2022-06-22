///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#pragma once

#include <mqueue.h>
#include <QThread>
#include <QString>

#define QUEUE_NAME_APP "/bt_queue"
#define MAX_SIZE 1024
#define QUEUE_PERMISIIONS 0664
#define MAX_MESSAGES 10
#define MAX_MSG_SIZE 256

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
