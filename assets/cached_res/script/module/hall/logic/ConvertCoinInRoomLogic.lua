module("ConvertCoinInRoomLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_cancel = nil
btn_convert = nil
btn_add = nil
btn_jian = nil
check_show = nil
convert_num = nil--兑换数量
convert_coin = nil--兑换后的金币
Label_num = nil;--
local minCoin = 0

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ConvertCoinInRoom.json")
	local gui = GUI_CONVERTCOININROOM
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel")
	btn_convert = cocostudio.getUIButton(view, "btn_convert")
	btn_add = cocostudio.getUIButton(view, "btn_add")
	btn_jian = cocostudio.getUIButton(view, "btn_jian")
	check_show = cocostudio.getUICheckBox(view, "check_show")
	convert_num = cocostudio.getUITextField(view, "lab_num")
	convert_coin = cocostudio.getUILabel(view, "lab_coin")
	Label_num = cocostudio.getUILabel(view, "Label_num");

	--设置兑换的元宝值
	local yuanbao = math.floor((minCoin+99-profile.User.getSelfCoin())/100)
	convert_num:setText(yuanbao)
	Label_num:setText(yuanbao);
	convert_coin:setText(yuanbao*100)
	--if Common.getDataForSqlite(CommSqliteConfig.ConvertCoinInRoomGuide .. profile.User.getSelfUserID()) == 1 then

	check_show:setSelectedState(true);
	--如果用户不取消对勾,则“兑换提示”界面,每天只出现一次
	saveSelectedStateData();
--	else
--check_show:setSelectedState(false)
--end
end

function setMinCoin(minCoinV)
	minCoin = minCoinV
end

function requestMsg()

end

--[[--
--ios输入框回调
--]]
function callbackInputForIos(valuetable)

	local value = valuetable["value"];
	convert_num:setText(value);
	Label_num:setText(value);
	if tonumber(lab_coin) > 0 then
		convert_coin:setText(yuanbao*100)
	end
end

--[[--
---用户名输入框(ios)
--]]
function callback_lab_num_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(convert_num:getStringValue(),0,true, callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[-
--用户名输入框(安卓)
--]]
function callback_lab_num()
	Label_num:setText(lab_num:getStringValue())
	if tonumber(convert_num:getStringValue()) > 0 then
		convert_coin:setText(yuanbao*100)
	end
end

--[[--
--保存选择框的数据
--]]
function saveSelectedStateData()
	local flag = check_show:getSelectedState();
	if not flag then
		local OldTime = {};
		OldTime.year = 2000;
		OldTime.month = 12;
		OldTime.day = 12;
		OldTime.hour = 12;
		Common.setDataForSqlite(CommSqliteConfig.ConvertCoinInRoomGuide .. profile.User.getSelfUserID(),OldTime);
	else
		Common.setDataForSqlite(CommSqliteConfig.ConvertCoinInRoomGuide .. profile.User.getSelfUserID(),os.date("*t", Common.getServerTime()));
	end
end

--加金币
function callback_btn_add(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local convertnum = convert_num:getStringValue()
		if tonumber(convertnum) ~= nil and isNumber(convertnum)then
			convertnum = convertnum + 1
			convert_num:setText(convertnum)
			convert_coin:setText(100*convertnum)
			Label_num:setText(convertnum)
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--减金币
function callback_btn_jian(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local convertnum = convert_num:getStringValue()
		if tonumber(convertnum) ~= nil and isNumber(convertnum) then
			convertnum = convertnum - 1;
			if(convertnum > 1) then
				convert_num:setText(convertnum)
				convert_coin:setText(100*convertnum)
				Label_num:setText(convertnum)
			else
				convert_num:setText(1)
				convert_coin:setText(100)
				Label_num:setText(1)
			end
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--今日不再显示
function callback_check_show(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--保存选择框的数据
		saveSelectedStateData();
	elseif component == CANCEL_UP then
	--取消
	end
end

--兑换金币
function callback_btn_convert(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local GoodsNum = tonumber(convert_num:getStringValue())
		if isNumber(GoodsNum) then
			if profile.User.getSelfYuanBao() >= GoodsNum then
				sendDBID_PAY_GOODS(profile.BuyGoods.BuyCoinGoodsID, GoodsNum)
			else
				mvcEngine.destroyModule(GUI_CONVERTCOININROOM)
				local num =  GoodsNum - profile.User.getSelfYuanBao()
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num ,RechargeGuidePositionID.ShopPositionA)
			end
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end

	elseif component == CANCEL_UP then
	--取消
	end
end

function isNumber(str)
	return string.find(str,"^-?[1-9]%d*$")
end

--取消
function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--关闭界面
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end

--关闭页面
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_CONVERTCOININROOM)
end

function resultBuyGoods()
	local resultData = profile.BuyGoods.getBuyGoodsData()
	local result = resultData["result"] --是否成功1是0否
	local resultMsg = resultData["resultMsg"]
	local ItemID = resultData["ItemID"]
	Common.log(result)
	if result == 1 then
		--购买成功，关闭对话框
		close()
	end
	Common.showToast(resultMsg, 2)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DBID_PAY_GOODS, resultBuyGoods)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_PAY_GOODS, resultBuyGoods)
end