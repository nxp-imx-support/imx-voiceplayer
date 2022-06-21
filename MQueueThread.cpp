///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

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
        qDebug() << "ERROR Server: mq_open (%s)\n", QUEUE_NAME_APP;
    }
}

//void *MQueue::VIT_run_thread_routine_mqueue_conection(void *args)
// Blocking operation
void MQueueThread::run()
{
    char sPath[MAX_SIZE] = {"/org/bluez/hci0/dev_"};
    char buffer[MAX_SIZE];
    char sMAC_Bt[50];
    int bytes_read=0;
    int iConnectionToBT = 0;
    int i;

   qDebug() << ("VIT_run_thread_routine_mqueue_conection\n");
   qDebug() << "Waiting conection...\n";

    // byPass connectivity check
    //iConnectionToBT=true;

    while (not iConnectionToBT)
    {
        bytes_read=mq_receive(mq, buffer, MAX_SIZE, NULL);

        if(bytes_read > 0)
        {
            sPath[bytes_read]= '\0';

            if(buffer[0] == '0')//Disconnect
            {
                iConnectionToBT=false;
                qDebug()<<("BTDisconnected\n");
            }
            else //Connect
            {
                //pthread_mutex_lock(&mutex_);
                qDebug()<<("BTConnected\nBytesReaded: %d \n",bytes_read);
                for(i=1;i<bytes_read;i++)
                {
                    sMAC_Bt[i-1] = buffer[i];
                }
                qDebug()<<("sMAC_Bt: %s \n",sMAC_Bt);

                // Cambiar esta seccion para que cree el path apartir de la MAC recivida
                //getPath();
                qDebug()<<("%s \n",sPath);

                //connectDBus();
                iConnectionToBT=true;
                //pthread_mutex_unlock(&mutex_);
                emit emitMacAddress(QString(sMAC_Bt));
            }
        }
    }
    qDebug() << ("VIT_run_thread_routine_mqueue_conection...exiting\n");
}

