/**
* arm_cpu.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "arm_cpu.h"

namespace transfo_bis {

ArmCpu::ArmCpu()
{
}

ArmCpu::~ArmCpu()
{
}

ArmCpu* ArmCpu::get_obj()
{
	static ArmCpu tmp_obj;
	return &tmp_obj;
}

}
