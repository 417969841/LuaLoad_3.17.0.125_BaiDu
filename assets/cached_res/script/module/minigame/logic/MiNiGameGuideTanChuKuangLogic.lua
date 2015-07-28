module("MiNiGameGuideTanChuKuangLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Image_suoming = nil;--
btn_close = nil;--
btn_queding = nil;--
Image_bg = nil;--
local ID_FRUIT_MACHINE = 102;--老虎机GameID
local ID_JIN_HUANG_GUAN = 103;--金皇冠GameID
local ID_WAN_REN_JIN_HUA = 104;--万人金花GameID
local ID_WAN_REN_FRUIT_MACHINE = 105;--万人水果派
local ID_JIN_HUA = 106;--扎金花
local picUrl = "http://f.99sai.com/hall/miniGame/AD.png"
local chatTable = nil --

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
	local gui = GUI_MINIGAMEGUIDETANCHUKUANG;
	view = cocostudio.createView("MiNiGameGuideTanChuKuang.json");
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Image_suoming = cocostudio.getUIImageView(view, "Image_suoming");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	btn_queding = cocostudio.getUIButton(view, "btn_queding");
	Image_bg = cocostudio.getUIImageView(view, "Image_bg");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();
	initData();
end

--[[--
--加载图片
--]]
local function getImage(path)
	local photoPath = nil
	local id = ""
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end

	if photoPath ~= nil and photoPath ~= "" and Image_bg ~= nil then
		Image_bg:loadTexture(photoPath);
		Image_bg:setVisible(true)
	end
end

function initData()
	--大厅弹出小游戏判断，如果chatTable为空则是大厅弹出小游戏引导
	if chatTable == nil then
		chatTable = profile.MiniGame.getMinigame_DuiJiang_TableV3()
	end

	Common.getPicFile(picUrl, 1, "", getImage)
end

--[[--
--设置初始化信息
--]]
function setChatTable(miniGameGuideInfoTable)
	chatTable = miniGameGuideInfoTable
end

function requestMsg()

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

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起

		if chatTable~= nil  then
			if  chatTable.actionId == 0 then
			--老虎机GameID
			elseif chatTable.actionId ==  ID_FRUIT_MACHINE then

				--水果机
				if GameLoadModuleConfig.getFruitIsExists() then
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view,nil,true))
				else
					Common.showToast("【水果机】还未加载完成，请到【幸运游戏】中查看",2)
				end


				--金皇冠GameID
			elseif chatTable.actionId ==  ID_JIN_HUANG_GUAN then
				--金皇冠

				if GameLoadModuleConfig.getJinHuangGuanIsExists() then
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					mvcEngine.createModule(GUI_JINHUANGUAN, LordGamePub.runSenceAction(HallLogic.view,nil,true))
				else
					Common.showToast("【金皇冠】还未加载完成，请到【幸运游戏】中查看",2)
				end


				--万人金花GameID
			elseif chatTable.actionId ==  ID_WAN_REN_JIN_HUA then

				if GameLoadModuleConfig.getWanRenJinHuaIsExists() then
					sendJHROOMID_MINI_JINHUA_ENTER_GAME()
					sendJHGAMEID_MINI_JINHUA_HELP() -- 预先获取万人金花帮助信息
					sendJHGAMEID_MINI_JINHUA_HISTORY() -- 预先获取万人金花历史信息
				else
					Common.showToast("【万人金花】还未加载完成，请到【幸运游戏】中查看",2)
				end

				--万人水果派
			elseif chatTable.actionId ==  ID_WAN_REN_FRUIT_MACHINE then

				--万人水果机
				if GameLoadModuleConfig.getWanRenFruitIsExists() then
					sendWRSGJ_INFO(0) --发送基本信息 INFO
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					mvcEngine.createModule(GUI_WRSGJ, LordGamePub.runSenceAction(HallLogic.view,nil,true))
				else
					Common.showToast("【万人水果派】还未加载完成，请到【幸运游戏】中查看",2)
				end

				--扎金花
			elseif chatTable.actionId ==  ID_JIN_HUA then

				--炸金花
				if GameLoadModuleConfig.getJinHuaIsExists() then
					sendJHID_ENTER_JH_MINI();--发送进入扎金花大厅消息(服务器不回)
					sendJINHUA_ROOMID_ROOM_LIST(profile.JinHuaRoomData.getTimeStamp());--发送扎金花房间列表消息
					GameConfig.setTheLastBaseLayer(GUI_HALL);
					mvcEngine.createModule(GUI_JINHUAHALL);
				else
					Common.showToast("【疯狂炸金花】还未加载完成，请到【幸运游戏】中查看",2)
				end
			end
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_queding(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_MINIGAMEGUIDETANCHUKUANG);

	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	chatTable = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MINI_COMMON_RECOMMEND, back_MINI_COMMON_RECOMMEND)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MINI_COMMON_RECOMMEND, back_MINI_COMMON_RECOMMEND)
end
