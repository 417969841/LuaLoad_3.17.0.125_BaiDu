module("TrickyPartyLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_6 = nil;--
Label_woDeDaoJu = nil;--
Label_paiming = nil;--
Button_Paihangbang = nil;--
Button_help = nil;--
Button_fanhui = nil;--
Panel_39 = nil;--
Image_dagou5 = nil;--
Image_dagou15 = nil;--
Image_dagou35 = nil;--
Image_dagou55 = nil;--
Button_shuaxin = nil;--
Button_qianwang = nil;--
Label_XiaoHao = nil;--
Label_endZi = nil;--
Label_endTime = nil;--
Panel_43 = nil;--
Button_lingqu1 = nil;--
Button_lingqu2 = nil;--
Button_lingqu3 = nil;--
Button_lingqu4 = nil;--
Image_lingqu1 = nil;--
Image_lingqu2 = nil;--
Image_lingqu3 = nil;--
Image_lingqu4 = nil;--


WuYiDaoJiShi = 0

OPERID_GODDESS_GET_INFOInfo = {}



function onKeypad(event)
	if event == "backClicked" then
		--返回键
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_TRICKYPARTY;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("load_res/TrickyParty/TrickyParty.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("load_res/TrickyParty/TrickyParty.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_6 = cocostudio.getUIPanel(view, "Panel_6");
	Label_woDeDaoJu = cocostudio.getUILabel(view, "Label_woDeDaoJu");
	Label_paiming = cocostudio.getUILabel(view, "Label_paiming");
	Button_Paihangbang = cocostudio.getUIButton(view, "Button_Paihangbang");
	Button_help = cocostudio.getUIButton(view, "Button_help");
	Button_fanhui = cocostudio.getUIButton(view, "Button_fanhui");
	Panel_39 = cocostudio.getUIPanel(view, "Panel_39");
	LoadingBar = cocostudio.getUILoadingBar(view, "LoadingBar");
	Image_dagou5 = cocostudio.getUIImageView(view, "Image_dagou5");
	Image_dagou15 = cocostudio.getUIImageView(view, "Image_dagou15");
	Image_dagou35 = cocostudio.getUIImageView(view, "Image_dagou35");
	Image_dagou55 = cocostudio.getUIImageView(view, "Image_dagou55");
	Button_shuaxin = cocostudio.getUIButton(view, "Button_shuaxin");
	Label_XiaoHao = cocostudio.getUILabel(view, "Label_XiaoHao");
	Button_qianwang = cocostudio.getUIButton(view, "Button_qianwang");
	Label_endZi = cocostudio.getUILabel(view, "Label_endZi");
	Label_endTime = cocostudio.getUILabel(view, "Label_endTime");
	Panel_43 = cocostudio.getUIPanel(view, "Panel_43");
	Button_lingqu1 = cocostudio.getUIButton(view, "Button_lingqu1");
	Button_lingqu2 = cocostudio.getUIButton(view, "Button_lingqu2");
	Button_lingqu3 = cocostudio.getUIButton(view, "Button_lingqu3");
	Button_lingqu4 = cocostudio.getUIButton(view, "Button_lingqu4");
	Image_lingqu1 = cocostudio.getUIImageView(view, "Image_77");
	Image_lingqu2 = cocostudio.getUIImageView(view, "Image_78");
	Image_lingqu3 = cocostudio.getUIImageView(view, "Image_79");
	Image_lingqu4 = cocostudio.getUIImageView(view, "Image_80");
	Button_shuaxin:setTouchEnabled(false)
	Button_shuaxin:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),nil)
	Button_lingqu1:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)
	Button_lingqu2:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)
	Button_lingqu3:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)
	Button_lingqu4:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)

end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	GameConfig.setTheCurrentBaseLayer(GUI_TrickyParty)
	initView();
	initData()
end

function requestMsg()

end

function initData()
	Image_dagou5:setVisible(false)
	Image_dagou15:setVisible(false)
	Image_dagou35:setVisible(false)
	Image_dagou55:setVisible(false)
	local function delaySentMessage()
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_GET_INFO(dataTable)
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)


	setTime(WuYiDaoJiShi)
	local delay = CCDelayTime:create(1)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(setTime))
	local seq = CCSequence:create(array)
	Label_endTime:runAction(CCRepeatForever:create(seq))
end


function callback_Panel_14(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_6(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Paihangbang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_TRICKYPARTYRANK)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_TRICKYPARTYGUIDE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_fanhui(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_39(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_shuaxin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		for i  = 1 ,4 do
			if(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 1)then
				Common.showToast("您还有未领取的奖励哦！！",2)
				return
			end
		end
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_RESET(dataTable)

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_qianwang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.showProgressDialog("正在转入牌桌...")
		sendQuickEnterRoom(2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_43(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_lingqu1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 1
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftStatus == 0 then
			Common.showToast("在癞子房中再打".. OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局，就能领取奖励哦！",2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_lingqu2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 2
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftStatus == 0 then
			Common.showToast("在癞子房中再打".. OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局，就能领取奖励哦！",2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_lingqu3(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 3
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftStatus == 0 then
			Common.showToast("在癞子房中再打".. OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局，就能领取奖励哦！",2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_lingqu4(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 4
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftStatus == 0 then
			Common.showToast("在癞子房中再打".. OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局，就能领取奖励哦！",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end



--设置时间
function setTime()
	if(WuYiDaoJiShi >= 1000)then
		WuYiDaoJiShi = WuYiDaoJiShi - 1000
	else
		WuYiDaoJiShi = 0
	end

	local sounds = ((WuYiDaoJiShi/1000)%60) - ((WuYiDaoJiShi/1000)%60)%1
	local minute = ((WuYiDaoJiShi/60000)%60) - ((WuYiDaoJiShi/60000)%60)%1
	local ours = (WuYiDaoJiShi/(1000*3600)) - (WuYiDaoJiShi/(1000*3600))%1
	local dates = ours/24 - (ours/24)%1
	ours = ours%24
	local oursString = ours > 9 and tostring(ours) or ("0" .. ours)
	local minuteString = minute > 9 and tostring(minute) or ("0" .. minute)
	local soundsString = sounds > 9 and tostring(sounds) or ("0" .. sounds)
	if(dates > 1)then
		Label_endTime:setText(dates.."天")
	else
		Label_endTime:setText(ours..":"..minuteString..":"..soundsString)
	end
end

function updata()
	if OPERID_GODDESS_GET_INFOInfo.completeNum >= 5 then
		Image_dagou5:setVisible(true)
	end
	if OPERID_GODDESS_GET_INFOInfo.completeNum >= 15 then
		Image_dagou15:setVisible(true)
	end
	if OPERID_GODDESS_GET_INFOInfo.completeNum >= 35 then
		Image_dagou35:setVisible(true)
	end
	if OPERID_GODDESS_GET_INFOInfo.completeNum >= 55 then
		Image_dagou55:setVisible(true)
		--解锁刷新
		Button_shuaxin:setTouchEnabled(true)
		Button_shuaxin:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)
	end

	--进度条
	LoadingBar:setPercent(math.ceil(OPERID_GODDESS_GET_INFOInfo.completeNum / 55.0 * 100))
	Common.log("wwwwwwwwwwwwwwwwwwwwwwww jindu = " .. OPERID_GODDESS_GET_INFOInfo.completeNum .. "  " .. math.ceil(OPERID_GODDESS_GET_INFOInfo.completeNum/55.0 * 100))

	--勤劳值
	Label_woDeDaoJu:setText(OPERID_GODDESS_GET_INFOInfo.labourValue)
	--我的名次
	if(OPERID_GODDESS_GET_INFOInfo.SelfRank>0)then
		Label_paiming:setText(OPERID_GODDESS_GET_INFOInfo.SelfRank)
	else
		Label_paiming:setText("999+")
	end
	--倒计时
	WuYiDaoJiShi = tonumber(OPERID_GODDESS_GET_INFOInfo.Time)

	--元宝消耗
	Label_XiaoHao:setText("消耗"..OPERID_GODDESS_GET_INFOInfo.expend.."元宝");
	WuYiDaoJiShi = tonumber(OPERID_GODDESS_GET_INFOInfo.Time)

	local button = {Button_lingqu1,Button_lingqu2,Button_lingqu3,Button_lingqu4}
	local image = {Image_lingqu1,Image_lingqu2,Image_lingqu3,Image_lingqu4}

	for i=1, 4 do
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 0)then
			--不能领取
			button[i]:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),nil)
			button[i]:setTouchEnabled(true)
			image[i]:loadTexture(Common.getResourcePath("load_res/TrickyParty/kelingqu_3.png"))
		elseif(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 1)then
			--可以领取
			button[i]:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),Common.getResourcePath("load_res/TrickyParty/btn_gerenziliao0.png"),nil)
			button[i]:setTouchEnabled(true)
			image[i]:loadTexture(Common.getResourcePath("load_res/TrickyParty/kelingqu_2.png"))
		elseif(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 2)then
			--已领取
			button[i]:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),nil)
			image[i]:loadTexture(Common.getResourcePath("load_res/TrickyParty/yilingqu_1.png"))
			button[i]:setTouchEnabled(false)
		end
	end
end


--获得女神的基本信息
function getOPERID_GODDESS_GET_INFOInfo()
	OPERID_GODDESS_GET_INFOInfo = profile.HuoDong.getOPERID_GODDESS_GET_INFOTable()
	updata()
end

--刷新奖励状态
function getOPERID_GODDESS_RESETInfo()
	local itemTable = profile.HuoDong.getOPERID_GODDESS_RESETTable()
	if(itemTable.isSuccesse == 1) then
		LoadingBar:setPercent(OPERID_GODDESS_GET_INFOInfo.rateofprogress)
		Image_dagou5:setVisible(false)
		Image_dagou15:setVisible(false)
		Image_dagou35:setVisible(false)
		Image_dagou55:setVisible(false)
		Button_shuaxin:setTouchEnabled(false)
		Button_shuaxin:loadTextures(Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),Common.getResourcePath("load_res/TrickyParty/btn_dark.png"),nil)
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_GET_INFO(dataTable)
	else
		--如果元宝不足则进行充值引导
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, 50, RechargeGuidePositionID.miniGamePositionF)
	end
	Common.showToast(itemTable["Mes"], 2)
end


--领取奖励
function getOPERID_GODDESS_GET_GIFTInfo()
	local dataTable = profile.HuoDong.getOPERID_GODDESS_GET_GIFTTable()
	Common.log("收到奖品信息：",dataTable["isSuccesse"],dataTable["Mes"])
	if(dataTable["isSuccesse"] == 1) then
		for i = 1,#dataTable["Awardlist"] do
			ImageToast.createView(dataTable["Awardlist"][i].url,nil,dataTable["Awardlist"][i].mes,"领取成功",#dataTable["Awardlist"] - i + 1)
			--			Common.log("zblzx..url = " .. dataTable["Awardlist"][i].url .. "mes = " ..  dataTable["Awardlist"][i].mes)
		end
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_GET_INFO(dataTable)
		if(OPERID_GODDESS_GET_INFOInfo.SelfRank ~= dataTable.SelfRank)then
		--			freshTableView(dataTable.LikeabilityList)
		--			if(dataTable.SelfRank > 0)then
		--				Label_paiming:setText(dataTable.SelfRank)
		--			else
		--				Label_paiming:setText("999")
		--			end
		end
	end
	Common.showToast(dataTable["Mes"], 2)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_GODDESS_GET_INFO,getOPERID_GODDESS_GET_INFOInfo)
	framework.addSlot2Signal(OPERID_GODDESS_RESET,getOPERID_GODDESS_RESETInfo)
	framework.addSlot2Signal(OPERID_GODDESS_GET_GIFT,getOPERID_GODDESS_GET_GIFTInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_GODDESS_GET_INFO,getOPERID_GODDESS_GET_INFOInfo)
	framework.removeSlotFromSignal(OPERID_GODDESS_RESET,getOPERID_GODDESS_RESETInfo)
	framework.removeSlotFromSignal(OPERID_GODDESS_GET_GIFT,getOPERID_GODDESS_GET_GIFTInfo)
end
