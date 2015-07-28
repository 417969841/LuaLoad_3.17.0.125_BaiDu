WanRenJinHuaUserInfo = {}

local userInfoEntity
local perAddCoin -- 单次增加金币
local dynamicAddCoinSchedule

-- 下载头像回调
function WanRenJinHuaUserInfo.updateWanRenJinHuaPortrait(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
		Common.log("update"..photoPath)
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		Common.log(i, j)
		--  string.sub(s,i,j) 提取字符串s的第i个到第j个字符。Lua中，第一个字符的索引值为1，最后一个为-1，以此类推，如：
		--  Common.log(string.sub("[hello world]",2,-2))      --输出hello world
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
		Common.log("photoPath = " .. photoPath)
	end
	if photoPath and photoPath ~= "" then
		userInfoEntity.setPortrait(photoPath)
	end
end

-- 下载图片
local function downloadPhoto(photoUrl)
	if photoUrl and photoUrl ~= "" then
		Common.getPicFile(photoUrl, 0, true, WanRenJinHuaUserInfo.updateWanRenJinHuaPortrait)
	end
end

-- 自己的下注数
-- layer 要加的层
-- 数据
function createWanRenJinHuaUserInfo(layer, data)
	local selfInfoTable = {}
	selfInfoTable["coin"] = data["surplusCoin"]
	selfInfoTable["nickname"] = profile.User.getSelfNickName()
	selfInfoTable["userID"] = profile.User.getSelfUserID()
	selfInfoTable["photo"] = profile.User.getSelfPhotoUrl()
	userInfoEntity = WanRenJinHuaUserInfoEntity(selfInfoTable, false)
	userInfoEntity:setAnchorPoint(ccp(0, 0))
	userInfoEntity:setPosition(5*TableConfig.TableScaleX, 5*TableConfig.TableScaleY)

	local selfInfoBgSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_wangrenjinhua_dibu.png"))
	selfInfoBgSprite:setAnchorPoint(ccp(0, 0))
	selfInfoBgSprite:setPosition(WanRenJinHuaConfig.SelfUserInfoX, WanRenJinHuaConfig.fitY)
	selfInfoBgSprite:addChild(userInfoEntity)
	layer:addChild(selfInfoBgSprite)

	downloadPhoto(selfInfoTable["photo"])
end

-- 更新用户信息
function WanRenJinHuaUserInfo.updateUserInfo(coin)
	if userInfoEntity then
		userInfoEntity.setCoin(coin)
	end
end

-- 获取玩家金币
function WanRenJinHuaUserInfo.getUserCoin()
	return userInfoEntity.getCoin()
end

-- 移除计时器
local function removeDynamicAddCoinSchedule()
	if dynamicAddCoinSchedule then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(dynamicAddCoinSchedule)
		dynamicAddCoinSchedule = nil
	end
end

-- 增加金币
local function perAddCoinFunc()
	local currentCoin = userInfoEntity:getCoin()
	currentCoin = perAddCoin + currentCoin
	local WanRenJinHuaResultData = profile.WanRenJinHua.getWanRenJinHuaResultDataTable()
	local surplusCoin = WanRenJinHuaResultData["surplusCoin"] -- 剩余金币

	if perAddCoin > 0 then
		if currentCoin > surplusCoin then
			WanRenJinHuaUserInfo.updateUserInfo(surplusCoin)
			removeDynamicAddCoinSchedule()
		else
			WanRenJinHuaUserInfo.updateUserInfo(currentCoin)
		end
	else
		if currentCoin < surplusCoin then
			WanRenJinHuaUserInfo.updateUserInfo(surplusCoin)
			removeDynamicAddCoinSchedule()
		else
			WanRenJinHuaUserInfo.updateUserInfo(currentCoin)
		end
	end
end

-- 动态增长金币  2秒钟涨10次
function WanRenJinHuaUserInfo.dynamicAddCoin(coin)
	perAddCoin = math.modf(coin / 20) -- 每次增长金币
	if not dynamicAddCoinSchedule then
		dynamicAddCoinSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(perAddCoinFunc, 0.1, false)
	end
end

-- 关掉任务
function WanRenJinHuaUserInfo.closeSchedule()
	removeDynamicAddCoinSchedule()
end

-- 检测并执行点击下注区域碰撞检测
function WanRenJinHuaUserInfo.checkAndDoTouchSelfUserInfoCollide(x, y)
	return userInfoEntity.checkAndDoTouchCollide(x, y)
end
