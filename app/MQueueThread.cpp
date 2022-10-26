/****************************************************************************
**
** Copyright 2022 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

#include <QDebug>
#include "MQueueThread.h"

MQueueThread::MQueueThread()
{
    initMqueue();

}

void MQueueThread::initMqueue()
{
    attr.mq_flags = 0;
    attr.mq_maxmsg = MAX_MESSAGES;
    attr.mq_msgsize = MAX_MSG_SIZE;
    attr.mq_curmsgs =0;

    //Create the message queue
    if((mq = mq_open (QUEUE_NAME_APP, O_RDONLY | O_CREAT, QUEUE_PERMISIIONS, &attr)) == -1)
    {
        qDebug() << "ERROR Server: mq_open " << QUEUE_NAME_APP;
    }
}

// Blocking operation
void MQueueThread::run()
{
    char buffer[MAX_SIZE];
    char sMAC_Bt[50];
    int bytes_read=0;
    int iConnectionToBT = 0;
    int i;

   qDebug() << "run thread routine mqueue conection\n";
   qDebug() << "Waiting conection...\n";


    while (not iConnectionToBT)
    {
        bytes_read=mq_receive(mq, buffer, MAX_SIZE, NULL);

        if(bytes_read > 0)
        {
            if(buffer[0] == '0')//Disconnect
            {
                iConnectionToBT=false;
                qDebug()<<("BTDisconnected\n");
            }
            else //Connect
            {
                for(i=1;i<bytes_read;i++)
                {
                    sMAC_Bt[i-1] = buffer[i];
                }
                iConnectionToBT=true;
                emit emitMacAddress(QString(sMAC_Bt));
            }
        }
    }
    qDebug() << __func__ <<"...exiting\n";
}

