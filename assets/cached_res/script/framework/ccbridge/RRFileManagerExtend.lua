
RRFileManagerExtend = class("RRFileManagerExtend")
RRFileManagerExtend.__index = RRFileManagerExtend

function RRFileManagerExtend.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, RRFileManagerExtend)
    return target
end
