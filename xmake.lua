add_rules("mode.release")

local lua_directorys = {
    {version = "54", directory = "lua-5.4.2"},
    {version = "53", directory = "lua-5.3.6"},
    {version = "52", directory = "lua-5.2.4"},
    {version = "51", directory = "lua-5.1.5"},
}
local luasocket_directory = "luasocket-3.1.0"

for _, item in ipairs(lua_directorys) do
    local lua_version, lua_directory = item.version, item.directory

    target("lua_lib" .. lua_version)
        set_kind("shared")
        set_prefixname("")
        set_basename("lua" .. (lua_version == "51" and "5.1" or lua_version))
        add_includedirs(lua_directory .. "/src", {public = true})
        add_files(lua_directory .. "/src/*.c|lua.c|luac.c")
        if is_plat("linux", "bsd") then
            add_defines("LUA_USE_LINUX")
        elseif is_plat("macosx", "iphoneos") then
            add_defines("LUA_USE_MACOSX")
        elseif is_plat("windows", "mingw") then
            add_defines("LUA_BUILD_AS_DLL")
        end

    target("lua_app" .. lua_version)
        set_kind("binary")
        set_prefixname("")
        set_basename("lua" .. (lua_version == "51" and "5.1" or lua_version))
        add_deps("lua_lib" .. lua_version)
        add_files(lua_directory .. "/src/lua.c")
        if not is_plat("windows", "mingw") then
            add_syslinks("dl")
        end

    target("luasocket.mime" .. lua_version)
        set_kind("shared")
        set_prefixname("socket/")
        set_basename("mime" .. lua_version)
        add_deps("lua_lib" .. lua_version)
        add_files(
            luasocket_directory .. "/src/mime.c",
            luasocket_directory .. "/src/compat.c"
        )

    target("luasocket.core" .. lua_version)
        set_kind("shared")
        set_prefixname("socket/")
        set_basename("core" .. lua_version)
        add_deps("lua_lib" .. lua_version)
        add_files(
            luasocket_directory .. "/src/auxiliar.c",
            luasocket_directory .. "/src/buffer.c",
            luasocket_directory .. "/src/compat.c",
            luasocket_directory .. "/src/except.c",
            luasocket_directory .. "/src/inet.c",
            luasocket_directory .. "/src/io.c",
            luasocket_directory .. "/src/luasocket.c",
            luasocket_directory .. "/src/options.c",
            luasocket_directory .. "/src/select.c",
            luasocket_directory .. "/src/tcp.c",
            luasocket_directory .. "/src/timeout.c",
            luasocket_directory .. "/src/udp.c"
        )
        if is_plat("windows", "mingw") then
            add_files(luasocket_directory .. "/src/wsocket.c")
            add_syslinks("ws2_32")
        else
            add_files(luasocket_directory .. "/src/usocket.c")
        end
end
