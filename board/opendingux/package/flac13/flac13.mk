################################################################################
#
# flac13
#
################################################################################

FLAC13_VERSION = 1.3.4
FLAC13_SITE = http://downloads.xiph.org/releases/flac
FLAC13_SOURCE = flac-$(FLAC13_VERSION).tar.xz
FLAC13_INSTALL_STAGING = YES
FLAC13_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
FLAC13_LICENSE = Xiph BSD-like (libFLAC), GPL-2.0+ (tools), LGPL-2.1+ (other libraries)
FLAC13_LICENSE_FILES = COPYING.Xiph COPYING.GPL COPYING.LGPL
FLAC13_CPE_ID_VENDOR = flac_project

# patch touching configure.ac
FLAC13_AUTORECONF = YES

FLAC13_CONF_OPTS = \
	$(if $(BR2_POWERPC_CPU_HAS_ALTIVEC),--enable-altivec,--disable-altivec) \
	$(if $(BR2_INSTALL_LIBSTDCPP),--enable-cpplibs,--disable-cpplibs) \
	$(if $(BR2_POWERPC_CPU_HAS_VSX),--enable-vsx,--disable-vsx) \
	--disable-xmms-plugin \
	--disable-stack-smash-protection

ifeq ($(BR2_PACKAGE_LIBOGG),y)
FLAC13_CONF_OPTS += --with-ogg=$(STAGING_DIR)/usr
FLAC13_DEPENDENCIES += libogg
else
FLAC13_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FLAC13_DEPENDENCIES += host-nasm
FLAC13_CONF_OPTS += --enable-sse
else
FLAC13_CONF_OPTS += --disable-sse
endif

$(eval $(autotools-package))
