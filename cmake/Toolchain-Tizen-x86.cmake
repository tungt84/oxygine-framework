set(TIZEN_TOOL_DIR /Users/tungt/tizen-studio/tools)
set(TIZEN_PLATFORM_DIR /Users/tungt/tizen-studio/platforms)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR X86)

set(CMAKE_C_COMPILER ${TIZEN_TOOL_DIR}/i386-linux-gnueabi-gcc-4.9/bin/i386-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER ${TIZEN_TOOL_DIR}/i386-linux-gnueabi-gcc-4.9/bin/i386-linux-gnueabi-g++)
SET(CMAKE_SYSROOT ${TIZEN_PLATFORM_DIR}/tizen-3.0/mobile/rootstraps/mobile-3.0-emulator.core)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_COMPILER_ARG1 -m32)
set(CMAKE_CXX_COMPILER_ARG1 -m32)

set(TIZEN 1)
set(STATIC 1)
