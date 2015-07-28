module("CertificateLogic",package.seeall)

view = nil
iv_Certificate = nil --获奖的panel
Panel_22 = nil --未获奖的panel
lblResultText = nil --获奖文字描述
lblSelectionResultText = nil --淘汰文字描述
--imgTitle = nil
--imageViewBisaijieguo = nil
--lblDate = nil
--imgCongratulations = nil
--imgCongratulationsTitle = nil
imgAwardBg = nil
lblRewardsContent1 = nil
lblRewardsContent2 = nil
lblRewardsContent3 = nil
imgReward1 = nil
imgReward2 = nil
imgReward3 = nil
imgRewardsSignature = nil
Button_award = nil
Button_again = nil;--

local MatchID = 0;
local MatchTitle = nil;

local result = {};

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
	view = cocostudio.createView("Certificate.json")
	local gui = GUI_TABLE_CERTIFICATEVIEW
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

	iv_Certificate = cocostudio.getUIImageView(view, "iv_Certificate")
	Panel_22 = cocostudio.getUIImageView(view, "Panel_22")

	Button_award = cocostudio.getUIButton(view, "Button_award")
	Button_again = cocostudio.getUIButton(view, "Button_again");

	lblResultText = cocostudio.getUILabel(view, "Label_11_0")
	lblSelectionResultText = cocostudio.getUILabel(view, "Label_29")
	--imgTitle = cocostudio.getUIImageView(view, "ImageView_26")
	--imageViewBisaijieguo = cocostudio.getUIImageView(view, "Image_bisaijieguo")
	--lblDate = cocostudio.getUILabel(view, "Label_11_1")
	--imgCongratulations = cocostudio.getUIImageView(view, "Image_12")
	--imgCongratulationsTitle = cocostudio.getUIImageView(view, "Image_12_0")
	lblRewardsContent1 = cocostudio.getUILabel(view, "Label_11_1_2")
	lblRewardsContent2 = cocostudio.getUILabel(view, "Label_11")
	lblRewardsContent3 = cocostudio.getUILabel(view, "Label_11_2_0")
	lblRewardsContent1:setVisible(false)
	lblRewardsContent2:setVisible(false)
	lblRewardsContent3:setVisible(false)

	imgReward1 = cocostudio.getUIImageView(view, "Image_20_0")
	imgReward2 = cocostudio.getUIImageView(view, "Image_20_1")
	imgReward3 = cocostudio.getUIImageView(view, "Image_20_2")
	imgReward1:setVisible(false)
	imgReward2:setVisible(false)
	imgReward3:setVisible(false)

	imgRewardsSignature = cocostudio.getUIImageView(view, "ImageView_28")
	imgAwardBg = cocostudio.getUIImageView(view, "ImageView_33")

	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		TableLogic.setOtherUserScore(false)
	end

	HallLogic.setHaveCertificate(true)
end

--[[--
--更新奖状内容
--
function updataCertificate(data)
result = data;
--	result.m_nRank = m_nRank;
--	result.m_sDate = date;
--	result.m_sResultCode = sResultCode;
--	result.mnHaveValuablyAward = nHaveValuablyAward;--是否有实物奖励 0无1有
local code = result.m_sResultCode
local x = Panel_webview:getPosition().x
local y = Panel_webview:getPosition().y
local w = Panel_webview:getSize().width
local h = Panel_webview:getSize().height

Common.showWebView("", code, x, y, w, h)
end
]]

local function updataimgReward1Image(path)
	Common.log("updataAwardsImage")
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
	if photoPath ~= nil and photoPath ~= ""then
		Common.log("photoPath = "..photoPath)
		Common.log("id = "..id)
		imgReward1:loadTexture(photoPath)
	end
end

local function updataimgReward2Image(path)
	Common.log("updataAwardsImage")
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
	if photoPath ~= nil and photoPath ~= ""then
		Common.log("photoPath = "..photoPath)
		Common.log("id = "..id)
		imgReward2:loadTexture(photoPath)
	end
end

local function updataimgReward3Image(path)
	Common.log("updataAwardsImage")
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
	if photoPath ~= nil and photoPath ~= ""then
		Common.log("photoPath = "..photoPath)
		Common.log("id = "..id)
		imgReward3:loadTexture(photoPath)
	end
end

--[[--
--3.03更新奖状内容
--]]
function updataCertificate_V4(data)
	result = data;
	MatchID = result.matchID
	MatchTitle = result.matchTitle
	imgAwardBg:loadTexture(Common.getResourcePath("ui_match_2level_btn_lingjiang.png"))
	-- 奖状类型
	if result.CertificateType == 0 or result.CertificateType == 1 then
		--imageViewBisaijieguo:setVisible(false)
		--imgTitle:setVisible(true)
		Panel_22:setVisible(false)
		iv_Certificate:setVisible(true)

		lblResultText:setText(result.ResultText)
		-- 奖品集合
		for i = 1, #result.Awards do
			if i == 1 then
				lblRewardsContent1:setVisible(true)
				lblRewardsContent1:setText(result["Awards"][i].AwardsContent)

				imgReward1:setVisible(true)
				Common.log("AwardsPic 1:"..result["Awards"][i].AwardsPic)
				Common.getPicFile(result["Awards"][i].AwardsPic, i, true, updataimgReward1Image)
			elseif i == 2 then
				lblRewardsContent2:setVisible(true)
				lblRewardsContent2:setText(result["Awards"][i].AwardsContent)

				imgReward2:setVisible(true)
				Common.log("AwardsPic 2:"..result["Awards"][i].AwardsPic)
				Common.getPicFile(result["Awards"][i].AwardsPic, i, true, updataimgReward2Image)
			elseif i == 3 then
				lblRewardsContent3:setVisible(true)
				lblRewardsContent3:setText(result["Awards"][i].AwardsContent)

				imgReward3:setVisible(true)
				Common.log("AwardsPic 3:"..result["Awards"][i].AwardsPic)
				Common.getPicFile(result["Awards"][i].AwardsPic, i, true, updataimgReward3Image)
			end
		end
	elseif result.CertificateType == 2 then
		-- 没有好名次也没有奖品
		--imageViewBisaijieguo:setVisible(true)
		--imgTitle:setVisible(false)

		--imgCongratulations:setVisible(false)
		--imgCongratulationsTitle:setVisible(false)
		Panel_22:setVisible(true)
		iv_Certificate:setVisible(false)

		lblSelectionResultText:setText(result.ResultText)
	end
end

function requestMsg()

end

--[[--
--回调关闭
--]]
local function close_CallBack()
	mvcEngine.destroyModule(GUI_TABLE_CERTIFICATEVIEW)

	if result.PhysicalCnt == 1 then
		--有实物奖
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_EXCHANGE)
		-- 跳转到我的奖品TAB
		ExchangeLogic.setTableState(3)
		ExchangeLogic.initMyPriceListView()
	end
	Common.log("close_CallBack------------------")
	CommShareConfig.showMatchSharePanel(result)

	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		TableLogic.exitLordTable()
	end
end

function callback_Button_award(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		TableConsole.bMatchIsOvered = false
		close_CallBack()
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_again(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
--		Common.showToast("再来一次",3)
		MatchDetailLogic.setNowEntrance(1)
		Common.log("iiiiiiiiiiiiiiiii传递2  .. matchId = " .. MatchID  .. "    title = " .. MatchTitle)
		MatchDetailLogic.setFormCertificate(MatchID,MatchTitle)
		mvcEngine.createModule(GUI_MATCHDETAIL)
	elseif component == CANCEL_UP then
	--取消

	end
end

--function setMatchIDAndTitle(matchId,title)
--	Common.log("iiiiiiiiiiiiiiiii传递1  .. matchId = " .. matchId  .. "    title = " .. title)
--	MatchID = matchId
--	MatchTitle = title
--end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
	Common.hideWebView()
end
