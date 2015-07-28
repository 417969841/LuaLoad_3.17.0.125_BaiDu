module("TableOtherUserInfoLogic",package.seeall)

view = nil
local UserID = 0;
local UserPos = 0;

panel_userinfo = nil;--背景
panel = nil;--弹出框
btn_close = nil;--关闭按钮
Panel_center = nil;--
iv_coin = nil;--筹码图标
lab_coin = nil;--筹码数量
ImageView_coin = nil;--
iv_address = nil;--
lab_address = nil;--地址
iv_gender = nil;--
Image_gender = nil;--
iv_birthday = nil;--
lab_birthday = nil;--生日
Panel_bottom = nil;--
btn_jubao = nil;--举报按钮
ImageView_jubao = nil;--
btn_dazhaohu = nil;--打招呼按钮
ImageView_dazhaohu = nil;--
btn_faxiaoxi = nil;--发信息按钮/屏蔽
ImageView_faxiaoxi = nil;--
Panel_top = nil;--
iv_vip = nil;--
img_vipbg = nil;--VIP图标
lab_vipnum = nil;--vip等级
lab_nickname = nil;--
lab_sign = nil;--个性签名
Image_sign = nil;--
touxiang = nil;--
img_useravator = nil;--头像图片
img_ttdj = nil;--天体等级
LabelAtlas_tt_level = nil;--白金等级
iv_tt_type = nil;--白金图片（字体）
Image_notvip = nil;--非vip背景
Image_vip = nil;--vip背景
maskImageView = nil;--VIP遮罩

local FROM_HALLCHATTING = 1; --由大厅跳转而来
local FROM_MAIL = 2; --由站内信跳转而来
local FROM_TABLE = 3; --由牌桌跳转而来
local jumpfromflag = nil; --界面跳转标记
local otherUserNickName = nil;
local isClose = 0 --是否屏蔽玩家站内信
local ColseMessageTable = {} -- 屏蔽某玩家站内信table
local zhuangtai = 1

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--动态初始化按钮
--]]
function initButtonDinamic()
	--如果是从大厅聊天跳转而来
	--	Common.log("aajumpfromflag=" .. jumpfromflag .. "FROM_TABLE=" .. FROM_TABLE);
	if jumpfromflag ~= nil then
		if jumpfromflag == FROM_HALLCHATTING then
			Common.log("initButtonDinamic" .. jumpfromflag);
			--			if Image_FaXaioXi ~= nil then
			ImageView_faxiaoxi:loadTexture(Common.getResourcePath("btn_emaila_send_message.png"));
			--			end
			btn_jubao:setVisible(false);
			btn_dazhaohu:setVisible(false);
			btn_jubao:setTouchEnabled(false);
			btn_dazhaohu:setTouchEnabled(false);
		--如果是站内信跳转而来
		elseif jumpfromflag == FROM_MAIL then
			ImageView_faxiaoxi:loadTexture(Common.getResourcePath("ui_hall_chat_pinbi.png"));
			btn_jubao:setVisible(false);
			btn_dazhaohu:setVisible(false);
			btn_jubao:setTouchEnabled(false);
			btn_dazhaohu:setTouchEnabled(false);
			isClose = MessagePlayerLogic.isCloseMessageFlag
			if isClose == 0 then  --没有屏蔽
				ImageView_faxiaoxi:loadTexture(Common.getResourcePath("ui_hall_chat_pinbi.png"));
			elseif isClose == 1 then --已经屏蔽
				ImageView_faxiaoxi:loadTexture(Common.getResourcePath("ui_qixiaopingbi.png"));
			end
			--如果是从牌桌跳转而来
		elseif jumpfromflag == FROM_TABLE then
			btn_faxiaoxi:setVisible(false);
			btn_faxiaoxi:setTouchEnabled(false);
			Common.setButtonVisible(btn_dazhaohu, true)
			Common.setButtonVisible(btn_jubao, true)
		end
	end

end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("TableOtherUserInfo.json")
	local gui = GUI_TABLE_OTHER_USER_INFO
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
	iv_address = cocostudio.getUIImageView(view, "iv_address");
	lab_address = cocostudio.getUILabel(view, "lab_address");
	iv_gender = cocostudio.getUIImageView(view, "iv_gender");
	Image_gender = cocostudio.getUIImageView(view, "Image_gender");
	iv_birthday = cocostudio.getUIImageView(view, "iv_birthday");
	lab_birthday = cocostudio.getUILabel(view, "lab_birthday");
	Panel_bottom = cocostudio.getUIPanel(view, "Panel_bottom");
	btn_jubao = cocostudio.getUIButton(view, "btn_jubao");
	ImageView_jubao = cocostudio.getUIImageView(view, "ImageView_jubao");
	btn_dazhaohu = cocostudio.getUIButton(view, "btn_dazhaohu");
	ImageView_dazhaohu = cocostudio.getUIImageView(view, "ImageView_dazhaohu");
	btn_faxiaoxi = cocostudio.getUIButton(view, "btn_faxiaoxi");
	ImageView_faxiaoxi = cocostudio.getUIImageView(view, "ImageView_faxiaoxi");
	Panel_top = cocostudio.getUIPanel(view, "Panel_top");
	iv_vip = cocostudio.getUIImageView(view, "iv_vip");
	img_vipbg = cocostudio.getUIImageView(view, "img_vipbg");
	lab_vipnum = cocostudio.getUILabelAtlas(view, "lab_vipnum");
	lab_nickname = cocostudio.getUILabel(view, "lab_nickname");
	--	Image_nickname = cocostudio.getUIImageView(view, "Image_nickname");
	lab_sign = cocostudio.getUILabel(view, "lab_sign");
	Image_sign = cocostudio.getUIImageView(view, "Image_sign");
	touxiang = cocostudio.getUIImageView(view, "touxiang");
	img_useravator = cocostudio.getUIImageView(view, "img_useravator");
	img_ttdj = cocostudio.getUIImageView(view, "img_ttdj");
	LabelAtlas_tt_level = cocostudio.getUILabelAtlas(view, "LabelAtlas_tt_level");
	iv_tt_type = cocostudio.getUIImageView(view, "iv_tt_type");
	Image_notvip = cocostudio.getUIImageView(view, "Image_notvip");
	Image_vip = cocostudio.getUIImageView(view, "Image_vip");
	maskImageView = cocostudio.getUIImageView(view, "maskImageView");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	initView()
	if UserPos == 1 then
		--下家
		panel:setPosition(ccp(710, 110))
	elseif UserPos == 2 then
		--上家
		panel:setPosition(ccp(50, 110))
	end
	LordGamePub.showDialogAmin(panel)

	img_useravator:setVisible(false);
	img_ttdj:setVisible(false);
	initButtonDinamic(); --动态初始化按钮
end


function requestMsg()

end

local function closeCallBack()
	mvcEngine.destroyModule(GUI_TABLE_OTHER_USER_INFO)
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

function callback_btn_jubao(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--设置举报需要用到的信息
		local playerInfo = TableConsole.getPlayerPosByUserID(UserID)
		local dataTable = {}
		--被举报用户ID
		dataTable["playerID"] = playerInfo["m_nUserID"]
		--被举报用户昵称
		dataTable["userName"] = playerInfo["m_sNickName"]
		--比赛实例ID
		dataTable["matchInstanceID"] = TableConsole.m_sMatchInstanceID
		--举报事件
		dataTable["time"] = Common.getServerTime() * 1000
		TableReportLogic.initReportInfo(dataTable)
		mvcEngine.createModule(GUI_TABLE_REPORT)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_dazhaohu(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendDBID_V2_SAY_HELLO(UserID)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_faxiaoxi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--来自大厅聊天
		if jumpfromflag == FROM_HALLCHATTING then
			Common.log("otherUserNickName=" .. otherUserNickName);
			if otherUserNickName ~= nil then
				MessagePlayerLogic.setConversationID(3,otherUserNickName)
			end
			mvcEngine.createModule(GUI_MESSAGEPLAYER)
			--end
			--来自站内信
		elseif jumpfromflag == FROM_MAIL then
			sendDBID_SHIELD_MAIL_USERID(UserID,isClose)
			--			Common.log("aab消息出去UserID=" .. UserID)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--界面跳转标记
--@param number fromflag 跳转标记
--]]
function setFromFlag(fromflag)
	jumpfromflag = fromflag;
end

--打招呼
local function getSayHello()
	local hellotable = profile.Message.getSayHello()
	Common.showToast(hellotable["Msg"], 2)
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
		img_useravator:setVisible(true);
	end
end

--[[--
--设置用户位置
--]]
function setUserPos(pos)
	UserPos = pos;
end

--[[--
--设置其他玩家数据
--@param #number nUserID 用户ID
--]]
function setOtherUserInfo(nUserID)
	UserID = nUserID;
	sendDBID_USER_INFO(nUserID)
end

local function updataOtherUserInfo()

	local otherInfo  = {}
	otherInfo = profile.User.getOtherUserInfo()
	UserID = otherInfo.UserID;
	if otherInfo.PhotoUrl ~= nil and otherInfo.PhotoUrl ~= "" then
		Common.getPicFile(otherInfo.PhotoUrl, 0, true, updataUserPhoto)
	else
		img_useravator:loadTexture(Common.getResourcePath("hall_portrait_default.png"))
		img_useravator:setVisible(true);
	end
	otherUserNickName = otherInfo.NickName;
	lab_nickname:setText("" .. otherUserNickName)--用户名称
	local VipLevel = otherInfo.VipLevel
	local vipType = VIPPub.getUserVipType(VipLevel)
	lab_vipnum:setStringValue(""..vipType)
	lab_vipnum:setVisible(true)
	if vipType >= VIPPub.VIP_1 then
--		lab_vipnum:setStringValue(""..vipType)
		img_vipbg:loadTexture(Common.getResourcePath("hall_vip_icon.png"));
--		lab_vipnum:setVisible(true)
		Image_notvip:setVisible(false);--非vip不可视
		Image_vip:setVisible(true);--如果牌桌的其他玩家是vip则vip背景可视
		maskImageView:setVisible(false)
		ImageView_coin:setVisible(false)
		Image_sign:setVisible(false)
		lab_sign:setColor(ccc3(92,59,42))
		lab_nickname:setColor(ccc3(92,59,42))
		lab_coin:setColor(ccc3(92,59,42))
		lab_address:setColor(ccc3(92,59,42))
		lab_birthday:setColor(ccc3(92,59,42))
	else
		img_vipbg:loadTexture(Common.getResourcePath("hall_vip_icon_no.png"));
--		lab_vipnum:setVisible(false)
		Image_notvip:setVisible(true);--如果牌桌的其他玩家不是vip则非vip背景可视
		Image_vip:setVisible(false);--vip不可视
		maskImageView:setVisible(true)
	end
	--	local strSex = " ";
	if (otherInfo.Sex == 1 or otherInfo.Sex == 0) then
		--		strSex = "男";
		Image_gender:loadTexture(Common.getResourcePath("male.png"));
--		Common.log("zbl...男")
	elseif (otherInfo.Sex == 2) then
		--		strSex = "女";
		Image_gender:loadTexture(Common.getResourcePath("female.png"));
--		Common.log("zbl...女")
	end
	local strAge = "保密";
	if (otherInfo.Age > 0) then
		strAge = otherInfo.Age .. "岁";
	end
	lab_birthday:setText(strAge)--年龄
	if otherInfo.sign == nil or otherInfo.sign== "" then
		lab_sign:setText("这个家伙很懒,什么都没有留下")--签名"
	else
		lab_sign:setText(""..otherInfo.sign)--签名
	end
--	Common.log("zblllll.....sign == " .. otherInfo.sign)
	lab_address:setText(""..otherInfo.City)--来自地区
	iv_coin:loadTexture(Common.getResourcePath("ic_hall_recharge_jinbi.png"));--筹码图标
	lab_coin:setText(""..otherInfo.Coin)--筹码
	iv_coin:loadTexture(Common.getResourcePath("ic_hall_recharge_jinbi.png"));--筹码图标

	local duanwei = otherInfo.ladderDuan
	local level = otherInfo.ladderLevel
	local ttjf = otherInfo.ladderScore--天梯积分
	local nextttjf = otherInfo.ladderUpScore--下一级需要积分
	img_ttdj:loadTexture(Common.getResourcePath(profile.TianTiData.getDuanWeiImage(duanwei)));
	LabelAtlas_tt_level:setStringValue(""..level)
	img_ttdj:setVisible(true);
end

--[[--举报消息回来后弹出Toast结果]]
local function showReportResult()
	local resultText = profile.TableReport.getReportResultText()
	if resultText ~= nil then
		Common.showToast(resultText, 2)
	end
end

--[[--屏蔽站内信消息回来后弹出Toast结果]]
local function showCloseMessage()
	ColseMessageTable = profile.Message.getCloseMsg()
	local isSucceed = ColseMessageTable["result"]
	local msg = ColseMessageTable["resultMsg"]
	--	Common.log("aab消息回来result=" .. isSucceed)
	if isSucceed == 0 then --成功
		isClose = (isClose + 1) % 2
		if isClose == 0 then  --没有屏蔽
			ImageView_faxiaoxi:loadTexture(Common.getResourcePath("ui_hall_chat_pinbi.png"));
		elseif isClose == 1 then --已经屏蔽
			ImageView_faxiaoxi:loadTexture(Common.getResourcePath("ui_qixiaopingbi.png"));
		end
		MessagePlayerLogic.isCloseMessageFlag = isClose
	else --失败

	end
	--	Common.log("aab消息回来resultmsg=" .. ColseMessageTable["resultMsg"])
	--	Common.log("aab屏蔽状态" .. MessagePlayerLogic.isCloseMessageFlag)
	Common.showToast(msg, 2)

end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	ColseMessageTable = {}
end

function addSlot()
	framework.addSlot2Signal(DBID_USER_INFO, updataOtherUserInfo)
	framework.addSlot2Signal(DBID_V2_SAY_HELLO, getSayHello)
	framework.addSlot2Signal(MANAGERID_PLAYER_REPORT,showReportResult)
	framework.addSlot2Signal(DBID_SHIELD_MAIL_USERID,showCloseMessage)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_USER_INFO, updataOtherUserInfo)
	framework.removeSlotFromSignal(DBID_V2_SAY_HELLO, getSayHello)
	framework.removeSlotFromSignal(MANAGERID_PLAYER_REPORT,showReportResult)
	framework.addSlot2Signal(DBID_SHIELD_MAIL_USERID,showCloseMessage)
end
