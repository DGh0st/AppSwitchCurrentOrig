include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AppSwitchCurrent10
AppSwitchCurrent10_FILES = ASCRootListController.m
AppSwitchCurrent10_INSTALL_PATH = /Library/PreferenceBundles
AppSwitchCurrent10_FRAMEWORKS = UIKit MessageUI
AppSwitchCurrent10_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AppSwitchCurrent10.plist$(ECHO_END)
