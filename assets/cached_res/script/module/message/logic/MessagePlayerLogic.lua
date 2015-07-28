module("MessagePlayerLogic",package.seeall)

view = nil;
Panel_20 = nil;--
Panel_372 = nil;--
btn_send = nil;--
txt_sendmsg = nil;--
Label_sendmsg = nil;--
scroll_msglist = nil;--滚动视图
btn_back = nil;--返回按钮
lab_username = nil;--
img_txt_userbg = nil;--
txt_username = nil;--------------
Label_Name = nil;--好友昵称标签
Panel_396 = nil;--

local messageRecordCacheTable = {}; --与好友聊天记录缓存表
local messageLayoutCacheTable = {}; --与好友聊天记录布局缓存表
local MessageImageTable = {}; --存储头像的图片的表
local MessageFriendHeadImageTable = {}; --存储朋友头像的图片的表
local chatMode = nil; --聊天方式  1.与列表中的好友聊天 2.与指定昵称好友聊天
local conversationID = -1; --会话ID
local nickName = nil; --聊天昵称
local friendID = 0; --聊天好友ID
local friendPhotoUrl = nil; --好友头像ID
local PageSize = 30; --每页请求的消息数量
local PageStartID = 0; --请求页起始ID
local selfHeadPortraitUrl = nil; --本机用户头像URL
local selfPhotoUrl = nil; --自己的头像URL
local selfHeadPortraitWidth = 77; --头像的大小
local removeLayoutHeight = 0; --刚移除消息的高度是多少
local currentHeight = 0; --滚动视图的当前高度
local chatListInnerHeight = 0; --聊天列表的内置高度
local chatListScrollViewWidth = 0; --scrollView的宽度
local chatlistScrollViewHeight = 0; --scrollView的高度
local MYSELF = 0; --发消息的人是自己
local FRIEND = 1; --发消息的人是聊天列表的好友
local MAXCOUNT = 60; --显示最大的消息条数
local firstChangeChatListPosFlag = true; --标记是否是第一次改变滚动视图的位置
local chatListInnerHeight = 0; --内置滚动视图的高
local spaceW = 10; --头像与屏幕左右的距离
local spaceH = 25; --上下消息的高度距离
local count = 1; --计数
local num = 1;
local TimeHeight = 25; --时间标签显示的高度
local TextHeight = 63; --一行文本的高度
local oneFontWidth = 50; --一个字的宽度为33
local flagInstantChat = 0; --第一次发起聊天标记
local firstChangePos = 0; --第一次改变滚动视图的聊天位置
local currentTxtInput = nil; --文本框输入
local currentTxtShow = nil; --标签显示
local defaultUserNameValue = ""; --输入框默认为空
local isInitFlag = false;
local firstChangeChatModeTwo = true; --指定昵称的方式第一次改变滚动视图的位置
local CHATWITHEXISTFRIEND = 1; --按个人聊天记录列表中已存在的好友方式聊天
local CHATBYNICKNAME = 2; --按指定昵称方式聊天
local CHATWITHFRIENDSFROMHALL = 3; --由大厅聊天跳转而来
local isFirstInitScrollView = false --第一次初始化消息列表
local isTheLastMsgLoad = false --是否是初次初始化消息列表的最后一条消息
isCloseMessageFlag = 0  --标记是否屏蔽玩家站内信

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_372 = cocostudio.getUIPanel(view, "Panel_372");
	btn_send = cocostudio.getUIButton(view, "btn_send");
	scroll_msglist = cocostudio.getUIScrollView(view, "scroll_msglist");
	txt_sendmsg = cocostudio.getUITextField(view, "txt_sendmsg");
	Label_sendmsg = cocostudio.getUILabel(view, "Label_sendmsg");
	btn_back = cocostudio.getUIButton(view, "btn_back");
	img_txt_userbg = cocostudio.getUIImageView(view, "img_txt_userbg");
	Label_Name = cocostudio.getUILabel(view, "Label_Name");
	Panel_396 = cocostudio.getUIPanel(view, "Panel_396");
	getScrollViewSize(); --获取滚动视图的宽和高
	initFriendName(); --初始化朋友昵称控件
end

--[[--
--初始化朋友昵称控件显示和隐藏两种状态
--]]
function initFriendName()
	--1:站内信聊天 2:发给制定昵称 3:大厅跳转过来的聊天
	if tonumber(chatMode) == CHATWITHEXISTFRIEND then
		Label_Name:setText(nickName); --nickname赋值
		img_txt_userbg:setTouchEnabled(false);
		txt_sendmsg:setVisible(false);
	elseif tonumber(chatMode) == CHATBYNICKNAME then
		img_txt_userbg:setTouchEnabled(false);
		txt_sendmsg:setVisible(false);
	elseif tonumber(chatMode) == CHATWITHFRIENDSFROMHALL then
		Label_Name:setText(nickName); --nickname赋值
		Common.log("nickName=" .. nickName);
		img_txt_userbg:setTouchEnabled(false);
		txt_sendmsg:setVisible(false);
	end
end

--[[--
--初始化滚动视图
--]]
function getScrollViewSize()
	chatListScrollViewWidth = scroll_msglist:getContentSize().width; --可视化的滚动视图的宽度
	chatlistScrollViewHeight = scroll_msglist:getContentSize().height; --可视化的滚动视图的高度
end



--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MessagePlayer.json")
	local gui = GUI_MESSAGEPLAYER
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
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView(); --初始化控件
	--如果聊天方式是通过与列表好友聊天
	isFirstInitScrollView = true
	isTheLastMsgLoad = false
	if chatMode == CHATWITHEXISTFRIEND then
		sendDBID_V2_GET_CONVERSATION(conversationID, PageSize, PageStartID); --向服务器发送会话请求
	end
end

--[[--
--更新自己头像的图片
--]]
local function updataSelfHeadImage(path)
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
	if photoPath ~= nil and photoPath ~= "" and MessageImageTable[""..id] ~= nil then
		MessageImageTable[""..id]:loadTexture(photoPath);
		MessageImageTable[""..id]:setScale(0.8);
	end
end

--[[--
--更新朋友头像的图片
--]]
local function updataFriendHeadImage(path)
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
	if photoPath ~= nil and photoPath ~= "" and MessageFriendHeadImageTable[""..id] ~= nil then
		MessageFriendHeadImageTable[""..id]:loadTexture(photoPath);
		MessageFriendHeadImageTable[""..id]:setScale(0.8);
	end
end

--[[--
--将滚动视图调整到底部
--]]
function chatScrollToBottomTimer()
	scroll_msglist:scrollToBottom(0.1, false);
end

--[[--
--计算消息气泡的宽度和高度
--]]
function caculateMessageWidth(textNum)
	local messagePropertyTable = {}; --存储消息气泡布局的宽和高
	local contentHeight = 0;
	local contentPanelWidth = 0;
	--消息字数少于11个字,则分配一行文本的高度
	if textNum <= 11 then
		contentHeight = TextHeight;
		--消息字数为一个
		if textNum == 1 then
			contentPanelWidth = 85;
		--消息字数为二个
		elseif textNum == 2 then
			contentPanelWidth = 120;
		--消息字数为三个
		elseif textNum == 3 then
			contentPanelWidth = 145;
		--消息字数为四个
		elseif textNum == 4 then
			contentPanelWidth =160;
		--消息字数为大于五个
		elseif textNum >= 5 then
			contentPanelWidth = 4 * oneFontWidth + (textNum - 4) * 23;
		end
		--消息字数大于11个字
	elseif textNum > 11  then
		contentPanelWidth = GameConfig.ScreenWidth * 0.29; --设置消息气泡宽度
		--如果是整行文字数
		if textNum % 11 == 0 then
			contentHeight = ((textNum / 11) - 1)* 35 + TextHeight; --内容的高度
		--如果不是整行文字数
		else
			contentHeight = (textNum / 11)* 35 + TextHeight; --内容的高度
		end
	end
	messagePropertyTable.contentHeight = contentHeight;
	messagePropertyTable.contentPanelWidth = contentPanelWidth;
	return messagePropertyTable;
end

--[[--
--向滚动视图添加新消息
--@param table chatTable 新聊天消息
--]]
function addNewMessageToScrollView(chatTable)
	count = count + 1;
	num = num + 1;
	local creatTime = chatTable.CreateTime; --获取消息产生的时间
	local messageContent = chatTable.Content; --获取消息内容
	local sender = chatTable.Sender; --发送消息的人
	local textNum = Common.utfstrlen(messageContent); --获取消息内容的字数
	local contentPanelWidth = 0;
	local contentHeight = 0;
	local messagePropertyTable = caculateMessageWidth(textNum);
	contentPanelWidth = messagePropertyTable.contentPanelWidth;
	contentHeight = messagePropertyTable.contentHeight;
	local newAddHeight = contentHeight + TimeHeight + spaceH; --将要新添的消息内容和加上时间条的的总高度
	chatListInnerHeight = chatListInnerHeight + newAddHeight; --内置滚动视图的高度

	--绘制显示时间的标签
	local lbTime = ccs.label({
		text = creatTime,
		color = ccc3(255,255,255),
	})
	local imageTimeBG = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("input_gerenziliao.png"),
		size = CCSizeMake(80,TimeHeight),
	})
	--绘制显示用户头像的UIImage,默认一个头像
	local imageHeadPortrait = ccs.image({
		scale9 = false,
		image = Common.getResourcePath("hall_portrait_default.png"),
		size = CCSizeMake(selfHeadPortraitWidth,selfHeadPortraitWidth),
	})


	local lbMessageContent = ccs.label({
		text = messageContent,
		fontSize = 25,
		color = ccc3(0, 0, 0),
	})

	lbMessageContent:setTextAreaSize(CCSizeMake(GameConfig.ScreenWidth/4, contentHeight));


	currentHeight = currentHeight + newAddHeight; --设置(更新)当前聊天记录的位置
	--绘制总的单元panel
	local layoutPanel = ccs.panel({
		size = CCSizeMake(GameConfig.ScreenWidth/2, newAddHeight - spaceH),
		capInsets = CCRectMake(20, 38, 10,3),
	})
	--绘制单元panel背景
	local messageBgPanel = nil;
	--如果是自己发送的消息
	if sender == MYSELF then
		lbMessageContent:setAnchorPoint(ccp(0.01, 0.2));
		lbTime:setAnchorPoint(ccp(0.5, 0.5));
		MessageImageTable[""..count] = imageHeadPortrait;
		--将聊天内容的背景置为黄色
		messageBgPanel = ccs.panel({
			scale9 = true,
			image = Common.getResourcePath("email_feedback_left_bg2.png"),
			size = CCSizeMake(contentPanelWidth,contentHeight),
			capInsets = CCRectMake(20, 38, 10,3),
		})
		messageBgPanel:setAnchorPoint(ccp(1,1)); --左下角
		--如果本账号用户的头像不为空,则更换默认头像
		selfHeadPortraitUrl = profile.User.getSelfPhotoUrl();
		if selfHeadPortraitUrl ~= "" and selfHeadPortraitUrl ~= nil and imageHeadPortrait ~= nil then
			Common.getPicFile(selfHeadPortraitUrl, count, true, updataSelfHeadImage);
		end
		--如果是朋友发送的消息
	elseif sender == FRIEND then
		lbMessageContent:setAnchorPoint(ccp(-0.03, 0.2));
		lbTime:setAnchorPoint(ccp(0.5, 0.5));
		MessageFriendHeadImageTable[""..count] = imageHeadPortrait;
		--将聊天内容的背景置为蓝色
		messageBgPanel = ccs.panel({
			scale9 = true,
			image = Common.getResourcePath("email_feedback_left_bg1.png"),
			size = CCSizeMake(contentPanelWidth,contentHeight),
			capInsets = CCRectMake(20, 38, 10,3),
		})
		messageBgPanel:setAnchorPoint(ccp(0,1)); --右下角
		--如果聊天好友的头像不为空,则更换默认头像
		if friendPhotoUrl ~= nil and friendPhotoUrl ~= "" and imageHeadPortrait ~= nil then
			Common.getPicFile(friendPhotoUrl, num, true, updataFriendHeadImage);
		end
	end
	messageBgPanel:addChild(lbMessageContent);
	imageHeadPortrait:setScale(0.8);
	layoutPanel:setTouchEnabled(false); --设置不可触摸
	layoutPanel:addChild(lbTime); --向画布上添加时间标签
	layoutPanel:addChild(imageHeadPortrait); --向画布上添加头像image
	layoutPanel:addChild(messageBgPanel); --向画布添加背景画布

	local positionY = 0; --设置总单元panel的位置
	positionY = chatListInnerHeight; --新添加消息的位置

	--记录聊天列表的布局信息缓存
	local chatLayoutData = {};
	chatLayoutData.layoutPanel = layoutPanel; --总单元画布控件地址
	chatLayoutData.height = layoutPanel:getSize().height; --总单元画布控件的高度
	chatLayoutData.positionY = positionY; --总单元画布控件的位置

	if flagInstantChat == 1 then
		if tonumber(firstChangePos) == 0 then
			positionY = messageLayoutCacheTable[1].positionY;
			chatLayoutData.positionY = messageLayoutCacheTable[1].positionY;
		elseif tonumber(firstChangePos) == 1 then
			positionY = messageLayoutCacheTable[#messageLayoutCacheTable].positionY;
			chatLayoutData.positionY = messageLayoutCacheTable[#messageLayoutCacheTable].positionY;
		end
		firstChangePos = 1;
	end
	--如果是按指定昵称的方式聊天
	if tonumber(chatMode) == CHATBYNICKNAME then
		if firstChangeChatModeTwo == true then
			positionY = 100;
			chatLayoutData.positionY = positionY;
		else
			positionY = messageLayoutCacheTable[#messageLayoutCacheTable].positionY;
			chatLayoutData.positionY = messageLayoutCacheTable[#messageLayoutCacheTable].positionY;
		end
		firstChangeChatModeTwo = false;
	end

	table.insert(messageLayoutCacheTable, chatLayoutData); --布局信息存入缓存表
	--设置总单元panel的位置,如果发送消息者是自己,则显示在右侧
	local layoutH = layoutPanel:getSize().height
	if tonumber(sender) == MYSELF then
		SET_POS(imageHeadPortrait, GameConfig.ScreenWidth - selfHeadPortraitWidth, selfHeadPortraitWidth/2 + TimeHeight); --设置头像位置
		SET_POS(lbMessageContent, spaceW * 2.5, 0);
		SET_POS(lbTime, GameConfig.ScreenWidth - selfHeadPortraitWidth , 5); --设置时间标签在总单元panel的显示位置
		SET_POS(imageTimeBG, GameConfig.ScreenWidth/2, contentHeight + TimeHeight*2);
		SET_POS(messageBgPanel, GameConfig.ScreenWidth - selfHeadPortraitWidth*1.5, selfHeadPortraitWidth + TimeHeight - 5);
		SET_POS(layoutPanel, GameConfig.ScreenWidth/189-5, positionY); --设置自己的聊天消息的位置
		if not isFirstInitScrollView then
			SET_POS(imageHeadPortrait, GameConfig.ScreenWidth - selfHeadPortraitWidth, layoutH - selfHeadPortraitWidth/2 - 5); --设置头像位置
			SET_POS(lbTime, GameConfig.ScreenWidth - selfHeadPortraitWidth , layoutH - selfHeadPortraitWidth - 20); --设置时间标签在总单元panel的显示位置
			SET_POS(messageBgPanel, GameConfig.ScreenWidth - selfHeadPortraitWidth*1.5, layoutH - 5);
		end
	elseif tonumber(sender) == FRIEND then
		SET_POS(imageHeadPortrait, selfHeadPortraitWidth, selfHeadPortraitWidth/2 + TimeHeight);
		SET_POS(lbMessageContent, spaceW * 3, 0);
		SET_POS(lbTime, selfHeadPortraitWidth, 5); --设置时间标签在总单元panel的显示位置
		SET_POS(imageTimeBG, GameConfig.ScreenWidth/2, contentHeight + TimeHeight*2);
		SET_POS(messageBgPanel, selfHeadPortraitWidth*1.5, selfHeadPortraitWidth + TimeHeight - 5);
		SET_POS(layoutPanel, 0, positionY); --
		if not isFirstInitScrollView then
			SET_POS(imageHeadPortrait, GameConfig.ScreenWidth - selfHeadPortraitWidth, layoutH - selfHeadPortraitWidth/2 - 5); --设置头像位置
			SET_POS(lbTime, selfHeadPortraitWidth, layoutH - selfHeadPortraitWidth - 20); --设置时间标签在总单元panel的显示位置
			SET_POS(messageBgPanel, selfHeadPortraitWidth*1.5, layoutH - 5);
		end
	end
	scroll_msglist:addChild(layoutPanel); --添加到滚动视图
	--如果内置滚动视图的位置小于0,则将视图滚到底部
	if(scroll_msglist:getInnerContainer():getPosition().y >= 0 or chatTable["SpeakerUserID"] ==0)then
		chatScrollToBottomTimer();
	end
	if isTheLastMsgLoad == true then
		isFirstInitScrollView = false
		isTheLastMsgLoad = false
	end
end

--[[--
--清除聊天缓存
--]]
function clearChatText()
	messageRecordCacheTable = {}; -- 聊天记录
	if scroll_msglist ~= nil then
		scroll_msglist:removeAllChildren();
	end
	messageLayoutCacheTable = {};
	chatListInnerHeight = 0;
	currentHeight = 0;
	firstChangeChatListPosFlag = true; -- 第一次改变聊天记录位置标记
	count = 0;
	num = 0;
	flagInstantChat = 0;
	firstChangePos = 0;
	isInitFlag = false;
	chatMode = nil;
	firstChangeChatModeTwo = true;
end

--[[--
--调整每条消息记录的位置
--]]
function changePositionOfEveryMessage()
	local chatLayoutTableSize = #messageLayoutCacheTable; --获取缓存布局表的个数
	local newAddMsgHeight = messageLayoutCacheTable[chatLayoutTableSize].height; --新添加的消息的高度
	if messageLayoutCacheTable[chatLayoutTableSize].positionY < 200 then
		chatScrollToBottomTimer();
	end
	--如果是按指定昵称发送聊天
	if tonumber(chatMode) == CHATBYNICKNAME then
		--当是第一个元素时不改变位置
		if chatLayoutTableSize == 1 then
		else
			for i = 1,chatLayoutTableSize - 1 do
				messageLayoutCacheTable[i].positionY = messageLayoutCacheTable[i].positionY + newAddMsgHeight;
				if tonumber(messageRecordCacheTable[i].Sender) == MYSELF then
					messageLayoutCacheTable[i].positionY = messageLayoutCacheTable[i].positionY + 20
					SET_POS(messageLayoutCacheTable[i].layoutPanel,GameConfig.ScreenWidth/189,messageLayoutCacheTable[i].positionY);
				elseif tonumber(messageRecordCacheTable[i].Sender) == FRIEND then
					SET_POS(messageLayoutCacheTable[i].layoutPanel,0,messageLayoutCacheTable[i].positionY);
				end
			end
		end
		--如果是按聊天列表里的好友聊天
	elseif tonumber(chatMode) == CHATWITHEXISTFRIEND then
		for i = 1,chatLayoutTableSize - 1 do
			messageLayoutCacheTable[i].positionY = messageLayoutCacheTable[i].positionY + newAddMsgHeight;
			if tonumber(messageRecordCacheTable[i].Sender) == MYSELF then
				messageLayoutCacheTable[i].positionY = messageLayoutCacheTable[i].positionY + 20
				SET_POS(messageLayoutCacheTable[i].layoutPanel,GameConfig.ScreenWidth/189,messageLayoutCacheTable[i].positionY);
			elseif tonumber(messageRecordCacheTable[i].Sender) == FRIEND then
				messageLayoutCacheTable[i].positionY = messageLayoutCacheTable[i].positionY + 20
				SET_POS(messageLayoutCacheTable[i].layoutPanel,0,messageLayoutCacheTable[i].positionY);
			end
		end
	end
end

--[[--
--调整滚动视图的大小
--]]
function changeScrollViewSize()
	currentHeight = currentHeight - removeLayoutHeight;
	scroll_msglist:setInnerContainerSize(CCSizeMake(chatListScrollViewWidth, currentHeight));
	chatListInnerHeight = currentHeight;
	removeLayoutHeight = 0;
end

--[[--
--向滚动视图里  动态的新添加一条聊天消息,其中分为3个封装方法(1.向滚动视图添加;2.调整每条消息记录的位置;3.调整滚动视图的大小)
--@param table chatTable 新聊天消息
--]]
function addOneNewChatRecordToScrollView(chatTable)
	addNewMessageToScrollView(chatTable); --向滚动视图添加新消息
	--如果消息发送成功,则将所有消息往上移一个消息内容的高度
	if tonumber(chatMode) == CHATWITHEXISTFRIEND then
		if flagInstantChat == 1 then
			changePositionOfEveryMessage(); --调整每条消息记录的位置
		end
		--按指定昵称方式聊天
	elseif tonumber(chatMode) == CHATBYNICKNAME then
		changePositionOfEveryMessage(); --调整每条消息记录的位置
	end
	changeScrollViewSize(); --调整滚动视图的大小
end

--[[--
--将聊天记录缓存表 显示在滚动视图上
--]]
function showChatRecordInScrollView()
	currentHeight = 0; --初始化滚动视图当前的位置高度
	chatListInnerHeight = 0; --初始化滚动视图的内置高度
	--如果缓存表不为空，并且消息数量不为0,则在滚动视图中显示消息记录列表
	if #messageRecordCacheTable ~= 0 then
		for i = #messageRecordCacheTable,1,-1 do
			addOneNewChatRecordToScrollView(messageRecordCacheTable[i]);
			if i == 1 then
				isTheLastMsgLoad = true
			end
		end
	end
end

--[[--
--初始化与好友的会话列表
--]]
function initScrollView()
	--如果缓存表不为空，并且消息数量不为0,则在滚动视图中显示消息记录列表
	if #messageRecordCacheTable ~= 0 then
		showChatRecordInScrollView();
	end
end

--[[--
--自己聊天消息的监听
--]]
function slot_Send()
	local flagTable = profile.Message.getSendMessage(); --获取消息发送是否成功
	--如果消息发送成功,则加入缓冲表
	if flagTable["Result"] == 0 then
		--Common.showToast(flagTable["ResultTxt"], 2);
		local chatLayoutTemp = {}; --存布局信息
		local chatRecordTemp = {}; --存消相关属性
		chatRecordTemp.Sender = 0; --发送消息者为自己
		chatRecordTemp.CreateTime = "刚刚"; --发送消息时间
		chatRecordTemp.Content = txt_sendmsg:getStringValue(); --输入文本框输入的内容
		txt_sendmsg:setText("");
		--新添加的即时消息
		flagInstantChat = 1;
		table.insert(messageRecordCacheTable,chatRecordTemp);  --添加新消息内容信息
		addOneNewChatRecordToScrollView(chatRecordTemp); --动态添加到表
	else
		Common.showToast(flagTable["ResultTxt"], 2);
	end
	txt_sendmsg:setText(""); --将输入文本框置为空
	Label_sendmsg:setText(""); --消息发送成功则将输入标签置为空
end

function requestMsg()

end

--[[--
--发送消息按钮回调
--]]
function callback_btn_send(component)
	local sendvalue = txt_sendmsg:getStringValue()
	local toNickname = Label_Name:getStringValue()
	--如果是以指定昵称的方式聊天
	if chatMode == CHATBYNICKNAME then
		--如果发送的昵称为空
		if toNickname == "" or toNickname == nil then
			Common.showToast("要发送的昵称为空", 2)
			return
		end
	end
	--如果发送的内容为空
	if sendvalue == nil or sendvalue == "" then
		Common.showToast("要发送的信息为空", 2)
		return
	end
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--1:站内信聊天 2：发给制定昵称
		if chatMode == CHATWITHEXISTFRIEND then
			local imei = Common.getDeviceInfo();
			sendDBID_V2_SEND_MESSAGE(friendID, sendvalue, "", "", imei, 1); --站内信好友聊天
		--按指定昵称方式聊天
		elseif chatMode == CHATBYNICKNAME then

			Common.log("sendDBID_V2_SEND_MSG_NICKNAME");
			Common.log("toNickname=" .. toNickname .. "sendvalue=" .. sendvalue);
			sendDBID_V2_SEND_MSG_NICKNAME(toNickname,sendvalue); --发送聊天消息请求
		elseif chatMode == CHATWITHFRIENDSFROMHALL then
			sendDBID_V2_SEND_MSG_NICKNAME(nickName,sendvalue); --发送聊天消息请求
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		clearChatText();
		mvcEngine.destroyModule(GUI_MESSAGEPLAYER)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--初始化聊天好友的相关信息
--@param int typeValue 发消息方式  1.与列表已存在好友聊天 2.指定昵称聊天
--@param string SenderNickNamevalue 好友昵称
--@param int ConversationIDvalue 会话ID
--@param int useridValue 用户ID
--@param string PhotoUrlValue 头像url
--]]
function setConversationID(typeValue,SenderNickNamevalue,ConversationIDvalue, useridValue,PhotoUrlValue)
	chatMode = typeValue;
	conversationID = ConversationIDvalue;
	nickName = SenderNickNamevalue;
	friendID = useridValue;
	friendPhotoUrl = PhotoUrlValue;
end

--[[--
--发送给指定昵称
--]]
function slot_ToAnyone()
	local resultTable = {};
	resultTable = profile.Message.getToAnyone();
	--	Common.log("发送给指定昵称" .. resultTable["Result"] .. "失败原因=" .. resultTable["ResultTxt"]);
	--	Common.showToast("结果=" .. resultTable["Result"] .. " 原因=" .. resultTable["ResultTxt"],3);
	--如果消息发送成功0,失败1
	if tonumber(resultTable["Result"]) == 0 then
		--Common.showToast(resultTable["ResultTxt"], 2); --弹成功toast
		local NewCnt =  0;
		if #messageRecordCacheTable == 0 then
			NewCnt =  1;
		else
			NewCnt = #messageRecordCacheTable + 1;
		end
		local ShowMessageContent = {};
		ShowMessageContent.Sender = 0;
		ShowMessageContent.CreateTime = "刚刚";
		ShowMessageContent.Content = txt_sendmsg:getStringValue();
		txt_sendmsg:setText("");
		table.insert(messageRecordCacheTable,ShowMessageContent);
		addOneNewChatRecordToScrollView(ShowMessageContent);
		txt_sendmsg:setText("");
		Label_sendmsg:setText("");
	elseif tonumber(resultTable["Result"]) == 1 then
		Common.showToast(table["ResultTxt"], 2);
		--		Common.showToast("发送成功", 2);
		txt_sendmsg:setText("");
		Label_sendmsg:setText("");
	end
end

--[[--
--获取与聊天好友的聊天记录
--]]
function get_MessageRecordWithFriend()
	local messageTable = profile.Message.getMessageContent();
	isInitFlag = true;
	for i = 1,#messageTable["MessageTable"] do
		table.insert(messageRecordCacheTable,messageTable["MessageTable"][i]);
	end

	initScrollView(); --初始化与好友的会话列表
	isCloseMessageFlag = messageTable.IsShield
	--	Common.log("aab......zzssaisCloseMessageFlag=" .. isCloseMessageFlag)
	--	Common.showToast(isCloseMessageFlag .. "              zzzz", 2)
end

--[[--
---发送内容输入框(安卓)
--]]
function callback_txt_sendmsg()
	--控件不存在,return
	if Label_sendmsg == nil then
		return;
	end
	if txt_sendmsg:getStringValue() ~= nil then
		--如果用户输入内容,则将输入的内容赋给显示的label
		Label_sendmsg:setText(txt_sendmsg:getStringValue());
	end
end

--[[--
---发送内容输入框(ios)
--]]
function callback_txt_sendmsg_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		currentTxtInput = txt_sendmsg;
		currentTxtShow = Label_sendmsg;
		Common.showAlertInput(txt_sendmsg:getStringValue(),0,true,callbackInputForIos)
	elseif component == CANCEL_UP then
	--取消
	end
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
		if defaultUserNameValue ~= nil then
			--如果用户输入的为空,且该label有默认值,则把默认显示的内容放回label
			currentTxtShow:setText(defaultUserNameValue);
		end
		return;
	end
	--如果用户输入内容,则将输入的内容赋给显示的label
	currentTxtInput:setText(value);
	currentTxtShow:setText(value);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(DBID_V2_GET_CONVERSATION, get_MessageRecordWithFriend); --添加获取与好友会话内容的监听
	framework.addSlot2Signal(DBID_V2_SEND_MESSAGE, slot_Send); --本账号玩家发送的消息
	framework.addSlot2Signal(DBID_V2_SEND_MSG_NICKNAME, slot_ToAnyone); --指定昵称发送聊天消息
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(DBID_V2_GET_CONVERSATION, get_MessageRecordWithFriend); --
	framework.removeSlotFromSignal(DBID_V2_SEND_MESSAGE, slot_Send); --
	framework.removeSlotFromSignal(DBID_V2_SEND_MSG_NICKNAME, slot_ToAnyone); --
end