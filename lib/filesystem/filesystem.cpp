extern "C" {
#include "../lua-headers/lua.h"
#include "../lua-headers/lauxlib.h"
#include "../lua-headers/lualib.h"
#include "../lua-headers/luaconf.h"
}

#include <string>
#include <iostream>
#include <stdexcept>
#include <filesystem>

// Wrapping functions in extern "C"
extern "C" {
  static int create_directory(lua_State *L) {
    lua_pushboolean(L, std::filesystem::create_directories(luaL_checkstring(L, 1)));
    return 1;
  }

  static int delete_directory(lua_State *L) {
    std::string path = luaL_checkstring(L, 1);
    lua_pushboolean(L, std::filesystem::remove_all(path)); // Return the number of files removed
    return 1;
  }

  static int exists(lua_State *L) {
    lua_pushboolean(L, std::filesystem::exists(luaL_checkstring(L, 1)));
    return 1;
  }

  static int subdirectories(lua_State *L) {
    std::string content;

    for (const auto &dir : std::filesystem::directory_iterator(luaL_checkstring(L, 1))) {
      content += dir.path().string() + "\n";
    }

    lua_pushstring(L, content.c_str());
    return 1;
  }

  static int full_path(lua_State *L) {
    lua_pushstring(L, std::filesystem::absolute(luaL_checkstring(L, 0)).c_str());
    return 1;
  }

  static const struct luaL_Reg mylib[] = {
    {"create", create_directory},
    {"delete", delete_directory},
    {"exists", exists},
    {"subdirectories", subdirectories},
    {NULL, NULL}
  };

  // Entry point for the Lua library
  int luaopen_filesystem(lua_State *L) {
    return 1;              // Return the table to Lua
  }
}

// Compile:
// gcc -o ../../filesystem.so -llua5.4 -lm -shared -fPIC filesystem.cpp -lstdc++ -std=c++23 -undefined 
//!       ^^^^^^^^^^^^^^^^^^^                            ^^^^^^^^^^^^^^
