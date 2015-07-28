module("HallChatLogic", package.seeall)

view = nil
layer = nil
btn_dismiss = nil
chat_send_bg = nil
showUserInfoFlag = false -- 显示用户信息标志
isSystemMessage = false
systemMessage = nil

hall_panel13 = nil;

local ID_FRUIT_MACHINE = 102;--老虎机GameID
local ID_JIN_HUANG_GUAN = 103;--金皇冠GameID
local ID_WAN_REN_JIN_HUA = 104;--万人金花GameID
local ID_WAN_REN_FRUIT_MACHINE = 105;--万人水果派
local ID_JIN_HUA = 106;--扎金花
local hall_chat_bg = nil;
local hall_chat_panel = nil --聊天面板
local hallChatScrollView = nil
local chatListWidth = nil -- listview大小
local chatListHeight = nil
local chatMaxCount = 30 -- 聊天最大条数
local chatListInnerHeight = 0
local currentHeight = 0
local chatTextTable = {} -- 聊天记录
local chatTableAction = nil --Actionid
local chatLayoutTable = {} -- 存放聊天item布局，及布局信息(高度，位置)

local firstChangeChatListPosFlag = true -- 第一次改变聊天记录位置标记
--local changeHallChatTextFieldPositionThreadId; -- 改变聊天输入框文字位置的任务id
local scrollChatUIToBottomThreadId; -- 将聊天滚动到最后一条的任务id

local chatTextFeild = nil;--聊天输入文字(用于输入)
local hall_chat_label = nil;--聊天输入文字(用于显示)
local hall_chat_edit_bg; -- 输入框的父控件
local reqUserId; -- 请求的用户信息的用户id

local isChatViewShowing = false -- 聊天框是否在显示中
local notSendText -- 玩家编辑未发送的文字
local removeLayoutHeight = 0 -- 要移除的聊天的高度

function onKeypad(event)
	if event == "backClicked" then
		closeChatPanel()
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("HallChat.json")
	local gui = GUI_HALLCHAT
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	isChatViewShowing = true
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)
	initChatInputBox();  --聊天输入框
	initChatTextFeild()
	initHallChatScrollView()

	hall_chat_bg = cocostudio.getUIImageView(view,"hall_chat_bg")
	hall_chat_panel = cocostudio.getUIImageView(view,"hall_chat_panel")
	hall_chat_panel:setPosition(ccp(-btn_dismiss:getPosition().x+btn_dismiss:getContentSize().width,0))
	hall_chat_panel:runAction(CCMoveTo:create(0.3,ccp(0,0)))
	isSystemMessage = false
	getChatData()

	hall_chat_panel:setTouchEnabled(false)
	hall_chat_bg:setTouchEnabled(false)


end

function initChatTextFeild()
	hall_panel13 = cocostudio.getUIButton(view, "Panel_13")
	btn_dismiss = cocostudio.getUIButton(view, "hall_chat_dimiss_btn")
	chat_send_bg = cocostudio.getUIButton(view, "hall_chat_send_bg")
	hall_chat_edit_bg = cocostudio.getUITextField(view, "hall_chat_edit_bg")
	hall_chat_label = cocostudio.getUILabel(view, "hall_chat_label")
	chatTextFeild = cocostudio.getUITextField(view, "hall_chat_edittext")
	chatTextFeild:setVisible(false)

	if (notSendText ~= "") then
		chatTextFeild:setText(notSendText);
		hall_chat_label:setText(notSendText)
		edit_hall_chat:setText(notSendText)
	end

	--弃用
	hall_panel13:setTouchEnabled(false);  --输入框的父节点
	chatTextFeild:setTouchEnabled(false);
	chatTextFeild:setVisible(false);
	hall_chat_edit_bg:setTouchEnabled(false);
	hall_chat_label:setTouchEnabled(false);
end

function initChatInputBox()
	local editBoxSize = CCSizeMake(532, 46)
	edit_hall_chat = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1-1.png")))
	edit_hall_chat:setPosition(ccp(36, 29))
	edit_hall_chat:setAnchorPoint(ccp(0, 0))
	edit_hall_chat:setFont("微软雅黑", 30)
	edit_hall_chat:setFontColor(ccc3(0xF9, 0xEB, 0xDB))
	edit_hall_chat:setPlaceHolder("")
	edit_hall_chat:setReturnType(kKeyboardReturnTypeDone)
	edit_hall_chat:setInputMode(kEditBoxInputModeSingleLine);
	view:addChild(edit_hall_chat, 10)
end

function initHallChatScrollView()
	hallChatScrollView = cocostudio.getUIScrollView(view, "hall_chat_list")
	chatListWidth = hallChatScrollView:getContentSize().width
	chatListHeight = hallChatScrollView:getContentSize().height
end

--[[发送进入聊天室]]
function sendEnterChatRoom()
	local dataTable = {}
	dataTable["NickName"] = profile.User.getSelfNickName()
	dataTable["IsFirstEnter"] = 1
	dataTable["ChatRoomName"] = ""
	Common.log("发送进入聊天室"..profile.User.getSelfNickName())
	sendIMID_ENTER_CHAT_ROOM(dataTable);
end

--获取聊天数据
function getChatData()
	local chatTableSize = #chatTextTable
	if (chatTableSize ~= 0) then
		showChatScrollViewByCachData()
		--scrollChatUIToBottomThreadId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(chatScrollToBottomTimer, 0.1, false)
	else
		sendEnterChatRoom()
	end
end

--滚动到底部
function chatScrollToBottomTimer()
	hallChatScrollView:scrollToBottom(0.1, false)
	--CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scrollChatUIToBottomThreadId)
end

--[[改变聊天内容的位置]]
function changeChatItemViewLocation()
	local chatLayoutTableSize = #chatLayoutTable
	if (chatLayoutTableSize >= chatMaxCount) then
		removeLayoutHeight = chatLayoutTable[1].height + 15;
		hallChatScrollView:removeChild(chatLayoutTable[1].layout)
		table.remove(chatLayoutTable, 1)
		chatLayoutTableSize = #chatLayoutTable
	end

	-- 内部滚动区域高度大于滚动布局高度
	if (chatListInnerHeight > chatListHeight) then
		if (chatLayoutTable[chatLayoutTableSize] ~= nil) then
			local disHeight = chatLayoutTable[chatLayoutTableSize].height + 15;
			for i = 1, chatLayoutTableSize - 1 do
				if (chatLayoutTable[i] ~= nil) then
					local positionY = chatLayoutTable[i].positionY + disHeight
					if (firstChangeChatListPosFlag) then
						positionY = positionY + disHeight - 30 ;
					end
					SET_POS(chatLayoutTable[i].layout, 0, positionY)
					chatLayoutTable[i].positionY = positionY
				end
			end
			firstChangeChatListPosFlag = false
		end
	end
end

--[[将聊天text加入scrollview中]]
function addNewChatItemToScrollView(chatTable)
	local chatText = "";
	local labelName;
	local vipLayout = nil;
	local numVipLevel = VIPPub.getUserVipType(chatTable["VipLevel"]);
	if numVipLevel > 0 then
		vipLayout = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("dot.png"),
			size = CCSizeMake(88, 17),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		vipLayout:setScale9Enabled(true);
		if chatTable["ActionId"] ~= nil and chatTable["ActionId"] ~= 0 then
			chatText = "[" .. chatTable["SpeakerNickName"] .. "]：" .. chatTable["SpeechText"] .. "  点这里强势进入!"
			chatTableAction = chatTable["ActionId"]
		else
			chatText = "[..............." .. chatTable["SpeakerNickName"] .. "]：" .. chatTable["SpeechText"]
		end
		local vipIcon = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("hall_vip_icon.png"),
		});
		local vipLevel = ccs.labelAtlas({
			text = numVipLevel,
			image = Common.getResourcePath("num_vip_level.png"),
			start = "0",
			w = 12,
			h = 19,
		})
		vipIcon:setPosition(ccp(0, 15));
		vipIcon:setAnchorPoint(ccp(0, 0.5));
		vipLevel:setPosition(ccp(63, 15));
		vipLayout:addChild(vipIcon);
		vipLayout:addChild(vipLevel);
	else
		if chatTable["ActionId"] ~= nil and chatTable["ActionId"] ~= 0 then
			chatText = "[" .. chatTable["SpeakerNickName"] .. "]：" .. chatTable["SpeechText"] .. "  点这里强势进入!"
		else
			chatText = "[" .. chatTable["SpeakerNickName"] .. "]：" .. chatTable["SpeechText"]
		end
	end


	labelName = ccs.label({
		text = chatText,
		fontSize = 23
	})
	labelName:setAnchorPoint(ccp(0, 0))
	labelName:setTextAreaSize(CCSizeMake(chatListWidth, 0))
	local speakerUserId = chatTable["SpeakerUserID"]
	if chatTable["ActionId"] ~= nil and chatTable["ActionId"] ~= 0 then
	labelName:setColor(ccc3(228 ,78  , 63))
	else
	labelName:setColor(ccc3(chatTable["ARGB1"], chatTable["ARGB2"], chatTable["ARGB3"]))
	end

	currentHeight = currentHeight + labelName:getContentSize().height + 15

	local layout = ccs.panel({
		size = CCSizeMake(chatListWidth, labelName:getSize().height),
		capInsets = CCRectMake(0, 0, 0, 0),
	})
	layout:setTouchEnabled(false)

	local button = ccs.button({
		scale9 = true,
		size = CCSizeMake(chatListWidth, labelName:getSize().height),
		normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				Common.log("Touch Down")
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				if chatTable["ActionId"] ~= nil and chatTable["ActionId"] ~= 0 then
					if chatTable["CheckCode"] ~= nil then
						MiniGameGuideConfig.setMiniGameRewarderId(chatTable["CheckCode"])
					end
					--通过ActionId，判断是否为同趣小妹跳转小游戏ID
					if chatTable["ActionId"] ~= nil then
						if  chatTable["ActionId"] == 0 then
						--老虎机GameID
						elseif chatTable["ActionId"] ==  ID_FRUIT_MACHINE then
							if chatTable["ActionParam"] == 1 then
								--水果机
								if GameLoadModuleConfig.getFruitIsExists() then
									GameConfig.setTheLastBaseLayer(GUI_HALL)
									mvcEngine.createModule(GUI_MINIGAME_FRUIT_MACHINE, LordGamePub.runSenceAction(HallLogic.view,nil,true))
								else
									Common.showToast("资源加载中，请稍候…",2)
								end
							elseif chatTable["ActionParam"] == 2 then
								Common.showToast("您还没有解锁",2)
							elseif chatTable["ActionParam"] == 3 then
								Common.showToast("您的金币不足",2)
							end

							--金皇冠GameID
						elseif chatTable["ActionId"] ==  ID_JIN_HUANG_GUAN then
							--金皇冠
							if chatTable["ActionParam"] == 1 then
								if GameLoadModuleConfig.getJinHuangGuanIsExists() then
									GameConfig.setTheLastBaseLayer(GUI_HALL)
									mvcEngine.createModule(GUI_JINHUANGUAN, LordGamePub.runSenceAction(HallLogic.view,nil,true))
								else
									Common.showToast("资源加载中，请稍候…",2)
								end
							elseif chatTable["ActionParam"] == 2 then
								Common.showToast("您还没有解锁",2)
							elseif chatTable["ActionParam"] == 3 then
								Common.showToast("您的金币不足",2)
							end

							--万人金花GameID
						elseif chatTable["ActionId"] ==  ID_WAN_REN_JIN_HUA then
							if chatTable["ActionParam"] == 1 then
								if GameLoadModuleConfig.getWanRenJinHuaIsExists() then
									sendJHROOMID_MINI_JINHUA_ENTER_GAME()
									sendJHGAMEID_MINI_JINHUA_HELP() -- 预先获取万人金花帮助信息
									sendJHGAMEID_MINI_JINHUA_HISTORY() -- 预先获取万人金花历史信息
								else
									Common.showToast("资源加载中，请稍候…",2)
								end
							elseif chatTable["ActionParam"] == 2 then
								Common.showToast("您还没有解锁",2)
							elseif chatTable["ActionParam"] == 3 then
								Common.showToast("您的金币不足",2)
							end
							--万人水果派
						elseif chatTable["ActionId"] ==  ID_WAN_REN_FRUIT_MACHINE then
							if chatTable["ActionParam"] == 1 then
								--万人水果机
								if GameLoadModuleConfig.getWanRenFruitIsExists() then
									sendWRSGJ_INFO(0) --发送基本信息 INFO
									GameConfig.setTheLastBaseLayer(GUI_HALL)
									mvcEngine.createModule(GUI_WRSGJ, LordGamePub.runSenceAction(HallLogic.view,nil,true))
								else
									Common.showToast("资源加载中，请稍候…",2)
								end
							elseif chatTable["ActionParam"] == 2 then
								Common.showToast("您还没有解锁",2)
							elseif chatTable["ActionParam"] == 3 then
								Common.showToast("您的金币不足",2)
							end
							--扎金花
						elseif chatTable["ActionId"] ==  ID_JIN_HUA then
							if chatTable["ActionParam"] == 1 then
								--炸金花
								if GameLoadModuleConfig.getJinHuaIsExists() then
									sendJHID_ENTER_JH_MINI();--发送进入扎金花大厅消息(服务器不回)
									sendJINHUA_ROOMID_ROOM_LIST(profile.JinHuaRoomData.getTimeStamp());--发送扎金花房间列表消息
									GameConfig.setTheLastBaseLayer(GUI_HALL);
									mvcEngine.createModule(GUI_JINHUAHALL);
								else
									Common.showToast("资源加载中，请稍候…",2)
								end
							elseif chatTable["ActionParam"] == 2 then
								Common.showToast("您还没有解锁",2)
							elseif chatTable["ActionParam"] == 3 then
								Common.showToast("您的金币不足",2)
							end
						end
					end
				else
					if(chatTable["SpeakerUserID"]~=0)then
						if(chatTable["SpeakerUserID"] == profile.User.getSelfUserID())then
							mvcEngine.createModule(GUI_USERINFO)
						else
							reqUserId = chatTable["SpeakerUserID"]
							ChatTanChuangLogic.reqUserId = reqUserId
							ChatTanChuangLogic.message = "[ " .. chatTable["SpeakerNickName"] .. " ]：" .. chatTable["SpeechText"]
							mvcEngine.createModule(GUI_CHATTANCHUANG)
							Common.log("Touch Up")

						end
					end
				end
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	button:setAnchorPoint(ccp(0, 0))
	layout:setAnchorPoint(ccp(0, 0))
	layout:addChild(labelName)
	layout:addChild(button)

	if vipLayout ~= nil then
		vipLayout:setAnchorPoint(ccp(0, 0.5))
		vipLayout:setPosition(ccp(5,  layout:getContentSize().height - 30));
		layout:addChild(vipLayout)
	end

	local positionY = 0
	if (chatListInnerHeight < chatListHeight) then
		positionY = chatListHeight - currentHeight
	end

	SET_POS(layout, 0, positionY)

	-- 把布局信息加入table保存
	local chatLayoutData = {}
	chatLayoutData.layout = layout
	chatLayoutData.height = layout:getSize().height
	chatLayoutData.positionY = positionY
	table.insert(chatLayoutTable, chatLayoutData)

	hallChatScrollView:addChild(layout)
	if(hallChatScrollView:getInnerContainer():getPosition().y >= 0 or chatTable["SpeakerUserID"] ==0)then
		chatScrollToBottomTimer()
	end
end

--[[设置聊天框的大小]]
function setChatScrollListSize()
	currentHeight = currentHeight - removeLayoutHeight
	hallChatScrollView:setInnerContainerSize(CCSizeMake(chatListWidth, currentHeight))
	chatListInnerHeight = currentHeight
	removeLayoutHeight = 0
end

--[[得到聊天信息并且加入列表中]]
function getAndSaveNewChatTable()
	local chatTable = nil
	if(isSystemMessage)then
		chatTable = systemMessage
	else
		chatTable = profile.IM.getUserChatTable()
	end
	local chatTableSize = #chatTextTable
	if (chatTableSize >= chatMaxCount) then
		table.remove(chatTextTable, 1)
	end
	table.insert(chatTextTable, chatTable)
	return chatTable
end

-- 添加到list
local function addOneItemChatToList(itemChatTable)
	addNewChatItemToScrollView(itemChatTable)
	changeChatItemViewLocation()
	setChatScrollListSize()
end

--[[把得到的聊天消息加入list]]
function addChatToList()
	if (isChatViewShowing == true) then
		local chatTable = getAndSaveNewChatTable()
		addOneItemChatToList(chatTable)
	else
		getAndSaveNewChatTable()
	end
end

--[[根据聊天缓存消息显示聊天]]
function showChatScrollViewByCachData()
	currentHeight = 0
	chatListInnerHeight = 0
	local chatTableSize = #chatTextTable
	for i = 1, chatTableSize do
		addOneItemChatToList(chatTextTable[i])
	end
end

--关闭聊天框
function closeChatPanel()
	HallLogic.btn_chat:setVisible(true);
	mvcEngine.destroyModule(GUI_HALLCHAT)
end

function requestMsg()
end

--[[收起聊天]]
function callback_hall_chat_dimiss_btn(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.3,ccp(-btn_dismiss:getPosition().x,0)))
		array:addObject(CCCallFuncN:create(closeChatPanel))
		local seq = CCSequence:create(array)
		hall_chat_panel:runAction(seq)

	elseif component == CANCEL_UP then
	--取消
	end
end

--[[发送聊天]]
function callback_hall_chat_send_bg(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.setUmengUserDefinedInfo("hall_btn_click", "聊天-提交")
		notSendText = ""
		local sendChat = edit_hall_chat:getText()
		if (sendChat ~= "") then
			Common.log("sendChat=="..sendChat)
			sendIMID_CHAT_ROOM_SPEAK(sendChat)
			edit_hall_chat:setText("");
			chatTextFeild:setText("");
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_hall_chat_panel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.3,ccp(-btn_dismiss:getPosition().x,0)))
		array:addObject(CCCallFuncN:create(closeChatPanel))
		local seq = CCSequence:create(array)
		hall_chat_panel:runAction(seq)

	elseif component == CANCEL_UP then
	end
end

function callback_hall_chat_edittext(component)
	Common.log("callback_hall_chat_edittext")
	edit_hall_chat:setText(chatTextFeild:getStringValue())
	notSendText = chatTextFeild:getStringValue();
end

function callback_hall_chat_bg(component)
end

--[[显示用户信息界面]]
function showUserInfoPop()
	if reqUserId then
		local userData = profile.User.getOtherUserInfo()
		if reqUserId == profile.User.getSelfUserID() then
			mvcEngine.createModule(GUI_USERINFO)
			UserInfoLogic.setUserInfo(1,userData)
			showUserInfoFlag = true
			reqUserId = nil
		else
			if userData["OtherInfo"] and userData["OtherInfo"].UserID and userData["OtherInfo"].UserID == reqUserId then
				mvcEngine.createModule(GUI_USERINFO)
				UserInfoLogic.setUserInfo(0,userData)
				showUserInfoFlag = true
				reqUserId = nil
			end
		end
	end
end

function clearChatText()
	chatTextTable = {}
	if hallChatScrollView ~= nil then
		hallChatScrollView:removeAllChildren()
		chatListWidth = hallChatScrollView:getContentSize().width
		chatListHeight = hallChatScrollView:getContentSize().height
	end
	chatLayoutTable = {}
	chatListInnerHeight = 0
	currentHeight = 0
	chatTextTable = {} -- 聊天记录
	chatTableAction = nil
	showUserInfoFlag = false -- 显示用户信息标志
end

--初始化所有聊天数据
function initAllChatData()
	chatListWidth = nil -- listview大小
	chatListHeight = nil
	chatListInnerHeight = 0
	currentHeight = 0
	chatTextTable = {} -- 聊天记录

	firstChangeChatListPosFlag = true -- 第一次改变聊天记录位置标记
	showUserInfoFlag = false -- 显示用户信息标志
end

---ios输入框
function callback_hall_chat_edittext_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.log("callback_hall_chat_edittext_ios")
		Common.showAlertInput(chatTextFeild:getStringValue(), 0, true, callbackChatInput)
	elseif component == CANCEL_UP then
	end
end

function callbackChatInput(valuetable)
	local value = valuetable["value"]
	edit_hall_chat:setText(value);
	chatTextFeild:setText(value);
end

function getIMID_OPERATE_CHAT_USER_TYPEInfo()
	local dataTable = profile.IM.getIMID_OPERATE_CHAT_USER_TYPETable()
	local chatTable = {}
	chatTable["SpeakerNickName"] = "系统公告"
	chatTable["SpeakerUserID"] = 0
	chatTable["SpeechText"] = dataTable["resultMsg"]
	chatTable["ARGB1"] = 228
	chatTable["ARGB2"] = 78
	chatTable["ARGB3"] = 63
	chatTable["VipLevel"] = 0;
	isSystemMessage = true
	systemMessage = chatTable
	addChatToList()
	isSystemMessage = false
	Common.closeProgressDialog()
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	if hallChatScrollView ~= nil then
		hallChatScrollView:removeAllChildren()
		hallChatScrollView = nil
	end
	isChatViewShowing = false
	HallLogic.btn_chat:setVisible(true);
	chatLayoutTable = {}
	firstChangeChatListPosFlag = true -- 第一次改变聊天记录位置标记
end

function addSlot()
	framework.addSlot2Signal(IMID_OPERATE_CHAT_USER_TYPE, getIMID_OPERATE_CHAT_USER_TYPEInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(IMID_OPERATE_CHAT_USER_TYPE, getIMID_OPERATE_CHAT_USER_TYPEInfo)
end
