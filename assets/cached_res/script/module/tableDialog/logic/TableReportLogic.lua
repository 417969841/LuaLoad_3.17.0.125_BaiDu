module("TableReportLogic",package.seeall)

view = nil;

Panel_TableReport = nil;--
Panel_23 = nil;--
CheckBox_ReportCheat = nil;--
CheckBox_ReportChat = nil;--
CheckBox_ReportHead = nil;--
btn_ok = nil;--
btn_cancel = nil;--
local reportTable = nil

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		mvcEngine.destroyModule(GUI_TABLE_REPORT)
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function closeCallBack()
	mvcEngine.destroyModule(GUI_TABLE_REPORT)
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_TableReport = cocostudio.getUIPanel(view, "Panel_TableReport");
	Panel_23 = cocostudio.getUIPanel(view, "Panel_23");
	CheckBox_ReportCheat = cocostudio.getUICheckBox(view, "CheckBox_ReportCheat");
	CheckBox_ReportChat = cocostudio.getUICheckBox(view, "CheckBox_ReportChat");
	CheckBox_ReportHead = cocostudio.getUICheckBox(view, "CheckBox_ReportHead");
	btn_ok = cocostudio.getUIButton(view, "btn_ok");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TableReport.json")
	local gui = GUI_TABLE_REPORT
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
	initView();
end

function requestMsg()

end

function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local reportText = ""
		if CheckBox_ReportCheat:getSelectedState() == true then
			reportText = reportText .. "玩家作弊；"
		end
		if CheckBox_ReportChat:getSelectedState() == true then
			reportText = reportText .. "聊天内容；"
		end
		if CheckBox_ReportHead:getSelectedState() == true then
			reportText = reportText .. "色情头像；"
		end
		if reportText == nil or reportText == "" then
			--未勾选举报原因
			Common.showToast("请勾选举报原因！", 2)
		else
			--已勾选举报原因
			reportTable["reportReason"] = reportText
			sendMANAGERID_PLAYER_REPORT(reportTable)
			LordGamePub.closeDialogAmin(Panel_23, closeCallBack)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(Panel_23, closeCallBack)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_TableReport(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(Panel_23, closeCallBack)
	elseif component == CANCEL_UP then
	--取消

	end
end

function initReportInfo(dataTable)
	reportTable = dataTable
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	reportTable = {}
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
