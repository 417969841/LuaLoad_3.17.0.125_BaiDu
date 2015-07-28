module("PaiHangBangLogic",package.seeall)

view = nil
Panel_20 = nil;--
meirizhuanjinbang = nil--赚金榜
ImageView_zhuanjin = nil
meirichongzhibang = nil--充值榜
ImageView_chongzhi = nil
tuhaobang = nil--土豪榜
ImageView_tuhao = nil
InfoLabel = nil
paihangbangTabel = nil --接收排行榜消息
currentLayer = 0  --当前层  1:每日赚金榜   2：今日充值榜排行   3：土豪榜  4：昨日充值排行榜
Meirizhuanjinlayer = nil
MeirichongzhiLayer = nil
PaiHangLayer = nil
buttonNUM = 1
btnGanTanHao_zhuanjin = nil --赚金红点
btnGanTanHao_chongzhi = nil --充值红点
btnGanTanHao_tuhao = nil --土豪红点
local TANHAO_X = 40;--按钮的X
local TANHAO_Y = 20;--按钮的Y
BackButton = nil;

Panel_chongzhongmianban = nil;--
Image_geren_chongzhi = nil;--
label_geren_chongzhi = nil;--
Image_jinri = nil;--
Image_zuori = nil;--
Button_jinri = nil;--
Button_zuori = nil;--
ScrollView_PaiHangBang = nil;--
Panel_geren = nil;--
Image_geren = nil;--
label_geren = nil;--
Label_coin = nil;--
Button_addCoin = nil;--
Label_yuanbao = nil;--
Button_addYuanbao = nil;--
ImageView_gonggao = nil;--
Image_dadiban = nil;--
Button_Help = nil;--
Prompt_Label = nil;--
ScrollView_Prompt = nil;--

panelTemp = nil
paiHangBangHongDian = nil
isWhichDay = 0  -- 1:今日 2：昨日


function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_PAIHANGBANG;
	if GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--适配方案 1136x640
		view = cocostudio.createView("PaiHangBang.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("PaiHangBang.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 960x640
		view = cocostudio.createView("PaiHangBang_960_640.json");
		GameConfig.setCurrentScreenResolution(view, gui, 960, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())

	GameConfig.setTheCurrentBaseLayer(GUI_PAIHANGBANG)
	GameStartConfig.addChildForScene(view)
	initPaiHangBangView()

	local function delaySentMessage()
		showScrollViewInfoByHongDianOrder()
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
	Panel_chongzhongmianban:setVisible(false)
	initData()
	--获取排行榜红点
	getRankHongDianTable()
	showHongDian()
	sendCOMMONS_GET_RECHARGE_ENCOURAGE_MSG()
end

function initPaiHangBangView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	meirizhuanjinbang = cocostudio.getUIImageView(view, "meirizhuanjinbang")
	meirizhuanjinbang:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	meirichongzhibang = cocostudio.getUIImageView(view, "meirichongzhibang")
	tuhaobang = cocostudio.getUIImageView(view, "tuhaobang")
	ImageView_zhuanjin = cocostudio.getUIImageView(view, "ImageView_zhuanjin")
	ImageView_chongzhi = cocostudio.getUIImageView(view, "ImageView_chongzhi")
	ImageView_tuhao = cocostudio.getUIImageView(view, "ImageView_tuhao")
	ImageView_zhuanjin:loadTexture(Common.getResourcePath("ui_paihangbang_btn_meirizuanjin2.png"))
	ImageView_chongzhi:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge.png"))
	ImageView_tuhao:loadTexture(Common.getResourcePath("ui_paihangbang_btn_tuhao.png"))
	InfoLabel = cocostudio.getUILabel(view, "Label_159")
	BackButton = cocostudio.getUIButton(view, "BackButton")

	Panel_chongzhongmianban = cocostudio.getUIPanel(view, "Panel_chongzhongmianban");
	Image_geren_chongzhi = cocostudio.getUIImageView(view, "Image_geren_chongzhi");
	label_geren_chongzhi = cocostudio.getUILabel(view, "label_geren_chongzhi");
	Image_jinri = cocostudio.getUIImageView(view, "Image_jinri");
	Image_zuori = cocostudio.getUIImageView(view, "Image_zuori");
	Button_jinri = cocostudio.getUIButton(view, "Button_jinri");
	Button_zuori = cocostudio.getUIButton(view, "Button_zuori");
	ScrollView_PaiHangBang = cocostudio.getUIScrollView(view, "ScrollView_PaiHangBang");
	Panel_geren = cocostudio.getUIPanel(view, "Panel_geren");
	Image_geren = cocostudio.getUIImageView(view, "Image_geren");
	label_geren = cocostudio.getUILabel(view, "label_geren");
	Label_coin = cocostudio.getUILabel(view, "Label_coin");
	Button_addCoin = cocostudio.getUIButton(view, "Button_addCoin");
	Label_yuanbao = cocostudio.getUILabel(view, "Label_yuanbao");
	Button_addYuanbao = cocostudio.getUIButton(view, "Button_addYuanbao");
	ImageView_gonggao = cocostudio.getUIImageView(view, "ImageView_gonggao");
	Image_dadiban = cocostudio.getUIImageView(view, "Image_dadiban");
	Prompt_Label = cocostudio.getUILabel(view, "Prompt_Label");
	ScrollView_Prompt = cocostudio.getUIScrollView(view, "ScrollView_Prompt");
	Prompt_Label:setColor(ccc3(228, 78, 63))

	paihangbangTabel = {}
	createGanTanHao()
end


function initData()
	Label_coin:setText(""..profile.User.getSelfCoin())
	Label_yuanbao:setText(""..profile.User.getSelfYuanBao())
end
function requestMsg()

end



function callback_Button_addCoin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_addYuanbao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		GameConfig.setTheLastBaseLayer(GUI_PAIHANGBANG)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消

	end
end


function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_meirizhuanjinbang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(buttonNUM ~= 1) then
			Common.showProgressDialog("数据加载中...")
			buttonNUM = 1
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.0001))
			array:addObject(CCCallFunc:create(changeButton))
			view:runAction(CCSequence:create(array))
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_meirichongzhibang(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(buttonNUM ~= 2) then
			Common.showProgressDialog("数据加载中...")
			buttonNUM = 2
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.0001))
			array:addObject(CCCallFunc:create(changeButton))
			view:runAction(CCSequence:create(array))
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tuhaobang(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(buttonNUM ~= 3) then
			Common.showProgressDialog("数据加载中...")
			buttonNUM = 3
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.0001))
			array:addObject(CCCallFunc:create(changeButton))
			view:runAction(CCSequence:create(array))
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_jinri(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if isWhichDay ~= 1 then
			--目前不是今日排行阶段
			Common.showProgressDialog("数据加载中...")
			isWhichDay = 1 --设置为今日排行
			currentLayer = 2  --设置当前为今日排行
			PaiHangLayer.replacePaiHang(paihangbangTabel.chongzhi,currentLayer)
			Common.log("zbl......加载本地今日榜")
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_zuori(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		if isWhichDay ~= 2 then
			--目前不是昨日排行阶段
			Common.showProgressDialog("数据加载中...")
			isWhichDay = 2  --设置为昨日排行
			if(paihangbangTabel.yesToday == nil)then
				local dataTable  = {}
				dataTable.startCount = 0
				dataTable["pageSize"] = 100
				dataTable["lastShowRanking"] = currentLayer
				dataTable["requestShowRanking"] = 4
				currentLayer = 4
				sendRankListGetRankDataBean(dataTable) --发送请求排行榜信息
				Common.log("zbl......加载下载昨日榜")
			else
				currentLayer = 4  --设置当前为昨日排行
				PaiHangLayer.replacePaiHang(paihangbangTabel.yesToday,currentLayer)
				Common.log("zbl......加载本地昨日榜")
			end
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_Help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		showRechargeRankHelp()
	elseif component == CANCEL_UP then
	--取消

	end
end

function InfoLabelScroll(Text)
	local movetoTime =  0.01
	InfoLabel:setAnchorPoint(ccp(0,0.5))
	local winSize = CCDirector:sharedDirector():getWinSize()
	InfoLabel:stopAllActions()
	InfoLabel:setText(Text)
	InfoLabel:setPosition(ccp(winSize.width,InfoLabel:getPosition().y))
	local moveto2 =  CCMoveTo:create(0.001,ccp(winSize.width,InfoLabel:getPosition().y))
	local moveto =  CCMoveBy:create(movetoTime*(InfoLabel:getContentSize().width +winSize.width),ccp(-InfoLabel:getContentSize().width - winSize.width,0))
	local headActioArray = CCArray:create()
	headActioArray:addObject(CCCallFuncN:create(function()
		ImageView_gonggao:setVisible(true)
	end
	))
	headActioArray:addObject(moveto)
	headActioArray:addObject(moveto2)
	headActioArray:addObject(CCCallFuncN:create(function()
		ImageView_gonggao:setVisible(false)
	end
	))
--	InfoLabel:runAction(CCRepeatForever:create(CCSequence:create(headActioArray)))
	InfoLabel:runAction(CCSequence:create(headActioArray))
end

--[[--
--改变按钮
--]]--
function changeButton()
	if(buttonNUM == 1)then
		btnGanTanHao_zhuanjin:setVisible(false)
		removeGanTanHao(1)
		meirizhuanjinbang:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		meirichongzhibang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		tuhaobang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		ImageView_zhuanjin:loadTexture(Common.getResourcePath("ui_paihangbang_btn_meirizuanjin2.png"))
		ImageView_chongzhi:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge.png"))
		ImageView_tuhao:loadTexture(Common.getResourcePath("ui_paihangbang_btn_tuhao.png"))
		currentLayer = 1
		if(paihangbangTabel.zhuanjin == nil)then
			local dataTable  = {}
			dataTable.startCount = 0
			dataTable["pageSize"] = 100
			dataTable["lastShowRanking"] = currentLayer
			dataTable["requestShowRanking"] = 1
			sendRankListGetRankDataBean(dataTable) --发送请求排行榜信息
--			Common.log("zbl...赚金榜请求消息")
		else
			PaiHangLayer.replacePaiHang(paihangbangTabel.zhuanjin,currentLayer)
			InfoLabelScroll(paihangbangTabel.zhuanjin.prizeGivingRule)
--			Common.log("zbl...赚金榜加载本地")
		end
	elseif(buttonNUM == 2)then
		firstEnterPaiHangBang()
		btnGanTanHao_chongzhi:setVisible(false)
		removeGanTanHao(2)
		currentLayer = 2
		meirizhuanjinbang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		meirichongzhibang:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		tuhaobang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		ImageView_zhuanjin:loadTexture(Common.getResourcePath("ui_paihangbang_btn_meirizuanjin.png"))
		ImageView_chongzhi:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge2.png"))
		ImageView_tuhao:loadTexture(Common.getResourcePath("ui_paihangbang_btn_tuhao.png"))
		if(paihangbangTabel.chongzhi == nil)then
			local dataTable  = {}
			dataTable.startCount = 0
			dataTable["pageSize"] = 100
			dataTable["lastShowRanking"] = currentLayer
			dataTable["requestShowRanking"] = 2
			sendRankListGetRankDataBean(dataTable) --发送请求排行榜信息
--			Common.log("zbl...充值榜请求消息")
		else
			PaiHangLayer.replacePaiHang(paihangbangTabel.chongzhi,currentLayer)
			InfoLabelScroll(paihangbangTabel.chongzhi.prizeGivingRule)
--			Common.log("zbl...充值榜加载本地")
		end

	elseif(buttonNUM == 3)then
		btnGanTanHao_tuhao:setVisible(false)
		removeGanTanHao(3)
		currentLayer = 3
		meirizhuanjinbang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		meirichongzhibang:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		tuhaobang:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		ImageView_zhuanjin:loadTexture(Common.getResourcePath("ui_paihangbang_btn_meirizuanjin.png"))
		ImageView_chongzhi:loadTexture(Common.getResourcePath("ui_paihangbang_btn_charge.png"))
		ImageView_tuhao:loadTexture(Common.getResourcePath("ui_paihangbang_btn_tuhao2.png"))
		if(paihangbangTabel.tuhao == nil)then
			local dataTable  = {}
			dataTable.startCount = 0
			dataTable["pageSize"] = 100
			dataTable["lastShowRanking"] = currentLayer
			dataTable["requestShowRanking"] = 3
			sendRankListGetRankDataBean(dataTable) --发送请求排行榜信息
--			Common.log("zbl...土豪榜请求消息")
		else
			PaiHangLayer.replacePaiHang(paihangbangTabel.tuhao,currentLayer)
			InfoLabelScroll(paihangbangTabel.tuhao.prizeGivingRule)
--			Common.log("zbl...土豪榜加载本地")
		end
	end
end

--[[--
--排行榜回调函数
--]]--
function paihangbangInfo()
	InfoLabelScroll(profile.PaiHangBang.getPaiHangBangInfo().prizeGivingRule)
	if(currentLayer == 1)then
		paihangbangTabel.zhuanjin = profile.PaiHangBang.getPaiHangBangInfo()
		PaiHangLayer.replacePaiHang(paihangbangTabel.zhuanjin,currentLayer)
	elseif(currentLayer == 2)then
		paihangbangTabel.chongzhi = profile.PaiHangBang.getPaiHangBangInfo()
		PaiHangLayer.replacePaiHang(paihangbangTabel.chongzhi,currentLayer)
	elseif(currentLayer == 3)then
		paihangbangTabel.tuhao = profile.PaiHangBang.getPaiHangBangInfo()
		PaiHangLayer.replacePaiHang(paihangbangTabel.tuhao,currentLayer)
	elseif(currentLayer == 4)then
		paihangbangTabel.yesToday = profile.PaiHangBang.getPaiHangBangInfo()
		PaiHangLayer.replacePaiHang(paihangbangTabel.yesToday,currentLayer)
	end
end

--[[--
--获取排行榜小红点
--]]
function getRankHongDianTable()
	local hongDianTable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	if hongDianTable[14] ~= nil and hongDianTable[14] ~= "" then
		paiHangBangHongDian = hongDianTable[14]["ID"]
	end
end

--[[--
--显示小红点
--]]
function showHongDian()
	getRankHongDianTable()
	if paiHangBangHongDian ~= nil and paiHangBangHongDian ~= "" then
		for i = 1, #paiHangBangHongDian do
			if tonumber(paiHangBangHongDian[i]) == 1 then
				btnGanTanHao_zhuanjin:setVisible(true)
			elseif tonumber(paiHangBangHongDian[i]) == 2 or tonumber(paiHangBangHongDian[1]) == 5 then
				btnGanTanHao_chongzhi:setVisible(true)
			elseif tonumber(paiHangBangHongDian[i]) == 3 then
				btnGanTanHao_tuhao:setVisible(true)
			end
		end
	end
end

--[[--
--创建小红点
--]]
function createGanTanHao()
--	btnGanTanHao_zhuanjin = nil --赚金红点
--	btnGanTanHao_chongzhi = nil --充值红点
--	btnGanTanHao_tuhao = nil --土豪红点
--	meirizhuanjinbang = nil--赚金榜
--	meirichongzhibang = nil--充值榜
--	tuhaobang = nil--土豪榜
	btnGanTanHao_zhuanjin = UIImageView:create();
	btnGanTanHao_zhuanjin:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	btnGanTanHao_zhuanjin:setPosition(ccp(TANHAO_X,TANHAO_Y));
	btnGanTanHao_zhuanjin:setVisible(false)
	meirizhuanjinbang:addChild(btnGanTanHao_zhuanjin)

	btnGanTanHao_chongzhi = UIImageView:create();
	btnGanTanHao_chongzhi:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	btnGanTanHao_chongzhi:setPosition(ccp(TANHAO_X,TANHAO_Y));
	btnGanTanHao_chongzhi:setVisible(false)
	meirichongzhibang:addChild(btnGanTanHao_chongzhi)

	btnGanTanHao_tuhao = UIImageView:create();
	btnGanTanHao_tuhao:loadTexture(Common.getResourcePath("gift_tan_hao.png"));
	btnGanTanHao_tuhao:setPosition(ccp(TANHAO_X,TANHAO_Y));
	btnGanTanHao_tuhao:setVisible(false)
	tuhaobang:addChild(btnGanTanHao_tuhao)
end

--[[--
--移除红点
--]]
function removeGanTanHao(num)
	getRankHongDianTable()
	if paiHangBangHongDian ~= nil and profile.HongDian.getProfile_HongDian_datatable() == 0 then
		if paiHangBangHongDian ~= "" and #paiHangBangHongDian >= 1 then
			paiHangBangHongDian[num] = nil
			sendMANAGERID_REMOVE_REDP(14, num)
			--2 和 5属于同一种类型的小红点
			if num == 2 then
				paiHangBangHongDian[5] = nil
				sendMANAGERID_REMOVE_REDP(14, 5)
			end
		end
	end
end

--[[--
--根据小红点顺序加载scrollview信息
--]]
function showScrollViewInfoByHongDianOrder()
	getRankHongDianTable()
	if profile.HongDian.getProfile_HongDian_datatable() == 0 then
		if paiHangBangHongDian ~= nil and paiHangBangHongDian ~= "" and #paiHangBangHongDian >= 1 then
			buttonNUM = tonumber(paiHangBangHongDian[1])
			-- 2 和 5 都是每日充值榜的小红点 5是排名掉落 2是充值榜普通信息
			if tonumber(paiHangBangHongDian[1]) == 5 then
				buttonNUM = 2
			end
		else
			buttonNUM = 1
		end
	else
		buttonNUM = 1
	end
	Common.showProgressDialog("数据加载中...")
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.0001))
	array:addObject(CCCallFunc:create(changeButton))
	view:runAction(CCSequence:create(array))
end

--[[--
--首次进入每日充值榜
--]]
function firstEnterPaiHangBang()
	getRankHongDianTable()
	--判断是否是首次进入充值榜
	local flag = Common.getDataForSqlite("FIRSTENTERPAIHANGBANG")
	if flag == nil or flag == "" or flag ~= true then
		Common.setDataForSqlite("FIRSTENTERPAIHANGBANG", true);
		RechargeRankCoverLogic.setShowType(1)
		ShadowLayer( 0, 0, 160, 160, 40)
		return
	end

	--判断是否是首次掉档
	flag = Common.getDataForSqlite("FIRSTPAIHANGBANGREDUCE")
	if flag == nil or flag == "" or flag ~= true then
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			if paiHangBangHongDian ~= nil and paiHangBangHongDian ~= "" and #paiHangBangHongDian >= 1 then
				if tonumber(paiHangBangHongDian[1]) == 5 then
					Common.setDataForSqlite("FIRSTPAIHANGBANGREDUCE", false);
					RechargeRankCoverLogic.setShowType(2)
					ShadowLayer( -100, -50, 1500, 250, 40)
				end
			end
		end
	end
end

--[[--
--@param #width number 宽度位置
--@param #height number 高度位置
--@param #SizeWidth number 设置显示宽度
--@param #SizeHeight number 设置显示高度
--@param #Hierarchy number 设置层级
--]]
function ShadowLayer(width,height,SizeWidth,SizeHeight,Hierarchy)
	panelTemp = ShadowForFullScreen.createShadowForFullScreenUIImageView(width,height,SizeWidth,SizeHeight);
	panelTemp:setTag(10000)
	Panel_20:addChild(panelTemp);
	panelTemp:setZOrder(Hierarchy);
	mvcEngine.createModule(GUI_RECHARGERANKCOVER)
end

--[[--
--移除遮罩层
--]]
function removeShadowLayer()
	Common.log("removeShadowLayer=================")
	Panel_20:removeChild(panelTemp)
end

--[[--
--显示帮助框
--]]
function showRechargeRankHelp()
	mvcEngine.createModule(GUI_CRAZY_RULE)
	local panelSize = CrazyRuleLogic.Panel_Web:getContentSize()
	CommDialogConfig.commonLoadWebView(GameConfig.URL_TABLE_PAIHANGBANG_HEIP, "URL_TABLE_PAIHANGBANG_HEIP", 261, 125, panelSize.width, panelSize.height)
end

--[[--
--显示充值榜鼓励充值信息
--]]
function showRechargeRankEncourageInfo()
	local encourageInfo = profile.PaiHangBangNotice.getPaiHangBangEncourageInfoTable()
	local messageContent = nil
	if encourageInfo ~= nil and encourageInfo ~= "" then
		if encourageInfo.Encourage == nil or encourageInfo.Encourage == "" then
			Prompt_Label:setText("")
			return
		end
		messageContent = encourageInfo.Encourage
		local textNum = Common.utfstrlen(messageContent); --获取消息内容的字数
		Prompt_Label:setText(messageContent)
		if textNum >= 30 then
			encourageInfoRollAction()
		end
	else
		Prompt_Label:setText("")
	end

	Common.log("messageContent=============="..messageContent)

end

--[[--
--鼓励信息滚动信息
--]]
function encourageInfoRollAction(time)
	local panelSize = ScrollView_Prompt:getContentSize()
	local labelSize = Prompt_Label:getContentSize()

	Common.log("encourageInfoRollAction==="..panelSize.width.."+"..labelSize.width)
	Prompt_Label:setPosition(ccp(panelSize.width + labelSize.width/2, panelSize.height/2))

	local array = CCArray:create()
	local moveTo = CCMoveBy:create(6, ccp(-(labelSize.width+panelSize.width), 0))
	array:addObject(moveTo)
	array:addObject(CCCallFunc:create(
		function ()
			Prompt_Label:setPosition(ccp(panelSize.width + labelSize.width/2, panelSize.height/2))
		end
	))
	local seq = CCSequence:create(array)
	Prompt_Label:runAction(CCRepeatForever:create(seq))
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
end

function addSlot()
	framework.addSlot2Signal(RankListGetRankDataBean, paihangbangInfo)
	framework.addSlot2Signal(COMMONS_GET_RECHARGE_ENCOURAGE_MSG, showRechargeRankEncourageInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(RankListGetRankDataBean, paihangbangInfo)
	framework.removeSlotFromSignal(COMMONS_GET_RECHARGE_ENCOURAGE_MSG, showRechargeRankEncourageInfo)
end
