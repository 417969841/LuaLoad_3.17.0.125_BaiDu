module("TableNotEndedLogic",package.seeall)

view = nil

isShowView = false;
Panel_TableNotEnded = nil
--Label_number = nil
Label_tips = nil
Label_Title = nil
--Button_ranking = nil
Button_details = nil
showMsgIndex = -1;--提示信息显示到第几条
stringTips = "" -- 提示文字
--数据
MatchTips = {}

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
	view = cocostudio.createView("TableNotEnded.json")
	local gui = GUI_TABLE_NOT_ENDED
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

	isShowView = true

	Panel_TableNotEnded = cocostudio.getUIPanel(view, "Panel_TableNotEnded")

	LordGamePub.showDialogAmin(Panel_TableNotEnded)

	Button_details = cocostudio.getUIButton(view, "Button_details")
--	Button_ranking = cocostudio.getUIButton(view, "Button_ranking")
	--Label_number = cocostudio.getUILabel(view, "Label_number")
	--Label_number = cocostudio.getUILabel(view, "Label_number")
	--Label_number:setVisible(false)
	Label_Title = cocostudio.getUILabel(view, "Label_30") -- tile
	Label_Title:setText("正在匹配对手，请耐心等待。。。")
	Label_tips = cocostudio.getUILabel(view, "Label_tips")

	showMsgIndex = -1

	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		TableLogic.setOtherUserScore(false)
	end
end

--[[--
--更新剩余比赛数量
--]]
function updataNotEndedCnt()
--Label_number:setText("还有".. TableConsole.m_nNotEndedCnt .."桌正在进行比赛，请耐心等待…")
end

--[[--
--是否显示
--]]
function isShow()
	return isShowView;
end

function requestMsg()

end
--[[--
--隐藏回调
--]]
local function exit_CallBack()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		TableLogic.setOtherUserScore(true)
	end
	mvcEngine.destroyModule(GUI_TABLE_NOT_ENDED)
end

--[[--
--关闭当前界面
--]]
function CloseView()
	exit_CallBack()
end

function callback_Button_ranking(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
--		mvcEngine.createModule(GUI_MATCH_RANKING)
--		到时候可能会出现问题
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_details(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		MatchDetailLogic.setNowEntrance(2)
		mvcEngine.createModule(GUI_MATCHDETAIL);
		MatchDetailLogic.setMatchID(TableConsole.m_nMatchID);
	elseif component == CANCEL_UP then
	--取消
	end
end

local function headLabelTTFCallBack(msgss)
	Label_tips:setText(msgss)
	Label_tips:setPosition(ccp(323, 25))
	Label_tips:stopAllActions()
	local moveto =  CCMoveBy:create(5,ccp(0, 110))
	local headActioArray = CCArray:create()
	headActioArray:addObject(moveto)
	headActioArray:addObject(CCCallFuncN:create(tipsMoveActionDone))
	Label_tips:runAction(CCRepeatForever:create(CCSequence:create(headActioArray)))
end

function update()
	if stringTips ~= nil then
		if showMsgIndex == -1 then
			-- 第一次的时候才发送该消息
			Common.log("first sendMATID_V4_TIPS")
			sendMATID_V4_TIPS(showMsgIndex)
		end
		Label_Title:setText(stringTips)
	end
end

function updateTips(nTipsIndex, strTips)
	Common.log("updateTips")

	showMsgIndex = nTipsIndex
	headLabelTTFCallBack(strTips)
end

function tipsMoveActionDone()
	sendMATID_V4_TIPS(showMsgIndex)
end

--[[
function update()
if not (MatchTips["AddMsg"] ~= nil and #MatchTips["AddMsg"] > 0) then
MatchTips = profile.TableTips.getDBID_V2_WATING_TIPS()
end
--开始滚动
if MatchTips["AddMsg"] ~= nil and #MatchTips["AddMsg"] > 0 then
showMsgIndex = math.random(1, #MatchTips["AddMsg"]);
local msg = MatchTips["AddMsg"][showMsgIndex].Title.."\n"..MatchTips["AddMsg"][showMsgIndex].Tip
if(msg ~= nil) then
headLabelTTFCallBack(msg)
end
end
end
]]

--[[--
--释放界面的私有数据
--]]
function releaseData()
	isShowView = false;
end

function addSlot()
--framework.addSlot2Signal(DBID_V2_WATING_TIPS, update)
end

function removeSlot()
--framework.removeSlotFromSignal(DBID_V2_WATING_TIPS, update)
end
