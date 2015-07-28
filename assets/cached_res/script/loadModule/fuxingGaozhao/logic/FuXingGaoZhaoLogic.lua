module("FuXingGaoZhaoLogic",package.seeall)

view = nil;

Panel_20 = nil;--
LabelAtlas_HuoDe = nil;--
BackButton = nil;--
Label_XianYou = nil;--
Label_XiaZhu = nil;--
Label_ShengYu = nil;--
Button_AddYuanBao = nil;--
Button_startGame = nil;--


scrollSprites = {}
cellSize = nil
winNums = {}
OPERID_FXGZ_PLAYInfo = nil
OPERID_FXGZ_GET_INFOInfo = nil--福星高照基本信息
isStop = false



hasSendPlayMsg = false;--是否已经发送摇奖消息
hasSeriveDataBack = false;-- 服务器数据是否已经回来

changeFruitCallBack = nil

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	--菜单键
	end
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/activity_res/FuXingGaoZhao.json")
	local gui = GUI_FUXINGGAOZHAO
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
	local tableView = ccTableView.create(CCSize(winSize.width*1.2,winSize.height*0.25))
	tableView:setDirection(kCCScrollViewDirectionHorizontal)
	tableView:setPosition(winSize.width*1.175-212,winSize.height*0.69-50)
	tableView.SeparatorWidth = 20
	tableView:setTouchEnabled(false)
	function tableView.numberOfrow()--返回行数
		return 5
	end

	function tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度
		return 100
	end

	function tableView.CellOfAtNumberOfRow(cell,i)--设置cell

		scrollSprites[6-i] = cell
		cell:setTag(60-i*10)
		--服务器未回滚动精灵ZOrder为 0,服务器消息回来滚动精灵ZOrder为 1
		cell:setZOrder(0)
		cellSize = cell:getContentSize()
		cell:setColor(ccc3(0,0,0))
		cell:setOpacity(0)
		--当前数
		local currentLabel = CCLabelAtlas:create("0",Common.getResourcePath("load_res/activity_res/num_activity_fuxinggaozhao.png") , 49, 63, 48)
		Common.log(currentLabel)
		currentLabel:setTag(10)
		currentLabel:setAnchorPoint(ccp(0.5,0.5))
		currentLabel:setPosition(ccp(cellSize.width*0.5,cellSize.height*0.5))

		--下一个数
		local afterLabel = CCLabelAtlas:create("1",Common.getResourcePath("load_res/activity_res/num_activity_fuxinggaozhao.png") , 49, 63, 48)
		afterLabel:setTag(20)
		afterLabel:setAnchorPoint(ccp(0.5,0.5))
		afterLabel:setPosition(ccp(cellSize.width*0.5,cellSize.height*1.5))
		cell:addChild(currentLabel)
		cell:addChild(afterLabel)
	end
	ccTableView.reloadData(tableView)
	view:addChild(tableView)
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	LabelAtlas_HuoDe = cocostudio.getUILabelAtlas(view, "LabelAtlas_HuoDe");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	Label_XianYou = cocostudio.getUILabel(view, "Label_XianYou");
	Label_XiaZhu = cocostudio.getUILabel(view, "Label_XiaZhu");
	Label_ShengYu = cocostudio.getUILabel(view, "Label_ShengYu");
	Button_AddYuanBao = cocostudio.getUIButton(view, "Button_AddYuanBao");
	Button_startGame = cocostudio.getUIButton(view, "Button_startGame");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_FUXINGGAOZHAO)
	GameStartConfig.addChildForScene(view)
	initView()

	local function delaySentMessage()
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_FXGZ_GET_INFO(dataTable)
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
end

--[[--
--重置抽奖数据
--]]
local function resetLotteryData()
	Button_startGame:setTouchEnabled(true)
	hasSendPlayMsg = false;
	hasSeriveDataBack = false;
	local dataTable = {}
	dataTable["gameID"] = GameConfig.GAME_ID
	sendOPERID_FXGZ_GET_INFO(dataTable)
end

--开始滚动函数
function startScroll()
	isStop = false
	Button_startGame:setTouchEnabled(false)
	--滚动水果机 (滚动的精灵,时间)
	local function scrollFruitAction(senter,time)
		local moveby = CCMoveBy:create(time,ccp(0,-cellSize.height))
		local callfun = CCCallFuncN:create(changeFruitCallBack)
		local array = CCArray:create()
		if(senter:getZOrder() ~= 0)then
			--服务器回了
			if(senter:getZOrder() == 1) then
				senter:setZOrder(2)
				moveby = CCMoveBy:create(time*2,ccp(0,-cellSize.height))
				array:addObject(moveby)
			else
				moveby = CCMoveBy:create(time*3,ccp(0,-cellSize.height*1.1))
				array:addObject(moveby)
				moveby = CCMoveBy:create(time*4,ccp(0,cellSize.height*0.1))
				moveby =  CCEaseIn:create(moveby,0.5)
				array:addObject(moveby)
			end
		else
			--服务器未回
			array:addObject(moveby)
		end
		array:addObject(callfun)
		local seq = CCSequence:create(array)
		senter:runAction(seq)
	end

	--水果机方法回调
	changeFruitCallBack = function(senter)
		senter:stopAllActions()
		--当前数
		local currentLabel = senter:getChildByTag(10)
		--下一个数
		local afterLabel = senter:getChildByTag(20)
		local currentNum = tonumber(currentLabel:getString())
		currentLabel:setString((currentNum + 1)%10)
		afterLabel:setString((currentNum + 2)%10)
		senter:setPositionY(senter:getPositionY()+cellSize.height)
		--cell的tag
		local lie = senter:getTag()
		local labelNum = (currentNum + 1)%10
		------如果服务器传来消息则停止
		if(isStop) then
			--失败则直接停止
			if winNums == nil or #winNums == 0 then
				senter:stopAllActions();
				currentLabel:setString(0);
				if lie == 50 then
					--重置抽奖数据
					resetLotteryData();
				end
				return;
			end
			--从右往左数
			if( (lie == 10 and (labelNum+2) % 10 == winNums[1]) --第一个数
				or (lie == 20 and scrollSprites[1]:numberOfRunningActions() == 0 and (labelNum+2) % 10 == winNums[2]) --第二个数
				or ((lie == 30 and scrollSprites[2]:numberOfRunningActions() == 0 and (labelNum+2) % 10) == winNums[3]) --第三个数
				or ((lie == 40 and scrollSprites[3]:numberOfRunningActions() == 0 and (labelNum+2) % 10) == winNums[4])	--第四个数
				or ((lie == 50 and scrollSprites[4]:numberOfRunningActions() == 0 and (labelNum+2) % 10) == winNums[5])) then --第五个数
				--五个数其中一个数回来,改变其ZOrder
				local sp = CCSprite:create()
				--服务器消息回来滚动精灵ZOrder为 1
				senter:setZOrder(1)
			end

			if(lie == 10 and labelNum == winNums[1] and senter:getZOrder() ~= 0) then
				senter:setZOrder(0)
				return
			elseif(lie == 20 and scrollSprites[1]:numberOfRunningActions() == 0 and labelNum == winNums[2] and senter:getZOrder() ~= 0) then
				senter:setZOrder(0)
				return
			elseif(lie == 30 and scrollSprites[2]:numberOfRunningActions() == 0 and labelNum == winNums[3] and senter:getZOrder() ~= 0) then
				senter:setZOrder(0)
				return
			elseif(lie == 40 and scrollSprites[3]:numberOfRunningActions() == 0 and labelNum == winNums[4] and senter:getZOrder() ~= 0) then
				senter:setZOrder(0)
				return
			elseif(lie == 50 and scrollSprites[4]:numberOfRunningActions() == 0 and labelNum == winNums[5] and senter:getZOrder() ~= 0) then
				senter:setZOrder(0)
				--重置抽奖数据
				resetLotteryData();
				ImageToast.createView(nil,Common.getResourcePath("load_res/activity_res/ic_sign_yuanbao.png"),"+" .. OPERID_FXGZ_PLAYInfo.Money,"",2)
				return
			end
		end
		--滚动的动作
		scrollFruitAction(senter,lie*0.0005 +0.075 )
	end
	for i = 1,#scrollSprites do
		local num = #scrollSprites + 1 -i
		scrollFruitAction(scrollSprites[num],num*0.01+0.1)
	end
end
function requestMsg()

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.showBaseLayerAction(view)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_AddYuanBao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_FUXINGGAOZHAO)
		mvcEngine.createModule(GUI_RECHARGE_CENTER,LordGamePub.runSenceAction(view,nil,true))
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_startGame(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--抬起
		--摇奖消息已发送
		if hasSendPlayMsg then
			return;
		end
		if(OPERID_FXGZ_GET_INFOInfo ~= nil and tonumber(OPERID_FXGZ_GET_INFOInfo.ShengYu) < 1)then
			Common.showToast("您的摇奖次数已经用完！",2)
			return
		end

		local xiazhuLabel = cocostudio.getUILabel(view, "Label_XiaZhu")
		if(tonumber(xiazhuLabel:getStringValue()) > profile.User.getSelfYuanBao())then
			--如果元宝不足则进行充值引导
			CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, tonumber(xiazhuLabel:getStringValue())- profile.User.getSelfYuanBao(), RechargeGuidePositionID.fuXingGaoZhaoPositionA)
		else
			startScroll()
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			sendOPERID_FXGZ_PLAY(dataTable)
			hasSendPlayMsg = true;
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--获取福星高照基本信息
function getOPERID_FXGZ_GET_INFOInfo()
	OPERID_FXGZ_GET_INFOInfo = profile.HuoDong.getOPERID_FXGZ_GET_INFOTable()
	local zuigaohuodeLabel = cocostudio.getUILabelAtlas(view, "LabelAtlas_HuoDe")
	--能够获取的最高奖励
	zuigaohuodeLabel:setStringValue(OPERID_FXGZ_GET_INFOInfo.TopAward)
	local xiazhuLabel = cocostudio.getUILabel(view, "Label_XiaZhu")
	--下注金额
	xiazhuLabel:setText(OPERID_FXGZ_GET_INFOInfo.Xiazhu)
	local xianyouyuanbaoLabel = cocostudio.getUILabel(view, "Label_XianYou")
	--现有元宝
	xianyouyuanbaoLabel:setText(profile.User.getSelfYuanBao())
	local ShengYuCishuLabel = cocostudio.getUILabel(view, "Label_ShengYu")
	--剩余次数
	ShengYuCishuLabel:setText(OPERID_FXGZ_GET_INFOInfo.ShengYu)
end

--获取所赢元宝数
function getOPERID_FXGZ_PLAYInfo()
	isStop = true;
	--已经有一次服务器数据回来了
	if hasSeriveDataBack then
		return;
	end

	OPERID_FXGZ_PLAYInfo = profile.HuoDong.getOPERID_FXGZ_PLAYTable()
	hasSeriveDataBack = true;
	if(OPERID_FXGZ_PLAYInfo.isSuccesse == 1)then
		for i = 1,5 do
			local num = 6-i
			local numString = string.format("%5d",OPERID_FXGZ_PLAYInfo.Money)
			if(string.sub(numString,num,num))then
				--结果数据(从右往左将数保存)
				winNums[i] = tonumber(string.sub(numString,num,num))
			else
				winNums[i] = 0
			end
		end
	else
		Common.showToast(OPERID_FXGZ_PLAYInfo["Mes"], 2)
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_FXGZ_GET_INFO,getOPERID_FXGZ_GET_INFOInfo)
	framework.addSlot2Signal(OPERID_FXGZ_PLAY,getOPERID_FXGZ_PLAYInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_FXGZ_GET_INFO,getOPERID_FXGZ_GET_INFOInfo)
	framework.removeSlotFromSignal(OPERID_FXGZ_PLAY,getOPERID_FXGZ_PLAYInfo)
end

