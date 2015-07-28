
RRGameEngineExtend = class("RRGameEngineExtend")
RRGameEngineExtend.__index = RRGameEngineExtend

function RRGameEngineExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, RRGameEngineExtend)
    return target
end
