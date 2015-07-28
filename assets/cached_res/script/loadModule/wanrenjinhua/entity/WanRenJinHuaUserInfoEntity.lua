-- userTable["coin"] 金币数
-- userTable["nickname"] 昵称
-- userTable["userID"] 用户userId
-- userTable["photo"] 头像地址

--[[--
-- 个人信息
--@param #table userTable 用户信息
--@param #boolean isDealer 是否是庄(庄家的头像0.75)
--]]
function WanRenJinHuaUserInfoEntity(userTable, isDealer)
	local showSize = CCSizeMake(WanRenJinHuaConfig.SelfUserInfoRectWidth, WanRenJinHuaConfig.SelfUserInfoRectHeight)
	local userInfoRect = CCNode:create()
	userInfoRect:setContentSize(showSize)
	userInfoRect:setAnchorPoint(ccp(0,0))

	local coinLabel = CCLabelTTF:create(userTable["coin"], "Arial", 24)
	coinLabel:setColor(ccc3(255, 236, 105))
	coinLabel:setAnchorPoint(ccp(0,0))
	coinLabel:setPosition(WanRenJinHuaConfig.SelfUserInfoElementsPositionX.selfUserCoinNum, WanRenJinHuaConfig.SelfUserInfoElementsPositionY.selfUserCoinNum)

	local nameLabel = CCLabelTTF:create(userTable["nickname"], "Arial", 26)
	nameLabel:setColor(ccc3(255, 255, 255))
	nameLabel:setAnchorPoint(ccp(0,0))
	nameLabel:setPosition(WanRenJinHuaConfig.SelfUserInfoElementsPositionX.selfUserName, WanRenJinHuaConfig.SelfUserInfoElementsPositionY.selfUserName)

	local coinIcon = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_coin.png"))
	coinIcon:setAnchorPoint(ccp(0,0))
	coinIcon:setPosition(WanRenJinHuaConfig.SelfUserInfoElementsPositionX.selfUserCoinImg, WanRenJinHuaConfig.SelfUserInfoElementsPositionY.selfUserCoinImg)

	local photoSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_playerhead.png", pathTypeInApp))
	photoSprite:setAnchorPoint(ccp(0.5,0.5))
	if isDealer then
		photoSprite:setScale(0.75);
		local dealerMark = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ui_touxiangzhuang.png")); --庄家标志
		local dealerSize = dealerMark:getContentSize();
		local photoSize = photoSprite:getContentSize();
		local dealerMarkX = (photoSize.width - dealerSize.width) / 2;
		local dealerMarkY = (photoSize.height - dealerSize.height) / 2;
		dealerMark:setPosition(photoSize.width - dealerMarkX, dealerMarkY)
		photoSprite:addChild(dealerMark)
	end
	photoSprite:setPosition(WanRenJinHuaConfig.SelfUserInfoElementsPositionX.selfUserImg, WanRenJinHuaConfig.SelfUserInfoElementsPositionY.selfUserImg)

	userInfoRect:addChild(coinLabel)
	userInfoRect:addChild(nameLabel)
	userInfoRect:addChild(coinIcon)
	userInfoRect:addChild(photoSprite)

	--设置头像
	function userInfoRect.setPortrait(path)
		local texture = CCTextureCache:sharedTextureCache():addImage(path)
		if texture then
			photoSprite:setTexture(texture)
		end
	end

	-- 显示个人信息
	local function showUserInfo()
		mvcEngine.createModule(GUI_USERINFO)
		UserInfoLogic.setUserInfo(userTable["userID"])
	end

	-- 设置金币
	function userInfoRect.setCoin(coinValue)
		coinLabel:setString(tostring(coinValue))
	end

	-- 返回金币 数字型
	function userInfoRect.getCoin()
		return tonumber(coinLabel:getString())
	end

	-- 碰见检测并执行
	function userInfoRect.checkAndDoTouchCollide(x, y)
		if userInfoRect then
			if userInfoRect:boundingBox():containsPoint(ccp(x,y)) then
--				showUserInfo()
				return true
			end
		end
		return false
	end

	return userInfoRect
end
