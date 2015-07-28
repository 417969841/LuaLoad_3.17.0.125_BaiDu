module("LuaUpdateLogic",package.seeall)

view = nil

local dataTable = {}--脚本升级数据
label_title = nil;
label_version = nil;
Image_unzip = nil;
ProgressBar_upzip = nil;
Label_upzip = nil;

local updateType = -1;

local LuaUpdateTypeTable = {};
LuaUpdateTypeTable.DOWNLOAD = 0;--下载
LuaUpdateTypeTable.UNZIP = 1;--解压

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function getLuaUpdateType()
	return LuaUpdateTypeTable;
end

--升级方案
--0、不升级
--1、提示升级
--2、强制升级
--3、有新版本，不提升(wifi后台升级，2G不升级)
--4、后台升级(wifi、2G下均后台升级)
--5、wifi后台升级，2G提示升级
--6、提示升级(用户取消时，wifi后台升级)
--7、提示升级(用户取消时，wifi、2G后台升级)

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("LuaUpdate.json")
	local gui = GUI_LUA_UPDATE_VIEW
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

	initScriptUpdateView()
end

function requestMsg()

end

function initScriptUpdateView()
	label_title = cocostudio.getUILabel(view, "Label_title")--更新标题
	label_version = cocostudio.getUILabel(view, "Label_text1")--更新版本内容
	Image_unzip = cocostudio.getUIImageView(view, "Image_unzip");
	ProgressBar_upzip = cocostudio.getUILoadingBar(view, "ProgressBar_upzip");
	Label_upzip = cocostudio.getUILabel(view, "Label_upzip");
end

--[[--
--设置提示框类型
--]]
function setLuaUpdateType(type)
	updateType = type;
	if updateType == LuaUpdateTypeTable.DOWNLOAD then
		--提示下载
		dataTable = profile.Script.getScriptUpdateData();
		label_title:setText("数据更新");
		label_version:setText("有新版本可以下载，是否更新？");
		Image_unzip:setVisible(false);
	elseif updateType == LuaUpdateTypeTable.UNZIP then
		--提示更新(解压)
		label_title:setText("数据更新");
		label_version:setText("有新功能可以更新，是否更新？");
		Image_unzip:setVisible(false);
		ProgressBar_upzip:setVisible(true);
		ProgressBar_upzip:setPercent(1);
		Label_upzip:setText(1/100)
	end
end


--[[--
--脚本解压回调
--]]
local function luaUnzipCallback(progressData)
    Common.log("脚本解压回调 ======== ");
	local progress = nil
	local max = nil
	if Common.platform == Common.TargetIos then
        progress = progressData["progress"]
		max = progressData["max"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(progressData, "#")
		progress = string.sub(progressData, 1, i - 1)
		max = string.sub(progressData, j + 1, -1)
	end

	--Common.log("progress ======= "..progress)
	--Common.log("max ======= "..max)
	--Common.log("math.floor((progress * 100) / max) ======= "..math.floor((progress * 100) / max))

	Image_unzip:setVisible(true);
	ProgressBar_upzip:setPercent(math.floor((progress * 100) / max));
	Label_upzip:setText((math.floor((progress * 100) / max)) .. "%")
	if progress == max then
		mvcEngine.destroyModule(GUI_LUA_UPDATE_VIEW);
	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if updateType == LuaUpdateTypeTable.DOWNLOAD then
			--提示下载
			if dataTable["updateType"] == 2 then
				--2、强制升级
				Common.AndroidExitSendOnlineTime();
			elseif dataTable["updateType"] == 6 then
				--6、提示升级(用户取消时，wifi后台升级)
				if Common.getConnectionType() == NET_WIFI then
					CommDialogConfig.updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
				end
			elseif dataTable["updateType"] == 7 then
				--7、提示升级(用户取消时，wifi、2G后台升级)
				CommDialogConfig.updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
			end
		elseif updateType == LuaUpdateTypeTable.UNZIP then
		--提示更新(解压)
		end
		mvcEngine.destroyModule(GUI_LUA_UPDATE_VIEW);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_update(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if updateType == LuaUpdateTypeTable.DOWNLOAD then
			--提示下载
			CommDialogConfig.updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
			mvcEngine.destroyModule(GUI_LUA_UPDATE_VIEW);
		elseif updateType == LuaUpdateTypeTable.UNZIP then
			--提示更新(解压)
            Image_unzip:setVisible(false);
			ProgressBar_upzip:setPercent(1);
			Label_upzip:setText(1/100)
			LuaUpdateConsole.logicLuaLord(luaUnzipCallback);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	updateType = -1;
	ResumeSocket("ScriptUpdata");
end

function addSlot()
end

function removeSlot()
end
