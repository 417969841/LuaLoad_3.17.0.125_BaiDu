luaoc = {}

local callStaticMethod = CCLuaObjcBridge.callStaticMethod

function luaoc.callStaticMethod(className, methodName, args)
    local ok, ret = callStaticMethod(className, methodName, args)
    if not ok then
        local msg = string.format("luaoc.callStaticMethod(\"%s\", \"%s\", \"%s\") - error: [%s] ",
            className, methodName, tostring(args), tostring(ret))
        if ret == -1 then
            Load.log(msg .. "INVALID PARAMETERS")
        elseif ret == -2 then
            Load.log(msg .. "CLASS NOT FOUND")
        elseif ret == -3 then
            Load.log(msg .. "METHOD NOT FOUND")
        elseif ret == -4 then
            Load.log(msg .. "EXCEPTION OCCURRED")
        elseif ret == -5 then
            Load.log(msg .. "INVALID METHOD SIGNATURE")
        else
            Load.log(msg .. "UNKNOWN")
        end
    end
    return ok, ret
end

return luaoc

