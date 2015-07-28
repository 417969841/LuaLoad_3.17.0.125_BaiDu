module("TableSelfUserInfoLogic",package.seeall)

view = nil
local UserID = 0;

panel_userinfo = nil;--背景
panel = nil;--弹出框
btn_close = nil;--关闭按钮
Panel_center = nil;--
iv_coin = nil;--
lab_coin = nil;--筹码图标
ImageView_coin = nil;--筹码数量
Panel_bottom = nil;--
img_ttdj = nil;--天梯等级图标
LabelAtlas_tt_level = nil;--白金等级
iv_tt_type = nil;--
ImageView_ji = nil;--
ImageView_jindu = nil;--
Panel_top = nil;--
img_vipbg = nil;--
lab_vipnum = nil;--
Image_vip_me = nil;--用户VIP背景图
lab_nickname = nil;--用户名
Image_nickname = nil;--
lab_sign = nil;--用户签名
Image_sign = nil;--
touxiang = nil;--
img_useravator = nil;--用户头像
Image_notvip = nil;--非会员背景图
Image_vip = nil;--会员背景图
lab_birthday = nil;--
lab_address = nil;--
Image_gender = nil;--
maskImageView = nil;--VIP遮罩



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
	view = cocostudio.createView("TableSelfUserInfo.json")
	local gui = GUI_TABLE_SELF_USER_INFO
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
	panel_userinfo = cocostudio.getUIPanel(view, "panel_userinfo");
	panel = cocostudio.getUIPanel(view, "panel");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Panel_center = cocostudio.getUIPanel(view, "Panel_center");
	iv_coin = cocostudio.getUIImageView(view, "iv_coin");
	lab_coin = cocostudio.getUILabel(view, "lab_coin");
	ImageView_coin = cocostudio.getUIImageView(view, "ImageView_coin");
	Panel_bottom = cocostudio.getUIPanel(view, "Panel_bottom");
	img_ttdj = cocostudio.getUIImageView(view, "img_ttdj");
	LabelAtlas_tt_level = cocostudio.getUILabelAtlas(view, "LabelAtlas_tt_level");
	iv_tt_type = cocostudio.getUIImageView(view, "iv_tt_type");
	ImageView_ji = cocostudio.getUIImageView(view, "ImageView_ji");
	ImageView_jindu = cocostudio.getUIImageView(view, "ImageView_jindu");
	Panel_top = cocostudio.getUIPanel(view, "Panel_top");
	img_vipbg = cocostudio.getUIImageView(view, "img_vipbg");
	lab_vipnum = cocostudio.getUILabelAtlas(view, "lab_vipnum");
	Image_vip_me = cocostudio.getUIImageView(view, "Image_vip_me");
	lab_nickname = cocostudio.getUILabel(view, "lab_nickname");
	Image_nickname = cocostudio.getUIImageView(view, "Image_nickname");
	lab_sign = cocostudio.getUILabel(view, "lab_sign");
	Image_sign = cocostudio.getUIImageView(view, "Image_sign");
	touxiang = cocostudio.getUIImageView(view, "touxiang");
	img_useravator = cocostudio.getUIImageView(view, "img_useravator");
	Image_notvip = cocostudio.getUIImageView(view, "Image_notvip");
	Image_vip = cocostudio.getUIImageView(view, "Image_vip");
	lab_birthday = cocostudio.getUILabel(view, "lab_birthday");
	lab_address = cocostudio.getUILabel(view, "lab_address");
	Image_gender = cocostudio.getUIImageView(view, "Image_gender");
	maskImageView = cocostudio.getUIImageView(view, "maskImageView");
end


function createView()
	--初始化当前界面
	initLayer();
	initView()
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	panel:setPosition(ccp(50, 50))
	LordGamePub.showDialogAmin(panel)

end

function requestMsg()

end

local function closeCallBack()
	mvcEngine.destroyModule(GUI_TABLE_SELF_USER_INFO)
end

function callback_panel_userinfo(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(panel, closeCallBack)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_panel(component)
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
		LordGamePub.closeDialogAmin(panel, closeCallBack)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and img_useravator ~= nil) then
		img_useravator:loadTexture(photoPath)
	end
end

--[[--
--设置自己的数据
--]]
function setSelfUserInfo()
	Common.setButtonVisible(btn_hello, false)
	Common.setButtonVisible(btn_jubao, false)
	local photoUrl = profile.User.getSelfPhotoUrl()
	if photoUrl ~= nil then
		Common.getPicFile(photoUrl, 0, true, updataUserPhoto)
	end
	--昵称
	lab_nickname:setText(""..profile.User.getSelfNickName())
	--地址
	lab_address:setText(""..profile.User.getSelfCity());

	--生日
	local brithday = "保密"
	if profile.User.getSelfAge() > 0 then
		brithday = profile.User.getSelfAge() .. "岁"
	end
	lab_birthday:setText(brithday);

	--性别
	if profile.User.getSelfSex() == 0 or profile.User.getSelfSex() == 1 then
		--女
		Image_gender:loadTexture(Common.getResourcePath("male.png"));
	elseif profile.User.getSelfSex() == 2 then
		--男
		Image_gender:loadTexture(Common.getResourcePath("female.png"))
	end
	--签名
	lab_sign:setText(""..profile.User.getSelfsign())
	--筹码
  	lab_coin:setText(""..profile.User.getSelfCoin())


	local VipLevel = profile.User.getSelfVipLevel()
	local vipType = VIPPub.getUserVipType(VipLevel)
	lab_vipnum:setStringValue(""..vipType)
	lab_vipnum:setVisible(true)
	if vipType >= VIPPub.VIP_1 then
--		lab_vipnum:setStringValue(""..vipType)
		img_vipbg:loadTexture(Common.getResourcePath("hall_vip_icon.png"));
		maskImageView:setVisible(false)
		img_vipbg:setVisible(true)
--		lab_vipnum:setVisible(true)
		Image_sign:setVisible(false)
		ImageView_coin:setVisible(false)
		Image_notvip:setVisible(false)
		Image_vip:setVisible(true)

		lab_nickname:setColor(ccc3(92,59,42))
		lab_sign:setColor(ccc3(92,59,42))
		lab_coin:setColor(ccc3(92,59,42))
		lab_birthday:setColor(ccc3(92,59,42))
		lab_address:setColor(ccc3(92,59,42))

	else
		img_vipbg:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"));
		img_vipbg:setVisible(true)
		maskImageView:setVisible(true)
--		lab_vipnum:setVisible(false)
	end

	local duanwei = profile.User.getSelfLadderDuan()
	local level = profile.User.getSelfLadderLevel()
	img_ttdj:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(duanwei)));
	LabelAtlas_tt_level:setStringValue(""..level)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
