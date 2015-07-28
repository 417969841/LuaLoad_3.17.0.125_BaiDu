module("ConvertCoinLogic",package.seeall)

--自定义常量
local ADDNUM = 1 --加元宝或是加道具
local SUBNUM = 2 --减元宝或是减道具
view = nil
--控件
--self_coin = nil
--self_yuanbao = nil
btn_add = nil
btn_jian = nil
btn_convert = nil
btn_gb = nil
--local self_title = nil
self_content = nil
convert_coin = nil
convert_yuanbao = nil
convert_num = nil
convert_image = nil
panel  = nil --底层panel
--全局变量
local GoodsID = 0--物品id
local imgurl = nil--url地址
local convert_coinvalue = 0--
local Price = 0--价格
local GoodsText = nil --简介

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
	view = cocostudio.createView("ConvertCoin.json")
	local gui = GUI_CONVERTCOIN
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
	initView()
end

local function updataImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and convert_image ~= nil then
		convert_image:loadTexture(photoPath)
	end
end

function initView()
	--self_coin = cocostudio.getUILabel(view, "txt_coin")
	--self_yuanbao = cocostudio.getUILabel(view, "--txt_yuanbao")
	--self_title = cocostudio.getUILabel(view, "txt_title")
	--self_content = cocostudio.getUILabel(view, "txt_content")
	convert_coin = cocostudio.getUILabel(view, "convert_coin")
	convert_num = cocostudio.getUITextField(view, "txt_num")
	convert_num:setVisible(false);
	convert_yuanbao = cocostudio.getUILabel(view, "txt_convertyuanbao")
	--convert_image = cocostudio.getUIImageView(view,"img_item")
	btn_add = cocostudio.getUIButton(view, "btn_add")
	btn_jian = cocostudio.getUIButton(view, "btn_jian")
	btn_convert = cocostudio.getUIButton(view, "btn_convert")
	btn_gb = cocostudio.getUIButton(view, "btn_gb")
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	--元宝金币
	local mycoin = profile.User.getSelfCoin()
	local myyuanbao = profile.User.getSelfYuanBao()
	if myyuanbao >= 100000 then
		myyuanbao = 100000
	end
	--self_coin:setText(mycoin)
	--self_yuanbao:setText(myyuanbao)
	--界面赋值
	if(RenWuLogic.getModifyUserInfo() == true)then
		--新手任务，显示兑换的元宝为1
		RenWuLogic.setModifyUserInfo(false)
		convert_num:setText(1)
	else
		convert_num:setText(myyuanbao)
	end
	convert_yuanbao:setText(Price*convert_num:getStringValue())
	convert_coin:setText(convert_coinvalue*convert_num:getStringValue())
	Common.getPicFile(imgurl, 0, true, updataImage)
end
function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
--复制
function setGoodsData(mnGoodsID, msGoodsName, msGoodsText, msExchangeCoin,msimgurl,mnPrice)
	GoodsID = mnGoodsID
	imgurl = msimgurl
	convert_coinvalue = msExchangeCoin
	Price = mnPrice
	GoodsText = msGoodsText
end

--[[--
--持续加减数量
--]]
function seriesChangeNum(changType)
	local convertnum = convert_num:getStringValue()
	local numSum = 1 --加减数量的比率
	if changType == ADDNUM then
		numSum = 1 --如果是加则为正
	elseif changType == SUBNUM then
		numSum = -1--如果是减则为负
	end
	if tonumber(convertnum) ~= nil and isNumber(convertnum) then --如果兑换数量是数字或非空
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(0.5)) --延时0.5秒开始连续数值变换
		array:addObject(CCCallFunc:create(
			function()
				local array1 = CCArray:create()
				array1:addObject(CCDelayTime:create(0.1)) --延时0.1秒进行数值变换
				array1:addObject(CCCallFunc:create(
					function ()
						numSum = numSum * 1.2 --加速度为每0.1秒加numSum,取numSum最小整数
						convertnum = convertnum + math.ceil(numSum)
						if convertnum <= 1 then --控制兑换数量不能小于1或者大于100000
							view:stopAllActions()
							convertnum = 1
						elseif convertnum >= 100000 then
							view:stopAllActions()
							convertnum = 100000
						end
						convert_num:setText(convertnum)
						convert_coin:setText(convert_coinvalue*convertnum)
						convert_yuanbao:setText(convertnum*Price)
					end
				))
				local sequence = CCSequence:create(array1)
				view:runAction(CCRepeatForever:create(sequence))
			end
		))
		local seq = CCSequence:create(array)
		view:runAction(seq)
	else
		Common.showToast("您输入的兑换数量不是数字奥！", 2)
	end
end

function callback_btn_add(component)
	if component == PUSH_DOWN then
		--按下
		seriesChangeNum(ADDNUM)
		btn_add:setScale(1.2)
	elseif component == RELEASE_UP then
		--抬起
		btn_add:setScale(1.0)
		btn_jian:setScale(1.0)
		view:stopAllActions()
		local convertnum = convert_num:getStringValue()
		if tonumber(convertnum) ~= nil and isNumber(convertnum) then
			convertnum = convertnum+1
			if convertnum <= 1 then
				view:stopAllActions()
				convertnum = 1
			elseif convertnum >= 100000 then
				view:stopAllActions()
				convertnum = 100000
			end
			convert_num:setText(convertnum)
			convert_coin:setText(convert_coinvalue*convertnum)
			convert_yuanbao:setText(convertnum*Price)
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end
	elseif component == CANCEL_UP then
	--取消
		view:stopAllActions();
	end
end

function callback_btn_jian(component)
	if component == PUSH_DOWN then
		--按下
		seriesChangeNum(SUBNUM)
		btn_add:setScale(1.0)
		btn_jian:setScale(1.2)
	elseif component == RELEASE_UP then
		--抬起
		view:stopAllActions()
		btn_jian:setScale(1.0)
		local convertnum = convert_num:getStringValue()
		if tonumber(convertnum) ~= nil and isNumber(convertnum) then
			convertnum = convertnum-1
			if(convertnum>1) then
				convert_num:setText(convertnum)
				convert_yuanbao:setText(convertnum*Price)
				convert_coin:setText(convert_coinvalue*convertnum)
			else
				convert_num:setText(1)
				convert_yuanbao:setText(Price)
				convert_coin:setText(convert_coinvalue*1)
			end
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end
	elseif component == CANCEL_UP then
	--取消
		view:stopAllActions();
	end
end

function callback_btn_convert(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local GoodsNum = convert_num:getStringValue()
		--判断是不是数字
		if isNumber(GoodsNum) then
			if profile.User.getSelfYuanBao() >=  Price * GoodsNum then
				sendDBID_PAY_GOODS(GoodsID, GoodsNum)
			else
				mvcEngine.destroyModule(GUI_CONVERTCOIN)
				local num =  Price * GoodsNum - profile.User.getSelfYuanBao()
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num ,RechargeGuidePositionID.ShopPositionA)
				PayGuidePromptLogic.setNeedOpenView(GUI_CONVERTCOIN)
			end
		else
			Common.showToast("您输入的兑换数量不是数字奥！", 2)
		end

	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_txt_num_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(convert_num:getStringValue(), 0, true, callbackConvertNumInput)
	elseif component == CANCEL_UP then
	--取消
	end
end
function callback_txt_num()
	convert_yuanbao:setText(convert_num:getStringValue())
	if tonumber(convert_num:getStringValue()) > 0 then
		convert_coin:setText(convert_coinvalue*convert_num:getStringValue())
	end
end

function callbackConvertNumInput(valuetable)
	local value = valuetable["value"]
	if tonumber(value) > 0 then
		convert_num:setText(value)
		convert_yuanbao:setText(value)
		convert_coin:setText(convert_coinvalue*convert_num:getStringValue())
	end
end


function isNumber(str)
	return string.find(str,"^-?[1-9]%d*$")
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
		sendCOMMONS_V3_NEWUSER_TASK_IS_COMPLETE();
		ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"),"兑换金币成功",resultMsg,2)
	end
--	Common.showToast(resultMsg, 2)

end
--关闭
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_CONVERTCOIN)
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

