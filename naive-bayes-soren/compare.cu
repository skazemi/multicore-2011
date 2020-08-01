/*$Id: compare.cu 2011-06-25 13:22:54$*/
/**
 *This is the source code for Soren, an Adaptive MapReduce framework on graphics
 *processors.
 *Developer: Reza Mokhtari(Shiraz University) 
 *If you have any question on the code, please contact us at 
 *           rmokhtari@cse.shirazu.ac.ir
 * */

/******************************************************************
 *Page View Count (PVC) 
 ******************************************************************/

#ifndef __COMPARE_CU__
#define __COMPARE_CU__
#include "../native_common/SorenInc.h"
#include "global.h"


//-----------------------------------------------------------
//No Sort in this application
//-----------------------------------------------------------
__device__ int compare(const void *d_a, int len_a, const void *d_b, int len_b)
{
	char* word1 = (char*)d_a;
	char* word2 = (char*)d_b;

	for (; *word1 != '\0' && *word2 != '\0' && *word1 == *word2; word1++, word2++);
	if (*word1 > *word2) return 1;
	if (*word1 < *word2) return -1;

	return 0;
}

#endif //__COMPARE_CU__
