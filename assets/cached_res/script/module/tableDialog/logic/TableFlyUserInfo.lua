module("TableFlyUserInfo", package.seeall)

local view = {}
local Label_city = nil;
local iv_tt_image = nil;
local iv_tt_type = nil;
local LabelAtlas_tt_level = nil;
local iv_photo = {};
local Label_name = nil;
local Panel_vip = nil;
local LabelAtlas_vip_level = nil;
local iv_sex = nil;
local iv_coin = nil;
local Label_coin = nil;
local ViewWidth = 310;

local function reomveAll()
	for i = 1, #view do
		view[i]:stopAllActions();
		view[i]:removeFromParentAndCleanup(true);
		TableElementLayer.getElementLayer():removeChild(view[i], true);
	end
	view = {}
	iv_photo = {};
	ResumeSocket("showTablePlayer");
	TableConsole.showTablePlayer();
end
--[[--
--隐藏用户动画
--]]
local function hideFlyUserInfoAnim()
	local ccmove = nil
	for i = 1, 2 do
		if i == 1 then
			ccmove = CCMoveBy:create(0.2,ccp(ViewWidth*2,0))
		elseif i == 2 then
			ccmove = CCMoveBy:create(0.2,ccp(-ViewWidth*2,0))
		end
		local arr = CCArray:create()
		arr:addObject(ccmove)
		if i == 2 then
			arr:addObject(CCCallFuncN:create(reomveAll))
		end
		local seq= CCSequence:create(arr)
		view[i]:runAction(seq)
	end
end

--[[--
--显示用户动画
--]]
local function showFlyUserInfoAnim(pos)
	local ccmove = nil
	if pos == 1 then
		ccmove = CCMoveBy:create(0.3,ccp(-ViewWidth*2, 0))
	elseif pos == 2 then
		ccmove = CCMoveBy:create(0.3,ccp(ViewWidth*2, 0))
	end
	local delay = CCDelayTime:create(3)
	local arr = CCArray:create()
	arr:addObject(ccmove)
	arr:addObject(delay)
	if pos == 2 then
		arr:addObject(CCCallFuncN:create(hideFlyUserInfoAnim))
	end
	local seq= CCSequence:create(arr)
	view[pos]:runAction(seq)
end

function showFlyUserInfo(player)
	local pos = player.m_nPos;
	view[pos] = cocostudio.createView("TableFlyUserInfo.json")


	-- 比赛中，这里暂时先隐藏飞框
	if TableConsole.mode == TableConsole.MATCH then
		view[pos]:setVisible(false)
	end

	view[pos]:setZOrder(10)
	TableElementLayer.getElementLayer():addChild(view[pos])
	Label_city = cocostudio.getUILabel(view[pos], "Label_city");
	iv_tt_image = cocostudio.getUIImageView(view[pos], "iv_tt_image");
	iv_tt_type = cocostudio.getUIImageView(view[pos], "iv_tt_type");
	LabelAtlas_tt_level = cocostudio.getUILabelAtlas(view[pos], "LabelAtlas_tt_level");
	iv_photo[pos] = cocostudio.getUIImageView(view[pos], "iv_photo");
	Label_name = cocostudio.getUILabel(view[pos], "Label_name");
	Panel_vip = cocostudio.getUIPanel(view[pos], "Panel_vip");
	LabelAtlas_vip_level = cocostudio.getUILabelAtlas(view[pos], "LabelAtlas_vip_level");
	iv_sex = cocostudio.getUIImageView(view[pos], "iv_sex");
	iv_coin = cocostudio.getUIImageView(view[pos], "iv_coin");
	Label_coin = cocostudio.getUILabel(view[pos], "Label_coin");

	local Offset = TableConfig.TableDefaultWidth / 2 + ViewWidth
	if pos == 1 then
		view[pos]:setPosition(ccp(Offset, 0))
	elseif pos == 2 then
		view[pos]:setPosition(ccp(-Offset, 0))
	end

	--[[--
	--更新个人头像
	--]]
	local function updataUserPhoto(path)
		local photoPath = nil
		local id = nil
		if Common.platform == Common.TargetIos then
			photoPath = path["useravatorInApp"]
			id = path["id"]
		elseif Common.platform == Common.TargetAndroid then
			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
			local i, j = string.find(path, "#")
			id = string.sub(path, 1, i - 1)
			photoPath = string.sub(path, j + 1, -1)
		end
		if (photoPath ~= nil and photoPath ~= "" and iv_photo[tonumber(id)] ~= nil) then
			iv_photo[tonumber(id)]:loadTexture(photoPath)
		end
	end

	if player.m_sPhotoUrl ~= nil then
		Common.getPicFile(player.m_sPhotoUrl, pos, true, updataUserPhoto)
	end

	local VipLevel = player.mnVipLevel;
	local vipType = VIPPub.getUserVipType(VipLevel)
	if vipType >= VIPPub.VIP_1 then
		LabelAtlas_vip_level:setStringValue(""..vipType)
		Panel_vip:setVisible(true)
	else
		Panel_vip:setVisible(false)
	end
	if player.strSex == "男" then
		iv_sex:loadTexture(Common.getResourcePath("ic_gerenziliao_man.png"))
	else
		iv_sex:loadTexture(Common.getResourcePath("ic_gerenziliao_woman.png"))
	end
	if TableConsole.mode == TableConsole.MATCH then
    Label_coin:setText(""..player.scoreCnt);
		iv_coin:loadTexture(Common.getResourcePath("ic_macth_jifen.png"));--筹码图标
	elseif TableConsole.mode == TableConsole.ROOM then
    Label_coin:setText(""..player.m_nChipCnt);
		iv_coin:loadTexture(Common.getResourcePath("ic_hall_recharge_jinbi.png"));--筹码图标
	end
	Label_name:setText(""..player.m_sNickName);
	Label_city:setText(""..player.userAddress);
	
	Common.log("player.ladderDuan ======== "..player.ladderDuan)
	if player.ladderDuan == 0 then
		player.ladderDuan = 1
	end
	iv_tt_image:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(player.ladderDuan)));
	iv_tt_type:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiType(player.ladderDuan)));
	LabelAtlas_tt_level:setStringValue(player.ladderLevel)

	showFlyUserInfoAnim(pos)
end