
RRTexturceManagerExtend = class("RRTexturceManagerExtend")
RRTexturceManagerExtend.__index = RRTexturceManagerExtend

function RRTexturceManagerExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, RRTexturceManagerExtend)
    return target
end
