/**
* transfo_bis.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once
namespace transfo_bis {

class TransfoBis
{
public:
	TransfoBis();
	~TransfoBis();
	static TransfoBis* get_obj();

public:
	int add_vec_vec_float();
	int add_vec_vec_float(float *a, float *b, float *c,
			int num1, int num2, int num3);
public:
	int gen_drive_area(unsigned char* src,unsigned char* dst,int width,int height);
};

}
