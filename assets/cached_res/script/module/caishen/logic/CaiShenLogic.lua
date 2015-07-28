module("CaiShenLogic",package.seeall)

view = nil

CaiShenInformationTable = {}
LabelAtlas_DaoJiShi = nil--------------------------
LinagJIangButton = nil -------------------------
caishenDaojishi = 0
local isFirst = true
isTouch = false--是否已经按下
FORTUNE_TIME_SYNCInfoTable = {} -- 财神基本信息

panel = nil
Label_JinBi1 = nil;--
Label_JinBi2 = nil;--
BackButton = nil;
Label_CaiYunZhi = nil;
Button_ShangXiang = nil;
Button_GuiZe = nil;
LabelAtlas_CaiShenXiang = nil;
Label_CaiShenXiang = nil;
Label_SuiPian1 = nil;--
Label_SuiPian2 = nil;--
Button_lingqu = nil;--
Label__DaoJiShi = nil;--
Image_LingQu = nil;--

function onKeypad(event)
	if event == "backClicked" then
		local function actionOver()
			mvcEngine.destroyModule(GUI_CAISHEN)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CaiShen.json")
	local gui = GUI_CAISHEN
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
	caishenDaojishi = 0;
	panel = cocostudio.getUIImageView(view, "ImageView_23")
	LordGamePub.showDialogAmin(panel, true)
	Button_ShangXiang = cocostudio.getUIButton(view, "Button_ShangXiang")
	Button_GuiZe = cocostudio.getUIButton(view, "Button_GuiZe")
	BackButton = cocostudio.getUIButton(view, "BackButton")
	Label_CaiYunZhi = cocostudio.getUILabel(view, "Label_CaiYunZhi")
	LabelAtlas_CaiShenXiang = cocostudio.getUILabel(view, "LabelAtlas_CaiShenXiang");
	Label_JinBi1 = cocostudio.getUILabel(view, "Label_JinBi1");
	Label_JinBi2 = cocostudio.getUILabel(view, "Label_JinBi2");
	Label_SuiPian1 = cocostudio.getUILabel(view, "Label_SuiPian1");
	Label_SuiPian2 = cocostudio.getUILabel(view, "Label_SuiPian2");
	Label__DaoJiShi = cocostudio.getUILabel(view, "Label__DaoJiShi");
	Button_lingqu = cocostudio.getUIButton(view, "Button_lingqu");
	Image_LingQu = cocostudio.getUIImageView(view, "Image_LingQu");
	Label__DaoJiShi:setVisible(false)
	LabelAtlas_CaiShenXiang:setText("")
	Label_CaiShenXiang = ccs.label({
		text = string.format("0"),
		color = ccc3(255,255,255),
	})
	Label_CaiShenXiang:setFontSize(18)
	Label_CaiShenXiang:setTouchEnabled(false)
	LabelAtlas_CaiShenXiang:addChild(Label_CaiShenXiang)
	--请求财神时间同步
	sendFORTUNE_TIME_SYNC()
	--请求财神基本信息
	sendFORTUNE_GET_INFORMATION()
	--财神通知
	sendFORTUNE_RELEASE_NOTIFICATION()
end


function caishenTimeSynchronization()
	Label_CaiYunZhi:setText(CaiShenInformationTable.FortuneValue);
	if tonumber(CaiShenInformationTable.SacrificeValue) > 0 then
		--白色
		Label_CaiShenXiang:setColor(ccc3(249, 235, 219))

	else
		--红色
		Label_CaiShenXiang:setColor(ccc3(228, 78, 63))
	end
	Label_CaiShenXiang:setText(CaiShenInformationTable.SacrificeValue);
	Label_JinBi2:setText(CaiShenInformationTable["ArrayList"][1].num);
	Label_JinBi1:setText(CaiShenInformationTable["ArrayList"][1].num);
	Label_SuiPian1:setText(CaiShenInformationTable["ArrayList"][2].num);
	Label_SuiPian2:setText(CaiShenInformationTable["ArrayList"][2].num);
	if(CaiShenInformationTable["FreeAward"] == 0)then
		setButtonTouchEnabled(false)
		isFirst = false;
	else
		isFirst = true;
	end

	if Label__DaoJiShi ~= nil then
		Label__DaoJiShi:stopAllActions();
	end

	if Label__DaoJiShi ~= nil then
		setTime();
		local delay = CCDelayTime:create(1)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(setTime))
		local seq = CCSequence:create(array)
		Label__DaoJiShi:runAction(CCRepeatForever:create(seq))
	end
end

function getGift()
	sendFORTUNE_GET_AWARD()
end

function setTime()
	if(caishenDaojishi >= 1000)then
		caishenDaojishi = caishenDaojishi - 1000
	else
		caishenDaojishi = 0
	end

	local sounds = ((caishenDaojishi/1000)%60) - ((caishenDaojishi/1000)%60)%1
	local minute = ((caishenDaojishi/60000)%60) - ((caishenDaojishi/60000)%60)%1
	local ours = (caishenDaojishi/(1000*3600)) - (caishenDaojishi/(1000*3600))%1
	local oursString = ours > 9 and tostring(ours) or ("0" .. ours)
	local minuteString = minute > 9 and tostring(minute) or ("0" .. minute)
	local soundsString = sounds > 9 and tostring(sounds) or ("0" .. sounds)
	minuteString = minuteString + (60 * ours);
	Label__DaoJiShi:setText(minuteString..":"..soundsString)
	--最后三秒进行时间同步
	if(ours == 0 and minute == 0 and sounds > 0 and sounds < 3) then
		--请求财神时间同步
		sendFORTUNE_TIME_SYNC()
	end
	if(ours == 0 and minute == 0 and sounds == 0) then
		setButtonTouchEnabled(true)
	end
end

--[[--
--设置领取按钮是否可以点击
--]]
function setButtonTouchEnabled(flag)
	if flag == true then
		Button_lingqu:loadTextures(Common.getResourcePath("btn_green.png"),Common.getResourcePath("btn_green.png"),"")
		Button_lingqu:setTouchEnabled(true)
		Image_LingQu:setVisible(true)
		Label__DaoJiShi:setVisible(false)
		Label__DaoJiShi:stopAllActions();
	else
		Button_lingqu:loadTextures(Common.getResourcePath("btn_gerenziliao0_no.png"),Common.getResourcePath("btn_gerenziliao0_no.png"),"")
		Label__DaoJiShi:setVisible(true)
		Image_LingQu:setVisible(false)
		Button_lingqu:setTouchEnabled(false)
	end
end

function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_CAISHEN)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
		--LordGamePub.comeFromIconPosition(view,iconPosition,actionOver,true)
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_Button_ShangXiang(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--上香
		if(tonumber(CaiShenInformationTable.SacrificeValue) > 0)then
			sendFORTUNE_OFFER_SACRIFICE()
		else
			mvcEngine.createModule(GUI_CAISHENCHONGZHI)
		end

	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_Button_GuiZe(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_CAISHENGUIZE)

	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_Button_lingqu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		HongDianLogic.removeshowHall_more_Verson(13)
		Common.log("HongDianLogic.removeshowHall_more_VersonCaishen")
		if(not isFirst and FORTUNE_TIME_SYNCInfoTable["IsOpenFortune"] ~= 1)then
			mvcEngine.createModule(GUI_CAISHENCHONGZHI)
		else
			Button_lingqu:setTouchEnabled(false)
			isTouch = true;
			getGift()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function getFORTUNE_GET_INFORMATIONInfo()
	Common.closeProgressDialog();
	CaiShenInformationTable = profile.CaiShen.getFORTUNE_GET_INFORMATIONTable();
	caishenTimeSynchronization();
end

function getFORTUNE_TIME_SYNCInfo()
	Common.closeProgressDialog()
	local dataTable = profile.CaiShen.getFORTUNE_TIME_SYNCTable()
	FORTUNE_TIME_SYNCInfoTable = dataTable
	if(dataTable["IsOpenFortune"] == 1)then
		caishenDaojishi = dataTable["AwardTime"]
		if(caishenDaojishi > 0)then
			setButtonTouchEnabled(false)
		else
			setButtonTouchEnabled(true)
		end
	end
end

function getFORTUNE_GET_AWARDInfo()
	local dataTable = profile.CaiShen.getFORTUNE_GET_AWARDTable()
	if(dataTable["IsSuccess"] == 1)then
		--财神领奖成功
		for i = 1,#dataTable["ArrayList"] do
			ImageToast.createView(dataTable["ArrayList"][i].url,nil,dataTable["ArrayList"][i].mes,"您已领取奖励！",2)
		end
		if LabelAtlas_DaoJiShi ~= nil then
			LabelAtlas_DaoJiShi:stopAllActions();
		end
		setButtonTouchEnabled(false)
		if(isFirst)then
			isFirst = false
			caishenDaojishi = 3*60*1000
		end
	end

	isTouch = false;

	sendFORTUNE_TIME_SYNC();
	sendFORTUNE_GET_INFORMATION();
end

function getFORTUNE_OFFER_SACRIFICEInfo()
	local dataTable = profile.CaiShen.getFORTUNE_OFFER_SACRIFICETable()
	if(dataTable["IsSuccess"] == 1)then
		CaiShenInformationTable.SacrificeValue = dataTable.SacrificeValue;
		Label_CaiYunZhi:setText(dataTable.FortuneValue)
		if tonumber(dataTable.SacrificeValue) > 0 then
			--白色
			Label_CaiShenXiang:setColor(ccc3(249, 235, 219))
		else
			--红色
			Label_CaiShenXiang:setColor(ccc3(228, 78, 63))
		end
		Label_CaiShenXiang:setText(dataTable.SacrificeValue)
		Label_JinBi2:setText(dataTable["ArrayList"][1].num)
		Label_JinBi1:setText(dataTable["ArrayList"][1].num)
		Label_SuiPian1:setText(dataTable["ArrayList"][2].num)
		Label_SuiPian2:setText(dataTable["ArrayList"][2].num)
		local string = string.gsub(string.gsub(string.gsub(dataTable["Notice"],"<br>","\n"),"\n\n","\n"),"\n\n","\n")
		ImageToast.createView(nil,Common.getResourcePath("ic_shop_caiyunshenxiang.png"),"+1",string,2)
	end
end

function getFORTUNE_RELEASE_NOTIFICATIONInfo()
	local dataTable = profile.CaiShen.getFORTUNE_RELEASE_NOTIFICATIONTable()
	CaiShenOkLogic.TitleString = string.gsub(string.gsub(string.gsub(dataTable["Title"],"<br>","\n"),"\n\n","\n"),"\n\n","\n")
	CaiShenOkLogic.NotificationString = string.gsub(dataTable["Notification"],"<br>","\n")
	mvcEngine.createModule(GUI_CAISHENOK)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(FORTUNE_GET_INFORMATION, getFORTUNE_GET_INFORMATIONInfo)
	framework.addSlot2Signal(FORTUNE_TIME_SYNC,getFORTUNE_TIME_SYNCInfo)
	framework.addSlot2Signal(FORTUNE_GET_AWARD,getFORTUNE_GET_AWARDInfo)
	framework.addSlot2Signal(FORTUNE_OFFER_SACRIFICE,getFORTUNE_OFFER_SACRIFICEInfo)
	framework.addSlot2Signal(FORTUNE_RELEASE_NOTIFICATION,getFORTUNE_RELEASE_NOTIFICATIONInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(FORTUNE_GET_INFORMATION, getFORTUNE_GET_INFORMATIONInfo)
	framework.removeSlotFromSignal(FORTUNE_TIME_SYNC,getFORTUNE_TIME_SYNCInfo)
	framework.removeSlotFromSignal(FORTUNE_GET_AWARD,getFORTUNE_GET_AWARDInfo)
	framework.removeSlotFromSignal(FORTUNE_OFFER_SACRIFICE,getFORTUNE_OFFER_SACRIFICEInfo)
	framework.removeSlotFromSignal(FORTUNE_RELEASE_NOTIFICATION,getFORTUNE_RELEASE_NOTIFICATIONInfo)
end
