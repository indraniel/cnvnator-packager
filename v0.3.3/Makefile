.PHONY: clean dependencies debian

CNVNATOR_VERSION  := 0.3.3

BASE_DIR          := /opt/cnvnator-$(CNVNATOR_VERSION)
BASE_INSTALL_DIR  := $(BASE_DIR)
BASE_SRC_DIR      := $(BASE_DIR)/src

ROOT_TGZ          := root_v6.06.02.source.tar.gz
ROOT_TGZ_PATH     := $(BASE_SRC_DIR)/$(ROOT_TGZ)
ROOT_SRC_DIR      := $(BASE_SRC_DIR)/root-6.06.02
ROOT_VERSION      := 6.06.02

YEPPP_TGZ         := yeppp-1.0.0.tar.bz2
YEPPP_TGZ_PATH    := $(BASE_SRC_DIR)/$(YEPPP_TGZ)
YEPPP_SRC_DIR     := $(BASE_SRC_DIR)/yeppp-1.0.0

CNVNATOR_SRC_DIR  := $(BASE_SRC_DIR)/CNVnator
CNVNATOR_TAG      := v$(CNVNATOR_VERSION)

SAMTOOLS          := 1.8
SAMTOOLS_TGZ      := samtools-1.8.tar.bz2
SAMTOOLS_TGZ_PATH := $(CNVNATOR_SRC_DIR)/$(SAMTOOLS_TGZ)
SAMTOOLS_SRC_DIR  := $(CNVNATOR_SRC_DIR)/samtools

ROOT_SITE_URL     := https://root.cern.ch/download/$(ROOT_TGZ)
YEPPP_SITE_URL    := https://bitbucket.org/MDukhan/yeppp/downloads/$(YEPPP_TGZ)
SAMTOOLS_SITE_URL := https://github.com/samtools/samtools/releases/download/${SAMTOOLS}/$(SAMTOOLS_TGZ)

ROOT_EXE           := $(BASE_INSTALL_DIR)/bin/root.exe
YEPPP_LIB          := $(BASE_INSTALL_DIR)/lib/libyeppp.so 
CNVNATOR_EXE       := $(BASE_INSTALL_DIR)/bin/cnvnator-$(CNVNATOR_VERSION)
SAMTOOLS_LIB       := $(CNVNATOR_SRC_DIR)/samtools/libbam.a

DEB_BUILD_DIR       := $(BASE_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := cnvnator_$(CNVNATOR_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(BASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/cnvnator-$(CNVNATOR_VERSION)

all: dependencies build

build: $(ROOT_EXE) $(YEPPP_LIB) $(CNVNATOR_EXE)

$(CNVNATOR_EXE): export LD_LIBRARY_PATH := $(BASE_INSTALL_DIR)/lib:$(BASE_INSTALL_DIR)/lib/root:$(LD_LIBRARY_PATH)
$(CNVNATOR_EXE): export PATH := $(BASE_INSTALL_DIR)/bin:$(PATH)
$(CNVNATOR_EXE): export YEPPPLIBDIR := $(BASE_INSTALL_DIR)/lib
$(CNVNATOR_EXE): export YEPPPINCLUDEDIR := $(BASE_INSTALL_DIR)/include
$(CNVNATOR_EXE): export ROOTSYS := $(BASE_INSTALL_DIR)
$(CNVNATOR_EXE): $(YEPP_LIB) $(SAMTOOLS_LIB) | $(CNVNATOR_SRC_DIR) 
	cd $(CNVNATOR_SRC_DIR) && \
		$(MAKE) && \
		cp -v cnvnator $(BASE_INSTALL_DIR)/bin/cnvnator-$(CNVNATOR_VERSION)

$(SAMTOOLS_LIB): | $(SAMTOOLS_SRC_DIR)
	cd $(SAMTOOLS_SRC_DIR) && \
		$(MAKE)

$(SAMTOOLS_SRC_DIR): | $(SAMTOOLS_TGZ_PATH) $(CNVNATOR_SRC_DIR) 
	cd $(CNVNATOR_SRC_DIR) && \
		tar jxvf $(SAMTOOLS_TGZ) && \
		mv samtools-1.3 samtools

$(SAMTOOLS_TGZ_PATH): | $(CNVNATOR_SRC_DIR)
	cd $(CNVNATOR_SRC_DIR) && \
		curl -L -O $(SAMTOOLS_SITE_URL)

$(CNVNATOR_SRC_DIR): | $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		git clone https://github.com/abyzovlab/CNVnator && \
		cd CNVnator && \
		git checkout tags/$(CNVNATOR_TAG) -b $(CNVNATOR_TAG)

$(YEPPP_LIB): | $(YEPPP_SRC_DIR) $(BASE_INSTALL_DIR)
	cd $(YEPPP_SRC_DIR) && \
		cp -v binaries/linux/x86_64/libyeppp.so $(BASE_INSTALL_DIR)/lib && \
		cp -v library/headers/*.h $(BASE_INSTALL_DIR)/include

$(YEPPP_SRC_DIR): | $(YEPPP_TGZ_PATH) $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		tar jxvf $(YEPPP_TGZ)

$(YEPPP_TGZ_PATH): | $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		curl -L -O $(YEPPP_SITE_URL)

$(ROOT_EXE): | $(ROOT_SRC_DIR) $(BASE_INSTALL_DIR)
	cd $(ROOT_SRC_DIR) && \
		./configure --prefix=$(BASE_INSTALL_DIR) --fail-on-missing --minimal && \
		$(MAKE) -j 2 && \
		$(MAKE) install

$(ROOT_SRC_DIR): $(ROOT_TGZ_PATH) | $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		tar zxvf $(ROOT_TGZ)

$(ROOT_TGZ_PATH): | $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		curl -L -O $(ROOT_SITE_URL)

$(BASE_INSTALL_DIR):
	if [ ! -e $(BASE_INSTALL_DIR) ]; then \
		sudo mkdir -p $(BASE_INSTALL_DIR); \
		sudo chown -R $(USER):$(USER) $(BASE_DIR); \
	fi;

$(BASE_SRC_DIR):
	if [ ! -e $(BASE_SRC_DIR) ]; then \
		sudo mkdir -p $(BASE_SRC_DIR); \
		sudo chown -R $(USER):$(USER) $(BASE_DIR); \
	fi;

dependencies: initialize-repo
	sudo apt-get install -y libgomp1
	sudo apt-get install -y libstdc++6
	sudo apt-get install -y libgcc1
	sudo apt-get install -y libxpm4 libxpm-dev
	sudo apt-get install -y zlib1g zlib1g-dev
	sudo apt-get install -y git
	sudo apt-get install -y libncurses5-dev
	
initialize-repo:
	sudo apt-get update
	sudo apt-get install -y build-essential

clean:
	rm -rf $(BASE_DIR)

debclean:
	if [ -d $(DEB_BUILD_DIR) ]; then rm -rf $(DEB_BUILD_DIR); fi;
	if [ -e $(DEB_PKG_PATH) ]; then rm -rf $(DEB_PKG_PATH); fi;

# CNVNATOR EXECUTABLE DEBIAN WRAPPER ##########################################
define cnvnator_wrapper
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)

export LD_LIBRARY_PATH=$${BASE}/lib:$${BASE}/lib/root:$${LD_LIBRARY_PATH}
export PATH=$${BASE}/bin:$${PATH}

$${BASE}/bin/cnvnator-$(CNVNATOR_VERSION) $$@
endef
export cnvnator_wrapper

# ROOT EXECUTABLE DEBIAN WRAPPER ##############################################
define root_wrapper
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)

export LD_LIBRARY_PATH=$${BASE}/lib:$${BASE}/lib/root:$${LD_LIBRARY_PATH}
export PATH=$${BASE}/bin:$${PATH}

$${BASE}/bin/root.exe $$@
endef
export root_wrapper

# DEBIAN CONTROL FILE #########################################################
define debian_control
Package: cnvnator-$(CNVNATOR_VERSION)
Architecture: amd64
Section: science
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Depends: build-essential, libc6, zlib1g, libgomp1, libstdc++6, libgcc1
Description: An unofficial WUSTL MGI package of CNVnator ( $(CNVNATOR_VERSION) )
Version: $(CNVNATOR_VERSION)-$(DEB_RELEASE_VERSION)
endef
export debian_control

# DEBIAN PREINST FILE #########################################################
define debian_preinst
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
SUBDIRS=(bin etc include lib include share)

if [ -e $${BASE} ]; then
    ROOT=$${BASE}/srasearch
    for subdir in $${SUBDIRS[*]}; do
        DIR=$${ROOT}/$${subdir}
        if [ ! -e $${DIR} ]; then
            mkdir -p $${DIR}
            chmod 0775 $${DIR}
        fi
    done
fi

endef
export debian_preinst

# DEBIAN POSTRM FILE ##########################################################
define debian_postrm
#!/bin/bash

BASE=/opt/cnvnator-$(CNVNATOR_VERSION)

if [ -e $${BASE} ]; then
    rm -rfv $${BASE}
fi

if [ -e /usr/local/cnvnator ]; then
    rm -fv /usr/local/cnvnator
fi

if [ -e /usr/local/root ]; then
    rm -fv /usr/local/root
fi

endef
export debian_postrm

debian:
	# setup the directory
	test -d $(DEB_BUILD_DIR) || mkdir $(DEB_BUILD_DIR)
	
	# setup the debian package meta information
	echo "$$debian_preinst" > $(DEB_BUILD_DIR)/preinst
	echo "$$debian_postrm" > $(DEB_BUILD_DIR)/postrm
	echo "$$debian_control" > $(DEB_BUILD_DIR)/control
	echo 2.0 > $(DEB_BUILD_DIR)/debian-binary
	
	# create the "installed" file directory structure
	mkdir -p $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# install compiled materials for cnvnator & root
	cp -rv $(BASE_INSTALL_DIR)/bin $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(BASE_INSTALL_DIR)/etc $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(BASE_INSTALL_DIR)/include $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(BASE_INSTALL_DIR)/lib $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(BASE_INSTALL_DIR)/share $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the "wrapper" scripts for cnvnator and root
	mkdir -p $(DEB_BUILD_DIR)/usr/local/bin
	echo "$$cnvnator_wrapper" >$(DEB_BUILD_DIR)/usr/local/bin/cnvnator
	chmod a+x $(DEB_BUILD_DIR)/usr/local/bin/cnvnator
	echo "$$root_wrapper" >$(DEB_BUILD_DIR)/usr/local/bin/root
	chmod a+x $(DEB_BUILD_DIR)/usr/local/bin/root
	
	# create the underlying tars of the debian package
	tar cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt usr
	tar cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control preinst postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		ar rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		mv $(DEB_PKG) ..

# https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
