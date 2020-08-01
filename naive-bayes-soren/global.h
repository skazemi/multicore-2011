/*$Id: global.cu 2011-06-25 13:22:54$*/
/**
 *This is the source code for Soren, an Adaptive MapReduce framework on graphics
 *processors.
 *Developer: Reza Mokhtari(Shiraz University) 
 *If you have any question on the code, please contact us at 
 *           rmokhtari@cse.shirazu.ac.ir
 * */

/******************************************************************
  Naive Bayes (NB) Developer: Saeed Kazemi <kazemi.ms@gmail.com>
 ******************************************************************/

#ifndef __GLOBAL_H__
#define __GLOBAL_H__

typedef struct
{
	char* file_buf;
	int entry_offset;
	int entry_hash;
} NB_KEY_T;

typedef struct
{
	int phase;
	int count;
} NB_VAL_T;

#endif
