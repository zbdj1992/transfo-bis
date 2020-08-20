/**
* cl_gpu.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once

#include "common.h"
#include "process.h"

namespace transfo_bis {

class ClGpu : public Process
{
public:
	ClGpu();
	~ClGpu();
	static ClGpu* get_obj();
};

}
