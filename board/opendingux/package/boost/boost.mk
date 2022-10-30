NEW_BOOST_OPTS = $(filter-out link=shared runtime-link=shared,$(BOOST_OPTS)) link=static runtime-link=static

undefine BOOST_BUILD_CMDS
undefine BOOST_INSTALL_TARGET_CMDS
undefine BOOST_INSTALL_STAGING_CMDS

define BOOST_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) ./b2 $(NEW_BOOST_OPTS)
endef

define BOOST_INSTALL_TARGET_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) ./b2 $(NEW_BOOST_OPTS) \
		--prefix=$(TARGET_DIR)/usr install
endef

define BOOST_INSTALL_STAGING_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) ./b2 $(NEW_BOOST_OPTS) \
		--prefix=$(STAGING_DIR)/usr install
endef
