/**
* nvidia_gpu.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "nvidia_gpu.h"
#include "cuda_runtime.h"

namespace transfo_bis {

NvidiaGpu::NvidiaGpu()
{
	cudaFree(0);
	cudaMalloc((void**)&_1Mfloat_aa, 1024 * 1024 * sizeof(float));
	cudaMalloc((void**)&_1Mfloat_bb, 1024 * 1024 * sizeof(float));
	cudaMalloc((void**)&_1Mfloat_cc, 1024 * 1024 * sizeof(float));
	cudaMalloc((void**)&_ibeoSrcImg, 512*512*sizeof(unsigned char));
	cudaMalloc((void**)&_ibeoDstImg, 512*512*sizeof(unsigned char));
	cudaMalloc((void**)&_ibeoTmpImg, 512*512*sizeof(unsigned char));
	
}

NvidiaGpu::~NvidiaGpu()
{
	cudaFree(_1Mfloat_aa);
	cudaFree(_1Mfloat_bb);
	cudaFree(_1Mfloat_cc);
	cudaFree(_ibeoSrcImg);
	cudaFree(_ibeoDstImg);
	cudaFree(_ibeoTmpImg);
}

NvidiaGpu* NvidiaGpu::get_obj()
{
	static NvidiaGpu tmp_obj;
	return &tmp_obj;
}

__global__ void KeAddVecVecFloat(float *a, float *b, float *c, int n)
{
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	if (i < n) {
		c[i] = a[i] + b[i];
	}
}
__global__ void KeImgCopy(unsigned char *src,unsigned char *dst,int width,int height){
	int xIndex = threadIdx.x + blockIdx.x * blockDim.x;
	int yIndex = threadIdx.y + blockIdx.y * blockDim.y;
	if((xIndex < width) && (yIndex < height)){
		dst[yIndex*width+xIndex] = src[yIndex*width+xIndex];
	}
}
__global__ void KeImgRev(unsigned char *img,int width,int height){
	int xIndex = threadIdx.x + blockIdx.x * blockDim.x;
	int yIndex = threadIdx.y + blockIdx.y * blockDim.y;
	if((xIndex < width) && (yIndex < height)){
		if(img[yIndex*width+xIndex] > 0){
			img[yIndex*width+xIndex] = 0;
		}else{
			img[yIndex*width+xIndex] = 255;
		}
	}
}

__global__ void KeImgRangeConvStep1(unsigned char *img,int width,int height,int flag){
	int m1 = 3;
	int m3 = m1;
	int m2 = 1;
	int m4 = 3;
	if (flag==0) {
		m1 = 1;m3 = 1;
		m2 = 1;m4 = 1;
	}
	if (flag==2) {
		m2 = 3;m4 = 1;
		m1 = 3;m3 = 3;
	}
	int xIndex = threadIdx.x + blockIdx.x * blockDim.x;
	int yIndex = threadIdx.y + blockIdx.y * blockDim.y;
	if((xIndex > 0) && (yIndex > 0) && (xIndex < width-1) && (yIndex < height-1)){
		if(img[yIndex*width+xIndex] < 254){
			int xIndexTmp = xIndex-1;
			int yIndexTmp = yIndex+1;
			if((img[yIndex*width+xIndex]+m1) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndex*width+xIndex]+m1;
			xIndexTmp = xIndex;
			yIndexTmp = yIndex+1;
			if((img[yIndex*width+xIndex]+m2) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndex*width+xIndex]+m2;
			xIndexTmp = xIndex+1;
			yIndexTmp = yIndex+1;
			if((img[yIndex*width+xIndex]+m3) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndex*width+xIndex]+m3;
			xIndexTmp = xIndex+1;
			yIndexTmp = yIndex;
			if((img[yIndex*width+xIndex]+m4) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndex*width+xIndex]+m4;

		}
	}
}
__global__ void KeImgRangeConvStep2(unsigned char *img,int width,int height,int flag){
	int m1 = 3;
	int m3 = m1;
	int m2 = 1;
	int m4 = 3;
	if (flag==0) {
		m1 = 1;m3 = 1;
		m2 = 1;m4 = 1;
	}
	if (flag==2) {
		m2 = 3;m4 = 1;
		m1 = 3;m3 = 3;
	}
	int xIndex = threadIdx.x + blockIdx.x * blockDim.x;
	int yIndex = threadIdx.y + blockIdx.y * blockDim.y;
	int xIndexR = width - xIndex;
	int yIndexR = height - yIndex;
	if((xIndexR > 0) && (yIndexR > 0) && (xIndexR < width-2) && (yIndexR < height-2)){
		if(img[yIndexR*width+xIndexR] < 254){
			int xIndexTmp = xIndexR-1;
			int yIndexTmp = yIndexR-1;
			if((img[yIndexR*width+xIndexR]+m1) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndexR*width+xIndexR]+m1;
			xIndexTmp = xIndexR;
			yIndexTmp = yIndexR-1;
			if((img[yIndexR*width+xIndexR]+m2) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndexR*width+xIndexR]+m2;
			xIndexTmp = xIndexR+1;
			yIndexTmp = yIndexR-1;
			if((img[yIndexR*width+xIndexR]+m3) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndexR*width+xIndexR]+m3;
			xIndexTmp = xIndexR-1;
			yIndexTmp = yIndexR;
			if((img[yIndexR*width+xIndexR]+m4) < img[yIndexTmp*width+xIndexTmp])
				img[yIndexTmp*width+xIndexTmp] = img[yIndexR*width+xIndexR]+m4;

		}
	}
}
__global__ void KeImgConvMassPoint(unsigned char *img,int width,int height,int scale){
	int xIndex = threadIdx.x + blockIdx.x * blockDim.x;
	int yIndex = threadIdx.y + blockIdx.y * blockDim.y;
	if((xIndex < width) && (yIndex < height)){
		if(img[yIndex*width+xIndex] <= scale)
			img[yIndex*width+xIndex] = 255;
	    else
	    	img[yIndex*width+xIndex] = 0;
	    }
}

int NvidiaGpu::add_vec_vec_float(float *a, float *b, float *c,
	int num1, int num2, int num3)
{
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	if (num1 != num2 || num1 != num3) {
		return -1;
	}
	if ((num1 >> 20) > 0) {
		printf("size to big!\n");
		return -1;
	}
	int block_size = 512;
	int grid_size = num1 >> 9;
	grid_size += 1;
	dim3 dimBlock(block_size);
	dim3 dimGrid(grid_size);
	int byte_size = num1 * sizeof(float);
	cudaMemcpy(_1Mfloat_aa, a, byte_size, cudaMemcpyHostToDevice);
	cudaMemcpy(_1Mfloat_bb, b, byte_size, cudaMemcpyHostToDevice);
	cudaEventRecord(start);
	KeAddVecVecFloat<<<dimGrid, dimBlock>>>(_1Mfloat_aa, _1Mfloat_bb, _1Mfloat_cc, num1);
	cudaEventRecord(stop);
	cudaMemcpy(c, _1Mfloat_cc, byte_size, cudaMemcpyDeviceToHost);

	float time;
	cudaEventElapsedTime(&time, start, stop);
	printf("cuda time:[%.2f]ms\n", time);
	return 0;
}
int NvidiaGpu::gen_drive_area(unsigned char* src,unsigned char* dst,int width,int height)
{
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	int byteSize = width*height;
	int scale = 20;
	int flag = 1;
	cudaMemcpy(_ibeoSrcImg,src,byteSize,cudaMemcpyHostToDevice);
	dim3 threadsPerBlock(32,32);
	dim3 blocksPerGrid((width + threadsPerBlock.x - 1) / threadsPerBlock.x,(height + threadsPerBlock.y -1)/ threadsPerBlock.y);
	cudaEventRecord(start);
	KeImgCopy<<<blocksPerGrid,threadsPerBlock>>> (_ibeoSrcImg,_ibeoTmpImg,width,height);
	KeImgRev<<<blocksPerGrid,threadsPerBlock>>> (_ibeoTmpImg,width,height);
	KeImgRangeConvStep1<<<blocksPerGrid,threadsPerBlock>>> (_ibeoTmpImg,width,height,flag);
	KeImgRangeConvStep2<<<blocksPerGrid,threadsPerBlock>>> (_ibeoTmpImg,width,height,flag);
	KeImgConvMassPoint<<<blocksPerGrid,threadsPerBlock>>> (_ibeoTmpImg,width,height,scale);
	cudaEventRecord(stop);
	//
	cudaMemcpy(dst,_ibeoTmpImg,byteSize,cudaMemcpyDeviceToHost);
	//cudaMemcpy(dst,_ibeoDstImg,byteSize,cudaMemcpyDeviceToHost);
	float time;
	cudaEventElapsedTime(&time, start, stop);
	printf("cuda time:[%.2f]ms\n", time);
	return 0;
}
}
