module("BuyGiftVipNotFitLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_cz = nil
--btn_vip = nil
lab_msg = nil
--LabelContent = nil;--
LabelDescription = nil;--
LabelConsume = nil;--
ImageGift = nil;--
LabelName = nil;--
AtlasLabel_VipLevel = nil;--
--ImageViewVipDetail = nil;--
--全局变量
local vip = nil --vip等级
local showVipGiftID = nil --礼包ID
local showName = nil --礼包名称
local showIconURL = nil --礼包URL
local showDescription = nil --礼包描述
local showConsume = nil --礼包单价
local fromflag = nil --跳转标记
local ISFROMSHOP = 1 --从商场礼包跳转而来
local ISFROMCHONGZHI = 2 --从充值界面跳转而来
local ISZHANNEIXING = 3 --从站内信跳转而来
local vipLevelTable = {}; --vip等级表
local needvip = nil;

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--更新礼包图片
--@param String path 礼包图片路径
---]]
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
	if photoPath ~= nil and photoPath ~= "" and ImageGift ~= nil then
		ImageGift:loadTexture(photoPath);
	end
end
--[[--
--初始化控件
--]]
function initView()
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_cz = cocostudio.getUIButton(view, "btn_cz")
	lab_msg = cocostudio.getUILabel(view, "lab_msg")
	--LabelContent = cocostudio.getUILabel(view, "--LabelContent");
	LabelDescription = cocostudio.getUILabel(view, "LabelDescription");
	LabelConsume = cocostudio.getUILabel(view, "LabelConsume");
	ImageGift = cocostudio.getUIImageView(view, "ImageGift");
	LabelName = cocostudio.getUILabel(view, "LabelName");
	AtlasLabel_VipLevel = cocostudio.getUILabelAtlas(view, "AtlasLabel_VipLevel");
	--btn_vip = cocostudio.getUIButton(view, "btn_vip")
	--ImageViewVipDetail = cocostudio.getUIImageView(view, "--ImageViewVipDetail");
	--	if fromflag ~= nil then
	--		if fromflag == ISFROMCHONGZHI then
	--			--ImageViewVipDetail:setVisible(false)
	--			--btn_vip:setVisible(false)
	--			--btn_vip:setTouchEnabled(false)
	--		elseif fromflag == ISFROMSHOP then
	--			--ImageViewVipDetail:setVisible(true)
	--			--btn_vip:setVisible(true)
	--			--btn_vip:setTouchEnabled(true)
	--		elseif fromflag == ISZHANNEIXING then
	--			--ImageViewVipDetail:setVisible(true)
	--			--btn_vip:setVisible(true)
	--			--btn_vip:setTouchEnabled(true)
	--		else
	--		end
	--	end

end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("BuyGiftVipNotFit.json")
	local gui = GUI_BUYGIFTVIPNOTFIT
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
	--初始化控件
	initView()
	sendMANAGERID_VIP_LEVEL_LIST(); --发送vip等级请求
	GameStartConfig.addChildForScene(view)
	panel = cocostudio.getUIPanel(view, "panel")
	LordGamePub.showDialogAmin(panel)

	local VipLevel = profile.User.getSelfVipLevel()--我的vip级别175
	local vipjb = VIPPub.getUserVipType(VipLevel)--我的vip等级，7级
	needvip = VIPPub.getUserVipType(vip)
	local money = 0
	if vipjb > 0 then
		money = VIPPub.VipCzje[needvip] - VIPPub.VipCzje[vipjb]
	else
		money = VIPPub.VipCzje[needvip]
	end
	if fromflag ~= nil then
		if fromflag == ISFROMCHONGZHI or fromflag == ISFROMSHOP or fromflag == ISZHANNEIXING then
			lab_msg:setText("您还不是VIP"..needvip.."，无法购买。充值"..money.."元即可免费成为VIP"..needvip.."。")
			AtlasLabel_VipLevel:setStringValue(VIPPub.getUserVipType(vip));
			--LabelContent:setText("礼包内容")
			LabelConsume:setText("礼包内容：" .. showDescription)
			LabelDescription:setText("您是VIP"..VIPPub.getUserVipType(vip).."，今天还可以购买1个。");
			if vipjb < needvip then
				LabelDescription:setVisible(false)
			end
		end
	end
	Common.getPicFile(showIconURL, 0, true, updataGoodsPhoto)
end

--[[--
--设置显示的礼包相关属性
--@param number vipV vip等级
--@param number  礼包ID
--@param String Name 礼包名称
--@param String IconURL 礼包路径
--@param String Description 礼包描述
--@param number Consume 礼包单价
--@param number type 跳转路径类型
--]]
function setNotFitValue(vipV,VipGiftID,Name,IconURL,Description,Consume,type)
	vip = vipV;
	showVipGiftID =VipGiftID;
	showName = Name;
	showIconURL = IconURL;
	showDescription = Description;
	showConsume = Consume;
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
	--关闭本界面后，再次显示web_view层容器
	--Common.showWebView(urlValue, codeValue, x, y, width, height)
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_BUYGIFTVIPNOTFIT)
end

function callback_btn_cz(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--GameConfig.setTheLastBaseLayer(GUI_SHOP)
		--mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
		mvcEngine.destroyModule(GUI_BUYGIFTVIPNOTFIT)
		local vipneedyuanbao =  VIPPub.getUserVipChaNeedMoney(VIPPub.getUserVipType(vip))
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, vipneedyuanbao ,RechargeGuidePositionID.MatchListPositionC)

	elseif component == CANCEL_UP then
	--取消
	end
end
function callback_btn_vip(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getTheCurrentBaseLayer() ~= GUI_VIP then
			GameConfig.setTheLastBaseLayer(GUI_SHOP)
			mvcEngine.createModule(GUI_VIP,LordGamePub.runSenceAction(view,nil,true))
		else
			mvcEngine.destroyModule(GUI_BUYGIFTVIPNOTFIT)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--获取vip等级数据
--]]
function getVipLevelTable()
	vipLevelTable = profile.VIPData.getVipLevelTable();
	for i = 1,#vipLevelTable["VipLevelListTable"] do
		if vip == vipLevelTable.VipLevelListTable[i].vipLevel then
			lab_msg:setText("您还不是VIP"..needvip.."，无法购买。充值"..vipLevelTable.VipLevelListTable[i].needMoney.."元即可免费成为VIP"..needvip.."。")
			return ;
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MANAGERID_VIP_LEVEL_LIST, getVipLevelTable);
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MANAGERID_VIP_LEVEL_LIST, getVipLevelTable);
end
