export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest
GO_EASY_ON_ME=1

include theos/makefiles/common.mk

TWEAK_NAME = AppSwitchCurrentOrig
AppSwitchCurrentOrig_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += appswitchcurrentorig
include $(THEOS_MAKE_PATH)/aggregate.mk
