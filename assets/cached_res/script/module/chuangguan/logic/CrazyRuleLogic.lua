module("CrazyRuleLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_Web = nil;--
panel = nil;--
--Label_Title = nil;--
btn_cancel = nil;--

local rule = "http://f.99sai.com/html/crazy_stage/CrazyStageHelp.html"; --闯关规则内容
local awardsInfo = nil; --昨日闯关奖励信息
local panelSize = nil; --
function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_Web = cocostudio.getUIPanel(view, "Panel_Web");
	panel = cocostudio.getUIPanel(view, "panel");
--	Label_Title = cocostudio.getUILabel(view, "Label_Title");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CrazyRule.json")
	local gui = GUI_CRAZY_RULE
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
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	Common.hideWebView()
	initView();
	panelSize = Panel_Web:getContentSize()
end

function setRule(ruleV)
	--	rule = ruleV
	--	Common.showWebView(rule,"",206,125,panelSize.width,panelSize.height)
	CommDialogConfig.commonLoadWebView(GameConfig.URL_TABLE_CRAZYSTAGE_HELP, "URL_TABLE_CRAZYSTAGE_HELP", 261, 125, panelSize.width, panelSize.height)
end

function setAwardsInfo(awardsInfoV)
	awardsInfo = awardsInfoV
--	Label_Title:setText("提  示")
	Common.showWebView("",awardsInfo,261,125,panelSize.width,panelSize.height)
end

function requestMsg()

end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_CRAZY_RULE)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.hideWebView()
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
