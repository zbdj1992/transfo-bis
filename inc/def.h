/**
* common.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once

#include "linux_cpu.h"
#include "arm_cpu.h"
#include "cl_gpu.h"
#include "nvidia_gpu.h"

namespace transfo_bis {

#ifdef LINUXCPU
	typedef LinuxCpu BisType;
#elif ARMCPU
	typedef ArmCpu BisType;
#elif NVIDIAGPU
	typedef NvidiaGpu BisType;
#elif CLGPU
	typedef ClGpu BisType;
#endif
}
