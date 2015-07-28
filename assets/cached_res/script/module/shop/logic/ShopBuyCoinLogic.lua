module("ShopBuyCoinLogic",package.seeall)

view = nil

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
btn_close = nil
btn_shop_goods_buy = nil
panel = nil

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
	view = cocostudio.createView("ShopBuyCoin.json")
	local gui = GUI_SHOP_BUY_COIN
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

--初始化界面
function initView()
	--text_self_coin = cocostudio.getUILabel(view, "text_self_coin") --自己的金币
	--text_self_yuanbao = cocostudio.getUILabel(view, "text_self_yuanbao") --自己的元宝
	text_need_yuanbao = cocostudio.getUILabel(view, "text_need_yuanbao") --消耗的元宝
	iv_goods_photo = cocostudio.getUIImageView(view, "iv_goods_photo") --道具图片
	--text_goods_name = cocostudio.getUILabel(view, "text_goods_name") --道具名称
	lab_name = cocostudio.getUILabel(view, "lab_name")
	text_goods_info = cocostudio.getUILabel(view, "text_goods_info") --道具详情
	--text_goods_num = cocostudio.getUILabel(view, "text_goods_num") --道具数量
	--shop_buy_scrollview = cocostudio.getUIScrollView(view, "shop_buy_scrollview") --道具数量
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_shop_goods_buy = cocostudio.getUIButton(view, "btn_shop_goods_buy")
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
end

local function updataGoodsPhoto(path)
	local photoPath
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and iv_goods_photo ~= nil then
		iv_goods_photo:loadTexture(photoPath)
	end
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

function setGoodsData(GoodsID, GoodsName, GoodsText, exchangeCoin,PhotoUrl,Price)
	mnGoodsID = GoodsID
	msGoodsName = GoodsName
	msGoodsText = GoodsText
	mnPrice = Price
	msPhotoUrl = PhotoUrl
	--msExchangeCoin = exchangeCoin

	lab_name:setText("购买金币")
	text_goods_info:setText(msGoodsText)
	--text_goods_num:setText(GoodsNum)
	text_need_yuanbao:setText(mnPrice)

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

		if profile.User.getSelfYuanBao() >=  mnPrice then
			BuyCoinConfimLogic.setData(mnGoodsID,msGoodsName,mnPrice)
			mvcEngine.createModule(GUI_BUYCOINCONFIM)

		else
			local num =  mnPrice * 1 - profile.User.getSelfYuanBao()
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num ,RechargeGuidePositionID.ShopPositionA)
		end

	elseif component == CANCEL_UP then
	--取消
	end
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
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_SHOP_BUY_COIN)
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
