/*$Id: hash.cu 2011-06-25 13:22:54$*/
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


#ifndef __HASH_CU__
#define __HASH_CU__

#include "../native_common/SorenInc.h"

__device__ int hashfunc(int len, char* str, int numBuckets)
{
	//IF_KEY_T* temp = (IF_KEY_T*)str;
	//int hash = (temp->positionx + temp->positiony) * 2166136261 + temp->positiony * 99;
	//return hash & numBuckets;
#if 1
        int hash = 2166136261;
	int FNVMultiple = 16777619;

	for(int i = 0; i < len; i++)
	{
		hash = hash ^ (str[i]);       /* xor  the low 8 bits */
		hash = hash * FNVMultiple;  /* multiply by the magic number */
	}
	hash += (len*len);
	if(hash<0)
		hash*=-1;
        return hash%numBuckets;
#endif
#if 0
	int FNVMultiple = 16777619;
	int hash = *((int*)str);
	hash *= FNVMultiple;
	if(hash<0)
		hash*=-1;
        return hash%numBuckets;
#endif


}
#if 1
__device__ int hashfuncKeyGenerator(int len, char* str, int numBuckets, int hashExtraNumber)
{

	#if 1
	int hash=200, i;
        for (i = 0, hash=len; i < len; i++)
	{
                hash = (hash<<4)^(hash<<20) | (hashExtraNumber | str[i]);
		hash ^= (str[i]<<5);
	}
	hash *= (numBuckets - hash);
	hash -=  (hashExtraNumber * hashExtraNumber);
	if(hash<0)
		hash*=-1;
	#endif
	#if 0
	int FNVMultiple = 16777619;
	
	int hash = len;
	hash *= *((int*)str);
	hash *= FNVMultiple;
	hash += hashExtraNumber;
	hash *= FNVMultiple;
	if(hash<0)
		hash *= -1;
	#endif
        return hash%numBuckets;
}
#endif

#endif
