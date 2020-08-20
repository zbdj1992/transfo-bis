/**
* process.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "process.h"

namespace transfo_bis {

Process::Process()
{
}

Process::~Process()
{
}

int Process::add_vec_vec_float(float *a, float *b, float *c,
	int num1, int num2, int num3)
{
	if (num1 != num2 || num1 != num3) {
		return -1;
	}
	for (int ii = 0; ii < num3; ii++) {
		c[ii] = a[ii] + b[ii];
	}
	return 0;
}
int Process::get_area_ibeo(unsigned char* src, unsigned char* dst)
{
	int left_start = 0;
    int right_start = 0;
    int up_start = 0;
    //cvZero(dst);
	for (int i = 0;i<512;i++){
		for(int j = 0;j<512;j++){
			dst[512 * i + j] = 0;
		}
	}
    //uchar* p0 = (uchar*)(src->imageData);
    //uchar* p1 = (uchar*)(dst->imageData);
	unsigned char *p0 = src;
	unsigned char *p1 = dst;
    for (int ii = CENT_Y; ii >= 0; ii--) {
        int det = CENT_Y - ii;
        float k = det / (float)(CENT_X - 0);
        for (int tmp_j = CENT_X; tmp_j >= 0; tmp_j--) {
            int tmp_i = CENT_Y - (CENT_X - tmp_j) * k;
            if (p0[MAP_WIDTH * tmp_i + tmp_j] == 0) {
                if (left_start == 1) {
                    p1[MAP_WIDTH * tmp_i + tmp_j] = 255;
                }
            } else {
                left_start = 1;
                break;
            }
        }
        k = det / (float)(MAP_WIDTH - CENT_X);
        for (int tmp_j = CENT_X; tmp_j < MAP_WIDTH; tmp_j++) {
            int tmp_i = CENT_Y - (tmp_j - CENT_X) * k;
            if (p0[MAP_WIDTH * tmp_i + tmp_j] == 0) {
                if (right_start == 1) {
                    p1[MAP_WIDTH * tmp_i + tmp_j] = 255;
                }
            } else {
                right_start = 1;
                break;
            }
        }
    }
    for (int jj = 0; jj < MAP_WIDTH; jj++) {
        int det = CENT_X - jj;
        float k = det / float(CENT_Y - 0);
        for (int tmp_i = CENT_Y; tmp_i >=0; tmp_i--) {
            int tmp_j = CENT_X - (CENT_Y - tmp_i) * k;
            if (p0[MAP_WIDTH * tmp_i + tmp_j] == 0) {
                if (up_start == 1) {
                    p1[MAP_WIDTH * tmp_i + tmp_j] = 255;
                }
            } else {
                up_start = 1;
                break;
            }
        }
    }

    if (use_pad_up) {
        for (int jj = 0; jj < MAP_WIDTH; jj++) {
            int y_min = -1;
            for (int ii = PAD_DOWN; ii >= PAD_TOP; ii--) {
                if (p1[MAP_WIDTH * ii + jj] == 255) {
                    y_min = ii;
                }
            }
            if (y_min > PAD_TOP) {
                for (int ii = y_min - 1; ii >= 0; ii--) {
                    if (p0[MAP_WIDTH * ii + jj] == 0) {
                        p1[MAP_WIDTH * ii + jj] = 200;
                    } else {
                        break;
                    }
                }
            }
        }
    }

    return 0;
}
int Process::range_conv(unsigned char* src, unsigned char* dst, int flag)
{
	int m1 = 3;
    int m3 = m1;
    int m2 = 1;
    int m4 = 3;
    //cvCopy(src, dst);
	for (int i = 0;i<512;i++){
		for(int j = 0;j<512;j++){
			dst[512 * i + j] = src[512 * i + j];
		}
	}
    //uchar* p1 = (uchar*)(dst->imageData);
	unsigned char* p1 = dst;
    for (int i = 0; i < 512; i++) {
        for (int j = 0; j < 512; j++) {
            if (p1[512 * i + j] > 0)
                p1[512 * i + j] = 0;
            else
                p1[512 * i + j] = 255;
        }
    }

    if (flag==0) {
        m1 = 1;
        m3 = 1;
        m2 = 1;
        m4 = 1;
    }
    if (flag==2) {
        m2 = 3;
        m4 = 1;
        m1 = 3;
        m3 = 3;
    }
    for (int i = 1; i <511; i++) {
        for (int j = 1; j < 511; j++){
            if (p1[512 * i + j] < 254) {
                if (p1[512 * i + j] + m1 < p1[512 * (i + 1) + (j - 1)])
                    p1[512 * (i +1) + (j - 1)] = p1[512 * i + j] + m1;
                if (p1[512 * i + j] + m2 < p1[512 * (i + 1) + j])
                    p1[512 * (i + 1) + j] = p1[512 * i + j] + m2;
                if (p1[512 * i + j] + m3 < p1[512 * (i + 1) + (j + 1)])
                    p1[512 * (i +1) + (j + 1)] = p1[512 * i + j] + m3;
                if (p1[512 * i + j] + m4 < p1[512 * i + (j + 1)])
                    p1[512 * i + (j + 1)] = p1[512 * i + j] + m4;
            }
        }
    }
    for (int i = 510; i > 0; i--) {
        for (int j = 510; j > 0; j--) {
            if (p1[512 * i + j] < 254) {
                if (p1[512 * i + j] + m1 < p1[512 * (i - 1) + (j - 1)])
                    p1[512 * (i - 1) + (j - 1)] = p1[512 * i + j] + m1;
                if (p1[512 * i + j] + m2 < p1[512 * (i - 1) + j])
                    p1[512 * (i - 1) + j] = p1[512 * i + j] + m2;
                if (p1[512 * i + j] + m3 < p1[512 * (i - 1) + (j + 1)])
                    p1[512 * (i - 1) + (j + 1)] = p1[512 * i + j] + m3;
                if (p1[512 * i + j] + m4 < p1[512 * i + (j - 1)])
                    p1[512 * i + (j - 1)] = p1[512 * i + j] + m4;
            }
        }
    }
    return 1;
}
int Process::conv_mass_point(unsigned char* img, int scale)
{
	//uchar* pmap = (uchar*)img->imageData;
	unsigned char* pmap = img;
    for (int i = 0; i < MAP_HEIGHT; i++) {
        for (int j = 0; j < MAP_WIDTH; j++) {
            if (pmap[MAP_WIDTH * i + j] <= scale)
                pmap[MAP_WIDTH * i + j] = 255;
            else
                pmap[MAP_WIDTH * i + j] = 0;
        }
    }
    return 0;
}
int Process::gen_drive_area(unsigned char* src,unsigned char* dst,const int width,const int height)
{
	int scale = 20;
	unsigned char img1[width][height];
	unsigned char img2[width][height];
	//unsigned char dst[width][height];
	unsigned char *pimg1 = &img1[0][0];
	unsigned char *pimg2 = &img2[0][0];
	//unsigned char *pdst = &dst[0][0];
	memset(pimg1,0,width*height);
	memset(pimg2,0,width*height);
	//memset(pdst,0,width*height);
	
	range_conv(src,pimg1,1);
	conv_mass_point(pimg1,scale);
	get_area_ibeo(pimg1,pimg2);
	memcpy(dst,pimg2,width*height);
	return 0;
}
}
