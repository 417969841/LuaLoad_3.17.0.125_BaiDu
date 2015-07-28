WanRenJinHuaTitle = {}

local titleSprite
local sysTimeLabel
local currentTime
local titleNameSprite
local updateTimeScheduler = nil -- 更新时间定时器

local function init()
--	local texture = CCTextureCache:sharedTextureCache():addImage(Common.getResourcePath("desk_bg_title.png", pathTypeInApp))
--	titleSprite = CCSprite:createWithTexture(texture)
--	local selfSize = titleSprite:getContentSize()
	currentTime = os.date("%H:%M", os.time())
	sysTimeLabel = CCLabelTTF:create(currentTime, "Arial", 30)
	sysTimeLabel:setColor(ccc3(163, 190, 181))
	sysTimeLabel:setAnchorPoint(ccp(0, 0.5))
	sysTimeLabel:setPosition(WanRenJinHuaConfig.SysTemTimeX, WanRenJinHuaConfig.WanRenJinHuaTitleY)

	titleNameSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_text_wanrenjinhua.png", pathTypeInApp))
	titleNameSprite:setAnchorPoint(ccp(0.5, 0.5))
	titleNameSprite:setPosition(TableConfig.TableDefaultWidth/2, WanRenJinHuaConfig.WanRenJinHuaTitleY)

--	titleSprite:addChild(sysTimeLabel)
--	titleSprite:addChild(titleNameSprite)
--	titleSprite:setAnchorPoint(ccp(0, 1))
--	titleSprite:setPosition(WanRenJinHuaConfig.fitX, WanRenJinHuaConfig.WanRenJinHuaTitleY)
end

-- 更新时间
local function updateCurrentTimeOnTitle()
	local currentTime = os.date("%H:%M", os.time())
	if sysTimeLabel ~= nil then
		sysTimeLabel:setString(currentTime)
	end
end

-- 启动计时器
local function startUpdateTimeScheduler()
	if not updateTimeScheduler then
		updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateCurrentTimeOnTitle, 60, false)
	end
end

-- clear标题栏   退出时调用
function WanRenJinHuaTitle.clearTableTitle()
	if updateTimeScheduler ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimeScheduler)
		updateTimeScheduler = nil;
	end
	sysTimeLabel = nil;
end

function createWanRenJinHuaTitle(layer)
	init()
	startUpdateTimeScheduler()
	layer:addChild(sysTimeLabel)
	layer:addChild(titleNameSprite)
end

