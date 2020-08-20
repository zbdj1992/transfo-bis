/**
* cl_gpu.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "cl_gpu.h"

namespace transfo_bis {

ClGpu::ClGpu()
{
}

ClGpu::~ClGpu()
{
}

ClGpu* ClGpu::get_obj()
{
	static ClGpu tmp_obj;
	return &tmp_obj;
}

}
