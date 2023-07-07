/****************************************************************************
**
** Copyright 2023 NXP
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/
#include "BTPVA_action_executor.h"
#include <dbus/dbus-glib.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>
#include <sys/syscall.h>
#include <unistd.h>
#ifndef DBUS_API_SUBJECT_TO_CHANGE
#define DBUS_API_SUBJECT_TO_CHANGE
#include <dbus/dbus.h>
#endif
#include <mqueue.h>
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#define QUEUE_NAME_VIT "/vit_queue"
#define QUEUE_NAME_VOICE_UI "/voice_ui_queue"

#define MAX_SIZE 1024
#define QUEUE_PERMISIIONS 0664
#define MAX_MESSAGES 10
#define MAX_MSG_SIZE 256
#define MAX_MAC_SIZE 25

#define START_PATH "/org/bluez/hci0/dev_"
#define END_PATH_MEDIAPLAYER1 "/player0\0"

#define NO_CONNECTION_TO_BT "*** There is not connection to a bluetooth ***\n"
#define COMMAND_NOT_IMPLEMENTED "*** Command not implemented ***\n"

#define R_MODE "r"
#define MUTE " 0"
#define INCREMENT " 1"
#define DECREMENT " 2"

char sPathMediaPlayer[MAX_SIZE];
char sMAC_Bt[MAX_MAC_SIZE];

DBusConnection *conn;
DBusError error;
struct mq_attr attr;
int iConnectionToBT = 0;
mqd_t mq;
mqd_t mq_voice_ui;

void connectDBus(void) {
  DBusMessage *dbmsg;
  dbus_error_init(&error);
  conn = dbus_bus_get(DBUS_BUS_SYSTEM, &error);
  if (conn == NULL) {
    fprintf(stderr, "Failed to open connection to bus: %s\n", error.message);
    dbus_error_free(&error);
    exit(1);
  } else
    printf("Connected to System Bus\n");
}

void callMethod(char *Method) {
  DBusMessage *dbmsg;
  dbmsg = dbus_message_new_method_call(
      "org.bluez",              /* target for the method call */
      sPathMediaPlayer,         /* object to call on          */
      "org.bluez.MediaPlayer1", /* interface to call on       */
      Method);                  /* method name                */
  if (dbmsg == NULL) {
    fprintf(stderr, "Couldn't create a DBusMessage\n");
    return;
  }
  while (!dbus_connection_send(conn, dbmsg, NULL)) {
    printf("Trying sending method...\n");
  }
  dbus_connection_flush(conn);
  dbus_message_unref(dbmsg);
}

static void BTPVA_init_mqueue() {
  attr.mq_flags = 0;
  attr.mq_maxmsg = MAX_MESSAGES;
  attr.mq_msgsize = MAX_MSG_SIZE;
  attr.mq_curmsgs = 0;

  if ((mq = mq_open(QUEUE_NAME_VIT, O_RDONLY | O_CREAT, QUEUE_PERMISIIONS,
                    &attr)) == -1) {
    printf("ERROR Server: mq_open (%s)\n", QUEUE_NAME_VIT);
  }
  if ((mq_voice_ui = mq_open(QUEUE_NAME_VOICE_UI, O_RDONLY | O_CREAT,
                             QUEUE_PERMISIIONS, &attr)) == -1) {
    printf("ERROR Server: mq_open (%s)\n", QUEUE_NAME_VOICE_UI);
  }
}

static void BTPVA_call_custom(int WW, int cmd) {
  char sVolume[50];

  switch (cmd) {
  case 1: /* MUTE */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      printf("MUTE command\n");
      strcpy(sVolume, "/opt/Btplayer/bin/volume.sh ");
      strcat(sVolume, sMAC_Bt);
      strcat(sVolume, MUTE);
      popen(sVolume, R_MODE);
    }
    break;
  case 2: /* NEXT SONG */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      callMethod("Next");
    }
    break;
  case 3: /* PAUSE */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      callMethod("Pause");
    }
    break;
  case 4: /* STOP */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      callMethod("Stop");
    }
    break;
  case 5: /* CONNECT */
    printf("CONNECT command\n");
    printf(COMMAND_NOT_IMPLEMENTED);
    break;
  case 6: /* PLAY MUSIC */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      callMethod("Play");
    }
    break;
  case 7: /* PREVIOUS SONG */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      callMethod("Previous");
    }
    break;
  case 8: /* STOP PLAYER */
    popen("pkill Btplayer", R_MODE);
    break;
  case 9: /* START PLAYER */
    popen("/opt/Btplayer/bin/Btplayer -platform wayland &", R_MODE);
    break;
  case 10: /* VOLUME UP */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      printf("VOLUME UP command\n");
      strcpy(sVolume, "/opt/Btplayer/bin/volume.sh ");
      strcat(sVolume, sMAC_Bt);
      strcat(sVolume, INCREMENT);
      popen(sVolume, R_MODE);
    }
    break;
  case 11: /* VOLUME DOWN */
    if (iConnectionToBT != true) {
      printf(NO_CONNECTION_TO_BT);
    } else {
      printf("VOLUME DOWN command\n");
      strcpy(sVolume, "/opt/Btplayer/bin/volume.sh ");
      strcat(sVolume, sMAC_Bt);
      strcat(sVolume, DECREMENT);
      popen(sVolume, R_MODE);
    }
    break;
  case 12: /* DISCONNECT */
    printf("DISCONNECT command\n");
    printf(COMMAND_NOT_IMPLEMENTED);
    break;
  default:
    printf("Command not found\n");
    break;
  }
}

void BTPVA_routine_WW_Command(void) {
  char buffer[MAX_SIZE] = {"\0"};
  int bytes_read = 0;
  int WW;
  int Command;

  bytes_read = mq_receive(mq_voice_ui, buffer, MAX_SIZE, NULL);
  if (bytes_read > 0) {
    sscanf(buffer, "%d%d", &WW, &Command);
    BTPVA_call_custom(WW, Command);
  }
}

/*****************************************************************************/
/*             CODE TO EXEC IN OTHER THREAD                                  */
/*****************************************************************************/
static volatile int running_ = 1;
static pthread_t thread_;
static pthread_cond_t cond_ = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t mutex_ = PTHREAD_MUTEX_INITIALIZER;
static int new_command_arrived_ = 0;

TAILQ_HEAD(tailhead, elem) head_;
volatile int commads_queued_ = 0;

static void *BTPVA_run_thread_routine_mqueue_conection(void *args) {
  char buffer[MAX_SIZE];
  int bytes_read = 0;
  int i;

#ifdef DEBUG
  fprintf(stdout, "VIT_run_thread_routine_mqueue_conection\n");
#endif
  printf("Waiting conection...\n");
  while (running_) {
    bytes_read = mq_receive(mq, buffer, MAX_SIZE, NULL);

    if (bytes_read > 0) {
      sPathMediaPlayer[bytes_read] = '\0';

      if (buffer[0] == '0') /* Disconnect */
      {
        iConnectionToBT = false;
        printf("BTDisconnected\n");
      } else /* Connect    */
      {
        printf("BTConnected\n");
        for (i = 1; i < bytes_read; i++) {
          sMAC_Bt[i - 1] = buffer[i];
        }
#ifdef DEBUG
        printf("sMAC_Bt: %s \n", sMAC_Bt);
#endif
        strcpy(sPathMediaPlayer, START_PATH);
        strcat(sPathMediaPlayer, sMAC_Bt);
        strcat(sPathMediaPlayer, END_PATH_MEDIAPLAYER1);
#ifdef DEBUG
        printf("MediaPlayer: %s \n", sPathMediaPlayer);
#endif
        connectDBus();
        iConnectionToBT = true;
      }
    }
  }
#ifdef DEBUG
  fprintf(stdout, "VIT_run_thread_routine_mqueue_conection...exiting\n");
#endif
  return 0;
}

int BTPVA_run_thread() {
  TAILQ_INIT(&head_);
  pthread_cond_init(&cond_, NULL);
  return pthread_create(&thread_, NULL,
                        BTPVA_run_thread_routine_mqueue_conection, NULL);
}

int BTPVA_stop_thread() {
  running_ = 0;
  pthread_join(thread_, NULL);
  pthread_cond_destroy(&cond_);
  return 0;
}

int main(void) {
  BTPVA_init_mqueue();
  BTPVA_run_thread();
  while (1) {
    BTPVA_routine_WW_Command();
  }

  return 0;
}
