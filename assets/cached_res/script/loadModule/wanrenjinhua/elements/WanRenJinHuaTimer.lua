WanRenJinHuaTimer = {}

local timerLabel
local timerSchedule -- 时间计时器
local currentTimer -- 时间
local localTime -- 记录本地时间

-- 更新计时器
local function updateTimer()
	if WanRenJinHuaConfig.TableStatus == WanRenJinHuaConfig.WanRenJinHuaBetState then -- 阶段 2下注 3结果
		if currentTimer <= 6 then
			WanRenJinHuaSound.playEffectMusic(WanRenJinHuaSound.SOUND_TIMER)
	end
	else
		if currentTimer == 1 then
			-- 清理牌桌
			WanRenJinHuaLogic.ClearTable()
		end
	end
	-- 为了当用户切出游戏时同步时间
	currentTimer = currentTimer - (os.time() - localTime)
	localTime = os.time()
	if currentTimer < 0 then
		currentTimer = 0
	end
	timerLabel:setString(tostring(currentTimer))
end

-- 更新时间倒计时
-- layer要加的层
-- num秒数
function WanRenJinHuaTimer.startTimer(layer, num)
	if not timerLabel then
		local miaoBGSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wanrenjinhua_tanchukuang_di.png"))
		miaoBGSprite:setPosition(WanRenJinHuaConfig.TableTimerX, WanRenJinHuaConfig.TableTimerY)

		timerLabel = CCLabelAtlas:create("18", WanRenJinHuaConfig.getWanRenJinHuaResource("num_wangrenjinhua_shijian.png"), 270 /10, 40, 48)
		timerLabel:setPosition(miaoBGSprite:getContentSize().width/3, miaoBGSprite:getContentSize().height/2)
		timerLabel:setAnchorPoint(ccp(0.5, 0.5))
		miaoBGSprite:addChild(timerLabel)

		local miaoSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wanrenjinhua_shijian_miao.png"))
		miaoSprite:setPosition(miaoBGSprite:getContentSize().width/3 + 27*2, miaoBGSprite:getContentSize().height/2)
		miaoBGSprite:addChild(miaoSprite)

		layer:addChild(miaoBGSprite)
	end
	-- 停止之前的计时
	if timerSchedule then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timerSchedule)
		timerSchedule = nil
	end
	currentTimer = tonumber(num)
	timerLabel:setString(tostring(num))
	localTime = os.time()
	-- 开始新计时
	timerSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimer, 1, false)
end

-- 关闭计时器
function WanRenJinHuaTimer.closeTimerSchedule()
	if timerSchedule then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timerSchedule)
		timerSchedule = nil
		timerLabel = nil
	end
end