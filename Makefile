INSTALL_TARGET_PROCESSES = SpringBoard
TARGET := iphone:clang:latest:14.0
SYSROOT = $(THEOS)/sdks/iPhoneOS14.2.sdk
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UptimeModule

UptimeModule_FILES = $(wildcard *.m)
UptimeModule_BUNDLE_EXTENSION = bundle
UptimeModule_PRIVATE_FRAMEWORKS = ControlCenterUIKit
UptimeModule_CFLAGS = -fobjc-arc
UptimeModule_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
