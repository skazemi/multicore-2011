/*$Id: reduce.cu 2011-06-25 13:22:54$*/
/**
 *This is the source code for Soren, an Adaptive MapReduce framework on graphics
 *processors.
 *Developer: Reza Mokhtari(Shiraz University) 
 *If you have any question on the code, please contact us at 
 *           rmokhtari@cse.shirazu.ac.ir
 * */

/******************************************************************
 *Naive Bayes (NB) Developer: Saeed Kazemi <kazemi.ms@gmail.com>
 ******************************************************************/

#ifndef __REDUCE_CU__
#define __REDUCE_CU__

#include "../native_common/SorenInc.h"
#include "global.h"

__device__ void nCombine(
		char* key, 
		char** vals, 
		int keySize, 
		int* valSize, 
		int valCount, 
		int totalValCount,
		keyVals_t* output,
		char* startMallocSpace,
		int* spaceOffset,
		int memoryPoolSize
		//char* sharedData
		)
{
	if(keySize<=0)
		return;
	int total = 0;
	NB_VAL_T* o_val=(NB_VAL_T*)GET_OUTPUT_BUF(4);
	for(int i = 0; i < valCount; i++)
		total += ((NB_VAL_T*)vals[i])->count;
	o_val->phase = 0;
	o_val->count = total;
	emitIncremental(key, (char*)o_val, keySize, sizeof(NB_VAL_T), totalValCount, output);
}
__device__ void nReduce	(
		char* key, 
		char** vals, 
		int keySize, 
		int* valSize, 
		int valCount, 
		int totalValCount,
		keyVals_t* input,
		keyVal_t* output,
		char* startMallocSpace,
		int* spaceOffset,
		int memoryPoolSize
		//char* sharedData
		)
{
	if(keySize<=0)
		return;
	int total = 0;
	NB_VAL_T* o_val=(NB_VAL_T*)GET_OUTPUT_BUF(4);
	for(int i = 0; i < valCount; i++)
		total += ((NB_VAL_T*)vals[i])->count;
	o_val->phase = 0;
	o_val->count = total;
	nEmit(key, (char*)o_val, keySize, sizeof(NB_VAL_T), totalValCount, input, output);
}
#endif //__REDUCE_CU__
