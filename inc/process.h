/**
* process.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once

#include "common.h"
namespace transfo_bis {
#define MAP_WIDTH 512
#define MAP_HEIGHT 512
#define CENT_X 256
#define CENT_Y 395
#define LINE_TOP 150
#define LINE_DOWN 350
#define PAD_TOP 150
#define PAD_DOWN 250
const int use_pad_up = 0;
const int use_pad_side = 0;
class Process
{
public:
	Process();
	~Process();

public:
	virtual int add_vec_vec_float(float *a, float *b, float *c,
			int num1, int num2, int num3);
public:
    virtual int gen_drive_area(unsigned char* src,unsigned char* dst,int width,int height);
private:
	int get_area_ibeo(unsigned char* src, unsigned char* dst);
    int range_conv(unsigned char* src, unsigned char* dst, int flag);
    int conv_mass_point(unsigned char* img, int scale);
};
}
