/*
 * Copyright 2022 NXP
 * SPDX-License-Identifier: BSD-3-Clause
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <mqueue.h>

#define QUEUE_NUMBER 2 // Number of q
#define QUEUE_NAME_VIT "/vit_queue"
#define QUEUE_NAME_BT "/bt_queue"
#define MAX_SIZE 1024
#define MSG_STOP "exit"

#define CHECK(x) \
        do { \
                if (!(x)) { \
                        fprintf(stderr, "%s:%d: ", __func__, __LINE__); \
                        perror(#x); \
                        exit(-1); \
                } \
        } while (0) \

int main(int argc, char **argv){
	mqd_t mq;
	char buffer[MAX_SIZE];
	char QUEUE_NAMES[QUEUE_NUMBER][MAX_SIZE] = {{QUEUE_NAME_VIT},  {QUEUE_NAME_BT}};

	for (int a=0; a<QUEUE_NUMBER; a++ ){
	/* open the mail queue */
	mq = mq_open(QUEUE_NAMES[a], O_WRONLY);
	CHECK((mqd_t)-1 != mq);

	printf("Sending %s %ld to %s\n", argv[1], strlen(argv[1]), QUEUE_NAMES[a]);
	memcpy(buffer, argv[1], strlen(argv[1]));

	/* send the message */
	CHECK(0 <= mq_send(mq, buffer, strlen(argv[1]), 0));

	/* cleanup */
	CHECK((mqd_t)-1 != mq_close(mq));
	}

	return 0;
}
