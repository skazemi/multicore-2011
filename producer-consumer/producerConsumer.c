#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int head;
int tail;
int counter;
int burgernum;
int queueSize;
int toCook;
int toEat;
int total;
int * buffer;

pthread_mutex_t counter_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t enqueue_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t dequeue_lock = PTHREAD_MUTEX_INITIALIZER;

void * produce(void *);
void * consume(void *);

int main (int argc, const char * argv[]) {
	if (argc < 6) {
		printf("Usage:\n\tNumOfCooks NumOfStudents QueueSize ToCook(each cook) ToEat(each student)\n");
		exit(0);
	}
	int i;
	int	numOfCooks = atoi(argv[1]);
	int numOfStudents = atoi(argv[2]);
	pthread_t cooks[numOfCooks];
	pthread_t students[numOfStudents];
	queueSize = atoi(argv[3]);
	toCook = atoi(argv[4]);
	toEat = atoi(argv[5]);
	head = 0;
	tail = 0;
	counter = 0;
	burgernum = 0;
	total = numOfCooks * toCook - 1;
	buffer = (int *) malloc(queueSize * sizeof(int));
	for (i = 0; i < numOfCooks; i++)
		pthread_create(&cooks[i], NULL, produce, (void *)i);
	for (i = 0; i < numOfStudents; i++)
		pthread_create(&students[i], NULL, consume, (void *)i);
	for (i = 0; i < numOfCooks; i++)
		pthread_join(cooks[i], NULL);
	for (i = 0; i < numOfStudents; i++)
		pthread_join(students[i], NULL);
	free(buffer);
    return 0;
}

void * produce(void * id) {
	int i;
	int current;
	int previous = 0;
	for (i = 0; i < toCook; i++) {
		current = previous;
		pthread_mutex_lock(&enqueue_lock);
		pthread_mutex_lock(&counter_lock);
		if (counter < queueSize) {
			counter++;
			buffer[head] = burgernum++;
			pthread_mutex_unlock(&counter_lock);
			current = burgernum;
			if (++head == queueSize)
				head = 0;
		}
		else
			pthread_mutex_unlock(&counter_lock);
		pthread_mutex_unlock(&enqueue_lock);
		if (current > previous)
			printf("Cook %d: I cooked burger %d.\n", (int)id, current - 1);
		else
			i--;
	}
	pthread_exit(NULL);
}

void * consume(void * id) {
	int i;
	int current;
	int previous = 0;
	for (i = 0; i < toEat; i++) {
		current = previous;
		pthread_mutex_lock(&dequeue_lock);
		pthread_mutex_lock(&counter_lock);
		if (counter > 0) {
			counter--;
			current = buffer[tail];
			pthread_mutex_unlock(&counter_lock);
			if (++tail == queueSize)
				tail = 0;
		}
		else
			pthread_mutex_unlock(&counter_lock);
		pthread_mutex_unlock(&dequeue_lock);
		if (current > previous)
			printf("Student %d: I ate burger %d.\n", (int)id, current);
		else { 
			if( tail == 0) {
				if(buffer[queueSize - 1] < total)
					i--;
			}
			else if(buffer[tail - 1] < total)
				i--;
		}
	}
	pthread_exit(NULL);	
}
