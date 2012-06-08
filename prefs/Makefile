include theos/makefiles/common.mk

BUNDLE_NAME = Plugication
Plugication_FILES = Plugication.mm
Plugication_INSTALL_PATH = /Library/PreferenceBundles
Plugication_FRAMEWORKS = UIKit
Plugication_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Plugication.plist$(ECHO_END)
