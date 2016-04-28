.PHONY: clean dependencies

BASE_INSTALL_DIR  := $(HOME)/automation/local
BASE_SRC_DIR      := $(HOME)/automation/src

ROOT_TGZ          := root_v6.06.02.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
ROOT_TGZ_PATH     := $(BASE_SRC_DIR)/$(ROOT_TGZ)
ROOT_SRC_DIR      := $(BASE_SRC_DIR)/root

YEPPP_TGZ         := yeppp-1.0.0.tar.bz2
YEPPP_TGZ_PATH    := $(BASE_SRC_DIR)/$(YEPP_TGZ)
YEPPP_SRC_DIR     := $(BASE_SRC_DIR)/yeppp

CNVNATOR_DIR      := $(BASE_SRC_DIR)/CNVnator

SAMTOOLS_TGZ      := samtools-1.3.tar.bz2
SAMTOOLS_TGZ_PATH := $(BASE_SRC_DIR)/$(SAMTOOLS_TGZ)
SAMTOOLS_SRC_DIR  := $(CNVNATOR_DIR)/samtools

ROOT_SITE_URL     := https://root.cern.ch/download/$(ROOT_TGZ)
YEPPP_SITE_URL    := https://bitbucket.org/MDukhan/yeppp/downloads/$(YEPP_TGZ)
SAMTOOLS_SITE_URL := https://github.com/samtools/samtools/releases/download/1.3/$(SAMTOOLS_TGZ)

ROOT_EXE          := $(BASE_INSTALL_DIR)/local/bin/root.exe

all: dependencies build

build: $(ROOT_EXE)

$(ROOT_EXE): $(ROOT_SRC_DIR) $(BASE_INSTALL_DIR)
	cd $(ROOT_SRC_DIR) && \
	./configure --prefix $(BASE_INSTALL_DIR) --fail-on-missing --minimal && \
	$(MAKE) -j 2

$(ROOT_SRC_DIR): $(BASE_SRC_DIR) $(ROOT_TGZ_PATH)
	cd $(BASE_SRC_DIR) && \
	tar zxvf $(ROOT_TGZ)

$(ROOT_TGZ_PATH): $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
	curl -L -O $(ROOT_SITE_URL)

$(BASE_INSTALL_DIR):
	if [ ! -e $(BASE_INSTALL_DIR) ]; then mkdir -p $(BASE_INSTALL_DIR); fi;

$(BASE_SRC_DIR):
	if [ ! -e $(BASE_SRC_DIR) ]; then mkdir -p $(BASE_SRC_DIR); fi;

dependencies: initialize-repo
	sudo apt-get install -y libxpm4 libxpm-dev
	sudo apt-get install -y zlib1g zlib1g-dev
	sudo apt-get install -y git
	sudo apt-get install -y libncurses5-dev
	
initialize-repo:
	sudo apt-get update
	sudo apt-get install -y build-essential
