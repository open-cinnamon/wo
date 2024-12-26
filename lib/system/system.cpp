#include "../lua-headers/lua.h"
#include "../lua-headers/lauxlib.h"
#include "../lua-headers/lualib.h"
#include "../lua-headers/luaconf.h"

#include <string>
#include <iostream>
#include <filesystem>

#ifdef _WIN32
#define OS "windows"
#elif defined(d)
#endif

extern "C" {

  static int get_os(lua_State *L) {
    
  }

  int luaopen_system(lua_State *L) {
    return 1;              // Return the table to Lua
  }
}