/*$Id: map.cu 2011-06-25 13:22:54$*/
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

#ifndef __MAP_CU__
#define __MAP_CU__

#include "../native_common/SorenInc.h"
#include "global.h"

__device__ int d_isdigit (char a)
{
	return '0' <= a && a <= '9';
}
__device__ long d_atoi(char* ptr, int size)
{
	long result = 0;
	for (int i = 0; i < size; i++)
		result = result * 10 + (ptr[i] - '0');
	return result;
}
__device__ int d_itoa(char* ptr, long val)
{
	int i;
	long pow = 1;
	for (i = 0; i < 19 && pow <= val; i++)
		pow *= 10;
	if (pow > val)
		pow /= 10;
	for (i = 0; pow > 0; i++)
	{
		ptr[i] = val / pow + '0';
		val = val % pow;
		pow /= 10;
	}
	if(!i)
		ptr[i++] = '0';
	ptr[i] = '\0';
	return i;
}
__device__ long calculateMapKey(int effectColumn, int effectValue, int causeValue)
{
	return causeValue * 100000 + effectColumn * 100 + effectValue;
}
__device__ int hash_func(char* str, int len)
{
	int hash, i;
	for (i = 0, hash=len; i < len; i++)
		hash = (hash<<4)^(hash>>28)^str[i];
	return hash;
}
__device__ void MAP_FUNC//(void *key, void *val, size_t keySize, size_t valSize)
{
	NB_VAL_T* nb_val = (NB_VAL_T*) val;
	if (nb_val->phase == 0)
	{
		int n, k;
		char* p = (char*)key;
		for (int i = 1; i <= nb_val->count; i++)
		{
			for(; !d_isdigit(*p); p++)
				;
			for(n = 0; d_isdigit(p[n]); n++)
				;
			if(i == nb_val->count)
				k = d_atoi(p, n);
			p += n;
		}
		p = (char*)key;
		int nk;
		char buffer[32];
		NB_VAL_T* o_val = (NB_VAL_T*)GET_OUTPUT_BUF(0);
		for (int i = 1; i <= nb_val->count - 1; i++)
		{
			for(; !d_isdigit(*p); p++)
				;
			for(n = 0; d_isdigit(p[n]); n++)
				;
			int j = d_atoi(p, n);
			p += n;
			o_val->count = 1;
			o_val->phase = 0;
			nk = d_itoa(buffer, calculateMapKey(i, j, k)) + 1;
			EMIT_INTERMEDIATE_FUNC(buffer, o_val, nk, sizeof(NB_VAL_T));
		}
		o_val->count = 1;
		o_val->phase = 0;
		nk = d_itoa(buffer, calculateMapKey(0, 0, k)) + 1;
		EMIT_INTERMEDIATE_FUNC(buffer, o_val, nk, sizeof(NB_VAL_T));
	}
	else 
	{
	}
}
#endif //__MAP_CU__
