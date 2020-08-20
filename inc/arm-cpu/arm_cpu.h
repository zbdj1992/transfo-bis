/**
* arm_cpu.h
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#pragma once

#include "common.h"
#include "process.h"

namespace transfo_bis {

class ArmCpu : public Process
{
public:
	ArmCpu();
	~ArmCpu();
	static ArmCpu* get_obj();
};

}
