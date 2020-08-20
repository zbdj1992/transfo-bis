MODEL_TYPE=

WORKROOT=.
CPU_LINUX_INC=$(WORKROOT)/inc/linux-cpu
CPU_ARM_INC=$(WORKROOT)/inc/arm-cpu
GPU_NVIDIA_INC=$(WORKROOT)/inc/nvidia-gpu
GPU_CL_INC=$(WORKROOT)/inc/cl-gpu
CU_DIR=/usr/local/cuda/lib64

#MODEL_TYPE=linuxcpu
#MODEL_TYPE=armcpu
MODEL_TYPE=nvidiagpu
#MODEL_TYPE=clgpu

OPT = debug
#OPT = release

GCC = g++
NVCC = nvcc
AR = ar

CORE_SRC=$(WORKROOT)/src
MAIN_SRC=$(WORKROOT)/src/main
CPU_LINUX_SRC=$(WORKROOT)/src/linux-cpu
CPU_ARM_SRC=$(WORKROOT)/src/arm-cpu
GPU_NVIDIA_SRC=$(WORKROOT)/src/nvidia-gpu
GPU_CL_SRC=$(WORKROOT)/src/cl-gpu

ifeq ($(MODEL_TYPE), linuxcpu)
USE_SRC=$(CPU_LINUX_SRC)
CPPFLAGS=-DLINUXCPU
else ifeq ($(MODEL_TYPE), armcpu)
USE_SRC=$(CPU_ARM_SRC)
CPPFLAGS=-DARMCPU
else ifeq ($(MODEL_TYPE), nvidiagpu)
USE_SRC=$(GPU_NVIDIA_SRC)
CPPFLAGS=-DNVIDIAGPU
else ifeq ($(MODEL_TYPE), clgpu)
USE_SRC=$(GPU_CL_SRC)
CPPFLAGS=-DCLGPU
endif

LIB_PATH=$(WORKROOT)/lib

INCLUDEDIR= -I$(CPU_LINUX_INC)       \
			-I$(CPU_ARM_INC)         \
			-I$(GPU_NVIDIA_INC)      \
			-I$(GPU_CL_INC)          \
			-I./inc

LIBDIR=		-L$(LIB_PATH) \
			-lm       \
			-lz       \
			-lrt      \
			-lpthread \
			-lstdc++

CULIB = -L$(CU_DIR) -lcudart -lcublas -lcurand

INCOUT= $(WORKROOT)/inc

SYSTEM = $(shell uname)
OBJDIR   = tmp_obj.$(SYSTEM).$(OPT)

MAINSRCWILD    = $(wildcard $(MAIN_SRC)/*.cpp)
MAINOBJS       = $(patsubst $(MAIN_SRC)/%.cpp, $(OBJDIR)/%_main_at.o, $(MAINSRCWILD))
CORESRCWILD    = $(wildcard $(CORE_SRC)/*.cpp)
COREOBJS       = $(patsubst $(CORE_SRC)/%.cpp, $(OBJDIR)/%_core_at.o, $(CORESRCWILD))
USESRCWILD    = $(wildcard $(USE_SRC)/*.cpp)
USEOBJS       = $(patsubst $(USE_SRC)/%.cpp, $(OBJDIR)/%_plat_at.o, $(USESRCWILD))
CUSRCWILD    = $(wildcard $(USE_SRC)/*.cu)
CUOBJS       = $(patsubst $(USE_SRC)/%.cu, $(OBJDIR)/%_plat_cu.o, $(CUSRCWILD))

TARGET1 = transfo_bis
LIBS    = libtransfo_bis.a
all : check output

ifeq ($(OPT), release)
CPPFLAGS += -O3 -finline-functions -Wall -pipe -Wno-deprecated -Wunused-variable -DNDEBUG -fPIC
else ifeq ($(OPT), debug)
CPPFLAGS += -g -finline-functions -Wall -pipe -Wno-deprecated -fPIC
endif

NVCCFLAGS = -O3 -Xcompiler -fPIC -m64 -Wno-deprecated-gpu-targets

$(OBJDIR)/%_main_at.o : $(MAIN_SRC)/%.cpp
	$(GCC) $(CPPFLAGS) -c $< -o $@ $(INCLUDEDIR)

$(OBJDIR)/%_core_at.o : $(CORE_SRC)/%.cpp
	$(GCC) $(CPPFLAGS) -c $< -o $@ $(INCLUDEDIR)

$(OBJDIR)/%_plat_at.o	: $(USE_SRC)/%.cpp
	$(GCC) $(CPPFLAGS) -c $< -o $@ $(INCLUDEDIR)

$(OBJDIR)/%_plat_cu.o	: $(USE_SRC)/%.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@ $(INCLUDEDIR)

$(TARGET1) : $(MAINOBJS) $(COREOBJS) $(USEOBJS) $(CUOBJS)
	$(GCC) $(CPPFLAGS) -fPIC -o $@ $^ $(LIBDIR) $(CULIB)

$(LIBS) : $(COREOBJS) $(USEOBJS) $(CUOBJS)
	$(AR) cqs $@ $^

check:
ifeq ($(MODEL_TYPE),)
	$(error "model type not set")
endif
ifneq ($(OBJDIR), $(wildcard $(OBJDIR)))
	mkdir $(OBJDIR)
endif
	$(info "model type: $(MODEL_TYPE)")

OUT_DIR=./output_$(MODEL_TYPE)
output: $(TARGET1) $(LIBS)
	rm -rf $(OUT_DIR)
	mkdir -p $(OUT_DIR)/bin
	mkdir -p $(OUT_DIR)/inc
	mkdir -p $(OUT_DIR)/lib
	cp -f ${TARGET1}  $(OUT_DIR)/bin
	cp -f ${LIBS}     $(OUT_DIR)/lib
	cp -f $(INCOUT)/transfo_bis.h  $(OUT_DIR)/inc
	rm -rf $(TARGET1) $(LIBS)

clean:
	rm -rf $(OBJDIR) $(TARGET1) $(LIBS) ./output*

