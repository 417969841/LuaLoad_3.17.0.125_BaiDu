module("TableExitLogic", package.seeall)

view = nil

Panel_table_exit = nil
ImageView_bg = nil
labelExit = nil
Button_exit = nil
Button_back = nil
local TableExitType = {};
TableExitType.LORD_TABLE = 1;--斗地主牌桌
TableExitType.WANRENJINHUA_QUIT = 2;--万人金花退出
exitType = 0;

--[[-
--获取TableExitType
--]]
function getTableExitType()
	return TableExitType;
end

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
	view = cocostudio.createView("TableExit.json")
	local gui = GUI_TABLE_EXIT
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
	Panel_table_exit = cocostudio.getUIPanel(view, "Panel_table_exit")
	ImageView_bg = cocostudio.getUIImageView(view, "ImageView_bg")

	LordGamePub.showDialogAmin(ImageView_bg, true, nil)

	Button_exit = cocostudio.getUIButton(view, "Button_exit")
	Button_back = cocostudio.getUIButton(view, "Button_back")
	labelExit = cocostudio.getUILabel(view, "labelExit")

end

--[[--
--设置退出提示文字
--@param #number type 类型
--]]
function setExitText(type)
	local data = ""
	exitType = type;
	if exitType == TableExitType.WANRENJINHUA_QUIT then
		data = "退出后，暂时扣除您下注金币的10倍，本局结束后按结果输赢返还，确定退出吗？"
	elseif exitType == TableExitType.LORD_TABLE then
		if TableConsole.mode == TableConsole.MATCH then
			data = "强行退出比赛将会扣除您大量金币！建议您耐心打完比赛"
		elseif TableConsole.mode == TableConsole.ROOM then
			if (TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_TABLE or
				TableConsole.m_nGameStatus == TableConsole.STAT_GAME_RESULT or
				TableConsole.m_nGameStatus == TableConsole.STAT_WAITING_READY) then
				if (TableConsole.m_bSendContinue) then
					data = "游戏中强退会扣除您大量金币！不如攒攒牌品，等这局结束再退出吧。";
				else
					data = "您确定要退出么？";
				end
			else
				data = "游戏中强退会扣除您大量金币！不如攒攒牌品，等这局结束再退出吧。";
			end
		end
	end

	labelExit:setText(data)
end

function requestMsg()
end

--[[--
--退出牌桌
--]]
local function exit_CallBack()
	if exitType == TableExitType.WANRENJINHUA_QUIT then
		mvcEngine.destroyModule(GUI_TABLE_EXIT);
		WanRenJinHuaLogic.quitTable();
	elseif exitType == TableExitType.LORD_TABLE then
		mvcEngine.destroyModule(GUI_TABLE_EXIT)
		TableLogic.exitLordTable()

		-- 记录退出牌桌的比赛实例
		TableConsole.pLastForceQuitMatchInstance = TableConsole.m_sMatchInstanceID
	end
end

--[[--
--返回牌桌
--]]
local function back_CallBack()
	mvcEngine.destroyModule(GUI_TABLE_EXIT)
end

function callback_Button_exit(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(ImageView_bg, exit_CallBack)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(ImageView_bg, back_CallBack)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
end
