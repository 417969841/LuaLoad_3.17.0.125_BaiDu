module("TiaoJianBaoMingLogic",package.seeall)

view = nil

mathcondition = nil -- 比赛实例
isSleepMember = {}

winSize = CCDirector:sharedDirector():getWinSize();

panel = nil
BackButton = nil;
tableView = nil;

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
	view = cocostudio.createView("TiaoJianBaoMing.json")
	local gui = GUI_TIAOJIANBAOMING
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

	panel = cocostudio.getUIPanel(view, "Panel_22")
	BackButton = cocostudio.getUIButton(view, "BackButton")
	isSleepMember = {}

	LordGamePub.showDialogAmin(panel, false, initView)
end

function sleep(isSleep)
	if(isSleep)then
		for i = 1,#isSleepMember do
			isSleepMember[i]:setEnabled(false)
		end
	else
		for i = 1,#isSleepMember do
			isSleepMember[i]:setEnabled(true)
		end
	end
end

function initView()
	tableView = ccTableView.create(CCSize(winSize.width*0.78,350))
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(winSize.width*0.71,winSize.height*0.55)
	tableView.SeparatorWidth = 4;
	function tableView.numberOfrow()--返回行数
		return #mathcondition.Condition
	end


	function tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度
		return 80
	end

	function tableView.CellOfAtNumberOfRow(cell, i)--设置cell
		local cellSize = cell:getContentSize()
		cell:setColor(ccc3(255,255,255))
		cell:setOpacity(0)

		local function buttonCallBack()
			Common.log("i = "..i)
			if(tableView.isMoved)then
				return
			end

			if (mathcondition.Condition[i].enable == true) then
				Common.log("mathcondition.Condition[i][1] = "..mathcondition.Condition[i][1])
				if profile.Match.getValueWithExpression2(mathcondition.Condition[i][1], ">=", 1) == profile.Match.MatchApplyConditionKeyTable["ticket"] then
					--如果是使用门票报名，弹出报名确认框
					local function startBaoming()
						profile.Match.didBaomingMatch(mathcondition, (#mathcondition.Condition)-1, 0)
						mvcEngine.destroyModule(GUI_TIAOJIANBAOMING)
					end
					TimeNotFitLogic.noticeMsg = "【退赛时无法退还门票，确定报名吗？】"
					TimeNotFitLogic.func = startBaoming
					mvcEngine.createModule(GUI_TIMENOTFIT)
					return
				end
				profile.Match.didBaomingMatch(mathcondition, i-1, 0) --服务器报名类型下标从0开始，这里减1
				mvcEngine.destroyModule(GUI_TIAOJIANBAOMING)
			else
				-- 不能报名
				showBaomingtiaojianTanchuang(mathcondition.Condition[i])
			end
		end

		local diImage = "btn_desk_4.png";

		local diSprite = LordGamePub.createPointNineSprite(Common.getResourcePath(diImage), 20, 20, cellSize.width, cellSize.height)

		local diSpriteItem = CCMenuItemSprite:create(diSprite, nil)
		diSpriteItem:registerScriptTapHandler(buttonCallBack)

		--local menuCell = CCMenu:createWithItem(diSpriteItem)
		local menuCell = CCMenu:create()
		menuCell:setPosition(cellSize.width*0.5,cellSize.height*0.5)
		menuCell:addChild(diSpriteItem)
		cell:addChild(menuCell)
		table.insert(isSleepMember, menuCell);

		local description = getDescriptionWithCondition(mathcondition.Condition[i])

		local userNameLabel = CCLabelTTF:create(description, "", 25)
		userNameLabel:setAnchorPoint(ccp(0.5,0.5))
		userNameLabel:setPosition(cellSize.width*0.5,cellSize.height*0.5)
		userNameLabel:setColor(ccc3(0,0,0))
		cell:addChild(userNameLabel)

		diImage = "ic_match_xuanzhebaomingtiaojian_weimanzu.png"
		if(mathcondition.Condition[i].enable == true) then
			Common.log("i = "..i.."enable = true")
			diImage = "ui_yiqian.png"
		else
			Common.log("i = "..i.."enable = false")
		end
		diSprite = CCSprite:create(Common.getResourcePath(diImage))
		diSprite:setScale(0.85)
		diSprite:setAnchorPoint(ccp(0,0.5))
		diSprite:setPosition(25,cellSize.height*0.5)
		cell:addChild(diSprite)

	end
	ccTableView.reloadData(tableView)
	view:addChild(tableView)
end

--[[
根据比赛条件，弹出不符合条件提示弹窗
tSubCondition:报名条件子数组
]]
function showBaomingtiaojianTanchuang(tSubCondition)
	for k = 1, #tSubCondition do
		local expression = tSubCondition[k]
		local key = profile.Match.getKeyWithExpression(expression, ">=")
		if key == profile.Match.MatchApplyConditionKeyTable["coin"] then
			local uCoin = profile.User.getSelfCoin()
			local needCoin = profile.Match.getValueWithExpression(expression, ">=") + mathcondition.freezeCoin
			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, needCoin-uCoin, RechargeGuidePositionID.MatchListPositionJ)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["yuanbao"] then
			local uCoin = profile.User.getSelfCoin()
			local needCoin = profile.Match.getValueWithExpression(expression, ">=")*100 + mathcondition.freezeCoin -- 这里乘以100，1元宝换100金币
			mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
			PayGuidePromptLogic.setPayGuideData(QuickPay.Pay_Guide_need_coin_GuideTypeID, needCoin-uCoin, RechargeGuidePositionID.MatchListPositionJ)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["vipLevel"] then
			MatchVipNotEnoughLogic.setGoToNum(3)
			MatchVipNotEnoughLogic.vipLvlNum = profile.Match.getValueWithExpression(expression, ">=")
			mvcEngine.createModule(GUI_MATCHVIPNOTENOUGH)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["ladderRank"] then
			MatchVipNotEnoughLogic.setGoToNum(4)
			MatchVipNotEnoughLogic.tiantidengjiDescription = getDescriptionWithKeyAndValue(key, profile.Match.getValueWithExpression(expression, ">="))
			mvcEngine.createModule(GUI_MATCHVIPNOTENOUGH)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["pieces"] then
			MatchVipNotEnoughLogic.setGoToNum(5)
			MatchVipNotEnoughLogic.suipianNum = profile.Match.getValueWithExpression(expression, ">=")
			mvcEngine.createModule(GUI_MATCHVIPNOTENOUGH)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["djq"] then
			MatchVipNotEnoughLogic.setGoToNum(6)
			MatchVipNotEnoughLogic.duijiangjuanNum = profile.Match.getValueWithExpression(expression, ">=")
			mvcEngine.createModule(GUI_MATCHVIPNOTENOUGH)
			break
		elseif key == profile.Match.MatchApplyConditionKeyTable["ticket"] then
			MatchVipNotEnoughLogic.setGoToNum(7)
			MatchVipNotEnoughLogic.matchInstance = mathcondition
			mvcEngine.createModule(GUI_MATCHVIPNOTENOUGH)
			break
		end
	end
end

--[[
通过一个表达式数组得出对应的描述信息
tSubCondition: 一个子表达式数组
]]
function getDescriptionWithCondition(tSubCondition)
	local description = ""
	local count = #tSubCondition

	for i = 1, #tSubCondition do
		local expression = tSubCondition[i]
		local key = LordGamePub.split(expression, ">=")[1]
		local value = LordGamePub.split(expression, ">=")[2]

		-- 连接词
		local linkWord = ""
		if count > 1 then
			count = count - 1
			linkWord = " 和 "
		end

		description = description..getDescriptionWithKeyAndValue(key, value)..linkWord
	end

	return description
end

--[[
通过key和value得出一个描述
key:条件名称
value:条件名称对应的值
]]
function getDescriptionWithKeyAndValue(key, value)
	local description = ""
	if key == profile.Match.MatchApplyConditionKeyTable["coin"] then
		description = "消耗"..value.."金币，".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["yuanbao"] then
		description = ""..value.." 元宝, ".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["vipLevel"] then
		description = "VIP等级"..value.." 级, ".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["ladderRank"] then
		local ttduan = string.sub(value, 1, 1)
		local ttji = string.sub(value, 3, 3)
		local text = profile.TianTiData.getDuanWeiName(tonumber(ttduan))
		description = ""..text..ttji.."级, ".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["pieces"] then
		description = ""..value.." 兑奖券碎片, ".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["djq"] then
		description = ""..value.." 兑奖券, ".."金币≥"..mathcondition.freezeCoin
	elseif key == profile.Match.MatchApplyConditionKeyTable["ticket"] then
		--description = ""..value.." 门票, ".."金币≥"..mathcondition.freezeCoin
		description = ""..mathcondition["TicketName"]..", 金币≥"..mathcondition.freezeCoin
	end

	return description
end

function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local function actionOver()
			mvcEngine.destroyModule(GUI_TIAOJIANBAOMING)
		end
		LordGamePub.closeDialogAmin(panel,actionOver)

	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	mathcondition = nil
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
