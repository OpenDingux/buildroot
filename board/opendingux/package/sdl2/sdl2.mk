SDL2_CONF_OPTS += --enable-joystick-translator
SDL2_AUTORECONF = YES
define SDL2_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
SDL2_PRE_CONFIGURE_HOOKS += SDL2_RUN_AUTOGEN
