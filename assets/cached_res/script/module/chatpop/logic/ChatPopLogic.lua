module("ChatPopLogic",package.seeall)

view = nil

panel = nil
--表情，常用语，聊天记录 切换按钮
iv_tab_biaoqing = nil;
iv_tab_common = nil;
iv_tab_log = nil;
--表情，常用语，聊天记录 布局
panel_biaoqing = nil;
panel_common = nil;
panel_log = nil;
img_bq_gj = nil;
img_bq = nil;
img_bq_common = nil;
img_common = nil;
img_log = nil;
--普通表情，高级表情 切换按钮
iv_biaoqing_tab_common = nil;
iv_biaoqing_tab_superior = nil;
--普通表情，高级表情  布局
panel_biaoqing_common = nil;
panel_biaoqing_superior = nil;
panel_goumai = nil;

btn_buygaoji = nil--购买高级表情包
--常用语
tv_common = {}

--输入框（常用语界面，日志界面）
et_msg_common = nil;--常用语输入框(用于输入)
label_msg_common = nil;--常用语输入框(用于显示)

et_msg_log = nil; --日志界面输入框(用于输入)
label_msg_log = nil; --日志界面输入框(用于显示)


-- 聊天语的数目
local COMMON_CHAT_NUM = 12
local defaultChatScrollHeight = 236

--日志scrollview
sv_log = nil;
--按钮
btn_close = nil;
btn_sendmsg_common = nil;
btn_sendmsg_log = nil;

local tableChatCommonText = {}
tableChatCommonText[1] = "大家好！给各位请安啦~"
tableChatCommonText[2] = "这牌你也敢叫地主？简直是自寻死路！"
tableChatCommonText[3] = "喂！你倒是快点啊！"
tableChatCommonText[4] = "拖时间是没用滴！"
tableChatCommonText[5] = "出啊，好牌都留着下蛋啊！"
tableChatCommonText[6] = "不怕神一样的对手，就怕猪一样的队友。"
tableChatCommonText[7] = "你很啰嗦耶，安静打牌好不？"
tableChatCommonText[8] = "别崇拜哥，哥只是个传说~"
tableChatCommonText[9] = "和你合作真是太愉快了！"
tableChatCommonText[10] = "不好意思各位，我要先走一步了！"
tableChatCommonText[11] = "这把牌实在太烂了…"
tableChatCommonText[12] = "牌好，心情就好！"
local lastTabState = 1 -- 最后显示的tab状态 1表情，2常用语，3聊天记录
local lastBiaoqingState = 1 -- 最后显示的表情tab状态 1普通表情，2高级表情

local chatLog = {}--存放聊天记录

local send_chat_superior_position = -1 -- 点击发送的高级表情包的位置
local hasGaojiEmtionBag = false

btn_bq_superior = {}
btn_bq_common = {}
currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--获取聊天记录
--@return #table 聊天记录
--]]
function getChatLog()
	return chatLog;
end

--[[--
--清空聊天记录
--]]
function clearChatList()
	if sv_log ~= nil then
		sv_log:removeAllChildren();
	end
	chatLog = {};
end

--[[--
--更新聊天记录
--]]
function upDataChatListToScrollView()
	if sv_log == nil then
		return;
	end
	local cellWidth = 800
	local currentHeight = 0
	-- 滚动区域的高度
	local chatScrollInnerHeight = 0
	local labelMsgTable = {}
	local buttonTable = {}
	local imageDividerTable = {}

	sv_log:removeAllChildren();

	for i=1, #chatLog do
		local labelMsg = ccs.label({
			text = chatLog[i].nickName..":"..chatLog[i].msg,
		})
		labelMsg:setAnchorPoint(ccp(0,0))
		labelMsg:setFontSize(25)
		table.insert(labelMsgTable, labelMsg)

		--按钮
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, labelMsg:getContentSize().height + 20),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)

				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					et_msg_log:setText(chatLog[i].msg)
					label_msg_log:setText(chatLog[i].msg)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
				end,
			}
		})
		button:setAnchorPoint(ccp(0,0))
		table.insert(buttonTable, button)

		--分割线
		local imageDivider = ccs.image({
			image = Common.getResourcePath("di_room_2level_face.png"),
		})
		imageDivider:setAnchorPoint(ccp(0,0))
		imageDivider:setTextureRect(CCRectMake(0,0,cellWidth,2))
		table.insert(imageDividerTable, imageDivider)

		chatScrollInnerHeight = chatScrollInnerHeight + labelMsg:getContentSize().height + 20
	end
	-- 加入聊天列表并设置位置
	for i = #chatLog, 1, -1 do
		if chatScrollInnerHeight < defaultChatScrollHeight then
			chatScrollInnerHeight = defaultChatScrollHeight
		end
		currentHeight = currentHeight + labelMsgTable[i]:getContentSize().height + 20
		SET_POS(imageDividerTable[i],20,chatScrollInnerHeight-currentHeight)
		SET_POS(buttonTable[i],20,chatScrollInnerHeight-currentHeight)
		SET_POS(labelMsgTable[i],20,chatScrollInnerHeight-currentHeight+10)
		sv_log:addChild(labelMsgTable[i])
		sv_log:addChild(buttonTable[i])
		sv_log:addChild(imageDividerTable[i])
	end
	sv_log:setInnerContainerSize(CCSizeMake(cellWidth,currentHeight))
end

local function initView()
	iv_tab_biaoqing = cocostudio.getUIImageView(view,"iv_tab_biaoqing")
	iv_tab_common = cocostudio.getUIImageView(view,"iv_tab_common")
	iv_tab_log = cocostudio.getUIImageView(view,"iv_tab_log")
	iv_biaoqing_tab_common = cocostudio.getUIImageView(view,"iv_biaoqing_tab_common")
	iv_biaoqing_tab_superior = cocostudio.getUIImageView(view,"iv_biaoqing_tab_superior")

	panel_biaoqing = cocostudio.getUITextField(view,"panel_biaoqing")
	panel_common = cocostudio.getUITextField(view,"panel_common")
	panel_log = cocostudio.getUITextField(view,"panel_log")
	panel_biaoqing_common = cocostudio.getUITextField(view,"panel_biaoqing_common")
	panel_biaoqing_superior = cocostudio.getUITextField(view,"panel_biaoqing_superior")
	panel_goumai = cocostudio.getUIPanel(view,"panel_goumai")
	--img_bq_gj,img_bq,img_bq_common,img_common,img_log
	img_bq_gj = cocostudio.getUIImageView(view,"img_bq_gj")
	img_bq = cocostudio.getUIImageView(view,"img_bq")
	img_bq_common = cocostudio.getUIImageView(view,"img_bq_common")
	img_common = cocostudio.getUIImageView(view,"img_common")
	img_log = cocostudio.getUIImageView(view,"img_log")
	--按钮
	btn_close = cocostudio.getUIButton(view, "btn_close")
	btn_sendmsg_common = cocostudio.getUIButton(view, "btn_sendmsg_common")
	btn_sendmsg_log = cocostudio.getUIButton(view, "btn_sendmsg_log")
	btn_buygaoji = cocostudio.getUIButton(view, "btn_buygaoji")
	initButton()

	for i=1,COMMON_CHAT_NUM do
		if (i < 10) then
			tv_common[i] = cocostudio.getUILabel(view,"tv_common_0"..i)
		else
			tv_common[i] = cocostudio.getUILabel(view,"tv_common_"..i)
		end
		tv_common[i]:setText(tableChatCommonText[i])
	end

	et_msg_common = cocostudio.getUITextField(view,"et_msg_common")
	et_msg_common:setVisible(false);
	label_msg_common = cocostudio.getUILabel(view,"Label_msg_common")
	et_msg_log = cocostudio.getUITextField(view,"et_msg_log")
	et_msg_log:setVisible(false);
	label_msg_log = cocostudio.getUILabel(view,"Label_msg_log")
	sv_log = cocostudio.getUIScrollView(view, "sv_log")

	upDataChatListToScrollView()


	--屏蔽之前的输入框
	et_msg_common:setTouchEnabled(false)
	et_msg_log:setTouchEnabled(false)

	label_msg_common:setTouchEnabled(false)
	label_msg_log:setTouchEnabled(false)


	label_msg_common:setVisible(false)
	label_msg_log:setVisible(false)

	--聊天内输入框
	createChatEditor()
end

function createChatEditor()
	local function editBoxTextEventHandle(strEventName,pSender)
		 local edit = tolua.cast(pSender,"CCEditBox")
		 local strFmt
		 if strEventName == "began" then
		 elseif strEventName == "ended" then
		 elseif strEventName == "changed" then
		 elseif strEventName == "return" then
		 end
	end

 	--聊天输入框
 	local editBoxSize = CCSizeMake(362, 46)
    edit_chat_common = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_chat_common:setPosition(ccp(291, 394))
    edit_chat_common:setAnchorPoint(ccp(0,0))
    edit_chat_common:setFont("微软雅黑", 22)
    edit_chat_common:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_chat_common:setPlaceHolder("")
    edit_chat_common:setMaxLength(32)
    edit_chat_common:setReturnType(kKeyboardReturnTypeDone)
    edit_chat_common:setInputMode(kEditBoxInputModeSingleLine);

	edit_chat_common:registerScriptEditBoxHandler(editBoxTextEventHandle)
    view:addChild(edit_chat_common)

    --记录内发送
    edit_chat_log = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
    edit_chat_log:setPosition(ccp(291, 394))
    edit_chat_log:setAnchorPoint(ccp(0, 0))
    edit_chat_log:setFont("微软雅黑", 22)
    edit_chat_log:setFontColor(ccc3(0xB3, 0x9C, 0x77))
    edit_chat_log:setPlaceHolder("")
    edit_chat_log:setMaxLength(32)
    edit_chat_log:setReturnType(kKeyboardReturnTypeDone)
    edit_chat_log:setInputMode(kEditBoxInputModeSingleLine);

	edit_chat_log:registerScriptEditBoxHandler(editBoxTextEventHandle)
    view:addChild(edit_chat_log)
end


function initButton()
	--高级表情
	for i=1,12 do
		btn_bq_superior[i] = cocostudio.getUIButton(view,"btn_bq_superior_"..i)
	end
	for i=1,24 do
		btn_bq_common[i] = cocostudio.getUIButton(view, "btn_bq_common_"..i)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ChatPop.json")
	local gui = GUI_CHATPOP
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
	initView()

	if GameConfig.gameIsFullPackage() then
		lastTabState = 1
	else
		lastTabState = 2
	end

	switchTab(lastTabState)
end

function requestMsg()

end

--表情
local TAB_BIAOQING = 1
--常用语
local TAB_COMMON = 2
--聊天记录
local TAB_LOG = 3
--切换界面
-- 选中的时候的颜色FF999B
local selectedLabelColor = {1, 185, 255}
-- 没选中的时候的颜色01b9ff
local notSelectedLabelColor = {255, 153, 155}

function switchTab(tabId)
	if not GameConfig.gameIsFullPackage() then
		if tabId == TAB_BIAOQING then
			Common.showToast("资源加载中，请稍候…",2)
			return
		end
	end
	if tabId == TAB_BIAOQING then
		edit_chat_common:setVisible(false)
		edit_chat_log:setVisible(false)

		iv_tab_biaoqing:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian1.png"))
		iv_tab_common:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))
		iv_tab_log:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))

		panel_biaoqing:setVisible(true)
		panel_common:setVisible(false)
		panel_log:setVisible(false)
		panel_biaoqing:setZOrder (2)
		panel_common:setZOrder (1)
		panel_log:setZOrder (1)

		panel_biaoqing:setTouchEnabled(true)
		panel_common:setTouchEnabled(false)
		panel_log:setTouchEnabled(false)
		setSuperiorButton(true)
		setCommonButton(true)

		img_common:loadTexture(Common.getResourcePath("ui_room_2level_language_btn.png"))
		img_log:loadTexture(Common.getResourcePath("ui_room_2level_chatrecord_btn.png"))
		img_bq:loadTexture(Common.getResourcePath("ui_room_2level_face_btn2.png"))
		lastTabState = TAB_BIAOQING

		switchBiaoqingTab(lastBiaoqingState)
	elseif tabId == TAB_COMMON then
		edit_chat_common:setVisible(true)
		edit_chat_log:setVisible(false)

		iv_tab_common:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian1.png"))
		iv_tab_biaoqing:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))
		iv_tab_log:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))

		panel_common:setVisible(true)
		panel_biaoqing:setVisible(false)
		panel_log:setVisible(false)
		panel_biaoqing:setZOrder (1)
		panel_common:setZOrder (2)
		panel_log:setZOrder (1)

		panel_biaoqing:setTouchEnabled(false)
		panel_common:setTouchEnabled(true)
		panel_log:setTouchEnabled(false)
		setSuperiorButton(false)
		setCommonButton(false)

		img_common:loadTexture(Common.getResourcePath("ui_room_2level_language_btn2.png"))
		img_log:loadTexture(Common.getResourcePath("ui_room_2level_chatrecord_btn.png"))
		img_bq:loadTexture(Common.getResourcePath("ui_room_2level_face_btn.png"))
		lastTabState = TAB_COMMON
	elseif tabId == TAB_LOG then
		edit_chat_common:setVisible(false)
		edit_chat_log:setVisible(true)

		iv_tab_log:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian1.png"))
		iv_tab_biaoqing:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))
		iv_tab_common:loadTexture(Common.getResourcePath("btn_liaotianbiaoqian0.png"))

		panel_log:setVisible(true)
		panel_biaoqing:setVisible(false)
		panel_common:setVisible(false)
		panel_biaoqing:setZOrder (1)
		panel_common:setZOrder (1)
		panel_log:setZOrder (2)

		panel_biaoqing:setTouchEnabled(false)
		panel_common:setTouchEnabled(false)
		panel_log:setTouchEnabled(false)
		setSuperiorButton(false)
		setCommonButton(false)

		--img_bq_gj,img_bq_common,    img_common,img_log,img_bq
		img_common:loadTexture(Common.getResourcePath("ui_room_2level_language_btn.png"))
		img_log:loadTexture(Common.getResourcePath("ui_room_2level_chatrecord_btn2.png"))
		img_bq:loadTexture(Common.getResourcePath("ui_room_2level_face_btn.png"))
		lastTabState = TAB_LOG
	end
end


--普通表情
local TAB_BQ_COMMON = 1
--高级表情
local TAB_BQ_SUPERIOR = 2
function switchBiaoqingTab(tabId)
	if tabId == TAB_BQ_COMMON then
		iv_biaoqing_tab_common:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		iv_biaoqing_tab_superior:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))

		panel_biaoqing_common:setVisible(true)
		panel_biaoqing_superior:setVisible(false)
		panel_goumai:setVisible(false)
		panel_biaoqing_common:setZOrder(2)
		panel_biaoqing_superior:setZOrder(1)
		panel_goumai:setZOrder(1)
		setSuperiorButton(false)
		setCommonButton(true)

		img_bq_common:loadTexture(Common.getResourcePath("ui_room_2level_face_btn_moren2.png"))
		img_bq_gj:loadTexture(Common.getResourcePath("ui_room_2level_face_btn_gaoji.png"))

		lastBiaoqingState = TAB_BQ_COMMON
	elseif tabId == TAB_BQ_SUPERIOR then
		iv_biaoqing_tab_superior:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		iv_biaoqing_tab_common:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))

		panel_biaoqing_common:setVisible(false)
		panel_biaoqing_common:setZOrder(1)

		if superiorFaceEnable() then
			--有高级表情包
			setSuperiorButton(true)
			setCommonButton(false)
			panel_biaoqing_superior:setVisible(true)
			panel_goumai:setVisible(false)
			panel_biaoqing_superior:setZOrder(2)
			panel_goumai:setZOrder(1)
		else
			--没有
			setSuperiorButton(false)
			setCommonButton(false)
			panel_biaoqing_superior:setVisible(false)
			panel_goumai:setVisible(true)
			panel_biaoqing_superior:setZOrder(1)
			panel_goumai:setZOrder(2)
		end

		img_bq_common:loadTexture(Common.getResourcePath("ui_room_2level_face_btn_moren.png"))
		img_bq_gj:loadTexture(Common.getResourcePath("ui_room_2level_face_btn_gaoji2.png"))

		lastBiaoqingState = TAB_BQ_SUPERIOR
	end
end

function setSuperiorButton(flag)
	for i=1,12 do
		Common.setButtonVisible(btn_bq_superior[i],flag)
	end

end
function setCommonButton(flag)
	for i=1,24 do
		Common.setButtonVisible(btn_bq_common[i],flag)
	end

end
local function sendChatEmotion(type,msg)
	sendLORDID_CHAT_MSG(TableConsole.m_sMatchInstanceID,type,msg)
	close()
end

-- 清除缓存的高级表情
function clearSendChatSuperiorPosition()
	send_chat_superior_position = -1
end

-- 得到缓存的高级表情
function getSendChatSuperiorPosition()
	return send_chat_superior_position
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
function close()
	LordGamePub.closeDialogAmin(panel,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_CHATPOP)
end

function callback_iv_tab_biaoqing(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		switchTab(TAB_BIAOQING)
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_iv_tab_common(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		switchTab(TAB_COMMON)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_iv_tab_log(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		switchTab(TAB_LOG)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_iv_biaoqing_tab_common(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		switchBiaoqingTab(TAB_BQ_COMMON)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_iv_biaoqing_tab_superior(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		switchBiaoqingTab(TAB_BQ_SUPERIOR)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_0")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`011`")
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`010`")
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_1")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`019`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_2")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`003`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_5(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_3")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`016`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_6(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_0_1")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`006`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_7(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_4")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`007`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_8(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_1_2")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`005`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_9(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_2_3")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`008`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_10(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_3_4")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`014`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_11(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_128)")--Image_126_0_1_2
--		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`022`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_12(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_4_5")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`024`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_13(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_1_2_3")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`004`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_14(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_2_3_4")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`012`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_15(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_3_4_5")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`018`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_16(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_0_1_2_3")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`020`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_17(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_4_5_6")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`002`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_18(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_1_2_3_4")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`015`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_19(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_2_3_4_5")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`023`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_20(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_3_4_5_6")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`017`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_21(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_0_1_2_3_4")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`021`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_22(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_4_5_6_7")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`013`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_23(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_1_2_3_4_5")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`001`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_common_24(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local bg = cocostudio.getUIImageView(view,"Image_126_2_3_4_5_6")
		bg:loadTexture(Common.getResourcePath("table.png"));
		sendChatEmotion(TableConsole.TYPE_CHAT_FACE,"`009`")
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#005#")
		else
			send_chat_superior_position = 0
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#011#")
		else
			send_chat_superior_position = 1
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#008#")
		else
			send_chat_superior_position = 2
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#007#")
		else
			send_chat_superior_position = 3
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_5(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#009#")
		else
			send_chat_superior_position = 4
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_6(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#010#")
		else
			send_chat_superior_position = 5
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_7(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#003#")
		else
			send_chat_superior_position = 6
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_8(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#004#")
		else
			send_chat_superior_position = 7
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_9(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#002#")
		else
			send_chat_superior_position = 8
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_10(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#006#")
		else
			send_chat_superior_position = 9
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_11(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#001#")
		else
			send_chat_superior_position = 10
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_bq_superior_12(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if superiorFaceEnable() then
			sendChatEmotion(TableConsole.TYPE_CHAT_FACE_SUPERIOR,"#012#")
		else
			send_chat_superior_position = 11
			showTableGoodBuySuperiorBiaoqingPop()
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_tv_common_1(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_1"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_1"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[1])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_1"):setScale(1)
	end

end

function callback_tv_common_2(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_2"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_2"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[2])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_2"):setScale(1)
	end


end

function callback_tv_common_3(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_3"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_3"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[3])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_3"):setScale(1)
	end
end

function callback_tv_common_4(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_4"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_4"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[4])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_4"):setScale(1)
	end

end

function callback_tv_common_5(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_5"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_5"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[5])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_5"):setScale(1)
	end

end

function callback_tv_common_6(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_6"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_6"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[6])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_6"):setScale(1)
	end

end

function callback_tv_common_7(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_7"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_7"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[7])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_7"):setScale(1)
	end

end

function callback_tv_common_8(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_8"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_8"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[8])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_8"):setScale(1)
	end

end

function callback_tv_common_9(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_9"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_9"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[9])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_9"):setScale(1)
	end

end

function callback_tv_common_10(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_10"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_10"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[10])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_10"):setScale(1)
	end

end

function callback_tv_common_11(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_11"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_11"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[11])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0_11"):setScale(1)
	end

end

function callback_tv_common_12(component)
	if component == PUSH_DOWN then
		--按下
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0"):setScale(1.1)
	elseif component == RELEASE_UP then
		--抬起
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0"):setScale(1)
		sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,tableChatCommonText[12])
	elseif component == CANCEL_UP then
		--取消
		--cocostudio.getComponent(ChatPopLogic.view,"ImageView_184_0"):setScale(1)
	end

end

--发送按钮
function callback_btn_sendmsg_common(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local sendChat = edit_chat_common:getText();   --label_msg_common:getStringValue()
		if (sendChat ~= "") then
			sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,sendChat)
			et_msg_common:setText("")
			label_msg_common:setText("")
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_sendmsg_log(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local sendChat = edit_chat_log:getText(); --label_msg_log:getStringValue()
		if (sendChat ~= "") then
			sendChatEmotion(TableConsole.TYPE_CHAT_TEXT,sendChat)
			et_msg_log:setText("")
			label_msg_log:setText("")
		end
	elseif component == CANCEL_UP then
	--取消
	end

end

function callback_btn_buygaoji(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if ServerConfig.getQuickPayIsShow() then
			if Common.getOperater() == Common.UNKNOWN then
				--非短代支付
				CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_biaoqing_GuideTypeID, 0, RechargeGuidePositionID.TablePositionD)
			else
				--短代支付，直接调用SDK
				local PaymentTable = QuickPay.getPaymentTable(QuickPay.Pay_Guide_biaoqing_GuideTypeID, 0, 0, true)
				QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, RechargeGuidePositionID.TablePositionD, 0)
			end
		else
			Common.showToast("您的道具已耗尽，请前往‘商城’购买!", 2);
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--是否可用高级表情
function superiorFaceEnable()
	if tonumber(GameConfig.remainSuperiorFaceTime) > 0 then
		return true
	else
		return false
	end
end

-- 显示购买高级表情包界面
function showTableGoodBuySuperiorBiaoqingPop()
	close()
	--Common.showToast("购买高级表情包", 2)
	--mvcEngine.createModule(GUI_TABLEGOODBUYPOP)
	--TableGoodsBuyPopLogic.setGoodsInfo(QuickPay.Pay_Guide_biaoqing_GuideTypeID,RechargeGuidePositionID.TablePositionD)
end

--[[--
--ios输入框回调
--]]
function callbackInputForIos(valuetable)
	--控件不能为空
	if currentTxtInput == nil or currentTxtShow == nil then
		return;
	end

	local value = valuetable["value"];
	--输入数据为空, return
	if value == nil or value == "" then
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	currentTxtInput:setText(value);
	currentTxtShow:setText(value);
end

--[[--
--常用语输入框(ios)
--]]
function callback_et_msg_common_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = et_msg_common;
		currentTxtShow = label_msg_common;
		Common.showAlertInput(et_msg_common:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--常用语输入框(Android)
--]]
function callback_et_msg_common()
	--控件不存在,return
	if label_msg_common == nil then
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	if et_msg_common:getStringValue() ~= nil and et_msg_common:getStringValue() ~= "" then
		label_msg_common:setText(et_msg_common:getStringValue());
	end
end

--[[--
--日志界面输入框(ios)
--]]
function callback_et_msg_log_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = et_msg_log;
		currentTxtShow = label_msg_log;
		Common.showAlertInput(et_msg_log:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--日志界面输入框(Android)
--]]
function callback_et_msg_log()
	--控件不存在,return
	if label_msg_log == nil then
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	if et_msg_log:getStringValue() ~= nil and et_msg_log:getStringValue() ~= "" then
		label_msg_log:setText(et_msg_log:getStringValue());
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
