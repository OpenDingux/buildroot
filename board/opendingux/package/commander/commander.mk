################################################################################
#
# DinguxCommander
#
################################################################################

COMMANDER_VERSION = 2021-04-02
COMMANDER_SITE = $(call github,od-contrib,commander,$(COMMANDER_VERSION))
COMMANDER_DEPENDENCIES = sdl sdl_gfx sdl_image sdl_ttf dejavu fonts-droid
COMMANDER_RESOURCES_DIR = /usr/share/commander/

COMMANDER_PLATFORM=$(call qstrip,$(BR2_PACKAGE_COMMANDER_PLATFORM))

COMMANDER_CONF_OPTS += \
	-DWITH_SYSTEM_SDL_GFX=ON -DWITH_SYSTEM_SDL_TTF=ON \
	-DKEYBOARD_SWAP_SYSTEM_AND_PARENT=ON \
	-DFONTS=$(BR2_PACKAGE_COMMANDER_FONTS) \
	-DLOW_DPI_FONTS=$(BR2_PACKAGE_COMMANDER_FONTS_LOW_DPI) \
	-DRES_DIR="\"$(COMMANDER_RESOURCES_DIR)\"" \
	-DTARGET_PLATFORM=$(COMMANDER_PLATFORM) \
	-DFILE_SYSTEM="\"/dev/mmcblk0p2\""

ifeq ($(BR2_PACKAGE_COMMANDER_AUTOSCALE),y)
COMMANDER_CONF_OPTS += -DAUTOSCALE=1
endif

ifneq ($(BR2_PACKAGE_COMMANDER_PPU_X),"")
COMMANDER_CONF_OPTS += -DPPU_X=$(BR2_PACKAGE_COMMANDER_PPU_X)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_PPU_Y),"")
COMMANDER_CONF_OPTS += -DPPU_Y=$(BR2_PACKAGE_COMMANDER_PPU_Y)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_WIDTH),"")
COMMANDER_CONF_OPTS += -DSCREEN_WIDTH=$(BR2_PACKAGE_COMMANDER_WIDTH)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_HEIGHT),"")
COMMANDER_CONF_OPTS += -DSCREEN_HEIGHT=$(BR2_PACKAGE_COMMANDER_HEIGHT)
endif

define COMMANDER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/res/Fiery_Turk.ttf \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/res/*.png \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/opkg/readme.$(COMMANDER_PLATFORM).txt \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)readme.txt
	$(INSTALL) -m 0755 -D $(COMMANDER_BUILDDIR)commander \
	  $(TARGET_DIR)/usr/bin/commander
endef

ifeq ($(BR2_PACKAGE_GMENU2X),y)
define COMMANDER_INSTALL_TARGET_GMENU2X
	$(INSTALL) -m 0644 -D $(BR2_EXTERNAL_OPENDINGUX_PATH)/package/commander/gmenu2x \
	  $(TARGET_DIR)/usr/share/gmenu2x/sections/applications/25_commander
	$(INSTALL) -m 0644 -D $(@D)/opkg/commander.png \
	  $(TARGET_DIR)/usr/share/gmenu2x/skins/320x240/Default/icons/dinguxcmdr.png
endef
COMMANDER_POST_INSTALL_TARGET_HOOKS += COMMANDER_INSTALL_TARGET_GMENU2X
endif

$(eval $(cmake-package))
