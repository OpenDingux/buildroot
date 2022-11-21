#############################################################
#
# od-model
#
#############################################################

OD_MODEL_SITE = board/opendingux/package/od-model
OD_MODEL_SITE_METHOD = local

define OD_MODEL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/od-model.c -o $(@D)/od-model
	$(TARGET_STRIP) -s $(@D)/od-model
endef

define OD_MODEL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/od-model $(TARGET_DIR)/usr/sbin/od-model
endef

$(eval $(generic-package))
