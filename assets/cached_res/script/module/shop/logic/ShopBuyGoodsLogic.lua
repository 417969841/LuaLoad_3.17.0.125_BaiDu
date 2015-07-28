module("ShopBuyGoodsLogic", package.seeall)

view = nil
--自定义常量
local ADDNUM = 1 --加元宝或是加道具
local SUBNUM = 2 --减元宝或是减道具

local mnGoodsID = nil
local msGoodsName = nil
local msGoodsText = nil
local mnPrice = nil
local msPhotoUrl = nil
local GoodsNum = nil

text_need_yuanbao = nil --消耗的元宝
iv_goods_photo = nil --道具图片
lab_name = nil--名称
text_goods_info = nil --道具详情
text_goods_num = nil --道具详情
btn_shop_goods_buy = nil
btn_add_goods = nil
btn_minus_goods = nil
btn_close = nil
panel = nil
lab_UnitPrice = nil;--单价

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
	view = cocostudio.createView("ShopBuyGoods.json")
	local gui = GUI_SHOP_BUY_GOODS
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

function requestMsg()
end

--[[--
--初始化购买道具界面
]]
function initView()
	--text_self_coin = cocostudio.getUILabel(view, "text_self_coin") --自己的金币
	--text_self_yuanbao = cocostudio.getUILabel(view, "text_self_yuanbao") --自己的元宝
	text_need_yuanbao = cocostudio.getUILabel(view, "text_need_yuanbao") --消耗的元宝
	iv_goods_photo = cocostudio.getUIImageView(view, "iv_goods_photo") --道具图片
	--text_goods_name = cocostudio.getUILabel(view, "text_goods_name") --道具名称
	lab_name = cocostudio.getUILabel(view, "lab_name")
	text_goods_info = cocostudio.getUILabel(view, "text_goods_info") --道具详情
	text_goods_num = cocostudio.getUILabel(view, "text_goods_num") --道具数量
	--shop_buy_scrollview = cocostudio.getUIScrollView(view, "shop_buy_scrollview") --道具数量
	btn_shop_goods_buy = cocostudio.getUIButton(view, "btn_shop_goods_buy")
	btn_add_goods = cocostudio.getUIButton(view, "btn_add_goods")
	btn_minus_goods = cocostudio.getUIButton(view, "btn_minus_goods")
	btn_close = cocostudio.getUIButton(view, "btn_close")
	panel = cocostudio.getUIPanel(view, "panel")
	lab_UnitPrice = cocostudio.getUILabel(view, "lab_UnitPrice");
	LordGamePub.showDialogAmin(panel)
end

local function updataGoodsPhoto(path)
	local photoPath = nil;
	local id = nil;
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and iv_goods_photo ~= nil then
		iv_goods_photo:loadTexture(photoPath)
	end
end

--[[--
--设置商品数据
]]
function setGoodsData(GoodsID, GoodsName, GoodsText, Price, PhotoUrl)
	mnGoodsID = GoodsID
	msGoodsName = GoodsName
	msGoodsText = GoodsText
	mnPrice = Price
	msPhotoUrl = PhotoUrl
	GoodsNum = 1

	--	local viewW = 400;
	--	local viewH = 80;
	--	local viewShowH = 200;
	--	shop_buy_scrollview:setSize(CCSizeMake(viewW, viewH))
	--	shop_buy_scrollview:setInnerContainerSize(CCSizeMake(viewW, viewShowH))

	--text_goods_name:setText(msGoodsName)
	lab_name:setText("购买道具")
	text_goods_info:setText(msGoodsText)
	--Common.log("text_goods_info:getSize().width == "..text_goods_info:getSize().width)
	--Common.log("text_goods_info:getSize().height == "..text_goods_info:getSize().height)

	--	SET_POS(text_goods_name, 0, viewShowH - 20)
	--	SET_POS(text_goods_info, 0, viewShowH - 50)

	text_goods_num:setText(GoodsNum)
	--text_self_coin:setText(profile.User.getSelfCoin())
	--text_self_yuanbao:setText(profile.User.getSelfYuanBao())
	text_need_yuanbao:setText(mnPrice)
	lab_UnitPrice:setText(mnPrice/GoodsNum)

	Common.getPicFile(msPhotoUrl, 0, true, updataGoodsPhoto)
end

--[[--
--购买
]]
function callback_btn_shop_goods_buy(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profile.User.getSelfYuanBao() >=  mnPrice * GoodsNum then
			sendDBID_PAY_GOODS(mnGoodsID, GoodsNum)
		else
			local num =  mnPrice * GoodsNum - profile.User.getSelfYuanBao()
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.ShopPositionB)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--持续加减数量
--]]
function seriesChangeNum(changType)
	local numSum = 1 --加减数量的比率
	if changType == ADDNUM then
		numSum = 1 --如果是加则为正
	elseif changType == SUBNUM then
		numSum = -1--如果是减则为负
	end
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5)) --延时0.5秒开始连续数值变换
	array:addObject(CCCallFunc:create(
		function()
			local array1 = CCArray:create()
			array1:addObject(CCDelayTime:create(0.1)) --延时0.1秒进行数值变换
			array1:addObject(CCCallFunc:create(
				function ()
					numSum = numSum * 1.05 --加速度为每0.1秒加numSum,取numSum最小整数
					GoodsNum = GoodsNum + math.ceil(numSum)
					if GoodsNum <= 1 then --控制兑换数量不能小于1或者大于100000
						view:stopAllActions()
						GoodsNum = 1
					elseif GoodsNum >= 1000 then
						view:stopAllActions()
						GoodsNum = 1000
					end
					text_goods_num:setText(GoodsNum)
					text_need_yuanbao:setText(mnPrice * GoodsNum)
					lab_UnitPrice:setText(mnPrice)
				end
			))
			local sequence = CCSequence:create(array1)
			view:runAction(CCRepeatForever:create(sequence))
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

--[[--
-- 加
]]
function callback_btn_add_goods(component)
	if component == PUSH_DOWN then
		--按下
		seriesChangeNum(ADDNUM)
		btn_add_goods:setScale(1.2)
	elseif component == RELEASE_UP then
		--抬起
		btn_add_goods:setScale(1.0)
		btn_minus_goods:setScale(1.0)
		view:stopAllActions()
		GoodsNum = GoodsNum + 1;
		text_goods_num:setText(GoodsNum)
		text_need_yuanbao:setText(mnPrice * GoodsNum)
		lab_UnitPrice:setText(mnPrice)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 减
]]
function callback_btn_minus_goods(component)
	if component == PUSH_DOWN then
		--按下
		seriesChangeNum(SUBNUM)
		btn_minus_goods:setScale(1.2)
	elseif component == RELEASE_UP then
		--抬起
		btn_add_goods:setScale(1.0)
		btn_minus_goods:setScale(1.0)
		view:stopAllActions()
		if GoodsNum > 1 then
			GoodsNum = GoodsNum - 1;
			text_goods_num:setText(GoodsNum)
			text_need_yuanbao:setText(mnPrice * GoodsNum)
			lab_UnitPrice:setText(mnPrice)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--关闭
]]
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

--[[--
--返回购买结果
]]
function resultBuyGoods()
	local resultData = profile.BuyGoods.getBuyGoodsData()
	local result = resultData["result"] --是否成功1是0否
	local resultMsg = resultData["resultMsg"]
	local ItemID = resultData["ItemID"]
	if result == 1 then
		sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_JIPAIQI) --查看记牌器信息
		--购买成功，关闭对话框
		close()
	end
	Common.showToast(resultMsg, 2)
end
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_SHOP_BUY_GOODS)
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
