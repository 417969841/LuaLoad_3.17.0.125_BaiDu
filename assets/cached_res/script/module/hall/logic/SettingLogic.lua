module("SettingLogic",package.seeall)

view = nil
panel = nil
--控件
btn_close = nil
btn_music = nil
btn_yinxiao = nil
btn_help = nil
btn_kefu = nil
btn_version = nil
btn_logout = nil
--lab_text1 = nil
lab_text2 = nil
img_music = nil
img_yinxiao = nil
btn_tishi = nil
btn_table_music = nil
btn_table_yinxiao = nil
btn_zhendong = nil

img_tishi_no = nil
img_table_music_no = nil
img_table_yinxiao_no = nil
img_table_zhendong_no = nil

ImageView_music = nil
ImageView_yinxiao = nil

ImageView_tishi = nil
ImageView_table_music = nil
ImageView_table_yinxiao = nil
ImageView_zhendong = nil

panel_hall_setting = nil--大厅设置
panel_table_setting = nil--牌桌设置
Image_Version = nil;--
Image_Switching = nil;--

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local function setTableSettingsVisible(Visible)
	panel_table_setting:setVisible(Visible)
	Common.setButtonVisible(btn_tishi, Visible)
	Common.setButtonVisible(btn_table_music, Visible)
	Common.setButtonVisible(btn_table_yinxiao, Visible)
	Common.setButtonVisible(btn_zhendong, Visible)
end

local function setHallSettingsVisible(Visible)
	panel_hall_setting:setVisible(Visible)
	Common.setButtonVisible(btn_music, Visible)
	Common.setButtonVisible(btn_yinxiao, Visible)
	Common.setButtonVisible(btn_help, Visible)
	Common.setButtonVisible(btn_kefu, Visible)
end

--[[--
--设置音乐图标显示状态
--]]
local function setMusicIconVisible(Visible)
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
		img_music:setVisible(Visible)
		ImageView_music:setVisible(Visible)

		if Visible then
			GameArmature.hideMusicAmin(view)
		else
			GameArmature.showMusicAmin(view, img_music:getPosition().x + 3, img_music:getPosition().y - 8);
		end
	else
		img_table_music_no:setVisible(Visible)
		ImageView_table_music:setVisible(Visible)
		if Visible then
			GameArmature.hideMusicAmin(view)
		else
			GameArmature.showMusicAmin(view, img_table_music_no:getPosition().x + 3, img_table_music_no:getPosition().y - 8);
		end
	end
end

--[[--
--设置音效图标显示状态
--]]
local function setSoundIconVisible(Visible)
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
		img_yinxiao:setVisible(Visible)
		ImageView_yinxiao:setVisible(Visible)
		if Visible then
			GameArmature.hideSoundAmin(view)
		else
			GameArmature.showSoundAmin(view, img_yinxiao:getPosition().x + 3, img_yinxiao:getPosition().y - 8);
		end
	else
		img_table_yinxiao_no:setVisible(Visible)
		ImageView_table_yinxiao:setVisible(Visible)
		if Visible then
			GameArmature.hideSoundAmin(view)
		else
			GameArmature.showSoundAmin(view, img_table_yinxiao_no:getPosition().x + 3, img_table_yinxiao_no:getPosition().y - 8);
		end
	end
end

--[[--
--设置自动提示图标显示状态
--]]
local function setAutomationIconVisible(Visible)
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		img_tishi_no:setVisible(Visible)
		ImageView_tishi:setVisible(Visible)
		if Visible then
			GameArmature.hideAutomationAmin(view)
		else
			GameArmature.showAutomationAmin(view, img_tishi_no:getPosition().x + 3, img_tishi_no:getPosition().y - 8);
		end
	end
end

--[[--
--设置震动图标显示状态
--]]
local function setVibrateIconVisible(Visible)
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
	--[[
	img_music:setVisible(Visible)
	ImageView_music:setVisible(Visible)

	if Visible then
	GameArmature.hideMusicAmin(view)
	else
	GameArmature.showMusicAmin(view, img_music:getPosition().x + 3, img_music:getPosition().y - 8);
	end
	]]
	else
		-- 在牌桌中
		img_table_zhendong_no:setVisible(Visible)
		ImageView_zhendong:setVisible(Visible)
		if Visible then
			GameArmature.hideVibrateAmin(view)
		else
			GameArmature.showVibrateAmin(view, img_table_zhendong_no:getPosition().x + 3, img_table_zhendong_no:getPosition().y);
		end
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("Setting.json")
	local gui = GUI_SETTING
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

	panel_hall_setting = cocostudio.getUIPanel(view, "panel_hall_setting")
	panel_table_setting = cocostudio.getUIPanel(view, "panel_table_setting")

	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_music = cocostudio.getUIButton(view, "btn_music")
	btn_yinxiao = cocostudio.getUIButton(view, "btn_yinxiao")
	btn_help = cocostudio.getUIButton(view, "btn_help")
	btn_kefu = cocostudio.getUIButton(view, "btn_kefu")
	btn_version = cocostudio.getUIButton(view, "btn_version")
	btn_logout = cocostudio.getUIButton(view, "btn_logout")
	btn_tishi = cocostudio.getUIButton(view, "btn_tishi")
	btn_table_music = cocostudio.getUIButton(view, "btn_table_music")
	btn_table_yinxiao = cocostudio.getUIButton(view, "btn_table_yinxiao")
	btn_zhendong = cocostudio.getUIButton(view, "btn_zhendong")

	--	lab_text1 =  cocostudio.getUILabel(view, "lab_text1")
	lab_text2 =  cocostudio.getUILabel(view, "lab_text2")

	ImageView_music = cocostudio.getUIImageView(view, "ImageView_music")
	ImageView_yinxiao = cocostudio.getUIImageView(view, "ImageView_yinxiao")

	ImageView_tishi = cocostudio.getUIImageView(view, "ImageView_tishi")
	ImageView_table_music = cocostudio.getUIImageView(view, "ImageView_table_music")
	ImageView_table_yinxiao = cocostudio.getUIImageView(view, "ImageView_table_yinxiao")
	ImageView_zhendong = cocostudio.getUIImageView(view, "ImageView_zhendong")

	img_music = cocostudio.getUIImageView(view, "img_music")
	img_yinxiao = cocostudio.getUIImageView(view, "img_yinxiao")

	img_tishi_no = cocostudio.getUIImageView(view, "img_tishi_no")
	img_table_music_no = cocostudio.getUIImageView(view, "img_table_music_no")
	img_table_yinxiao_no = cocostudio.getUIImageView(view, "img_table_yinxiao_no")
	img_table_zhendong_no = cocostudio.getUIImageView(view, "img_zhendong_no")
	Image_Version = cocostudio.getUIImageView(view, "Image_Version");
	Image_Switching = cocostudio.getUIImageView(view, "Image_Switching");

	--	lab_text1:setText("ID:"..profile.User.getSelfUserID())
	lab_text2:setText("游戏版本号:"..Common.getVersionName().."."..Common.getChannelID() .. "      ID:"..profile.User.getSelfUserID())

	if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
		--牌桌外
		setTableSettingsVisible(false)
		setHallSettingsVisible(true)
		btn_version:loadTextures(Common.getResourcePath("btn_green.png"), Common.getResourcePath("btn_green.png"), "")
		btn_version:setTouchEnabled(true)
		btn_logout:loadTextures(Common.getResourcePath("btn_gerenziliao0.png"), Common.getResourcePath("btn_gerenziliao0.png"), "")
		btn_logout:setTouchEnabled(true)
		Image_Version:loadTexture(Common.getResourcePath("ic_setup_banbenjiance.png"));
		Image_Switching:loadTexture(Common.getResourcePath("qiehuanzhanghao.png"));
	else
		--牌桌内
		setTableSettingsVisible(true)
		setHallSettingsVisible(false)
		--自动提示
		if GameConfig.getGameAutomation() then
			--setAutomationIconVisible(false)
			img_tishi_no:setVisible(false);
		else
			--setAutomationIconVisible(true)
			img_tishi_no:setVisible(true);
		end
		-- 震动
		if GameConfig.getGameVibrate() then
			--setVibrateIconVisible(false)
			img_table_zhendong_no:setVisible(false);
		else
			--setVibrateIconVisible(true)
			img_table_zhendong_no:setVisible(false);
		end
		btn_version:loadTextures(Common.getResourcePath("btn_gerenziliao0_no.png"), Common.getResourcePath("btn_gerenziliao0_no.png"), "")
		btn_version:setTouchEnabled(false)
		btn_logout:loadTextures(Common.getResourcePath("btn_gerenziliao0_no.png"), Common.getResourcePath("btn_gerenziliao0_no.png"), "")
		btn_logout:setTouchEnabled(false)
		Image_Version:loadTexture(Common.getResourcePath("banbenjiance0.png"));
		Image_Switching:loadTexture(Common.getResourcePath("qiehuanid0.png"));
	end
	--音乐
	if GameConfig.getGameMusicOff() then
		--setMusicIconVisible(false)
		img_music:setVisible(false);
	else
		--setMusicIconVisible(true)
		img_music:setVisible(true);
	end
	--音效
	if GameConfig.getGameSoundOff() then
		--setSoundIconVisible(false)
		img_yinxiao:setVisible(false);
	else
		--setSoundIconVisible(true)
		img_yinxiao:setVisible(true);
	end
	--LordGamePub.comeFromIconPosition(view,iconPosition,nil,false)
end

function requestMsg()

end

local function closePanel()
	mvcEngine.destroyModule(GUI_SETTING)
end

--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel, closePanel)
		--LordGamePub.comeFromIconPosition(view,iconPosition,actionOver,true)
	elseif component == CANCEL_UP then
	--取消
	end
end

--音乐
function callback_btn_music(component)
	if component == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(btn_music,1.05,false)
	elseif component == RELEASE_UP then
		--抬起
		if img_music == nil then
			return;
		end
		if GameConfig.getGameMusicOff() then
			img_music:setZOrder(200)
			GameConfig.setGameMusicOff(false)
			--setMusicIconVisible(true)
			LordGamePub.setActionAnimate(btn_music,img_music,function ()
				img_music:setZOrder(5)
			end)
		else
			GameConfig.setGameMusicOff(true)
			--setMusicIconVisible(false)
			LordGamePub.setActionAnimate(btn_music,img_music,nil)
		end

	elseif component == CANCEL_UP then
		--取消
		LordGamePub.setActionAnimate(btn_music,img_music,nil)
	end
end

--音效
function callback_btn_yinxiao(component)
	if component == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(btn_yinxiao,1.05,false)
	elseif component == RELEASE_UP then
		--抬起
		if img_yinxiao == nil then
			return;
		end
		if GameConfig.getGameSoundOff() then
			img_yinxiao:setZOrder(200)
			GameConfig.setGameSoundOff(false)
			--setSoundIconVisible(true)
			LordGamePub.setActionAnimate(btn_yinxiao,img_yinxiao,function ()
				img_yinxiao:setZOrder(5)
			end)
		else
			GameConfig.setGameSoundOff(true)
			--setSoundIconVisible(false)
			LordGamePub.setActionAnimate(btn_yinxiao,img_yinxiao,nil)
		end
	elseif component == CANCEL_UP then
		--取消
		LordGamePub.setActionAnimate(btn_yinxiao,img_yinxiao,nil)
	end
end

--帮助
function callback_btn_help(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
--		CustomServiceLogic.setTab(CustomServiceLogic.getMenuTable().MENUHELP)
--		mvcEngine.createModule(GUI_CUSTOMSERVICE,LordGamePub.runSenceAction(view,nil,true))
		mvcEngine.createModule(GUI_GAMEHELP)
	elseif component == CANCEL_UP then
	--取消
	end
end

--客服
function callback_btn_kefu(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_CUSTOMSERVICE,LordGamePub.runSenceAction(view,nil,true))
		if profile.HongDian.getProfile_HongDian_datatable() == 0 then
			HongDianLogic.removeshowHall_more_Verson(10)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--版本
function callback_btn_version(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if Common.platform == Common.TargetIos then
			--IOS版本检测
			if GameConfig.IOSChannelID == 61 then
				--如果是海马渠道
				Common.upDataGameVersionForIOS(GameConfig.mnIOSForce, GameConfig.mnIOSTest);
			else
				--如果不是
				--profile.Version.setUserInitiative(true);
				--sendBASEID_PLAT_VERSION(); --发送版本检测消息
				Common.showToast("你当前已经是最新版本", 2);
			end
		elseif Common.platform == Common.TargetAndroid then
			--android版本检测
			profile.Version.setUserInitiative(true);
			sendBASEID_PLAT_VERSION(); --发送版本检测消息
			if profile.HongDian.getProfile_HongDian_datatable() == 0 then
				HongDianLogic.removeshowHall_more_Verson(11)
				if HongDianLogic.getHongDian_GengDuo_table() ~= nil then
					if HongDianLogic.getHongDian_GengDuo_table()[1] ~= nil then
						HongDianLogic.getHongDian_GengDuo_table()[1]:setVisible(false)
					end
				end
			end
		end

	elseif component == CANCEL_UP then
	--取消
	end
end

--退出
function callback_btn_logout(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--发送用户在线时长
		LoginLogic.setChangeAccount(true)
		mvcEngine.createModule(GUI_LOGIN)

	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--自动提示
--]]
function callback_btn_tishi(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if img_tishi_no == nil then
			return;
		end
		if GameConfig.getGameAutomation() then
			img_tishi_no:setZOrder(200)
			GameConfig.setGameAutomation(false)
			--setAutomationIconVisible(true)
			LordGamePub.setActionAnimate(btn_tishi,img_tishi_no,function ()
				img_tishi_no:setZOrder(5)
			end)
		else
			GameConfig.setGameAutomation(true)
			--setAutomationIconVisible(false)
			LordGamePub.setActionAnimate(btn_tishi,img_tishi_no,nil)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--牌桌声音
--]]
function callback_btn_table_music(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if img_table_music_no == nil then
			return;
		end
		if GameConfig.getGameMusicOff() then
			img_table_music_no:setZOrder(200)
			GameConfig.setGameMusicOff(false)
			--setMusicIconVisible(true)
			LordGamePub.setActionAnimate(btn_table_music,img_table_music_no,function ()
				img_table_music_no:setZOrder(5)
			end)
		else
			GameConfig.setGameMusicOff(true)
			--setMusicIconVisible(false)
			LordGamePub.setActionAnimate(btn_table_music,img_table_music_no,nil)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--牌桌音效
--]]
function callback_btn_table_yinxiao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if img_table_yinxiao_no == nil then
			return;
		end
		if GameConfig.getGameSoundOff() then
			img_table_yinxiao_no:setZOrder(200)
			GameConfig.setGameSoundOff(false)
			--setSoundIconVisible(true)
			LordGamePub.setActionAnimate(btn_table_music,img_table_yinxiao_no,function ()
				img_table_yinxiao_no:setZOrder(5)
			end)
		else
			GameConfig.setGameSoundOff(true)
			--setSoundIconVisible(false)
			LordGamePub.setActionAnimate(btn_table_music,img_table_yinxiao_no,nil)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--牌桌震动
--]]
function callback_btn_zhendong(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if img_table_zhendong_no == nil then
			return;
		end
		if GameConfig.getGameVibrate() then
			Common.log("震动准备关闭")
			img_table_zhendong_no:setZOrder(200)
			GameConfig.setGameVibrate(false)
			--setVibrateIconVisible(true)
			LordGamePub.setActionAnimate(btn_zhendong,img_table_zhendong_no,function ()
				img_table_zhendong_no:setZOrder(5)
			end)
		else
			Common.log("震动准备开启")
			GameConfig.setGameVibrate(true)
			--setVibrateIconVisible(false)
			LordGamePub.setActionAnimate(btn_zhendong,img_table_zhendong_no,nil)
		end
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
--	GameArmature.hideMusicAmin(view)
--	GameArmature.hideSoundAmin(view)
--	GameArmature.hideAutomationAmin(view)
--	GameArmature.hideVibrateAmin(view)
end
