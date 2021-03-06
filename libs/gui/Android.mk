LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

#Engle, add for perforamnce
ifeq ($(strip $(TARGET_CPU_VARIANT)),cortex-a8)
LOCAL_CFLAGS += -O3 -march=armv7-a -mfpu=neon -mfloat-abi=softfp -funroll-loops
endif

LOCAL_SRC_FILES:= \
	BitTube.cpp \
	BufferItemConsumer.cpp \
	BufferQueue.cpp \
	ConsumerBase.cpp \
	CpuConsumer.cpp \
	DisplayEventReceiver.cpp \
	DummyConsumer.cpp \
	GLConsumer.cpp \
	GraphicBufferAlloc.cpp \
	GuiConfig.cpp \
	IDisplayEventConnection.cpp \
	IGraphicBufferAlloc.cpp \
	IGraphicBufferProducer.cpp \
	ISensorEventConnection.cpp \
	ISensorServer.cpp \
	ISurfaceComposer.cpp \
	ISurfaceComposerClient.cpp \
	LayerState.cpp \
	Sensor.cpp \
	SensorEventQueue.cpp \
	SensorManager.cpp \
	Surface.cpp \
	SurfaceControl.cpp \
	SurfaceComposerClient.cpp \
	SyncFeatures.cpp \

LOCAL_SHARED_LIBRARIES := \
	libbinder \
	libcutils \
	libEGL \
	libGLESv2 \
	libsync \
	libui \
	libutils \
	liblog

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
ifneq ($(TARGET_QCOM_DISPLAY_VARIANT),)
    LOCAL_C_INCLUDES += hardware/qcom/display-$(TARGET_QCOM_DISPLAY_VARIANT)/libgralloc
else
    LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc
endif
    LOCAL_CFLAGS += -DQCOM_BSP
endif

ifeq ($(BOARD_EGL_NEEDS_LEGACY_FB),true)
    LOCAL_CFLAGS += -DBOARD_EGL_NEEDS_LEGACY_FB
    ifneq ($(TARGET_BOARD_PLATFORM),exynos4)
        LOCAL_CFLAGS += -DSURFACE_SKIP_FIRST_DEQUEUE
    endif
endif

LOCAL_MODULE:= libgui

ifeq ($(TARGET_BOARD_PLATFORM), tegra)
	LOCAL_CFLAGS += -DDONT_USE_FENCE_SYNC
endif
ifeq ($(TARGET_BOARD_PLATFORM), tegra3)
	LOCAL_CFLAGS += -DDONT_USE_FENCE_SYNC
endif
ifeq ($(TARGET_QCOM_DISPLAY_VARIANT), legacy)
	LOCAL_CFLAGS += -DDONT_USE_FENCE_SYNC
endif
ifeq ($(TARGET_TOROPLUS_RADIO), true)
	LOCAL_CFLAGS += -DTOROPLUS_RADIO
endif

include $(BUILD_SHARED_LIBRARY)

ifeq (,$(ONE_SHOT_MAKEFILE))
include $(call first-makefiles-under,$(LOCAL_PATH))
endif
