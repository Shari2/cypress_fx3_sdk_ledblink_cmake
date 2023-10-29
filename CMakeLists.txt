cmake_minimum_required(VERSION 3.16)
project(ledblink C ASM)

# SDK license restrictions:

# Subject to the terms and conditions set forth herein,
# Cypress hereby grants to Licensee a limited, personal, non-exclusive,
# non-transferable license solely for Licensee's internal use to use, modify
# and create derivative works of the Source Code, and to compile the Source Code
# and derivative works thereof into object code for the sole purpose of creating
# custom software solely for use in a Licensee product that incorporates a
# Cypress integrated circuit (a "Licensee Product").

# Only allowed to distribute object code.
# Fetch your own copy from https://itoolspriv.infineon.com/itbhs/api/packages/com.ifx.tb.tool.ezusbfx3sdk/Versions/1.3.4/artifacts/FX3_SDK_1.3.4_Linux.tar.gz/download


#34b714e55ada4cba9dbd026ed9480986691f6aae837c9a1a14647ad1f9cb34d6
include(FetchContent)
FetchContent_Declare(
  fx3_sdk_1_3_4_linux
  URL "file://${CMAKE_SOURCE_DIR}/FX3_SDK_1.3.4_Linux.tar.gz"
)

FetchContent_MakeAvailable(fx3_sdk_1_3_4_linux)
