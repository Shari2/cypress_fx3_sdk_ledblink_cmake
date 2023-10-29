# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY") 
set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs -nostartfiles" )

# here is the target environment is located
SET(CMAKE_FIND_ROOT_PATH "/usr/lib/gcc/arm-none-eabi/10.3.1")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
