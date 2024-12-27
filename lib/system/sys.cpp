extern "C" {
  #include "../lua-headers/lua.h"
  #include "../lua-headers/lauxlib.h"
  #include "../lua-headers/lualib.h"
  #include "../lua-headers/luaconf.h"
}

#include <string>
#include <iostream>
#include <filesystem>

#if defined(_WIN32) || defined(_WIN64)
  #define OS "windows"
  #if defined(_WIN64)
    #define ARCH "64-bit"
  #else
    #define ARCH "32-bit"
  #endif
#elif defined(__APPLE__) || defined(__MACH__)
  #define OS "macos"
  #if defined(__x86_64__) || defined(__ppc64__)
    #define ARCH "64-bit"
  #else
    #define ARCH "32-bit"
  #endif
#elif defined(__linux__)
  #define OS "linux"
  #if defined(__x86_64__) || defined(__ppc64__)
    #define ARCH "64-bit"
  #else
    #define ARCH "32-bit"
  #endif
#else
  #define OS "unknown"
  #define ARCH "unknown"
#endif

extern "C" {

  static int get_os(lua_State *L) {
    lua_pushstring(L, OS);
    return 1;
  }

  static int get_arch(lua_State *L) {
    lua_pushstring(L, ARCH);
    return 1;
  }

  int luaopen_sys(lua_State *L) {
    static const struct luaL_Reg mylib[] = {
      {"get_os", get_os},
      {"get_arch", get_arch},
      {NULL, NULL}
    };
    
    return 1;              // Return the table to Lua
  }
}