# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)
project(ledblink C ASM)

# Only allowed to distribute object code.
# Fetch your own copy from https://itoolspriv.infineon.com/itbhs/api/packages/com.ifx.tb.tool.ezusbfx3sdk/Versions/1.3.4/artifacts/FX3_SDK_1.3.4_Linux.tar.gz/download
# Place it next to this CMakeLists.txt file

include(FetchContent)
FetchContent_Declare(
  fx3_sdk_1_3_4_linux
  URL "file://${CMAKE_SOURCE_DIR}/FX3_SDK_1.3.4_Linux.tar.gz"
  URL_HASH SHA256=34b714e55ada4cba9dbd026ed9480986691f6aae837c9a1a14647ad1f9cb34d6
  # classic Cypress move: zip inside tar.gz inside tar.gz
  PATCH_COMMAND ${CMAKE_COMMAND} -E tar xf fx3_firmware_linux.tar.gz COMMAND ${CMAKE_COMMAND} -E tar xf cyfx3sdk/firmware/fx3_sdk_1_3_4_src.zip
)

FetchContent_MakeAvailable(fx3_sdk_1_3_4_linux)

# classic Cypress move: SDK has no source for CyFx3BusyWait, CyFx3DevIOConfigure and many more
# so it is not possible to build from source

#set(cyfx3boot_source_prefix "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/libsrc")
#
#add_library(cyfx3boot STATIC
#  "${cyfx3boot_source_prefix}/cyfx3device.c"
#  "${cyfx3boot_source_prefix}/cyfx3dma.c"
#  "${cyfx3boot_source_prefix}/cyfx3gpio.c"
#  "${cyfx3boot_source_prefix}/cyfx3i2c.c"
#  "${cyfx3boot_source_prefix}/cyfx3pib.c"
#  "${cyfx3boot_source_prefix}/cyfx3spi.c"
#  "${cyfx3boot_source_prefix}/cyfx3uart.c"
#  "${cyfx3boot_source_prefix}/cyfx3usb.c"
#  "${cyfx3boot_source_prefix}/cyfx3utils.c"
#  #"${cyfx3boot_source_prefix}/cyfx_gcc_startup.S"  # example apps provide their own startup file
#)
#
#target_include_directories(cyfx3boot PUBLIC
#  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/include"
#  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/sdk/firmware/include"
#)
#target_include_directories(cyfx3boot PRIVATE
#  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/libsrc"
#)


# fallback to binary blob from Cypress

add_library(cyfx3boot STATIC IMPORTED)
set_target_properties(cyfx3boot PROPERTIES
  IMPORTED_LOCATION "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/boot_lib/1_3_4/lib/libcyfx3boot.a"
  INTERFACE_INCLUDE_DIRECTORIES "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/boot_lib/1_3_4/include"
)

set(ledblik_source_prefix "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/firmware/boot_fw/ledblink")
add_executable(led_blink
  "${ledblik_source_prefix}/main.c"
  "${ledblik_source_prefix}/cyfx_gcc_startup.S"
)

target_link_libraries(led_blink PRIVATE
  cyfx3boot
)
target_link_options(led_blink PRIVATE "-T${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/fw_build/boot_fw/cyfx3.ld")

# quick hack to build with host gcc
add_custom_target(
  elf2img
  COMMAND gcc elf2img.c -o elf2img
  WORKING_DIRECTORY "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/util/elf2img"
)

# auto convert elf to image file
add_custom_target(
  app.img
  COMMAND "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/cyfx3sdk/util/elf2img/elf2img" -i led_blink -o app.img -v -vectorload yes
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
  DEPENDS led_blink
  DEPENDS elf2img
)

# There are so many fxload variations (https://xkcd.com/927/) that is easier to build it from source.
# Use libusb fxload for fx3 support.

include(ExternalProject)
ExternalProject_Add(
  libusb-cmake
  GIT_REPOSITORY https://github.com/libusb/libusb-cmake.git
  GIT_TAG        e3189c1343789c2db36f3bf2341239a7e0b9f5ae # v1.0.26
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -H<SOURCE_DIR> -DLIBUSB_BUILD_EXAMPLES=ON -DLIBUSB_BUILD_SHARED_LIBS=OFF
  BUILD_COMMAND ${MAKE_COMMAND}
  INSTALL_COMMAND ""
)

# run fxload binary build from libusb
ExternalProject_Get_property(libusb-cmake BINARY_DIR)
add_custom_target(
  fxload
  COMMAND "${BINARY_DIR}/fxload" -t fx3 -d 04b4:00f3 -i app.img -v
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
  DEPENDS app.img
)