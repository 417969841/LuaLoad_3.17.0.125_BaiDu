module("JinHuaChatPopLogic",package.seeall)



view = nil

--表情，常用语，聊天记录 切换按钮
iv_tab_biaoqing = nil;
iv_tab_common = nil;
iv_tab_log = nil;
--表情，常用语，聊天记录 布局
panel_biaoqing = nil;
panel_common = nil;
panel_log = nil;
label_common_biaoqing = nil;
label_superior_biaoqing = nil;
label_tab_biaoqing = nil;
label_tab_common_chat = nil;
label_tab_chat_log = nil;

--普通表情，高级表情 切换按钮
iv_biaoqing_tab_common = nil;
iv_biaoqing_tab_superior = nil;
--普通表情，高级表情  布局
panel_biaoqing_common = nil;
panel_biaoqing_superior = nil;

--常用语
tv_common = {}

--输入框（常用语界面，日志界面）
et_msg_common = nil;
et_msg_log = nil;
-- 聊天语的数目
local COMMON_CHAT_NUM = 17
local defaultChatScrollHeight = 236

--日志scrollview
sv_log = nil;

local tableChatCommonText = {}
tableChatCommonText[1] = "大家好，很高兴认识大家！"
tableChatCommonText[2] = "快点吧，我等到花儿也谢了！"
tableChatCommonText[3] = "咱们要不玩把大的？"
tableChatCommonText[4] = "痛快，痛快！这把赢得真痛快！"
tableChatCommonText[5] = "你敢上，我就敢跟！这年头谁怕谁啊！"
tableChatCommonText[6] = "投降吧！算你少输点！"
tableChatCommonText[7] = "寡人有事，咱们择日再战！"
tableChatCommonText[8] = "知道我是骗子还跟我玩那么长时间牌，什么人品啊你？"
tableChatCommonText[9] = "别看牌！跟你丫死磕！"
tableChatCommonText[10] = "看你存钱不易，这把牌先放你一马！"
tableChatCommonText[11] = "搏一搏，单车变摩托！"
tableChatCommonText[12] = "不是我喜欢赢牌，是你们老排着队让我赢！"
tableChatCommonText[13] = "不要走，决战到天亮！"
tableChatCommonText[14] = "你是在自寻死路！"
tableChatCommonText[15] = "天啊！这是什么破牌啊！"
tableChatCommonText[16] = "我感觉这把牌赢定了！"
tableChatCommonText[17] = "又断了，网络怎么这么差。"
local lastTabState = 1 -- 最后显示的tab状态 1表情，2常用语，3聊天记录
local lastBiaoqingState = 1 -- 最后显示的表情tab状态 1普通表情，2高级表情
chatLog = {}

local send_chat_superior_position = -1 -- 点击发送的高级表情包的位置

--[[--
--
--]]
function getTableChatCommonText()
	return tableChatCommonText;
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

-- 聊天加入列表中
local function addChatListToScrollView()
	local cellWidth = 640
	local currentHeight = 0
	-- 滚动区域的高度
	local chatScrollInnerHeight = 0
	local labelMsgTable = {}
	local buttonTable = {}
	local imageDividerTable = {}

	for i=1, #chatLog do
		local labelMsg = ccs.label({
			text = chatLog[i].nickName..":"..chatLog[i].msg,
		})
		labelMsg:setAnchorPoint(ccp(0,0))
		table.insert(labelMsgTable, labelMsg)

		--按钮
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth, labelMsg:getContentSize().height + 20),
			pressed = getJinHuaResource("menghei_hall_gengduo_ic.png", pathTypeInApp),
			normal = getJinHuaResource("menghei2_hall_gengduo_ic.png", pathTypeInApp),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					et_msg_log:setText(chatLog[i].msg)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
				end,
			}
		})
		button:setAnchorPoint(ccp(0,0))
		table.insert(buttonTable, button)

		--分割线
		local imageDivider = ccs.image({
			image = getJinHuaResource("di_changyongyu.png", pathTypeInApp),
		})
		imageDivider:setAnchorPoint(ccp(0,0))
		imageDivider:setTextureRect(CCRectMake(0,0,cellWidth,2))
		table.insert(imageDividerTable, imageDivider)

		chatScrollInnerHeight = chatScrollInnerHeight + labelMsg:getContentSize().height + 20
	end
	-- 加入聊天列表并设置位置
	for i=#chatLog, 1, -1 do
		if chatScrollInnerHeight < defaultChatScrollHeight then
			chatScrollInnerHeight = defaultChatScrollHeight
		end
		currentHeight = currentHeight + labelMsgTable[i]:getContentSize().height + 20
		SET_POS(imageDividerTable[i],2,chatScrollInnerHeight-currentHeight)
		SET_POS(buttonTable[i],2,chatScrollInnerHeight-currentHeight)
		SET_POS(labelMsgTable[i],2,chatScrollInnerHeight-currentHeight+10)
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

	label_common_biaoqing = cocostudio.getUITextField(view,"label_common_biaoqing")
	label_superior_biaoqing = cocostudio.getUITextField(view,"label_superior_biaoqing")
	label_tab_biaoqing = cocostudio.getUITextField(view,"label_tab_biaoqing")
	label_tab_common_chat = cocostudio.getUITextField(view,"label_tab_common_chat")
	label_tab_chat_log = cocostudio.getUITextField(view,"label_tab_chat_log")

	for i=1,COMMON_CHAT_NUM do
		if (i < 10) then
			tv_common[i] = cocostudio.getUILabel(view,"tv_common_0"..i)
		else
			tv_common[i] = cocostudio.getUILabel(view,"tv_common_"..i)
		end

		tv_common[i]:setText(tableChatCommonText[i])
	end

	et_msg_common = cocostudio.getUITextField(view,"et_msg_common")
	et_msg_log = cocostudio.getUITextField(view,"et_msg_log")
	sv_log = cocostudio.getUIScrollView(view, "sv_log")

	addChatListToScrollView()
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaChatPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView()
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
	if tabId == TAB_BIAOQING then
		iv_tab_biaoqing:loadTexture(getJinHuaResource("btn_hall_middle_press.png", pathTypeInApp))
		iv_tab_common:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))
		iv_tab_log:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))

		panel_biaoqing:setVisible(true)
		panel_common:setVisible(false)
		panel_log:setVisible(false)
		panel_biaoqing:setZOrder (2)
		panel_common:setZOrder (1)
		panel_log:setZOrder (1)

		panel_biaoqing:setTouchEnabled(true)
		panel_common:setTouchEnabled(false)
		panel_log:setTouchEnabled(false)

		label_tab_biaoqing:setColor(ccc3(selectedLabelColor[1], selectedLabelColor[2], selectedLabelColor[3]))
		label_tab_common_chat:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		label_tab_chat_log:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		lastTabState = TAB_BIAOQING

		switchBiaoqingTab(lastBiaoqingState)
	elseif tabId == TAB_COMMON then
		iv_tab_common:loadTexture(getJinHuaResource("btn_hall_middle_press.png", pathTypeInApp))
		iv_tab_biaoqing:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))
		iv_tab_log:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))

		panel_common:setVisible(true)
		panel_biaoqing:setVisible(false)
		panel_log:setVisible(false)
		panel_biaoqing:setZOrder (1)
		panel_common:setZOrder (2)
		panel_log:setZOrder (1)

		panel_common:setTouchEnabled(true)
		panel_biaoqing:setTouchEnabled(false)
		panel_log:setTouchEnabled(false)

		label_tab_biaoqing:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		label_tab_common_chat:setColor(ccc3(selectedLabelColor[1], selectedLabelColor[2], selectedLabelColor[3]))
		label_tab_chat_log:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		lastTabState = TAB_COMMON
	elseif tabId == TAB_LOG then
		iv_tab_log:loadTexture(getJinHuaResource("btn_hall_middle_press.png", pathTypeInApp))
		iv_tab_biaoqing:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))
		iv_tab_common:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))

		panel_log:setVisible(true)
		panel_biaoqing:setVisible(false)
		panel_common:setVisible(false)
		panel_biaoqing:setZOrder (1)
		panel_common:setZOrder (1)
		panel_log:setZOrder (2)

		panel_log:setTouchEnabled(false)
		panel_biaoqing:setTouchEnabled(false)
		panel_common:setTouchEnabled(false)

		label_tab_biaoqing:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		label_tab_common_chat:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		label_tab_chat_log:setColor(ccc3(selectedLabelColor[1], selectedLabelColor[2], selectedLabelColor[3]))
		lastTabState = TAB_LOG
	end
end


--普通表情
local TAB_BQ_COMMON = 1
--高级表情
local TAB_BQ_SUPERIOR = 2
function switchBiaoqingTab(tabId)
	Common.log("切换表情：：：：：：："..tabId)
	if tabId == TAB_BQ_COMMON then
		iv_biaoqing_tab_common:loadTexture(getJinHuaResource("btn_hall_middle_press.png", pathTypeInApp))
		iv_biaoqing_tab_superior:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))

		panel_biaoqing_common:setVisible(true)
		panel_biaoqing_superior:setVisible(false)
		panel_biaoqing_common:setZOrder(2)
		panel_biaoqing_superior:setZOrder(1)

		label_common_biaoqing:setColor(ccc3(selectedLabelColor[1], selectedLabelColor[2], selectedLabelColor[3]))
		label_superior_biaoqing:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))

		lastBiaoqingState = TAB_BQ_COMMON
	elseif tabId == TAB_BQ_SUPERIOR then
		iv_biaoqing_tab_superior:loadTexture(getJinHuaResource("btn_hall_middle_press.png", pathTypeInApp))
		iv_biaoqing_tab_common:loadTexture(getJinHuaResource("btn_hall_middle_nor.png", pathTypeInApp))

		panel_biaoqing_superior:setVisible(true)
		panel_biaoqing_common:setVisible(false)
		panel_biaoqing_superior:setZOrder(2)
		panel_biaoqing_common:setZOrder(1)

		label_common_biaoqing:setColor(ccc3(notSelectedLabelColor[1], notSelectedLabelColor[2], notSelectedLabelColor[3]))
		label_superior_biaoqing:setColor(ccc3(selectedLabelColor[1], selectedLabelColor[2], selectedLabelColor[3]))

		lastBiaoqingState = TAB_BQ_SUPERIOR
	end
end

local function sendChatEmotion(type,msg)
	sendJHID_CHAT_REQ(type,""..msg)
	mvcEngine.destroyModule(GUI_JINHUA_CHATPOP)
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
		mvcEngine.destroyModule(GUI_JINHUA_CHATPOP)
	elseif component == CANCEL_UP then
	--取消
	end
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
		sendChatEmotion(TYPE_CHAT_COMMON,0)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,1)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,2)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,3)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_5(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,4)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_6(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,5)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_7(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,6)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_8(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,7)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_9(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,8)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_10(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,9)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_11(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,10)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_12(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,11)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_13(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,12)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_14(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,13)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_15(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,14)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_16(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,15)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_17(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,16)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_18(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,17)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_19(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,18)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_20(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,19)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_21(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,20)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_22(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,21)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_23(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,22)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_bq_common_24(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_COMMON,23)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_1,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior1()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,0)
	else
		send_chat_superior_position = 0
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior1()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_bq_superior_2,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior2()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,1)
	else
		send_chat_superior_position = 1
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior2();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_bq_superior_3,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior3()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,2)
	else
		send_chat_superior_position = 2
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior3();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_4,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior4()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,3)
	else
		send_chat_superior_position = 3
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior4();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_5,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior5()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,4)
	else
		send_chat_superior_position = 4
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_5(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior5();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_6,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior6()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,5)
	else
		send_chat_superior_position = 5
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_6(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior6();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_7,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior7()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,6)
	else
		send_chat_superior_position = 6
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_7(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior7();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_8,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior8()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,7)
	else
		send_chat_superior_position = 7
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_8(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior8();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_9,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior9()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,8)
	else
		send_chat_superior_position = 8
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_9(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior9();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_10,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior10()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,9)
	else
		send_chat_superior_position = 9
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_10(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior10();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_11,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior11()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,10)
	else
		send_chat_superior_position = 10
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_11(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior11();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
-- 点击按钮btn_bq_superior_12,手指抬起后做的事
--]]
local function releaseUpForBtnBqSuperior12()
	if superiorFaceEnable() then
		sendChatEmotion(TYPE_CHAT_SUPERIOR,11)
	else
		send_chat_superior_position = 11
		showTableGoodBuySuperiorBiaoqingPop()
	end
end

function callback_btn_bq_superior_12(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnBqSuperior12();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[1])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[2])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[3])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[4])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_5(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[5])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_6(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[6])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_7(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[7])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_8(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[8])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_9(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[9])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_10(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[10])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_11(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[11])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_12(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[12])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_13(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[13])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_14(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[14])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_15(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[15])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_16(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[16])
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_tv_common_17(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		sendChatEmotion(TYPE_CHAT_TEXT,tableChatCommonText[17])
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_sendmsg_common,手指抬起后做的事
--]]
local function releaseUpForBtnSendmsgCommon()
	local sendChat = et_msg_common:getStringValue()
	if (sendChat ~= "") then
		sendChatEmotion(TYPE_CHAT_TEXT,sendChat)
		et_msg_common:setText("")
	end
end

function callback_btn_sendmsg_common(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnSendmsgCommon();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_sendmsg_log,手指抬起后做的事
--]]
local function releaseUpForBtnSendmsglog()
	local sendChat = et_msg_log:getStringValue()
	if (sendChat ~= "") then
		sendChatEmotion(TYPE_CHAT_TEXT,sendChat)
		et_msg_log:setText("")
	end
end

function callback_btn_sendmsg_log(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnSendmsglog();
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
	mvcEngine.destroyModule(GUI_JINHUA_CHATPOP)
	mvcEngine.createModule(GUI_JINHUA_TABLEGOODSBUYPOP)
	JinHuaTableGoodsBuyPopLogic.setGoodsInfo(QuickPay.Pay_Guide_biaoqing_GuideTypeID,RechargeGuidePositionID.TablePositionD)
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
