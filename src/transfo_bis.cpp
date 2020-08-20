/**
* transfo_bis.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include <sys/time.h>
#include "transfo_bis.h"
#include "def.h"

namespace transfo_bis {

TransfoBis::TransfoBis()
{
}

TransfoBis::~TransfoBis()
{
}

TransfoBis* TransfoBis::get_obj()
{
	static TransfoBis tmp_obj;
	return &tmp_obj;
}

float get_time_ms(struct timeval& start_time, struct timeval& end_time) {
	return (1000 * (end_time.tv_sec - start_time.tv_sec) +
			(end_time.tv_usec - start_time.tv_usec) * 1.0 / 1000);
}

int TransfoBis::add_vec_vec_float(float *a, float *b, float *c,
	int num1, int num2, int num3)
{
	BisType* bis_obj = BisType::get_obj();
	return bis_obj->add_vec_vec_float(a, b, c, num1, num2, num3);
}

int TransfoBis::add_vec_vec_float()
{
	struct timeval start_time;
	struct timeval end_time;
	const int num = 100000;
	float a[num];
	float b[num];
	float c[num];
	for (int ii = 0; ii < num; ii++) {
		a[ii] = 1.0f;
		b[ii] = 2.5f;
		c[ii] = 0.0f;
	}
	printf("test add two vec!\n");
	BisType::get_obj();
	gettimeofday(&start_time, NULL);
	int ret = add_vec_vec_float(a, b, c, num, num, num);
	gettimeofday(&end_time, NULL);
	float deal_time = get_time_ms(start_time, end_time);
	if (ret == -1) {
		printf("fail to cal add\n");
		return -1;
	}
	float result = c[0];
	for (int ii = 0; ii < num; ii++) {
		if (result != c[ii]) {
			printf("result not equal!\n");
			return -1;
		}
	}
	printf("result:[%.2f] repeat:[%d]\n", result, num);
	printf("deal time:[%.2f]ms\n", deal_time);
	return 0;
}
int TransfoBis::gen_drive_area(unsigned char* src,unsigned char* dst,int width,int height)
{
	BisType* bis_obj = BisType::get_obj();
	return bis_obj->gen_drive_area(src,dst,width,height);
}
}
