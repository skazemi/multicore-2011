#include "../native_common/SorenInc.h"
#include "global.h"
#include "../native_common/util.h"
#include "../stream_common/reducer.h"
#include "../native_common/abstract.h"
#include <ctype.h>

float hashTableTuner=200;
int spacePerThread = 1;
int selectedEngine = 0;
float valSpaceTuner = 2.5;
float keySpaceTuner = 1.8;
/*
void SplitToMapInputRecord(Spec_t* spec, const char * const_input_data,int const_input_data_size, char ** hasError)
{
	debug("Innnnnnnnnnnnnnnnn SplitToMapInputRecord\n");
	PVC_VAL_T val;
        int offset = 0;
        int p = 0;
        int start = 0;
        int numOfRecs = 0;
        int sizeOfRecs = 0;
	double allrectime = 0;
        TimeVal_t preTimer;
	val.phase = 0;
	val.count=0;
        while (1)
        {
                int blockSize = 23;// 2 * 1024;
                if (offset + blockSize > const_input_data_size) blockSize = const_input_data_size - offset;

                p += blockSize;
                for (; p < const_input_data_size && const_input_data[p] != '\n' ; p++);
		p++;

                if (p < const_input_data_size)
                {
                        blockSize = (int)(p - start);
			//startTimer2(&preTimer);
                        AddMapInputRecord(spec, (void*)(const_input_data + start), &val, blockSize, sizeof(PVC_VAL_T));
			//allrectime += endTimer2(&preTimer);
                        sizeOfRecs+=blockSize;
                        numOfRecs+=1;
                        if (*spec->hasError){
                                error("while AddMapInputRecord\n");
                                break;
                        }
                        offset += blockSize;
                        start = p;
                }
                else
                {
                        blockSize = (int)(const_input_data_size - offset);
			startTimer2(&preTimer);
                        AddMapInputRecord(spec,(void*) (const_input_data + offset), &val, blockSize, sizeof(PVC_VAL_T));
			allrectime += endTimer2(&preTimer);
                        sizeOfRecs+=blockSize;
                        numOfRecs+=1;
                        break;
                }
        }
}
*/

void SplitToMapInputRecord(Spec_t* spec, const char * const_input_data,int const_input_data_size, char ** hasError)
{
	debug("Innnnnnnnnnnnnnnnn SplitToMapInputRecord\n");
	int offset = 0;
	int start = 0;
	int cur = 0;
	NB_VAL_T val;
	val.phase = 0;
        int numOfRecs = 0;
        int sizeOfRecs = 0;
	info("phase is set to %d\n", phase);
	while (1)
	{
		for (; const_input_data[offset] != '\n'; ++offset);
		// *offset = '\0';
		if(offset == 0)
			break;
		offset++;
		val.count = 10; // nember of columns
		val.phase = phase;
		cur += (offset-start);
		if (cur >= const_input_data_size) break;
		AddMapInputRecord(spec, (void*)(const_input_data + start), &val, (offset-start), sizeof(NB_VAL_T));
		numOfRecs++;
		sizeOfRecs += offset - start;
		start = offset;
	}
	debugWait("after AddMapInputRecords");
        info("After AddMapInputRecords, data size %d, numOfRecs %d, sizeOfRecs %d\n", const_input_data_size, numOfRecs, sizeOfRecs);
}
void SplitToReduceInputRecord(Spec_t* spec, const char * const_input_data,int const_input_data_size, char ** hasError)
{
	debug("not implemented yet\n");
}
