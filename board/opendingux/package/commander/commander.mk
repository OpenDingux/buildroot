################################################################################
#
# DinguxCommander
#
################################################################################

COMMANDER_VERSION = 9706b2d
COMMANDER_SITE = $(call github,od-contrib,commander,$(COMMANDER_VERSION))
COMMANDER_DEPENDENCIES = sdl sdl_gfx sdl_image sdl_ttf dejavu fonts-droid

COMMANDER_RESOURCES_DIR = /usr/share/commander/
COMMANDER_PLATFORM=$(call qstrip,$(BR2_PACKAGE_COMMANDER_PLATFORM))

COMMANDER_CONF_OPTS += \
	-DWITH_SYSTEM_SDL_GFX=ON -DWITH_SYSTEM_SDL_TTF=ON \
	-DFONTS="{\"/usr/share/fonts/dejavu/DejaVuSansCondensed.ttf\",10},{\"/usr/share/fonts/truetype/droid/DroidSansFallback.ttf\",9}" \
	-DLOW_DPI_FONTS="{RES_DIR\"Fiery_Turk.ttf\",8},{\"/usr/share/fonts/dejavu/DejaVuSansCondensed.ttf\",10},{\"/usr/share/fonts/truetype/droid/DroidSansFallback.ttf\",9}" \
	-DFILE_SYSTEM=\"/dev/mmcblk0p2\" \
	-DRES_DIR="\"$(COMMANDER_RESOURCES_DIR)\"" \
	-DTARGET_PLATFORM=$(COMMANDER_PLATFORM)

define COMMANDER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/res/Fiery_Turk.ttf \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/res/*.png \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
	$(INSTALL) -m 0644 $(@D)/opkg/readme.$(COMMANDER_PLATFORM).txt \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)readme.txt
endef

define COMMANDER_INSTALL_DEFAULT
	$(INSTALL) -m 0755 -D $(COMMANDER_BUILDDIR)commander \
	  $(TARGET_DIR)/usr/bin/commander
endef

define COMMANDER_INSTALL_RS90_RG99
	$(INSTALL) -m 0755 -D $(COMMANDER_BUILDDIR)commander \
	  $(TARGET_DIR)/usr/libexec/commander
	$(INSTALL) -m 0755 -D $(BR2_EXTERNAL_OPENDINGUX_PATH)/package/commander/commander.sh \
	  $(TARGET_DIR)/usr/bin/commander
	$(INSTALL) -m 0644 $(@D)/opkg/commander.rg99.cfg \
	  $(TARGET_DIR)$(COMMANDER_RESOURCES_DIR)
endef

ifeq ($(COMMANDER_PLATFORM),rs90)
COMMANDER_POST_INSTALL_TARGET_HOOKS += COMMANDER_INSTALL_RS90_RG99
else
COMMANDER_POST_INSTALL_TARGET_HOOKS += COMMANDER_INSTALL_DEFAULT
endif

ifeq ($(BR2_PACKAGE_GMENU2X),y)
define COMMANDER_INSTALL_TARGET_GMENU2X
	$(INSTALL) -m 0644 -D $(BR2_EXTERNAL_OPENDINGUX_PATH)/package/commander/gmenu2x \
	  $(TARGET_DIR)/usr/share/gmenu2x/sections/applications/25_commander
endef
COMMANDER_POST_INSTALL_TARGET_HOOKS += COMMANDER_INSTALL_TARGET_GMENU2X
endif

$(eval $(cmake-package))
