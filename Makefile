THEOS_PACKAGE_DIR_NAME = debs
export TARGET = :clang
export ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Plugication
Plugication_FILES = Tweak.xm HBSettingsManager.m
Plugication_PRIVATE_FRAMEWORKS = Celestial TelephonyUtilities
Plugication_LIBRARIES += cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += plugication
include $(THEOS_MAKE_PATH)/aggregate.mk
