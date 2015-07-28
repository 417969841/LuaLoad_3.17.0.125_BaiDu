module("BindPhoneConfig",package.seeall)

isShowBindPhone = false

--[[--
--牌桌第三局弹出绑定手机页面
--]]
function showBindPhoneLayer()
	local operator = Common.getOperater()
	local BindPhone = profile.BindPhone.getBindPhone()
	local BindPhoneList = profile.BindPhone.getBindPhoneList()
	Common.log("showBindPhoneLayer=============="..operator.."+"..BindPhone)
	--setFlag  1绑定,2解绑,-1非手机绑定,-2非手机解绑
	if(BindPhone == "" or BindPhone == nil or BindPhone == 0) then
		if(operator == 0) then
			BindPhoneMsgLogic.setFlag(-1,BindPhoneList,operator)
			mvcEngine.createModule(GUI_BINDPHONEMSG)
			isShowBindPhone = true
		else
			BindPhoneLogic.setFlag(1,BindPhoneList,operator)
			mvcEngine.createModule(GUI_BINDPHONE)
			isShowBindPhone = true
		end
	else
		GameConfig.isShowHallGiftOrBindPhone = true
		showHallGift()
	end
end

--[[--
--显示因为绑定手机而暂存的红包（用于牌桌第三局和福利）
--]]
function showHallGift()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and GameConfig.hasShowHallGift then
		--在牌桌内关闭绑定手机弹框后弹出暂存的礼包
		GameConfig.hasShowHallGift = false
		local giftData = profile.Gift.getGiftDataTable()
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	end
end

--[[--
--金币小于1500显示绑定手机界面（牌桌和大厅通用,）
--]]
function showBindPhoneCommonLayer()
	GameConfig.isShowHallGiftOrBindPhone = true
	if HallGiftShowLogic.isShow == false then
		Common.log("showBindPhoneCommonLayer=====3"..profile.BindPhone.getBindPhone())
		if profile.BindPhone.getBindPhone() == nil or profile.BindPhone.getBindPhone() == "" or profile.BindPhone.getBindPhone() == 0 then
			if(Common.getOperater() == 0) then
				--判断金币是否为1500
				BindPhoneMsgLogic.setFlag(-1,profile.BindPhone.getBindPhoneList(),Common.getOperater())
				if tonumber(profile.User.getSelfCoin()) <= 1500 and profile.User.getSelfRound() >= 1 then
					if judgeTheNewDay("BindingMoiblePhone") then
						mvcEngine.createModule(GUI_BINDPHONEMSG)
						isShowBindPhone = true
					end
				end
			----------------------------------
			elseif Common.getOperater() ~= 0 then
				--判断金币是否小于1500
				BindPhoneLogic.setFlag(1,profile.BindPhone.getBindPhoneList(),Common.getOperater())
				if tonumber(profile.User.getSelfCoin()) <= 1500 and profile.User.getSelfRound() >= 1 then
					if judgeTheNewDay("BindingMoiblePhone") then
						mvcEngine.createModule(GUI_BINDPHONE)
						HallLogic.setMiniGameTanKuang(false)
						isShowBindPhone = true
					end
				end
			end
		end
	end
end

--[[--
--在牌桌时判断是直接弹出绑定手机还是小于1500金币弹出绑定手机
--]]
function showBindPhoneLayerOnTable()
	if not GameConfig.isShowHallGiftOrBindPhone then
		--绑定手机
		showBindPhoneLayer()
	else
		showBindPhoneCommonLayer()
	end
end

--[[--
--判断是否为新的一天（即凌晨开始计时）
--@param LocalTableKey 存入本地Table的Key
--]]
function judgeTheNewDay(LocalTableKey)
	local localSaveTable = Common.LoadShareTable(LocalTableKey)
	--获得的格式：{year=2005, month=11, day=6, hour=22, min=18, sec=30}
	local theCurrentTime = os.date("*t",os.time())
	--当前日期是第几天
	local theCurrentTimeDay = theCurrentTime.day
	--如果没有记录日期或当前日期与上次日期天数不等则定义为新的一天
	if localSaveTable == nil then
		Common.SaveShareTable(LocalTableKey,theCurrentTime)
		return true
	else
		--上一次记录日期是第几天
		local theLastTimeDay = localSaveTable.day
		if theLastTimeDay ~= theCurrentTimeDay then
			Common.SaveShareTable(LocalTableKey,theCurrentTime)
			return true
		else
			return false
		end
	end
end
