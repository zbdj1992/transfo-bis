/**
* linux_cpu.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "linux_cpu.h"

namespace transfo_bis {

LinuxCpu::LinuxCpu()
{
}

LinuxCpu::~LinuxCpu()
{
}

LinuxCpu* LinuxCpu::get_obj()
{
	static LinuxCpu tmp_obj;
	return &tmp_obj;
}

}
