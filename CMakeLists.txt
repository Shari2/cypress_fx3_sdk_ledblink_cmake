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

set(cyfx3boot_source_prefix "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/libsrc/")

add_library(cyfx3boot STATIC
  "${cyfx3boot_source_prefix}/cyfx3device.c"
  "${cyfx3boot_source_prefix}/cyfx3dma.c"
  "${cyfx3boot_source_prefix}/cyfx3gpio.c"
  "${cyfx3boot_source_prefix}/cyfx3i2c.c"
  "${cyfx3boot_source_prefix}/cyfx3pib.c"
  "${cyfx3boot_source_prefix}/cyfx3spi.c"
  "${cyfx3boot_source_prefix}/cyfx3uart.c"
  "${cyfx3boot_source_prefix}/cyfx3usb.c"
  "${cyfx3boot_source_prefix}/cyfx3utils.c"
  #"${cyfx3boot_source_prefix}/cyfx_gcc_startup.S"
)

target_include_directories(cyfx3boot PRIVATE
  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/include"
  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/sdk/firmware/include"
  "${fx3_sdk_1_3_4_linux_SOURCE_DIR}/fx3_sdk_1_3_4_src/FX3/firmware/boot_fw/libsrc"
)
