module("JinHuaTableChangeCardPopLogic",package.seeall)


view = nil
iv_content_bg = nil;
iv_select_bg = nil;
cardValues = {}
local changeCardValue = nil
--本局换牌的次数
local changeCardRemainTime = 0;
--本次换牌需要的道具数
local thisRoundChangeCardNeedPropsCnt = 0;

--[[--
--获取兑换回来的牌值
--]]
function getChangeCardValue()
	return changeCardValue;
end

--[[--
--设置本局换牌的次数
--@param #number value 本局换牌的次数
--]]
function setChangeCardRemainTime(value)
	changeCardRemainTime = value;
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

-- 选中要换的牌
local function checkChangeCard(index)
	-- 设置选中背景的位置
	iv_select_bg:setPosition(ccp(34 + (index-2) * 126, -20))
	iv_select_bg:setVisible(true)
	changeCardValue = cardValues[index]
end

-- 得到默认选中要换的牌，顺序同花-豹子-顺子-最小牌
local function getDefaultChangeCard()
	local defaultIndex = 1
	local typeIndex = {}
	local valueIndex = {}
	for i=1, #cardValues do
		typeIndex[i] = math.modf(cardValues[i] / 13)
		valueIndex[i] = cardValues[i] % 13
	end

	-- 最小牌
	if (valueIndex[1] < valueIndex[2]) then
		if (valueIndex[1] < valueIndex[3]) then
			defaultIndex = 1
		else
			defaultIndex = 3
		end
	else
		if (valueIndex[2] < valueIndex[3]) then
			defaultIndex = 2
		else
			defaultIndex = 3
		end
	end

	-- 顺子
	if (math.abs(valueIndex[1] - valueIndex[2]) == 1 or math.abs(valueIndex[1] - valueIndex[2]) == 2) then
		defaultIndex = 3
	elseif(math.abs(valueIndex[1] - valueIndex[3]) == 1 or math.abs(valueIndex[1] - valueIndex[3]) == 2) then
		defaultIndex = 2
	elseif(math.abs(valueIndex[2] - valueIndex[3]) == 1 or math.abs(valueIndex[2] - valueIndex[3]) == 2) then
		defaultIndex = 1
	end

	-- 豹子
	if (valueIndex[1] == valueIndex[2]) then
		defaultIndex = 3
	elseif(valueIndex[1] == valueIndex[3]) then
		defaultIndex = 2
	elseif(valueIndex[2] == valueIndex[3]) then
		defaultIndex = 1
	end

	-- 同花
	if (typeIndex[1] == typeIndex[2]) then
		defaultIndex = 3
	elseif(typeIndex[1] == typeIndex[3]) then
		defaultIndex = 2
	elseif(typeIndex[2] == typeIndex[3]) then
		defaultIndex = 1
	end

	return defaultIndex
end

--[[--
--设置换牌框的文字
--]]
local function setTableChangeCardPopText()
	Common.log("setTableChangeCardPopText is " .. changeCardRemainTime)
	if changeCardRemainTime == 3 then
		thisRoundChangeCardNeedPropsCnt = 1;
	elseif changeCardRemainTime == 2 then
		thisRoundChangeCardNeedPropsCnt = 2;
	elseif changeCardRemainTime == 1 then
		thisRoundChangeCardNeedPropsCnt = 4;
	end
	label_table_changecard_info:setText("消耗" .. thisRoundChangeCardNeedPropsCnt .. "张换牌卡");
end

local function initView()
	iv_content_bg = cocostudio.getUIImageView(view,"iv_table_changecard_pop_bg")
	iv_select_bg = cocostudio.getUIImageView(view,"iv_table_changecard_select_card")
	label_table_changecard_info = cocostudio.getUILabel(view,"label_table_changecard_info")
	iv_select_bg:setVisible(false)
	iv_select_bg:setZOrder(100)
	local card1 = CardSprite()
	card1:setPosition(-126,32)
	card1.setValue(cardValues[1])
	card1.showFront()
	card1:setScaleX(1136/800)
	card1:setScaleY(640/480)
	--设置换牌框的文字
	setTableChangeCardPopText();

	local button1 = ccs.button({
		size = CCSizeMake(JinHuaTableConfig.cardWidth,JinHuaTableConfig.cardHeight),
		normal = getJinHuaResource("menghei2_hall_gengduo_ic.png", pathTypeInApp),
		scale9 = true,
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				Common.log("Touch Down")

			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			--[[Common.log("Touch Move" .. i)]]
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				checkChangeCard(1)
				Common.log("Touch Up 1")
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	button1:setPosition(ccp(-126,32))

	local card2 = CardSprite()
	card2:setPosition(0,32)
	card2.setValue(cardValues[2])
	card2.showFront()
	card2:setScaleX(1136/800)
	card2:setScaleY(640/480)
	local button2 = ccs.button({
		size = CCSizeMake(JinHuaTableConfig.cardWidth,JinHuaTableConfig.cardHeight),
		normal = getJinHuaResource("menghei2_hall_gengduo_ic.png", pathTypeInApp),
		scale9 = true,
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				Common.log("Touch Down")

			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			--[[Common.log("Touch Move" .. i)]]
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				checkChangeCard(2)
				Common.log("Touch Up 2")
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	button2:setPosition(ccp(0,32))
	local card3 = CardSprite()
	card3:setPosition(126,32)
	card3.setValue(cardValues[3])
	card3.showFront()
	card3:setScaleX(1136/800)
	card3:setScaleY(640/480)
	local button3 = ccs.button({
		size = CCSizeMake(JinHuaTableConfig.cardWidth,JinHuaTableConfig.cardHeight),
		normal = getJinHuaResource("menghei2_hall_gengduo_ic.png", pathTypeInApp),
		scale9 = true,
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
				Common.log("Touch Down")
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			--[[Common.log("Touch Move" .. i)]]
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				checkChangeCard(3)
				Common.log("Touch Up 3")
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	button3:setPosition(ccp(126,32))
	iv_select_bg:setPosition(ccp(34,-20))
	iv_content_bg:getRenderer():addChild(card1)
	iv_content_bg:getRenderer():addChild(card2)
	iv_content_bg:getRenderer():addChild(card3)
	iv_content_bg:addChild(button1)
	iv_content_bg:addChild(button2)
	iv_content_bg:addChild(button3)

	checkChangeCard(getDefaultChangeCard())
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableChangeCardPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView()
end

function requestMsg()
end

--设置
function setCardValues(value1,value2,value3)
	cardValues[1] = value1
	cardValues[2] = value2
	cardValues[3] = value3
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_JINHUA_TABLECHANGECARDPOP)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_confirm,手指抬起后做的事
--]]
local function releaseUpForBtnConfirm()
	if changeCardValue then
		JinHuaTableMyOperation.setLastChangeCardRound()
		sendJHID_CHANGE_CARD_REQ(changeCardValue)
		mvcEngine.destroyModule(GUI_JINHUA_TABLECHANGECARDPOP)
	else
		Common.showToast("请选择要换的牌", 2)
	end
end

function callback_btn_confirm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnConfirm();
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
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
