################################################################################
#
# libmodplug
#
################################################################################

LIBMODPLUG_VERSION = d1b97ed
LIBMODPLUG_SITE = $(call github,Konstanty,libmodplug,$(LIBMODPLUG_VERSION))
LIBMODPLUG_INSTALL_STAGING = YES
LIBMODPLUG_LICENSE = Public Domain
LIBMODPLUG_LICENSE_FILES = COPYING
LIBMODPLUG_CPE_ID_VENDOR = konstanty_bialkowski

$(eval $(cmake-package))
