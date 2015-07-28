module("RenWuJiangLiInfoLogic",package.seeall)

view = nil
panel = nil;
BackButton = nil;
Label_NewUserRenWu = nil;
Label_WuXing = nil;

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
	view = cocostudio.createView("RenWuJiangLiInfo.json")
	local gui = GUI_RENWUJIANGLI
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
	panel = cocostudio.getUIImageView(view, "ImageView_22")

	BackButton = cocostudio.getUIButton(view, "Button_Ok")
	Label_NewUserRenWu = cocostudio.getUILabel(view, "Label_NewUserRenWu");
	Label_WuXing = cocostudio.getUILabel(view, "Label_WuXing");


	LordGamePub.showDialogAmin(panel, true)
	if(CommDialogConfig.getNewUserTaskFinish() == true)then
		--如果新手任务已经完成
		Label_NewUserRenWu:setVisible(false);
		Label_WuXing:setVisible(true);
		sendDAILYTASKID_FIVESTAR_AWARD()
	else
		NewUserPicAndTitle();
	end
end

function requestMsg()

end

function callback_Button_Ok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_RENWUJIANGLI)
		end
		LordGamePub.closeDialogAmin(panel, actionOver)
		--LordGamePub.comeFromIconPosition(view,iconPosition,actionOver,true)
	elseif component == CANCEL_UP then
	--取消
	end
end

function getDAILYTASKID_FIVESTAR_AWARDInfo()
	local DAILYTASKID_FIVESTAR_AWARDInfo = profile.DailyTasks.getDAILYTASKID_FIVESTAR_AWARDTable();
	for i = 1,#DAILYTASKID_FIVESTAR_AWARDInfo.gift do
		local ImageView = cocostudio.getUIImageView(view, "ImageView_" ..i)
		local label = cocostudio.getUILabel(view, "Label_" .. i)

		if label ~= nil then
			--保底方案：label不为空
			label:setText(DAILYTASKID_FIVESTAR_AWARDInfo.gift[i].Title);
		end
		--		if(DAILYTASKID_FIVESTAR_AWARDInfo.gift[i].isGiven == 1)then
		--			local wintSprite = UIImageView:create()
		--			wintSprite:loadTexture(Common.getResourcePath("ic_login_sign_pass.png"))
		--			wintSprite:setZOrder(100)
		--			ImageView:addChild(wintSprite)
		--		end

		local function getIcon(path)
			local photoPath = nil
			local id = nil;
			if Common.platform == Common.TargetIos then
				photoPath = path["useravatorInApp"]
				id = path["id"]
			elseif Common.platform == Common.TargetAndroid then
				--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
				local i, j = string.find(path, "#")
				id = string.sub(path, 1, i - 1)
				photoPath = string.sub(path, j + 1, -1)
			end
			if ImageView ~= nil and photoPath ~= nil and photoPath ~= "" and ImageView ~= nil then
				ImageView:loadTexture(photoPath);
			end
		end
		Common.getPicFile(DAILYTASKID_FIVESTAR_AWARDInfo.gift[i].TitleUrl, 1, true, getIcon)
	end
end

--新手任务奖励布局
function NewUserPicAndTitle()
	local PicTitle = profile.RenWu.getNewUserPicAndTitle();
	if(PicTitle ~= nil)then
		for i = 1,#PicTitle do
			local ImageView = cocostudio.getUIImageView(view,"ImageView_"..i);
			local label = cocostudio.getUILabel(view,"Label_"..i);
			if label ~= nil then
				--保底方案：label不为空
				label:setText(PicTitle[i].awardDescription);
			end
			local function getPath(path)
				local photoPath = nil;
				local id = nil;

				if Common.platform == Common.TargetIos then
					photoPath = path["useravatorInApp"];
					id = path["id"];
				elseif Common.platform == Common.TargetAndroid then
					--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
					local i , j = string.find(path,"#");
					id = string.sub(path , 1 , i-1);
					photoPath = string.sub(path, j+1 , -1);
				end
				if ImageView ~= nil and photoPath ~= nil and photoPath ~= "" and ImageView ~= nil then
					ImageView:loadTexture(photoPath);
				end
			end
			Common.getPicFile(PicTitle[i].picUrl, 1, true, getPath)
		end
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DAILYTASKID_FIVESTAR_AWARD,getDAILYTASKID_FIVESTAR_AWARDInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(DAILYTASKID_FIVESTAR_AWARD,getDAILYTASKID_FIVESTAR_AWARDInfo)
end
