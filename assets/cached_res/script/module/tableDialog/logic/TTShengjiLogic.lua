module("TTShengjiLogic",package.seeall)

view = nil
panel = nil
btn_close = nil
btn_lq = nil--领取
img_ttjb = nil --天梯级别
lab_jbbl = nil --积分比例
lab_msg = nil--提示信息
lab_title = nil
panel_web = nil
ImageView_42 = nil
ImageView_36 = nil
img_ttjb_now = nil;--
LabelAtlas_tt_level_now = nil;--
iv_tt_type_now = nil;--
Label_Progress = nil

myTimer = nil--进度条
img_ttdj = nil--天梯类型图标
iv_tt_type = nil--天梯类型
LabelAtlas_tt_level = nil--天梯等级
preLadderScore = nil--前天梯积分
CurrentLadderScore = nil--当前天梯积分
selfLadderUpScore = nil--下一等级的天梯分(升级积分)
selfLadderDownScore = nil--当前段初始天梯分(降级积分)
selfLadderPreDownScore = nil--上一级初始天梯分(降级积分)
selfLadderPreUpScore = nil--上一级升级积分
scrollWidth = nil--进度条宽度
scrollHeight = nil--进度条高度

local progressLabel = nil
local flag = 0 --是否提示0：无法领奖，1：领奖
local ladderLevel = 0 --现在的天梯级别
local oldLadderLevel = 0 --之前的天梯级别
local ladderDuanwei = 1;--天梯段位
local SILVERLADDERGIFTID = 1023--白银天梯礼包消息类型
local GOLDLADDERGIFTID = 1024--黄金天梯礼包消息类型
local PLATINUMLADDERGIFTID = 1025--白金天梯礼包类型
local SILVERLADDERGIFT = 1--白银天梯礼包
local GOLDLADDERGIFT = 2--黄金天梯礼包
local PLATINUMLADDERGIFT = 3--白金天梯礼包


TTJieduanInfo = {}--天体阶段信息

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
	view = cocostudio.createView("TTShengji.json")
	local gui = GUI_TTSHENGJI
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
	btn_lq = cocostudio.getUIButton(view, "btn_lq")
	img_ttjb =  cocostudio.getUIImageView(view, "img_ttjb");
	lab_jbbl = cocostudio.getUILabel(view, "lab_jbbl")
	lab_msg = cocostudio.getUILabel(view, "lab_msg")
	lab_title = cocostudio.getUILabel(view, "lab_title")
	panel_web = cocostudio.getUIPanel(view, "panel_web")
	ImageView_42 = cocostudio.getUIImageView(view, "ImageView_42")
	ImageView_36 = cocostudio.getUIImageView(view, "ImageView_36")
	img_ttdj = cocostudio.getUIImageView(view, "img_ttdj")--天梯类型图标
	iv_tt_type = cocostudio.getUIImageView(view, "iv_tt_type")--天梯类型
	LabelAtlas_tt_level = cocostudio.getUILabelAtlas(view, "LabelAtlas_tt_level")--天梯等级
	img_ttjb_now = cocostudio.getUIImageView(view, "img_ttjb_now");
	LabelAtlas_tt_level_now = cocostudio.getUILabelAtlas(view, "LabelAtlas_tt_level_now");
	iv_tt_type_now = cocostudio.getUIImageView(view, "iv_tt_type_now");
	Label_Progress = cocostudio.getUILabel(view, "Label_Progress");
	--发送请求
	sendLADDERID2_LADDER_LEVEL_UP_NOTICE(ladderLevel, oldLadderLevel)
	img_ttjb:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(ladderDuanwei)))
	iv_tt_type:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiType(ladderDuanwei)));
	LabelAtlas_tt_level:setStringValue(""..oldLadderLevel)
	img_ttjb_now:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(ladderDuanwei)))
	iv_tt_type_now:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiType(ladderDuanwei)));
	LabelAtlas_tt_level_now:setStringValue(""..ladderLevel)
	ImageView_36:setVisible(false)
	lab_title:setVisible(false)
	creatTimer()
	initData()
end

function setFlag(flagV, ladderLevelV, Duanwei)
	flag = flagV
	ladderLevel = ladderLevelV
	oldLadderLevel = ladderLevel-1
	ladderDuanwei = Duanwei
end

function requestMsg()

end

--领取
function callback_btn_lq(component)
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

function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end

function closePanel()
	mvcEngine.destroyModule(GUI_TTSHENGJI)
end

function ttshengjiinfo()
	TTJieduanInfo = profile.TianTiData.getLADDERID2_LADDER_LEVEL_UP_NOTICE()
	local content = ""

	local index = -1;
	if TTJieduanInfo["tequan"] ~= nil and #TTJieduanInfo["tequan"] > 0 then
		for i = 1, #TTJieduanInfo["tequan"] do
			if (TTJieduanInfo["tequan"][i].ladderLevel >= ladderDuanwei *100 + oldLadderLevel) then
				index = i;
				break;
			end
			if(i == #TTJieduanInfo["tequan"])then
				index = #TTJieduanInfo["tequan"];
			end
		end
		if (index < 1) then
			index = 1;
		end
		content = TTJieduanInfo["tequan"][index].privilegeHtml
		local x = panel_web:getPosition().x
		local y = panel_web:getPosition().y
		local w = panel_web:getSize().width
		local h = panel_web:getSize().height
		Common.log("X = "..x)
		Common.log("Y = "..y)
		Common.log("width = "..w)
		Common.log("height = "..h..content)
		--设置文字
		local ttduan = string.sub(TTJieduanInfo["tequan"][index].ladderLevel, 1, 1)
		local ttji = string.sub(TTJieduanInfo["tequan"][index].ladderLevel, 3, 3)
		local text = profile.TianTiData.getDuanWeiName(tonumber(ttduan))
		Common.log("天梯等级"..ttduan)
		Common.log("天梯等级"..ttji)
		Common.log("天梯等级"..text)
		Common.showWebView("", content, (1136-600)/1.8, (640-150)/1.5, 600, 150)
		lab_title:setText("升级到【"..text..ttji.."级】您将获得以下特权");
		lab_title:setVisible(false);
	else
		lab_title:setText("您已获得所有天梯特权");
		lab_title:setVisible(true);
	end

	if TTJieduanInfo["jiangli"][1].sumCoinCnt == 0 then
		lab_jbbl:setText("奖励已领取")--sumCoinCnt
		btn_lq:loadTextures(Common.getResourcePath("btn_gerenziliao0_no.png"), Common.getResourcePath("btn_gerenziliao0_no.png"), "")
		btn_lq:setTouchEnabled(false)
		ImageView_42:loadTexture(Common.getResourcePath("yilingqu.png"))
		lab_msg:setVisible(false)
	else
		if flag == 1 then
			btn_lq:loadTextures(Common.getResourcePath("btn_gerenziliao0.png"), Common.getResourcePath("btn_gerenziliao0.png"), "")
			btn_lq:setTouchEnabled(true)
			ImageView_42:loadTexture(Common.getResourcePath("ui_room_2level_tianjiangdali_btn.png"))
		else
			btn_lq:loadTextures(Common.getResourcePath("btn_gerenziliao0_no.png"), Common.getResourcePath("btn_gerenziliao0_no.png"), "")
			btn_lq:setTouchEnabled(false)
			ImageView_42:loadTexture(Common.getResourcePath("yilingqu.png"))
		end
		lab_jbbl:setText(TTJieduanInfo["jiangli"][1].currentCoinCnt.."/"..TTJieduanInfo["jiangli"][1].sumCoinCnt)--sumCoinCnt
		lab_msg:setText(TTJieduanInfo["jiangli"][1].getCoinDes)
	end

	ImageView_36:setVisible(true)
end

function initData()
	--第一次进度条滚动时间
	local timeFirst = 1
	if preLadderScore ~= nil and selfLadderPreUpScore ~= nil and selfLadderPreDownScore ~= nil then
		--上一段位两级积分差
		local preUpScoreSubDownScore = selfLadderPreUpScore - selfLadderPreDownScore
		--上一级与上一级降级积分的积分差
		local preSubScore = preLadderScore - selfLadderPreDownScore
		--积分差在进度条中比例
		local pl = preSubScore / preUpScoreSubDownScore
		timeFirst = preSubScore / preUpScoreSubDownScore * 1
		Label_Progress:setText(preLadderScore.."/"..selfLadderPreUpScore)

	else
		Label_Progress:setText("0/0")
		Image_Progress:setPercent(100)
	end

	ladderUpScoreScrollAnimation(timeFirst)
end

function creatTimer()
	local posX = (1136-600)/1.4
	local psoY = (640-150)/1.9
	local timerTexture = CCTextureCache:sharedTextureCache():addImage(Common.getResourcePath("ui_gerenziliao_schedule_fg1.png"))
	local spriteTimer = CCSprite:createWithTexture(timerTexture)
	local bgTexture = CCTextureCache:sharedTextureCache():addImage(Common.getResourcePath("ui_gerenziliao_schedule_bg1.png"))
	local spriteBg = CCSprite:createWithTexture(bgTexture)
	if selfLadderPreUpScore ~= nil and preLadderScore ~= nil then
		progressLabel = CCLabelTTF:create(preLadderScore.."/"..selfLadderPreUpScore, "Arial", 25)
	else
		progressLabel = CCLabelTTF:create("100/100", "Arial", 25)
	end
	myTimer = CCProgressTimer:create(spriteTimer)
	myTimer:setType(kCCProgressTimerTypeBar)
	myTimer:setMidpoint(ccp(0,0));
	myTimer:setBarChangeRate(ccp(1, 0));
	myTimer:setPercentage(0)

	myTimer:setZOrder(2)
	progressLabel:setZOrder(3)
	myTimer:setPosition(posX, psoY)
	spriteBg:setPosition(posX, psoY)
	progressLabel:setPosition(posX*1.5, psoY-2)
	myTimer:setAnchorPoint(ccp(0, 0))
	spriteBg:setAnchorPoint(ccp(0, 0))
	progressLabel:setAnchorPoint(ccp(0.5, 0))
	view:addChild(myTimer)
	view:addChild(progressLabel)
	view:addChild(spriteBg)
end

--[[--
--天梯进度条动画
--]]
function ladderUpScoreScrollAnimation(timeFirst)
	--当前段位两级积分差
	local upScoreSubDownScore = selfLadderUpScore - selfLadderDownScore
	--当前与降级积分积分差
	local subScore = CurrentLadderScore - selfLadderDownScore
	--积分差在进度条中比例
	local pl = subScore / upScoreSubDownScore
	--第二次进度条滚动时间
	local timeSecond = subScore / upScoreSubDownScore * 1
	local delayFirst = CCDelayTime:create(timeFirst)
	local delaySecond = CCDelayTime:create(timeSecond)
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.6))
	array:addObject(CCCallFuncN:create(
		function()
			local pro = CCProgressTo:create(timeFirst, 100)
			myTimer:runAction(pro)
		end
	))
	array:addObject(delayFirst)
	array:addObject(CCCallFuncN:create(
		function()
			myTimer:setPercentage(0)
			local pro = CCProgressTo:create(timeSecond, pl * 100)
			myTimer:runAction(pro)
			progressLabel:setString(CurrentLadderScore.."/"..selfLadderUpScore)
		end
	))
	local seq = CCSequence:create(array)
	view:runAction(seq)
end

--[[--
--天梯晋升礼包
--]]
function ladderUpgradeGifts()
	local ladderDuan = profile.User.getSelfLadderDuan()
	if ladderDuan == SILVERLADDERGIFT then
		sendGIFTBAGID_REQUIRE_GIFTBAG(SILVERLADDERGIFTID, 0)
	elseif ladderDuan == GOLDLADDERGIFT then
		sendGIFTBAGID_REQUIRE_GIFTBAG(GOLDLADDERGIFTID, 0)
	elseif ladderDuan == PLATINUMLADDERGIFT then
		sendGIFTBAGID_REQUIRE_GIFTBAG(PLATINUMLADDERGIFTID, 0)
	end
	--暂无钻石礼包
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(LADDERID2_LADDER_LEVEL_UP_NOTICE,ttshengjiinfo)
end

function removeSlot()
	Common.hideWebView()
	framework.removeSlotFromSignal(LADDERID2_LADDER_LEVEL_UP_NOTICE,ttshengjiinfo)
end
