/**
* main.cpp
* Author: zhubin
* Created on: 2019-02-12
* Copyright (c) luchangzhineng. All Rights Reserved
*/

#include "transfo_bis.h"
#include "common.h"
int main(int argc, char *argv[])
{
	if (argc != 2) {
		printf("Usage: ./output/transfo-bis test_type\n");
		exit(0);
	}

	int test_type = atoi(argv[1]);
	transfo_bis::TransfoBis* tfb_obj = transfo_bis::TransfoBis::get_obj();

	if (test_type == 1) {
		tfb_obj->add_vec_vec_float();
	}
	return 0;
}
