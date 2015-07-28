module("BuyVipGiftLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
img_gift = nil
lab_content = nil
btn_buy = nil

lab_name = nil
lab_zhu = nil

lab_kouyuanbao = nil
Label_Prompt = nil;--
AtlasLabel_VipLevel = nil;--

--全局变量
local Name = nil
local IconURL = nil
local Description = nil
local Consume = nil
local needVipMinLevel = nil
local VipGiftID = nil--礼包id
local fromflag = nil --跳转路径
local ISFROMSHOPVIEW = 1 --从商城界面跳转而来
local ISFROMCHONGZHIVIEW = 2 --从充值界面跳转而来
local ISFROMZHANNEIXING = 3 --从站内信跳转而来
local fromTypeTable = {} --跳转类型表

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		fromflag = nil;
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
-- 获取跳转类型
]]
function getFromType()
	fromTypeTable["ISFROMSHOPVIEW"] = ISFROMSHOPVIEW;
	fromTypeTable["ISFROMCHONGZHIVIEW"] = ISFROMCHONGZHIVIEW;
	fromTypeTable["ISFROMZHANNEIXING"] = ISFROMZHANNEIXING;
	return fromTypeTable;
end

local function updataGoodsPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and img_gift ~= nil then
		img_gift:loadTexture(photoPath);
	end
end

--[[--
--初始化控件
--]]
function initView()
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_buy = cocostudio.getUIButton(view, "btn_buy")
	lab_name =  cocostudio.getUILabel(view, "lab_name")
	lab_content =   cocostudio.getUILabel(view, "lab_content")
	lab_zhu =  cocostudio.getUILabel(view, "lab_zhu")

	lab_kouyuanbao =  cocostudio.getUILabel(view, "lab_kouyuanbao")
	img_gift = cocostudio.getUIImageView(view, "img_gift")
	Label_Prompt = cocostudio.getUILabel(view, "Label_Prompt");
	lab_name:setText(Name)
	lab_content:setText(Description)
	lab_zhu:setText("注：仅限VIP"..VIPPub.getUserVipType(needVipMinLevel).."及以上用户购买，每天限购1个。")
	lab_kouyuanbao:setText("-"..Consume)
	if fromflag ~= nil then
		if fromflag == ISFROMCHONGZHIVIEW then
		elseif fromflag == ISFROMSHOPVIEW or fromflag == ISFROMZHANNEIXING then
		end
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("BuyVipGift.json")
	local gui = GUI_BUYVIPGIFT
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
	local vipnum = VIPPub.getUserVipType(needVipMinLevel)

	Common.getPicFile(IconURL, 0, true, updataGoodsPhoto)
end

--[[--
--设置显示的礼包相关属性
--@param number vipV vip等级
--@param number VipGiftIDV 礼包ID
--@param String NameV 礼包名称
--@param String IconURLV 礼包路径
--@param String DescriptionV 礼包描述
--@param number ConsumeV 礼包单价
--@param number needVipMinLevelV 满足购买礼包所需最小级别
--@param number type 跳转路径类型
--]]
function setValue(VipGiftIDV,NameV,IconURLV,DescriptionV,ConsumeV,needVipMinLevelV,type)
	VipGiftID = VipGiftIDV;
	Name = NameV;
	IconURL = IconURLV;
	Description = DescriptionV;
	Consume = ConsumeV;
	needVipMinLevel = needVipMinLevelV;
	fromflag = type;
end

function requestMsg()
end

--关闭
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

--关闭
function close()
	fromflag = nil;
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_BUYVIPGIFT)
end
--购买
function callback_btn_buy(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profile.User.getSelfYuanBao() >=  Consume  then
			--購買vip禮包
			sendGIFTBAGID_BUY_GIFTBAG(VipGiftID)
			--Common.showToast("请求已发出，请稍等", 2)
			close()
			checkCanBuy()
			--sendDBID_PAY_GOODS(VipGiftID, 1)
		else
			local num =  Consume - profile.User.getSelfYuanBao()
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.ShopPositionB)

		end
	elseif component == CANCEL_UP then
	--取消
	end
end
function checkCanBuy()

end

----vip
--function callback_img_vip(component)
--	if component == PUSH_DOWN then
--	--按下
--	elseif component == RELEASE_UP then
--		--抬起
--		GameConfig.setTheLastBaseLayer(GUI_SHOP)
--		mvcEngine.createModule(GUI_VIP,LordGamePub.runSenceAction(view,nil,true))
--	elseif component == CANCEL_UP then
--	--取消
--	end
--end

----vip  info
--function callback_img_vipinfo(component)
--	if component == PUSH_DOWN then
--	--按下
--	elseif component == RELEASE_UP then
--		--抬起
--		GameConfig.setTheLastBaseLayer(GUI_SHOP)
--		mvcEngine.createModule(GUI_VIP,LordGamePub.runSenceAction(view,nil,true))
--	elseif component == CANCEL_UP then
--	--取消
--	end
--end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
end

