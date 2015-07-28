CCSLayoutExtend = class("CCSLayoutExtend", CCSWidgetExtend)
CCSLayoutExtend.__index = CCSLayoutExtend

function CCSLayoutExtend.extend(target)
        local t = tolua.getpeer(target)
        if not t then
            t = {}
            tolua.setpeer(target, t)
        end
        setmetatable(t, CCSLayoutExtend)
        return target
end

function CCSLayoutExtend:initlayout(params)
    local size          = params.size or ccs.DEFAULT_LAYOUT_SIZE
    local color         = params.color
    local endColor      = params.endColor
    local colorType     = params.colorType
    local image         = tostring(params.image)
    local scale9        = params.scale9
    local capInsets     = params.capInsets--[[ or ccs.DEFAULT_CAPINSETS]]
    local type          = params.type
    local listener      = params.listener
    local x             = params.x or 0
    local y             = params.y or 0


    local init = true
   
    while true
    do
        init = self:init(params)
    --[[
        init = (tolua.type(size) == "CCSize")
        assert(init,"layout invalid params.size")
        if init == false then break end
        self:setSize(size)
    ]]
        if colorType then
            self:setBackGroundColorType(colorType)
            if colorType == LAYOUT_COLOR_GRADIENT then
                if color and endColor then
                    init = (tolua.type(color) == "ccColor3B" or tolua.type(color) == "const ccColor3B")
                    assert(init,"layout invalid params.color")
                    init = (tolua.type(endColor) == "ccColor3B")
                    assert(init,"layout invalid params.endColor")
                    if init == false then break end
                    self:setBackGroundColor(color,endColor)
                end
            else
                if color then
                    init = (tolua.type(color) == "ccColor3B" or tolua.type(color) == "const ccColor3B")
                    assert(init,"[ccs.plane] invalid params.color")
                    if init == false then break end
                    self:setBackGroundColor(color)
                end
            end
        end

        if image then
            self:setBackGroundImage(image)
        end

        if scale9 then
            self:setBackGroundImageScale9Enabled(scale9)
            self:setBackGroundImageCapInsets(capInsets)
        end

        -- layout 的布局方式
        if type then
            self:setLayoutType(type)
        end
--[[
        if listener then
            init = (type(listener) == "table")
            if init == false then break end
            self:setListener(listener)
        end

        SET_POS(self,x,y)
]]
        break
    end
    return init
end