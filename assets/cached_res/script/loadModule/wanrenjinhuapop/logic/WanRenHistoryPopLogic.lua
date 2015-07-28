module("WanRenHistoryPopLogic",package.seeall)

view = nil
wanren_history_image = {};--历史imageView
WanRenJinHuaHistoryDataTable = {};--历史数据
wanren_history_bg_image = nil;--历史背景ImageView


--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_WANRENJINHUA_HISTORY);
end

function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.closeDialogAmin(wanren_history_bg_image,closeTheBox);
	elseif event == "menuClicked" then
	end
end

local wanren_history_table = {"wanren_history_tong_", "wanren_history_qu_", "wanren_history_you_", "wanren_history_xi_"}

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/WanRenJinHua/WanRenHistoryPop.json")
	local gui = GUI_WANRENJINHUA_HISTORY
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

	WanRenJinHuaHistoryDataTable = profile.WanRenJinHua.getWanRenJinHuaHistoryDataTable()

	wanren_history_bg_image = cocostudio.getUIImageView(view, "wanren_history_bg_image");

	if WanRenJinHuaHistoryDataTable["historyIndex"] then
		for i = 1, #WanRenJinHuaHistoryDataTable["historyIndex"] do
			if WanRenJinHuaHistoryDataTable["historyIndex"][i]["historyRound"] then
				for j = 1, #WanRenJinHuaHistoryDataTable["historyIndex"][i]["historyRound"] do
					wanren_history_image = cocostudio.getUIImageView(view, wanren_history_table[i]..j)
					if WanRenJinHuaHistoryDataTable["historyIndex"][i]["historyRound"][j].result == 1 then
						wanren_history_image:loadTexture(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_lishi_sheng.png"))
					else
						wanren_history_image:loadTexture(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_lishi_fu.png"))
					end
				end
			end
		end
	end

end

function requestMsg()
end

function callback_wanren_history_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(wanren_history_bg_image,closeTheBox);
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
