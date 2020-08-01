#include "../native_common/SorenInc.h"
#include "../native_common/util.h"
#include "../native_common/abstract.h"
#include "../stream_common/common.h"
#include "../stream_common/mapper.h"
#include "convertor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int native_workflow = MAP_REDUCE_ONLY;
Convertor_Func_t convert_func = convert_map_reduce_str_int;
char* convert_map_reduce_str_int(Spec_t* spec, char** hasError)
{
	debug("converting results finalRecordCount:%d\n", spec->finalRecordCount);
	char* startKey=spec->finalKeys;
	char* startVal=spec->finalVals;
	keyVal_t* keyVals=spec->finalKeyVals;
	char * valtostr = (char*)malloc(20);
	if(valtostr == 0)
	{
		*hasError = "can not allocate temporal memory of size 20";
		return NULL;
	}
	int i = 0;
	for(i=0;i<spec->finalRecordCount;i++)
	{
		int wordSize=keyVals[i].keySize;
		if(wordSize<=0)
			continue;
		//debug("1.%d\n", i);
		char* word=(char*)((unsigned long int)keyVals[i].key+(unsigned long int)startKey);
		//debug("2.%d\n", i);
		char* val=(char*)((unsigned long int)keyVals[i].val+(unsigned long int)startVal);
		//debug("3.%d %p %d\n", i, val, val == NULL);
		//debug("3.%c%c%c%c\n", i, val[0], val[1], val[2], val[3]);
		int value=*((int*)(val + 4));
		//debug("4.%d\n", i);
		sprintf(valtostr,"%d", value);
		//debug("5.%d\n", i);
		printf("%s\t%d\n", word, value);
		if (wordSize == 0)
			warn("wordSize is 0 for word %s\n", word);
		//word[wordSize] = 0;
		int valsize = strlen(valtostr);
		//debug("6.%d keysize:%d value:%d<%d>\n", i, wordSize, value, valsize);
		/*if (i >= 1020000)
		  {
		  fprintf(stderr, "emitIntermediate KEY <");
		  for (int i = 0; i < wordSize; i++)
		  fprintf(stderr, "%c", word[i]);
		  fprintf(stderr, ">\t");
		  fprintf(stderr, "VAL<");
		  for (int i = 0; i < valsize; i++)
		  fprintf(stderr, "%c", valtostr[i]);
		  fprintf(stderr, ">\n");
		  }*/
		emitIntermediate(word, wordSize, valtostr, valsize);
		//debug("7.%d\n", i);
	}
	//free, new
	free(spec->finalKeyVals);
	free(spec->finalVals);
	free(spec->finalKeys);
	free(valtostr);
	//
	char * mrresult = get_map_result(&i);
	//debug("result size %d\n", i);
	return mrresult;
}
