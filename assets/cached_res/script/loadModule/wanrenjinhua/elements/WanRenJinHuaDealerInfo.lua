WanRenJinHuaDealerInfo = {}

local userInfoEntity
local dealerName -- 庄家名字
local dealerCoin -- 庄家金币数
local dealerMark --庄家标志

-- 下载头像回调
function WanRenJinHuaDealerInfo.updateWanRenJinHuaPortrait(dataInApp)
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
		Common.getPicFile(photoUrl, 0, true, WanRenJinHuaDealerInfo.updateWanRenJinHuaPortrait)
	end
end

-- 自己的下注数
-- layer 要加的层
-- 数据
function createWanRenJinHuaDealerInfo(layer, data)
	if not data then
		return
	end
	userInfoEntity = WanRenJinHuaUserInfoEntity(data["dealer"], true)
	userInfoEntity:setAnchorPoint(ccp(0, 1))
	userInfoEntity:setPosition(WanRenJinHuaConfig.DealerInfoX, WanRenJinHuaConfig.DealerInfoY)
	layer:addChild(userInfoEntity)

	dealerName = data["dealer"]["nickname"]
	dealerCoin = data["dealer"]["coin"]
	downloadPhoto(data["dealer"]["photo"])

end

-- 更新用户信息
function WanRenJinHuaDealerInfo.updateUserInfo(coin)
	if userInfoEntity then
		userInfoEntity:setCoin(coin)
	end
	dealerCoin = coin
end

-- 检测并执行点击下注区域碰撞检测
function WanRenJinHuaDealerInfo.checkAndDoTouchDealerUserInfoCollide(x, y)
	return userInfoEntity.checkAndDoTouchCollide(x, y)
end

-- 获取庄家名字
function WanRenJinHuaDealerInfo.getDealerName()
	return dealerName
end

-- 获取庄家金币数
function WanRenJinHuaDealerInfo.getDealerCoin()
	return dealerCoin
end
