/**
* nvidia_gpu.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once

#include "common.h"
#include "process.h"

namespace transfo_bis {

class NvidiaGpu : public Process
{
public:
	NvidiaGpu();
	~NvidiaGpu();
	static NvidiaGpu* get_obj();

public:
	int add_vec_vec_float(float *a, float *b, float *c,
			int num1, int num2, int num3);

public:
	float* _1Mfloat_aa;
	float* _1Mfloat_bb;
	float* _1Mfloat_cc;
public:
	int gen_drive_area(unsigned char* src,unsigned char* dst,int width,int height);
public:
	unsigned char* _ibeoSrcImg;
	unsigned char* _ibeoTmpImg;
	unsigned char* _ibeoDstImg;
};

}
