
RRStringUtilsExtend = class("RRStringUtilsExtend")
RRStringUtilsExtend.__index = RRStringUtilsExtend

function RRStringUtilsExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, RRStringUtilsExtend)
    return target
end
