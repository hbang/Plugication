include theos/makefiles/common.mk

TWEAK_NAME = Plugication
Plugication_FILES = Tweak.xm
Plugication_PRIVATE_FRAMEWORKS = Celestial

SUBPROJECTS = prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)echo " Compressing files..."$(ECHO_END)
	$(ECHO_NOTHING)find -L _/ -name *.plist -not -xtype l -print0|xargs -0 plutil -convert binary1;exit 0$(ECHO_END)
	$(ECHO_NOTHING)find -L _/ -name *.png -not -xtype l -print0|xargs -0 pincrush -i$(ECHO_END)
