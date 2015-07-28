module("CustomServiceLogic",package.seeall)


view = nil
local scene = nil
local viewShowTag = 1--显示tab
local ConversationID = -1--回话id
local PageSize = 10--显示数量
local PageStartID = 0
--控件
btn_back = nil--返回键
btn_send = nil--发送键
lab_userid = nil--用户id
panel_fankui = nil--
messagelistScrollView = nil
txt_sendmsg = nil --发送消息输入框(用于输入)
label_sendmsg = nil --发送消息输入框(用于输入)

--动态添加数据
local ShowMessageContent = {}
local MessageContent = {}
--全局变量
local size = nil
local useravator = nil --个人头像在本地的地址
--菜单
local menuTable = {};--菜单table

local tab = nil --当前的tab

local leftMargin = 50 --左边和右边的间距
local cellWidth = 0  --每个元素的宽
local cellHeight = 100 --每个元素的高
local lieSize = 1 --列数
local spacingW = 0 --横向间隔
local spacingH = 10 --纵向间隔
local avatorWidth = 77 --头像的大小

local viewW = 0
local viewHMax = 450
local viewH = 0
local viewX = 0
local viewY = 100

local ImageOffXY = 10 --字体和背景图的间距

function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CustomService.json")
	local gui = GUI_CUSTOMSERVICE
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
	GameStartConfig.addChildForScene(view);
	size = CCDirector:sharedDirector():getWinSize()
	initView()

	--添加android返回键
	GameConfig.setTheCurrentBaseLayer(GUI_CUSTOMSERVICE)

	useravator = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())

	local function delaySentMessage()
		--请求消息
		sendDBID_V2_GET_CONVERSATION(ConversationID, PageSize, PageStartID)
	end

	LordGamePub.runSenceAction(view,delaySentMessage,false)
end

function initView()
	btn_back = cocostudio.getUIButton(view, "btn_back")
	btn_send = cocostudio.getUIButton(view, "btn_send")
	lab_userid = cocostudio.getUILabel(view,"lab_userid")
	panel_fankui = cocostudio.getUITextField(view, "Panel_fankui")
	messagelistScrollView = cocostudio.getUIScrollView(view, "scroll_msglist")
	txt_sendmsg = cocostudio.getUITextField(view, "txt_sendmsg")
	txt_sendmsg:setVisible(false);
	label_sendmsg = cocostudio.getUILabel(view, "Label_sendmsg")
	--初始化
	if #MessageContent == 0 then
		Common.showProgressDialog("数据加载中,请稍后...")
	end
	--初始化界面信息
	lab_userid:setText("ID:"..profile.User.getSelfUserID())
	cellWidth = (size.width-leftMargin*2)/2 -10
	viewW = size.width-100
	viewY = 100
end

function requestMsg()

end
--返回
function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消
	end
end

function initList()
	local cellSize = #ShowMessageContent --总数
	Common.log("客服size.width"..size.width)
	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数

	local RightMargin = 20 --左边距
	local AllHangshu = 0 --文字总行数
	local AllViewHeight = 0 --控件总高度
	local TimeHeight = 35 --时间文字高度
	local TextHeight = 30
	local IamgeOffXY = 10
	local cellHeightTable = {}
	for i = 0, cellSize - 1 do
		local Content = ShowMessageContent[i + 1].Content
		local textNum = Common.utfstrlen(Content)
		local textHang = 0
		textHang = (textNum + 15 )/16
		if i ~= 0 then
			cellHeightTable[i+1] = cellHeightTable[i]+ textHang * TextHeight + TimeHeight
		else
			cellHeightTable[i+1] = textHang * TextHeight + TimeHeight
		end
		AllHangshu = AllHangshu + textHang
	end

	AllViewHeight = AllHangshu * TextHeight + (spacingH + TimeHeight) *(cellSize - 1) + (TimeHeight)* cellSize +20--控件总高度

	if AllViewHeight > viewHMax then
		viewH = viewHMax
		viewX = leftMargin
		viewY = viewY
	else
		viewH = AllViewHeight
		viewX = leftMargin
		viewY = viewY + viewHMax - AllViewHeight
	end

	messagelistScrollView:setPosition(ccp(viewX, viewY))
	messagelistScrollView:setSize(CCSizeMake(viewW, viewH))
	messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW, AllViewHeight))

	local OffsetX = (viewW - cellWidth * lieSize) / 2 - spacingW * (lieSize - 1) --横向位移，用于居中scrollView
	local OffsetY = cellHeight * hangSize + spacingH * (hangSize - 1) --纵向位移，用于对齐scrollView顶部

	for i = 0, cellSize - 1 do
		local Content = ShowMessageContent[i + 1].Content
		local time = ShowMessageContent[i + 1].CreateTime
		local Sender = ShowMessageContent[i + 1].Sender

		--每行的高度随字数的多少而增加
		--行数  16字一行
		local textNum = Common.utfstrlen(Content)
		local textHang = 0
		local textWidth = 0
		textHang = (textNum + 15 )/16
		--时间
		local labelTime = ccs.label({
			text = time,
			color = ccc3(249, 235, 219),
		})
		labelTime:setFontSize(25)
		--内容
		local textAreaInfo = nil
		if textHang < 2 then
			textAreaInfo = ccs.TextArea({
				text = Content,
				size = CCSizeMake(cellWidth-avatorWidth-10,  TimeHeight),
				color = ccc3(43,24,16),
			})
			textWidth = textNum * 20 + avatorWidth + ImageOffXY
			if textWidth >= (cellWidth+ImageOffXY-avatorWidth) then
				textWidth = cellWidth+ImageOffXY-avatorWidth
			end
		else
			textAreaInfo = ccs.TextArea({
				text = Content,
				size = CCSizeMake(cellWidth-avatorWidth-10, (textHang) * TextHeight ),
				color = ccc3(43,24,16),
			})
			textWidth = textNum * 20 + avatorWidth + ImageOffXY
			if textWidth >= (cellWidth+ImageOffXY-avatorWidth) then
				textWidth = cellWidth+ImageOffXY-avatorWidth
			end
		end

		textAreaInfo:setFontSize(25)
		textAreaInfo:setAnchorPoint(ccp(0, 1))
		--内容背景，头像
		local imageInfoBg = nil
		local imageAvator = nil
		--自己的信息
		if Sender == 0 then
			imageInfoBg = ccs.panel({
				scale9 = true,
				image = Common.getResourcePath("email_feedback_left_bg2.png"),
				size = CCSizeMake(textWidth ,TimeHeight+ (textHang) * TextHeight + IamgeOffXY),
				capInsets = CCRectMake(20, 38, 10,3),
			})
			imageInfoBg:setAnchorPoint(ccp(1, 1))
			imageAvator = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("hall_portrait_default.png"),
				size = CCSizeMake(avatorWidth,avatorWidth),
			})
			imageAvator:setScale(0.9)
			if useravator ~= nil and useravator ~= "" then
				imageAvator:loadTexture(useravator)
				imageAvator:setScale(0.8)
			end
		else

			imageInfoBg = ccs.panel({
				scale9 = true,
				image = Common.getResourcePath("email_feedback_left_bg1.png"),
				size = CCSizeMake(textWidth + IamgeOffXY, TimeHeight + (textHang) * TextHeight + IamgeOffXY),
				capInsets = CCRectMake(20, 38, 10,3),
			})
			imageInfoBg:setAnchorPoint(ccp(0, 1))
			imageAvator = ccs.image({
				scale9 = false,
				image = Common.getResourcePath("ic_email_system_information.png"),
				size = CCSizeMake(avatorWidth, avatorWidth),
			})

		end
		--背景层，layer
		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(cellWidth+ImageOffXY,  TimeHeight*2  + textHang * TextHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})

		local dx = (messagelistScrollView:getSize().width - layout:getSize().width * lieSize) / 2  --横向位移，用于居中scrollView

		if Sender == 0 then --自己的信息
			ShowMessageContent[i + 1].msgViewX = (size.width-100)/2
			--设置時間
			SET_POS(labelTime, layout:getSize().width - imageAvator:getSize().width/1.5 , layout:getSize().height-avatorWidth-5)
			--设置头像
			SET_POS(imageAvator,layout:getSize().width - avatorWidth/2-RightMargin, layout:getSize().height-avatorWidth/2+10)
			--设置对话背景
			SET_POS(imageInfoBg, layout:getSize().width - imageAvator:getSize().width - RightMargin - 5, layout:getSize().height + 10)
			--设置描述
			SET_POS(textAreaInfo, layout:getSize().width- imageAvator:getSize().width - textWidth + IamgeOffXY - RightMargin,  layout:getSize().height - 15)
		else
			--设置時間
			SET_POS(labelTime, imageAvator:getSize().width/1.5 , layout:getSize().height-avatorWidth-5)
			--客服信息
			ShowMessageContent[i + 1].msgViewX = 0
			--设置头像
			SET_POS(imageAvator, avatorWidth/2 + RightMargin - 5,layout:getSize().height-avatorWidth/2+10)
			--设置对话背景
			SET_POS(imageInfoBg, avatorWidth + RightMargin + 15, layout:getSize().height + 10)
			--设置描述
			SET_POS(textAreaInfo, avatorWidth + RightMargin + 35, layout:getSize().height - 20)
		end

		ShowMessageContent[i + 1].msgViewY = AllViewHeight - cellHeightTable[i+1] - spacingH * i -10
		SET_POS(layout, ShowMessageContent[i + 1].msgViewX, AllViewHeight - cellHeightTable[i+1] - spacingH * i-10 - TimeHeight * (i+1) )

		layout:addChild(imageInfoBg)
		layout:addChild(labelTime)
		layout:addChild(textAreaInfo)
		layout:addChild(imageAvator)

		ShowMessageContent[i + 1].msgViewH = textHang * TextHeight + TimeHeight
		ShowMessageContent[i + 1].layout = layout

		messagelistScrollView:addChild(layout)
	end
	--信息滑动到底部
	messagelistScrollView:scrollToBottom(1, false)
end

--发信息
function callback_btn_send(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local sendvalue = label_sendmsg:getStringValue()
		local imei = Common.getDeviceInfo()

		if sendvalue ~= nil and sendvalue ~= "" then
			Common.log(1001, sendvalue)
			local connecttype = Common.getConnectionType()
			local version = Common.getVersionName()
			Common.log("sendmsgto1001"..connecttype..version)
			sendDBID_V2_SEND_MESSAGE(1001, sendvalue, "", "", imei, connecttype,version)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function slot_Content()
	Common.closeProgressDialog()
	MessageContent = profile.Message.getMessageContent()
	ShowMessageContent = MessageContent["MessageTable"]
	initList()
end

function slot_Send()
	local flagTable = profile.Message.getSendMessage()
	if flagTable["Result"] == 0 then
		Common.showToast(flagTable["ResultTxt"], 2)
		local NewCnt = #ShowMessageContent + 1
		ShowMessageContent[NewCnt] = {}
		ShowMessageContent[NewCnt].Sender = "0"
		ShowMessageContent[NewCnt].CreateTime = "刚刚"
		ShowMessageContent[NewCnt].Content = label_sendmsg:getStringValue()
		ShowMessageContent[NewCnt].msgViewX = (size.width-100)/2
		ShowMessageContent[NewCnt].msgViewY = 0
		local textNum = Common.utfstrlen(ShowMessageContent[NewCnt].Content)
		local textHang = (textNum + 15 )/16
		ShowMessageContent[NewCnt].msgViewH  = textHang * 30 + 35
		if NewCnt > 1 then
			ShowMessageContent[NewCnt].msgViewY = ShowMessageContent[NewCnt - 1].msgViewY
			for i = 1, NewCnt - 1 do
--				Common.log("ShowMessageContent============"..ShowMessageContent[i].msgViewY)

				if i ~= NewCnt - 1 then
					ShowMessageContent[i].msgViewY = ShowMessageContent[i].msgViewY + ShowMessageContent[NewCnt].msgViewH + spacingH + 35
				else
					ShowMessageContent[i].msgViewY = ShowMessageContent[i].msgViewY + ShowMessageContent[NewCnt].msgViewH + spacingH + 55
				end
				SET_POS(ShowMessageContent[i].layout, ShowMessageContent[i].msgViewX, ShowMessageContent[i].msgViewY - 35 * i)
			end
		end
		Addmsg()
	else
		Common.showToast(flagTable["ResultTxt"], 2)
	end
	txt_sendmsg:setText("")
	label_sendmsg:setText("")
end

--[[--
-- 动态添加列
]]
function Addmsg()
	label_sendmsg:setText("");
	txt_sendmsg:setText("");
	local cellSize = #ShowMessageContent --总数
	Common.log(" ShowMessageContent == " .. cellSize)

	local hangSize = math.floor((cellSize + (lieSize - 1)) / lieSize) --行数

	local RightMargin = 20 --左边距
	local AllHangshu = 0 --文字总行数
	local AllViewHeight = 0 --控件总高度
	local TimeHeight = 35 --时间文字高度
	local TextHeight = 30
	local IamgeOffXY = 10
	local cellHeightTable = {}
	for i = 0, cellSize - 1 do
		local Content = ShowMessageContent[i + 1].Content
		local textNum = Common.utfstrlen(Content)
		local textHang = 0
		textHang = (textNum + 15 )/16
		AllHangshu = AllHangshu + textHang
	end
	viewY = 100
	AllViewHeight = AllHangshu * TextHeight + (spacingH + TimeHeight) *(cellSize - 1) + (TimeHeight)* cellSize + 20 --控件总高度

	if AllViewHeight > viewHMax then
		viewH = viewHMax
		viewX = leftMargin
		viewY = viewY
	else
		viewH = AllViewHeight
		viewX = leftMargin
		viewY = viewY+viewHMax - AllViewHeight
	end
	messagelistScrollView:setPosition(ccp(viewX, viewY))
	messagelistScrollView:setSize(CCSizeMake(viewW, viewH))
	messagelistScrollView:setInnerContainerSize(CCSizeMake(viewW, AllViewHeight))
	for i = cellSize, cellSize do
		ShowMessageContent[cellSize].msgViewY = ShowMessageContent[cellSize].msgViewY + 35
		local Content = ShowMessageContent[i].Content
		local time = ShowMessageContent[i].CreateTime
		local Sender = ShowMessageContent[i].Sender

		--每行的高度随字数的多少而增加
		--行数  16字一行
		local textNum = Common.utfstrlen(Content)
		local textHang = 0
		local textWidth = 0
		textHang = (textNum + 15 )/16

		local labelTime = ccs.label({
			text = time,
			color = ccc3(255, 255, 255),
		})

		local textAreaInfo = nil
		if textHang < 2 then
			textAreaInfo = ccs.TextArea({
				text = Content,
				size = CCSizeMake(cellWidth-avatorWidth-10,  TimeHeight),
				color = ccc3(43,24,16),
			})
			textWidth = textNum * 20 + avatorWidth + ImageOffXY
			if textWidth >= (cellWidth+ImageOffXY-avatorWidth) then
				textWidth = cellWidth+ImageOffXY-avatorWidth
			end
		else
			textAreaInfo = ccs.TextArea({
				text = Content,
				size = CCSizeMake(cellWidth-avatorWidth-10, (textHang) * TextHeight ),
				color = ccc3(43,24,16),
			})
			textWidth = textNum * 20 + avatorWidth + ImageOffXY
			if textWidth >= (cellWidth+ImageOffXY-avatorWidth) then
				textWidth = cellWidth+ImageOffXY-avatorWidth
			end
		end
		textAreaInfo:setFontSize(25)
		textAreaInfo:setAnchorPoint(ccp(0, 1))
		local imageInfoBg  = ccs.panel({
			scale9 = true,
			image = Common.getResourcePath("email_feedback_left_bg2.png"),
			size = CCSizeMake(textWidth, TimeHeight+ (textHang) * TextHeight + IamgeOffXY),
			capInsets = CCRectMake(20, 38, 10,3),
		})
		imageInfoBg:setAnchorPoint(ccp(1, 1))
		--头像
		local imageAvator = ccs.image({
			scale9 = false,
			image = Common.getResourcePath("hall_portrait_default.png"),
			size = CCSizeMake(avatorWidth,avatorWidth),
		})
		imageAvator:setScale(0.9)
		if useravator ~= nil and useravator ~= "" then
			imageAvator:loadTexture(useravator)
			imageAvator:setScale(0.8)
		end

		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(cellWidth+ImageOffXY,  TimeHeight*2  + textHang * TextHeight),
			capInsets = CCRectMake(0, 0, 0, 0),
		})

		--设置時間
		SET_POS(labelTime, layout:getSize().width - imageAvator:getSize().width/1.5 , layout:getSize().height-avatorWidth-5)
		--设置头像
		SET_POS(imageAvator,layout:getSize().width - avatorWidth/2-RightMargin, layout:getSize().height-avatorWidth/2+10)
		--设置对话背景
		SET_POS(imageInfoBg, layout:getSize().width - imageAvator:getSize().width - RightMargin - 5, layout:getSize().height + 10)
		--设置描述
		SET_POS(textAreaInfo, layout:getSize().width- imageAvator:getSize().width - textWidth + IamgeOffXY - RightMargin,  layout:getSize().height - 15)

		SET_POS(layout, ShowMessageContent[i].msgViewX, ShowMessageContent[i].msgViewY - (cellSize)*35 + 20)
		layout:addChild(imageAvator)
		layout:addChild(imageInfoBg)
		layout:addChild(labelTime)
		layout:addChild(textAreaInfo)

		ShowMessageContent[i].msgViewH = textHang * TextHeight + TimeHeight
		ShowMessageContent[i].layout = layout

		messagelistScrollView:addChild(layout)
		--添加完信息后滑动到底部
		messagelistScrollView:scrollToBottom(1, false)
	end
end

--[[--
---发送消息输入框(ios)
--]]
function callback_txt_sendmsg_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(txt_sendmsg:getStringValue(),0,true,callbackSendInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
---发送消息输入框(Android)
--]]
function callback_txt_sendmsg()
	--控件不存在,return
	if label_sendmsg == nil then
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	if txt_sendmsg:getStringValue() ~= nil and txt_sendmsg:getStringValue() ~= "" then
		label_sendmsg:setText(txt_sendmsg:getStringValue());
	end
end


function callbackSendInput(valuetable)
	local value = valuetable["value"]
	--输入数据为空, return
	if value == nil or value == "" then
		return;
	end

	--控件存在
	if txt_sendmsg ~= nil and label_sendmsg ~= nil then
		txt_sendmsg:setText(value);
		label_sendmsg:setText(value);
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DBID_V2_GET_CONVERSATION, slot_Content)
	framework.addSlot2Signal(DBID_V2_SEND_MESSAGE, slot_Send)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_V2_GET_CONVERSATION, slot_Content)
	framework.removeSlotFromSignal(DBID_V2_SEND_MESSAGE, slot_Send)
end