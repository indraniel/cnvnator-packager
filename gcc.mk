BASE_DIR            := /tmp/gcc-build
BASE_SRC_DIR        := $(BASE_DIR)/src
BASE_INSTALL_DIR    := $(BASE_DIR)/local

GCC_VERSION         := 4.8.4
GCC_DIR             := $(BASE_SRC_DIR)/gcc-4.8.4
GCC_TGZ_PATH        := /gscuser/idas/software/gcc/gcc-4.8.4.tar.gz

DEB_BUILD_DIR       := $(BASE_DIR)/deb-build
UBUNTU_EDITION      := $(shell . /etc/lsb-release; echo $$DISTRIB_RELEASE)
DEB_RELEASE_VERSION := 1ubuntu$(UBUNTU_EDITION)
DEB_PKG             := gcc_$(GCC_VERSION)-$(DEB_RELEASE_VERSION).deb
DEB_PKG_PATH        := $(BASE_DIR)/$(DEB_PKG)
DEB_BASE_INSTALL    := /opt/gcc-$(GCC_VERSION)

$(GCC_DIR): | $(BASE_SRC_DIR)
	cd $(BASE_SRC_DIR) && \
		cp $(GCC_TGZ_PATH) . && \
		tar zxvf gcc-4.8.4.tar.gz 

$(BASE_INSTALL_DIR):
	if [ ! -e $(BASE_INSTALL_DIR) ]; then \
		mkdir -p $(BASE_INSTALL_DIR); \
		#chown -R $(USER):$(USER) $(BASE_DIR); \
	fi;

$(BASE_SRC_DIR):
	if [ ! -e $(BASE_SRC_DIR) ]; then \
		mkdir -p $(BASE_SRC_DIR); \
		#chown -R $(USER):$(USER) $(BASE_DIR); \
	fi;

# DEBIAN CONTROL FILE #########################################################
define debian_control
Package: gcc-$(GCC_VERSION)
Architecture: amd64
Section: development
Maintainer: Indraniel Das <idas@wustl.edu>
Priority: optional
Description: An unofficial gcc 4.8.4 for ubuntu 10.04 ( $(GCC_VERSION) )
Version: $(GCC_VERSION)-$(DEB_RELEASE_VERSION)
endef
export debian_control

# DEBIAN PREINST FILE #########################################################
define debian_preinst
#!/bin/bash

BASE=$(DEB_BASE_INSTALL)
SUBDIRS=(bin include lib lib32 lib64 libexec share)

if [ -e $${BASE} ]; then
    ROOT=$${BASE}/gcc-$(GCC_VERSION)
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

BASE=/opt/gcc-$(GCC_VERSION)

if [ -e $${BASE} ]; then
    rm -rfv $${BASE}
fi

endef
export debian_postrm

clean:
	rm -rf $(BASE_DIR)

debclean:
	if [ -d $(DEB_BUILD_DIR) ]; then rm -rf $(DEB_BUILD_DIR); fi;
	if [ -e $(DEB_PKG_PATH) ]; then rm -rf $(DEB_PKG_PATH); fi;

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
	cp -rv $(GCC_DIR)/bin $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/include $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/lib $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/lib32 $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/lib64 $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/libexec $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	cp -rv $(GCC_DIR)/share $(DEB_BUILD_DIR)/$(DEB_BASE_INSTALL)
	
	# create the underlying tars of the debian package
	tar cvzf $(DEB_BUILD_DIR)/data.tar.gz --owner=0 --group=0 -C $(DEB_BUILD_DIR) opt
	tar cvzf $(DEB_BUILD_DIR)/control.tar.gz -C $(DEB_BUILD_DIR) control preinst postrm
	
	# assemble the formal "deb" package
	cd $(DEB_BUILD_DIR) && \
		ar rc $(DEB_PKG) debian-binary control.tar.gz data.tar.gz && \
		mv $(DEB_PKG) ..
