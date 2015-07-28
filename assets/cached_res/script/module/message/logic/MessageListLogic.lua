module("MessageListLogic",package.seeall)

view = nil
local scene = nil

local PageSize = 30
local PageStartID = 0
local ConversationIDServer = 0

local LastMessageId = 0;
local Count = 0;
local MessageId = 0;
local NickName = nil;
local SendValue = nil;

--控件
messagelistScrollView = nil
Panel_20 = nil;--
img_user = nil;--
zi_user = nil;--
img_server = nil;--
zi_server = nil;--
btn_back = nil;--
scroll_msglist = nil;--
Image_Server = nil;--
Panel_SelfMsg = nil;--
img_txt_userbg = nil;--
Label_Name = nil;--
txt_username = nil;--
Label_sendmsg = nil;--
txt_sendmsg = nil;--
btn_send = nil;--
Image_MyMeg = nil;--
Image_LabMyMeg = nil;--
Image_SendMsg = nil;--
Image_LabSendMsg = nil;--
Panel_18 = nil;--
btn_Coin = nil;--
Label_Coin = nil;--
btn_YuanBao = nil;--
Label_yuanbao = nil;--
panel_MyMsg = nil;
panel_SendMsg = nil;

--变量
MessageTable = {}--user信息
MessageImageGooodsTable = {}--user头像
MessageContent = {}--server信息
SystemMessageTable = {} --系统消息表
MessageStateTable = {} --消息已读 或未读 状态存储表
MessageReceiveStateTable = {} --领奖状态 存储表

--全局变量
local MSG_SERVER = 0--系统消息
local MSG_USER = 1--个人消息
local MSG_MYMSG = 3--我的消息
local MSG_SENDMSG = 4--发送消息
local size = nil
local currentTab = 0

function onKeypad(event)
	if event == "backClicked" then
		HallLogic.sendMessageInfo()
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end

--[[--
--系统消息列表cell点击事件
--@param #Byte MessageID 消息ID
--]]
function callSeverCellClicked(MessageID)
	if SystemMessageTable["SystemMessageList"] ~= nil then
		for i = 1, #SystemMessageTable["SystemMessageList"] do
			if SystemMessageTable["SystemMessageList"][i] ~= nil then
				if MessageID == SystemMessageTable["SystemMessageList"][i].MessageId then
					--如果是系统消息是未读状态
					if SystemMessageTable["SystemMessageList"][i].MessageFlag == 0 then
						--更新消息状态  1：消息类型 2：消息ID
						updateSeverImageState(SystemMessageTable["SystemMessageList"][i].MessageType, SystemMessageTable["SystemMessageList"][i].MessageId);
						sendMAIL_SYSTEM_MESSAGE_READ(SystemMessageTable["SystemMessageList"][i].MessageId);
						SystemMessageTable["SystemMessageList"][i].MessageFlag = 1;
					end
					updateServerReveiveState(MessageId, SystemMessageTable["SystemMessageList"][i].MessageFlag);
					--传递该消息的所有相关属性  消息标题，消息内容，消息类型 ，消息状态  动作类  动作参数
					MessageServerLogic.setServerViewNeedParams(SystemMessageTable["SystemMessageList"][i].MessageId, SystemMessageTable["SystemMessageList"][i].MessageTitle, SystemMessageTable["SystemMessageList"][i].MessageContent, SystemMessageTable["SystemMessageList"][i].MessageType, SystemMessageTable["SystemMessageList"][i].MessageFlag, SystemMessageTable["SystemMessageList"][i].Action, SystemMessageTable["SystemMessageList"][i].ActionParam)
					mvcEngine.createModule(GUI_MESSAGESERVER)
					break;
				end
			end
		end
	end
end

--[[--
--更新图片
]]
local function updataImageGooods(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and MessageImageGooodsTable[""..id] ~= nil then
		MessageImageGooodsTable[""..id]:loadTexture(photoPath);
		MessageImageGooodsTable[""..id]:setScale(0.8);
	end
end

--[[--
--初始化界面
--@param #number type 显示列表类型
--]]
function initView(type)
	currentTab = type
	messagelistScrollView:removeAllChildren()
	MessageImageGooodsTable = {}
	MessageStateTable = {} -- 用户已读  或者 未读状态存储表
	MessageReceiveStateTable = {}--用户领奖状态存储表
	local cellSize = 0
	if type == MSG_SERVER then
		if SystemMessageTable["SystemMessageList"] ~= nil and SystemMessageTable["SystemMessageList"] ~= "" then
			cellSize = #SystemMessageTable["SystemMessageList"] --总数
			Common.log("youxiang  CellSize1 = " .. cellSize)
			--个人消息红点
			if btnGanTanHao_System ~= nil then
				btnGanTanHao_System:setVisible(false)
			end
			if 	profile.Message.getUserMessage_no_ReadCount() >= 1 then
				if btnGanTanHao_User ~= nil then
					btnGanTanHao_User:setVisible(true)
				end
			elseif profile.Message.getUserMessage_no_ReadCount() == 0 then
				if btnGanTanHao_User ~= nil then
					btnGanTanHao_User:setVisible(false)
				end
			end
		end
	elseif type == MSG_USER then
		Common.log(profile.Message.getSystemMessage_no_ReadCount().."messagelistmac")
		if MessageTable["MessageList"] ~= nil and MessageTable["MessageList"] ~= "" then
			cellSize = #MessageTable["MessageList"]--总数
			Common.log("youxiang  CellSize2 = " .. cellSize)
			---系统消息红点
			--
			if btnGanTanHao_User ~= nil then
				btnGanTanHao_User:setVisible(false)
			end
			Common.log(profile.Message.getSystemMessage_no_ReadCount().."messagelistmac")
			if 	profile.Message.getSystemMessage_no_ReadCount() >= 1 then
				if btnGanTanHao_System ~= nil then
					btnGanTanHao_System:setVisible(true)
				end
			elseif	profile.Message.getSystemMessage_no_ReadCount()== 0  then
				if btnGanTanHao_System ~= nil then
					btnGanTanHao_System:setVisible(false)
				end
			end
		end
	end
	--点击站内信之后如果总数为零则设置为False
	if (profile.Message.getSystemMessage_no_ReadCount() + profile.Message.getUserMessage_no_ReadCount()) == 0 then
		profile.Message.setisHallMessage_isRed()
	end
	local leftAndRight = 80 --左右的间距
	local viewW = 1136
	local viewHMax = 400
	local viewH = 0
	local viewX = 0
	local viewY = 70
	local cellWidth = 1136 - leftAndRight*2 --每个元素的宽
	local cellHeight = 130 --每个元素的高
	local lieSize = 1 --列数
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数
	local spacingW = 0 --横向间隔
	local spacingH = 10 --纵向间隔
	local layoutX = 0--layout的X坐标
	Common.log("youxiang  CellSize3 = " .. cellSize)
	--为0直接返回
	if cellSize == 0 then
		Common.log("youxiangnomsgcontent===...cellSize = " .. cellSize)
		--如果服务器消息数量为0 则关闭loading动画
--		Common.closeProgressDialog()
--		Common.log("youxiang189")
		cellSize = 1

		local nomsgcontent = ""
		if type == MSG_SERVER then
			layoutX = viewW/2
			nomsgcontent = "还未收到任何系统消息"
			messagelistScrollView:setSize(CCSizeMake(viewW, viewHMax))
			messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW, viewHMax+1))
			messagelistScrollView:setPosition(ccp(viewX, 65))
		else
			layoutX = viewW/3 + 70
			nomsgcontent = "还未收到任何个人消息"
			cellWidth = cellWidth - 120
			messagelistScrollView:setSize(CCSizeMake(viewW - 270, viewHMax))
			messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW - 270, viewHMax+1))
			messagelistScrollView:setPosition(ccp(200, 65))
		end
		local labelName = ccs.label({
			text = nomsgcontent,
			color = ccc3(156,156,156),
		})
		labelName:setFontSize(25)
		--底层layer
		local layout = ccs.panel({
			scale9 = true,
			image = Common.getResourcePath("bg_paihangbang_gonggao.png"),
			size = CCSizeMake(cellWidth-20, cellHeight-20),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setAnchorPoint(ccp(0.5, 0.5))
		local button = ccs.button({
			scale9 = true,
			size = CCSizeMake(cellWidth-20, cellHeight-20),
			pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
			text = "",
			capInsets = CCRectMake(0, 0, 0, 0),
			listener = {
				[ccs.TouchEventType.began] = function(uiwidget)
					layout:setScale(1.1)
				end,
				[ccs.TouchEventType.moved] = function(uiwidget)
				end,
				[ccs.TouchEventType.ended] = function(uiwidget)
					layout:setScale(1)
				end,
				[ccs.TouchEventType.canceled] = function(uiwidget)
					layout:setScale(1)
				end,
			}
		})
		SET_POS(button, layout:getSize().width / 2 , layout:getSize().height / 2 )
		SET_POS(labelName, layout:getSize().width / 2 , layout:getSize().height / 2)
		SET_POS(layout, layoutX, 350)

		layout:addChild(labelName)
		layout:addChild(button)
		messagelistScrollView:addChild(layout)

	else
		local allmsgheight = 0;
		if hangSize * cellHeight > viewHMax then
			viewH = viewHMax
			viewY = 0
			allmsgheight = cellHeight * hangSize + spacingH * (hangSize - 1)+40
		else
			viewH = hangSize * cellHeight+ spacingH * (hangSize - 1)
			allmsgheight = viewHMax
			viewY = 0
		end

		messagelistScrollView:setSize(CCSizeMake(viewW, viewHMax))--设置scrollview的大小
		messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW, allmsgheight))
		messagelistScrollView:setPosition(ccp(0, 65))
		if type == MSG_USER then
			cellWidth = cellWidth - 120
		end
		for i = 0, cellSize - 1 do
			local imageUser = nil --用户头像
			local zhuangtai = nil --状态
			--user信息
			local ConversationID = nil
			local SenderNickName = nil
			local UnreadMessageCnt = nil --消息数量
			local LastMsgTime = nil--时间
			local userID = nil
			local PhotoUrl = nil
			local LastMsgContent = nil
			local LastMsgContentShort = nil

			--sever信息
			--消息内容
			--local sMessageContent = nil
			--消息类型
			local sMessageType = nil
			--消息状态
			local sMessageFlag = nil
			if type == MSG_USER then
				--会话id
				ConversationID = MessageTable["MessageList"][i+1].ConversationID
				--是否系统消息
				local IsSysMsg = MessageTable["MessageList"][i+1].IsSysMsg
				--头像
				PhotoUrl = MessageTable["MessageList"][i+1].PhotoUrl
				--昵称
				SenderNickName = MessageTable["MessageList"][i+1].SenderNickName
				--时间
				LastMsgTime = MessageTable["MessageList"][i+1].LastMsgTime
				--内容
				LastMsgContent = MessageTable["MessageList"][i+1].LastMsgContent
				local ContentLength = Common.utfstrlen(LastMsgContent)
				if ContentLength > 20 then
					LastMsgContentShort = Common.SubUTF8String(LastMsgContent,1,20).."......"
				else
					LastMsgContentShort = LastMsgContent
				end
				--UserID
				userID = MessageTable["MessageList"][i+1].UserID
				--UnreadMessageCnt
				UnreadMessageCnt =  MessageTable["MessageList"][i+1].UnreadMessageCnt

				messagelistScrollView:setSize(CCSizeMake(viewW - 270, viewHMax))--设置scrollview的大小
				messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW-270, allmsgheight))
				messagelistScrollView:setPosition(ccp(200, 65))

			elseif type == MSG_SERVER then
				--server系统消息
				--消息内容
				local sMessageContent_temp = SystemMessageTable["SystemMessageList"][i + 1].MessageContent;
				local ContentLength = Common.utfstrlen(sMessageContent_temp)
				if ContentLength > 20 then
					LastMsgContentShort = Common.SubUTF8String(sMessageContent_temp,1,20).."......"
				else
					LastMsgContentShort = sMessageContent_temp
				end
				--消息类型 0：普通消息  1 ：领奖消息   2：执行Action
				sMessageType = SystemMessageTable["SystemMessageList"][i + 1].MessageType;
				--消息状态 0：未读  1：已读  2：已领奖
				sMessageFlag = SystemMessageTable["SystemMessageList"][i + 1].MessageFlag;
				--消息时间
				LastMsgTime = SystemMessageTable["SystemMessageList"][i + 1].CreateTime;
			end
			--控件
			--姓名消息标题
			local labelName = ccs.label({
				text = "",
				color = ccc3(0,0,0),
			})
			labelName:setFontSize(25)
			--时间
			local labelTime = ccs.label({
				text = LastMsgTime,
				color = ccc3(0,0,0),
			})
			labelTime:setAnchorPoint(ccp(1, 0.5))

			labelTime:setFontSize(25)
			--留言
			local textAreaInfo =  ccs.label({
				text = LastMsgContentShort,
				color = ccc3(0,0,0),
			})
			textAreaInfo:setFontSize(25)

			local isReadimg = ""
			local avatorurl = ""


			if type == MSG_USER then
				labelName:setText(SenderNickName.."("..UnreadMessageCnt..")")
				if UnreadMessageCnt == 0 then
					isReadimg = ""
				else
					isReadimg = "ic_email_new.png"
				end
				avatorurl = "hall_portrait_default.png"
			elseif type == MSG_SERVER then
				--系统消息标题
				labelName:setText(SystemMessageTable["SystemMessageList"][i + 1].MessageTitle)
				if sMessageType == 0 then
					if sMessageFlag == 0  then
						avatorurl = "ic_email_envelope.png"
					elseif sMessageFlag == 1 then
						avatorurl = "ic_email_envelope_yidu.png"
					end
				end
				if sMessageType == 2 then
					if sMessageFlag == 0  then
						avatorurl = "ic_email_envelope.png"
					elseif sMessageFlag == 1 then
						avatorurl = "ic_email_envelope_yidu.png"
					end
				end
				if sMessageType == 1 or sMessageType == 3 then
					if sMessageFlag ~= 0 then
						avatorurl = "ic_email_gift_yidu.png"
					else
						avatorurl = "ic_email_gift.png"
					end
				end
				if SystemMessageTable["SystemMessageList"][i + 1].MessageFlag == 2 then
					--系统消息标题
					labelName:setText(SystemMessageTable["SystemMessageList"][i + 1].MessageTitle .. "[已领取]")
				end
			end
			--头像背景bg_email_information0_touxiang
			local imgBg = ccs.image({
				scale9 = true,
				image = Common.getResourcePath("hall_portrait.png"),
				size = CCSizeMake(91,93),
			})
			imgBg:setScale(0.9)
			--头像
			imageUser = ccs.image({
				scale9 = false,
				image = Common.getResourcePath(avatorurl),
				size = CCSizeMake(88,88),
			})

			if type == MSG_USER then
				MessageImageGooodsTable[""..ConversationID] = imageUser
				if PhotoUrl ~= nil and  PhotoUrl ~= ""  then
					Common.getPicFile(PhotoUrl, ConversationID, true, updataImageGooods)
				else
					imageUser:setScale(0.9)
				end

			elseif type == MSG_SERVER then

				MessageStateTable[""..SystemMessageTable["SystemMessageList"][i + 1].MessageId] = imageUser
				MessageReceiveStateTable[""..SystemMessageTable["SystemMessageList"][i + 1].MessageId] = labelName
			end
			--状态
			if isReadimg ~= "" then
				zhuangtai = ccs.image({
					scale9 = false,
					image = Common.getResourcePath(isReadimg),
					size = CCSizeMake(100,84),
				})
			end

			--底层layer
			local layout = ccs.panel({
				scale9 = true,
				image = Common.getResourcePath("bg_email_information0.png"),
				size = CCSizeMake(cellWidth, cellHeight),
				capInsets = CCRectMake(0, 0, 0, 0),
			})

			layout:setAnchorPoint(ccp(0.5, 0.5))
			local button = ccs.button({
				scale9 = true,
				size = CCSizeMake(cellWidth, cellHeight),
				pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
				text = "",
				capInsets = CCRectMake(0, 0, 0, 0),
				listener = {
					[ccs.TouchEventType.began] = function(uiwidget)
						layout:setScale(1.1)
					end,
					[ccs.TouchEventType.moved] = function(uiwidget)
					end,
					[ccs.TouchEventType.ended] = function(uiwidget)
						layout:setScale(1)
						if isReadimg ~= "" then
							zhuangtai:setVisible(false)
						end
						if type == MSG_USER then
							--type 1：站内信聊天 2：发给指定昵称
							if UnreadMessageCnt ~= 0 then
								profile.Message.setUserMessage_no_ReadCount()
							end
							MessageTable["MessageList"][i+1].UnreadMessageCnt = 0
							MessagePlayerLogic.setConversationID(1,SenderNickName,ConversationID,userID,PhotoUrl)
							mvcEngine.createModule(GUI_MESSAGEPLAYER)
						elseif type == MSG_SERVER then
							--系统消息列表cell点击事件 :param1:消息ID
							if SystemMessageTable["SystemMessageList"][i + 1].MessageFlag == 0 then
								profile.Message.setSystemMessage_no_ReadCount()
							end
							callSeverCellClicked(SystemMessageTable["SystemMessageList"][i + 1].MessageId)
						end
					end,
					[ccs.TouchEventType.canceled] = function(uiwidget)
						layout:setScale(1)
					end,
				}
			})
			--设置名称位置
			SET_POS(button, layout:getSize().width / 2 , layout:getSize().height / 2 )
			SET_POS(labelName, layout:getSize().width / 2 , 90)
			--设置描述背景
			--设置时间
			SET_POS(labelTime, size.width-leftAndRight*3 + 50, layout:getSize().height / 2)
			--设置描述位置
			SET_POS(textAreaInfo, layout:getSize().width / 2,40)
			--设置图标位置
			SET_POS(imgBg, 80,layout:getSize().height / 2)
			SET_POS(imageUser,80,layout:getSize().height / 2)
			if isReadimg ~= "" then
				SET_POS(zhuangtai, imageUser:getSize().width / 2+50,layout:getSize().height / 2-20)
			end
			--allmsgheight
			SET_POS(layout,viewW/2, allmsgheight - cellHeight/2 -i*(cellHeight-spacingH*2))
			if type	== MSG_USER then
				SET_POS(layout,viewW/3 + 70, allmsgheight - cellHeight/2-i*(cellHeight - spacingH*2))
				--设置时间
				SET_POS(labelTime, size.width-leftAndRight*5 + 50, layout:getSize().height / 2)
			end
			labelName:setColor(ccc3(43, 24, 16))
			labelTime:setColor(ccc3(43, 24, 16))
			textAreaInfo:setColor(ccc3(84, 36, 7))
			layout:addChild(labelTime)
			layout:addChild(textAreaInfo)
			if type == MSG_USER then
				layout:addChild(imgBg)
			end
			layout:addChild(imageUser)
			layout:addChild(labelName)
			if isReadimg ~= "" then
				layout:addChild(zhuangtai)
			end
			layout:addChild(button)
			messagelistScrollView:addChild(layout)
		end
		--			Common.closeProgressDialog()
		--			Common.log("youxiang516")
	end
	Common.closeProgressDialog()
end

function initSystemMessagePanel()

end

--显示系统消息列表
function setSystemMessageList()
	Common.log("setSystemMessageList======")
	SystemMessageTable["SystemMessageList"] = profile.Message.getSystemMessageTable();
	if #SystemMessageTable["SystemMessageList"] == 0 then
--		Common.closeProgressDialog()
		Common.log("youxiang529")
		initView(MSG_SERVER)
	else
		if currentTab == MSG_SERVER then
			initView(MSG_SERVER)
			Common.log("youxiang534")
		end
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MessageList.json")
	local gui = GUI_MESSAGELIST
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

	GameConfig.setTheCurrentBaseLayer(GUI_MESSAGELIST)
	--全局变量
	size = CCDirector:sharedDirector():getWinSize()

	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)
	--控件
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	img_user = cocostudio.getUIImageView(view, "img_user");
	zi_user = cocostudio.getUIImageView(view, "zi_user");
	img_server = cocostudio.getUIImageView(view, "img_server");
	zi_server = cocostudio.getUIImageView(view, "zi_server");
	btn_back = cocostudio.getUIButton(view, "btn_back");
	messagelistScrollView = cocostudio.getUIScrollView(view, "scroll_msglist");
	Image_Server = cocostudio.getUIImageView(view, "Image_Server");
	Panel_SelfMsg = cocostudio.getUIPanel(view, "Panel_SelfMsg");
	img_txt_userbg = cocostudio.getUIImageView(view, "img_txt_userbg");
	Label_Name = cocostudio.getUILabel(view, "Label_Name");
	txt_username = cocostudio.getUITextField(view, "txt_username");
	Label_sendmsg = cocostudio.getUILabel(view, "Label_sendmsg");
	txt_sendmsg = cocostudio.getUITextField(view, "txt_sendmsg");
	btn_send = cocostudio.getUIButton(view, "btn_send");
	Image_MyMeg = cocostudio.getUIImageView(view, "Image_MyMeg");
	Image_LabMyMeg = cocostudio.getUIImageView(view, "Image_LabMyMeg");
	Image_SendMsg = cocostudio.getUIImageView(view, "Image_SendMsg");
	Image_LabSendMsg = cocostudio.getUIImageView(view, "Image_LabSendMsg");
	Panel_18 = cocostudio.getUIPanel(view, "Panel_18");
	btn_Coin = cocostudio.getUIButton(view, "btn_Coin");
	Label_Coin = cocostudio.getUILabel(view, "Label_Coin");
	btn_YuanBao = cocostudio.getUIButton(view, "btn_YuanBao");
	Label_yuanbao = cocostudio.getUILabel(view, "Label_yuanbao");
	panel_MyMsg = cocostudio.getUIImageView(view, "Image_14_0");
	panel_SendMsg = cocostudio.getUIImageView(view, "Image_14");

	currentTab = MSG_SERVER
	Panel_SelfMsg:setVisible(false)
	Image_Server:setVisible(true)
	Common.showProgressDialog("数据加载中,请稍后...")
	initData()
	---添加系统红点和个人信息红点
	showMessageRedPoint()
	local function delaySentMessage()
		--发送消息
		sendUser()
		--发送系统列表请求消息
		sendMAIL_SYSTEM_MESSGE_LIST(0,100)
		if profile.Message.getUserMessage_no_ReadCount() + profile.Message.getSystemMessage_no_ReadCount() == 0 then
			profile.Message.setisHallMessage_isRed()
		end
	end

	LordGamePub.runSenceAction(view, delaySentMessage, false)
end

function initData()
	local coinNum = profile.User.getSelfCoin()
	local yuanBaoNum = profile.User.getSelfYuanBao()
	Label_Coin:setText(""..coinNum)
	Label_yuanbao:setText(""..yuanBaoNum)
	txt_username:setVisible(false)
	txt_sendmsg:setVisible(false)
	img_server:loadTexture(Common.getResourcePath("btn_macth_press.png"))
	img_user:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
	zi_server:loadTexture(Common.getResourcePath("ui_email_btn_system2.png"))
	zi_user:loadTexture(Common.getResourcePath("ui_email_btn_personage.png"))
	local MyMegPos = Image_MyMeg:getPosition()
	local SendMsgPos = Image_SendMsg:getPosition()
	--为了去掉按钮与右边框的空白间隔
	Image_MyMeg:setPosition(ccp(MyMegPos.x + 0.5, MyMegPos.y))
	Image_SendMsg:setPosition(ccp(SendMsgPos.x + 0.5, SendMsgPos.y))
end

--发送获取个人消息
function sendUser()
	--全部的消息，现在要干掉server
	sendDBID_V2_GET_CONVERSATION_LIST(PageStartID,PageSize)
end

--[[--
--更新系统站内信 阅读状态
--@param #Byte MessageType 消息类型
--@param #number MessageID 站内信ID
--]]
function updateSeverImageState(MessageType, MessageID)
	--如果不是系统领奖消息类型
	if MessageStateTable[""..MessageID] == nil then
		return
	end
	if MessageType ~= 1 then
		MessageStateTable[""..MessageID]:loadTexture(Common.getResourcePath("ic_email_envelope_yidu.png"))
	else
		MessageStateTable[""..MessageID]:loadTexture(Common.getResourcePath("ic_email_gift_yidu.png"))
	end
end


--[[--
--更新系统站内信 领奖状态
--@param #number MessageID 消息ID
--]]
function updateServerReveiveState(MessageID, type)
	if SystemMessageTable["SystemMessageList"] ~= nil then
		for i = 1, #SystemMessageTable["SystemMessageList"] do
			if SystemMessageTable["SystemMessageList"][i] ~= nil then
				if MessageID == SystemMessageTable["SystemMessageList"][i].MessageId then
					--如果是系统消息
					SystemMessageTable["SystemMessageList"][i].MessageFlag = type;
					--type :2.已领奖
					if type == 2 then
						SystemMessageTable["SystemMessageList"][i].MessageTitle = (SystemMessageTable["SystemMessageList"][i].MessageTitle .. "[已领奖]")
						--type :1.已读
					elseif type == 1 then
						SystemMessageTable["SystemMessageList"][i].MessageTitle = (SystemMessageTable["SystemMessageList"][i].MessageTitle .. "[已读]")
					end
					MessageReceiveStateTable[""..MessageID]:setText(SystemMessageTable["SystemMessageList"][i].MessageTitle)
					break;
				end
			end
		end
	end
end

function requestMsg()

end

--返回
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		HallLogic.sendMessageInfo()
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

--发消息到制定昵称
function callback_btn_send(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--type 2:发给制定昵称
		--		MessagePlayerLogic.setConversationID(2)
		--如果发送的昵称为空
		if NickName == "" or NickName == nil then
			Common.showToast("要发送的昵称为空", 2)
			return
		end
		--如果发送的内容为空
		if SendValue == nil or SendValue == "" then
			Common.showToast("要发送的信息为空", 2)
			return
		end
		sendDBID_V2_SEND_MSG_NICKNAME(NickName,SendValue); --发送聊天消息请求
	elseif component == CANCEL_UP then
	--取消
	end
end

--系统邮件
function callback_img_server(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		img_server:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		img_user:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		zi_server:loadTexture(Common.getResourcePath("ui_email_btn_system2.png"))
		zi_user:loadTexture(Common.getResourcePath("ui_email_btn_personage.png"))
		if currentTab ~= MSG_SERVER then
			setUserOrServerPanelVisible(true)
			setSelfMessageUiVisible(true)
			Common.showProgressDialog("数据加载中,请稍后...")
			initView(MSG_SERVER)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--个人邮件
function callback_img_user(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		img_server:loadTexture(Common.getResourcePath("btn_macth_nor.png"))
		img_user:loadTexture(Common.getResourcePath("btn_macth_press.png"))
		zi_server:loadTexture(Common.getResourcePath("ui_email_btn_system.png"))
		zi_user:loadTexture(Common.getResourcePath("ui_email_btn_personage2.png"))
		if currentTab ~= MSG_USER then
			setUserOrServerPanelVisible(false)
			setSelfMessageUiVisible(true)
			Common.showProgressDialog("数据加载中,请稍后...")
			initView(MSG_USER)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--金币自由兑换
function callback_btn_Coin(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local myyuanbao = profile.User.getSelfYuanBao()
		if myyuanbao >= 50 then
			Common.openConvertCoin()
		else
			--充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 7000, RechargeGuidePositionID.TablePositionB)
			PayGuidePromptLogic.setEnterType(true)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--点击元宝加号
--]]--
function callback_btn_YuanBao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_HALL);
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_MyMeg(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setSelfMessageUiVisible(true)
		initView(MSG_USER)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_SendMsg(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setSelfMessageUiVisible(false)
	elseif component == CANCEL_UP then
	--取消

	end
end

function setSelfMessageUiVisible(flag)
	if flag == true then
		Image_MyMeg:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		Image_LabMyMeg:loadTexture(Common.getResourcePath("ui_email_btn_wodexiaoxi.png"))
		Image_SendMsg:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		Image_LabSendMsg:loadTexture(Common.getResourcePath("btn_emaila_send_message.png"))
		panel_MyMsg:setVisible(true)
		panel_SendMsg:setVisible(false)
		messagelistScrollView:setVisible(true)
		messagelistScrollView:setTouchEnabled(true)

	else
		Image_MyMeg:loadTexture(Common.getResourcePath("btn_paihangbang_charge_nor.png"))
		Image_LabMyMeg:loadTexture(Common.getResourcePath("ui_email_btn_wodexiaoxi2.png"))
		Image_SendMsg:loadTexture(Common.getResourcePath("btn_paihangbang_charge_press.png"))
		Image_LabSendMsg:loadTexture(Common.getResourcePath("btn_emaila_send_message2.png"))
		panel_MyMsg:setVisible(false)
		panel_SendMsg:setVisible(true)
		messagelistScrollView:setVisible(false)
		messagelistScrollView:setTouchEnabled(false)
		messagelistScrollView:removeAllChildren()
	end
end

function setUserOrServerPanelVisible(flag)
	--如果为true则为系统消息，false为个人消息
	if flag then
		Panel_SelfMsg:setVisible(false)
		Image_Server:setVisible(true)
	else
		Panel_SelfMsg:setVisible(true)
		Image_Server:setVisible(false)
	end

end

--全部信息，包括server
function slot_GetMessageList()
	Common.log("youxiang...........diaoyong")
	MessageTable["MessageList"] = profile.Message.getMessageTable()
	if #MessageTable["MessageList"] == 0 then
		--		Common.closeProgressDialog()
		Common.log("youxiang62")
	else
	--		if currentTab == MSG_USER then
	--			initView(MSG_USER)
	--			Common.log("youxiang_user")
	--		else
	--			initView(MSG_SERVER)
	--			Common.log("youxiang_server")
	--		end
	end
end

--[[--
--ios输入确认回调
--]]
local function callbacktxt_username(valuetable)
	local dataTable = {}
	if valuetable["value"] ~= nil then
		Label_Name:setText(valuetable["value"])
		NickName = valuetable["value"]
	end
end

--[[--
--输入框回调函数（ios）
--]]
function callback_txt_username_ios(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(txt_username:getStringValue(), 0, true, callbacktxt_username)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--输入框回调函数（android）
--]]
function callback_txt_username(component)
	local dataTable = {}
	if txt_username:getStringValue() ~= nil then
		Label_Name:setText(txt_username:getStringValue())
		NickName = txt_username:getStringValue()
	end
end

--[[--
--ios输入确认回调
--]]
local function callbacktxt_sendmsg(valuetable)
	local dataTable = {}
	if valuetable["value"] ~= nil then
		Label_sendmsg:setText(valuetable["value"])
		SendValue = valuetable["value"]
	end
end

--[[--
--输入框回调函数（ios）
--]]
function callback_txt_sendmsg_ios(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(txt_sendmsg:getStringValue(), 0, true, callbacktxt_sendmsg)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--输入框回调函数（android）
--]]
function callback_txt_sendmsg(component)
	local dataTable = {}
	if txt_sendmsg:getStringValue() ~= nil then
		Label_sendmsg:setText(txt_sendmsg:getStringValue())
		SendValue = txt_sendmsg:getStringValue()
	end
end

function slot_ToAnyone()
	local resultTable = {};
	resultTable = profile.Message.getToAnyone();
	--如果消息发送成功0,失败1
	if tonumber(resultTable["Result"]) == 0 then
		Common.showToast("发送成功", 2); --弹成功toast
		txt_sendmsg:setText("");
		Label_sendmsg:setText("");
	elseif tonumber(resultTable["Result"]) == 1 then
		Common.showToast(resultTable["ResultTxt"], 2);
		txt_sendmsg:setText("");
		Label_sendmsg:setText("");
	end
end

--[[--
--个人消息红点显示
--]]
function showMessageRedPoint()
	Common.log("showUserMessage   1")
	btnGanTanHao_User = UIImageView:create()
	btnGanTanHao_User:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	btnGanTanHao_User:setPosition(ccp(80, 15));
	btnGanTanHao_User:setVisible(false)
	img_user:addChild(btnGanTanHao_User)
	Common.log("showSystemMessage   1")
	btnGanTanHao_System = UIImageView:create()
	btnGanTanHao_System:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	btnGanTanHao_System:setPosition(ccp(80, 15));
	btnGanTanHao_System:setVisible(false)
	img_server:addChild(btnGanTanHao_System)
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DBID_V2_GET_CONVERSATION_LIST, slot_GetMessageList)
	--新版站内信 监听
	--系统消息列表监听
	framework.addSlot2Signal(MAIL_SYSTEM_MESSGE_LIST, setSystemMessageList)
	framework.addSlot2Signal(DBID_V2_SEND_MSG_NICKNAME, slot_ToAnyone); --指定昵称发送聊天消息
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_V2_GET_CONVERSATION_LIST, slot_GetMessageList)
	--新版站内信 监听
	--移除系统消息列表监听
	framework.removeSlotFromSignal(MAIL_SYSTEM_MESSGE_LIST, setSystemMessageList)
	framework.removeSlotFromSignal(DBID_V2_SEND_MSG_NICKNAME, slot_ToAnyone); --
end
