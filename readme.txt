SPDX-License-Identifier: BSD-2-Clause
SPDX-FileCopyrightText: Copyright (c) 2023 Marian Sauer

Needs
  cmake
  ninja
  make
  arm-none-eabi-gcc

1. download SDK
  https://itoolspriv.infineon.com/itbhs/api/packages/com.ifx.tb.tool.ezusbfx3sdk/Versions/1.3.4/artifacts/FX3_SDK_1.3.4_Linux.tar.gz/download
  Put it next to toplevel CMakeLists.txt.

2. build
  cmake -H. -Bbuild -GNinja -DCMAKE_TOOLCHAIN_FILE=toolchain_arm926ej-s.cmake
  ninja -C build all

3. Download to fx3
  ninja -C build fxload

4. Functional test
  Press SW_GPIO45
  LED_CTS alias LED2 should be on
  Release SW_GPIO45
  LED_CTS alias LED2 should be off

