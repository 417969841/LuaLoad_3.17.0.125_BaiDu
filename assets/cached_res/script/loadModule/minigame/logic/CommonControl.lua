module("CommonControl",package.seeall)


local scrollShowCount = 5
local vipScrollShowCount = 7
local DIR_UP = 0--向上
local DIR_DOWN = 1--向下
local FRUITMACHINE = 1 --水果机
local JINHUANGGUAN = 2 --金皇冠
local WANRENFURIT  = 3 --万人水果派
local WEIGHTSTATEONE = 1  --打赏第一次弹出框
local WEIGHTSTATETWO = 2  --打赏第二次弹出框
local WINSTREAK = 1 --连胜动画
local WINREWARD = 2 --奖金奖励动画

--rewardWeightState = 1 --打赏控件类型 1 第一次弹框 2 第二次弹框 3...

miniGameType = 1 -- 1 水果机 2 金皇冠
isNewInfo = false--是否获取新的info
mLabel_talk = nil--顶部奖池的信息展示框
mTalkRectWidth = 0--顶部展示框的宽度
mTalkRectHeight = 0--顶部展示框的高度
view = nil --当前view
mScrollTitleArray = nil--记录上方滚动信息的数组
layoutTable = {} --滚动条layout的table
awardsCount = 0 --当前取到中奖纪录的哪一条
mWinrecordArray = nil --用来指向中奖纪录数组的
recordList = nil --记录滚动中奖信息列表
VipRaiseList = nil --Vip加奖比率列表
vipLableTable = nil --Vip加奖比率列表lable的table
timeStamp = 0 --时间戳
isRequestRollMessage = false --是否已经请求了滚动奖励信息

--[[--
--设置小游戏类型
@parm gameType	小游戏类型
@parm currentView	当前view,用于打赏动画
--]]
function setMiniGameType(gameType, currentView)
	miniGameType = gameType
	view = currentView
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(CommonControlGetResource("trumpet.png"), CommonControlGetResource("trumpet.plist"), CommonControlGetResource("trumpet.ExportJson"))
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(miniGameGetResource("fruitTrumpet0.png"), miniGameGetResource("fruitTrumpet0.plist"), miniGameGetResource("fruitTrumpet.ExportJson"))
end

--[[--
--移动顶部的奖池信息
--]]
function movePrizeInfo(Label_talk, talkRectWidth, talkRectHeight, scrollTitleArray)
	if (not isNewInfo)then
	--初始化数据
		mLabel_talk = Label_talk
		mTalkRectWidth = talkRectWidth
		mTalkRectHeight = talkRectHeight
		mScrollTitleArray = scrollTitleArray
		isNewInfo = true
	end
	local talkMove = CCMoveBy:create(4, ccp(0, 0))
	local array = CCArray:create()
	array:addObject(talkMove)
	array:addObject(CCCallFuncN:create(movePrizeLogic))
	mLabel_talk:runAction(CCSequence:create(array))
end

--[[--
--有调用上面的movePrizeInfo,主要作用是设置Label_takl的text，控制何时向服务器申请获取text
--]]
function movePrizeLogic()
	if (#mScrollTitleArray > 1)then
		mLabel_talk:setText(mScrollTitleArray[1].msg)
		mLabel_talk:setColor(ccc3(255, 197, 113))
		mLabel_talk:setAnchorPoint(ccp(0, 0.5))
		mLabel_talk:setPosition(ccp(0, mTalkRectHeight/2))
		table.remove(mScrollTitleArray, 1)
	end
	if (#mScrollTitleArray < 5) and isRequestRollMessage == false then
		local delay = CCDelayTime:create(5)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(
			function()
				isRequestRollMessage = false
			end
		))
		local seq = CCSequence:create(array)
		view:runAction(seq)
		--发送申请
		if miniGameType == JINHUANGGUAN then
			sendJHG_ROLL_MESSAGE() --获取金皇冠滚动信息和滚动的条目
		end
	end
	movePrizeInfo()
end

--[[--
--设置滚动信息的内容
--]]
function setPrizeInfo(array)
	mScrollTitleArray = array
end

--[[--
比倍机右侧Vip额外彩金说明
@parm index 当前是第几手
@parm rightVipRateLable 右侧ui表
@parm vipRaiseTateTable 加奖比例
--]]
function bonusExplain(index, rightVipRateLable, vipRaiseRateTable)--后er项只在第一次进行初始化使用，以后可以不用

	if vipRaiseRateTable ~= nil then
		vipLableTable = rightVipRateLable
		VipRaiseList = vipRaiseRateTable
	end

	vipLableTable["Flag"]:setVisible(false)
	local selfVip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
	if VipRaiseList ~= nil then
		for i = 1, #VipRaiseList do
			if index == 4 then
				vipLableTable[i]:setText("四手多奖"..VipRaiseList[i].fourHand.."%")
			elseif index == 6 then
				vipLableTable[i]:setText("六手多奖"..VipRaiseList[i].sixHand.."%")
				local delay = CCDelayTime:create(0.3*i)
				local scaleBig = CCScaleTo:create(0.1, 1.2)
				local scaleSmall = CCScaleTo:create(0.1, 1)
				local array = CCArray:create()
				array:addObject(delay)
				array:addObject(scaleBig)
				array:addObject(scaleSmall)
				local seq = CCSequence:create(array)
				vipLableTable[i]:runAction(seq)
				delay = CCDelayTime:create(0.3*(i+#VipRaiseList))
				scaleBig = CCScaleTo:create(0.1, 1.2)
				scaleSmall = CCScaleTo:create(0.1, 1)
				array = CCArray:create()
				array:addObject(delay)
				array:addObject(scaleBig)
				array:addObject(scaleSmall)
				seq = CCSequence:create(array)
				vipLableTable[i]:runAction(seq)
			end
			if selfVip == i then
				if vipLableTable["PanelVip"] ~= nil then
					vipLableTable["PanelVip"]:setVisible(false)
				end
				vipLableTable["Flag"]:setVisible(true)
				vipLableTable["Flag"]:setPosition(ccp(vipLableTable["Flag"]:getPosition().x, vipLableTable[i]:getPosition().y))
			end
		end
	end
end

--[[--
--更新得奖记录
--首先创造7个layout，然后实现像老虎机一样的滚动，
--]]
---------------------------------------------------------------------------
function upAwards(ScrollView_recordList, winRecordArray, time, gameType)
	layoutTable = {}
	timeStamp = time
	mWinrecordArray = winRecordArray
	recordList = ScrollView_recordList
	miniGameType = gameType
	local scrollHeight = ScrollView_recordList:getSize().height
	local containerW = ScrollView_recordList:getSize().width
	local containerH = ScrollView_recordList:getSize().height / 5
	local ViewX = ScrollView_recordList:getPosition().x
	local baseFontSize = 21
	local scaleY = 1
	ViewX = ViewX + 6  --展示的时候左边和边框相差4个像素点

	local ViewY = ScrollView_recordList:getPosition().y


	local viewWMax = containerW
	local viewHMax = containerH * 5

	for i = 1, scrollShowCount do
		awardsCount = awardsCount + 1
		--昵称
		local nickName = mWinrecordArray[i].nickname
		--金币数量
		local coin = mWinrecordArray[i].coin
		--比倍次数
		local playTime = mWinrecordArray[i].playTime
		--Vip等级
		local vipLevel = VIPPub.getUserVipType(mWinrecordArray[i].vipLevel)

		--昵称
		local labelNickName = nil
		if miniGameType == FRUITMACHINE then
			labelNickName = ccs.label({
				text = nickName,
				color = ccc3(235,145,67),
			})
		elseif miniGameType == JINHUANGGUAN then
			labelNickName = ccs.label({
				text = nickName,
				color = ccc3(115, 119, 20),
			})
		end

		labelNickName:setFontSize(baseFontSize)
		labelNickName:setAnchorPoint(ccp(0,0))
		labelNickName:setScaleY(scaleY)
		--VIP等级
		local labelVIP = ccs.label({
			text = "vip" .. vipLevel,
			color =  ccc3(205, 43, 28),
		})
		labelVIP:setFontSize(baseFontSize + 3)
		labelVIP:setAnchorPoint(ccp(0,0))
		labelNickName:setScaleY(scaleY)
		--金币数量
		local labelCoin = nil
		if gameType == FRUITMACHINE then
			labelCoin = ccs.label({
				text = coin .. "金币",
				color =  ccc3(183,72,19),
			})
		elseif gameType == JINHUANGGUAN then
			labelCoin = ccs.label({
				text = coin .. "金币",
				color =  ccc3(174,151,72),
			})
		end
		labelCoin:setFontSize(baseFontSize)
		labelCoin:setAnchorPoint(ccp(0,0))
		labelNickName:setScaleY(scaleY)
		--比倍次数
		local labelTimes = ccs.label({
			text = "比倍x"..playTime,
			color =  ccc3(183,72,19),
		})
		labelTimes:setFontSize(baseFontSize)
		labelTimes:setAnchorPoint(ccp(0,0))
		labelNickName:setScaleY(scaleY)

		--底层layer
		local layout = ccs.panel({
			scale9 = false,
			size = CCSizeMake(containerW , containerH),
			capInsets = CCRectMake(0, 0, 0, 0),
		})
		layout:setAnchorPoint(ccp(0,0))

		--设置
		SET_POS(labelNickName, ViewX, 30)
		SET_POS(labelVIP, ViewX + containerW * 3 / 4.2, 30)
		SET_POS(labelCoin, ViewX, 0)
		SET_POS(labelTimes, ViewX + containerW * 3 / 5, 0)
		SET_POS(layout,ViewX,viewHMax - containerH*(i) + 10)

		layout:addChild(labelNickName)
		layout:addChild(labelVIP)
		layout:addChild(labelCoin)
		layout:addChild(labelTimes)

		table.insert(layoutTable, layout)
		layoutTable[i] = {}
		layoutTable[i]["labelNickName"] = labelNickName
		layoutTable[i]["labelVIP"] = labelVIP
		layoutTable[i]["labelCoin"] = labelCoin
		layoutTable[i]["labelTimes"] = labelTimes
		--在初始化的时候，如果VIP的等级为0的话,该label不显示
		if (vipLevel == 0)then
			layoutTable[i]["labelVIP"]:setVisible(false)
		end
		if (playTime == 0)then
			layoutTable[i]["labelTimes"]:setVisible(false)
		end
		ScrollView_recordList:addChild(layout)
	end

	upAwardsAnima()
end

--[[--
--得奖列表的改变动画
--]]
function upAwardsAnima()
	if (awardsCount ~= #mWinrecordArray)then
	--有记录的情况
		scrollUpAwards()
		local delay = CCDelayTime:create(2)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(CCCallFuncN:create(upAwardsAnima))
		local seq = CCSequence:create(array)
		recordList:runAction(seq)
	else
	--没有记录，隔5秒发送一次请求
		local delay_ = CCDelayTime:create(5)
		local array_ = CCArray:create()
		array_:addObject(delay_)
		array_:addObject(CCCallFuncN:create(sendSlotUpAwards))
		array_:addObject(CCCallFuncN:create(upAwardsAnima))
		local seq_ = CCSequence:create(array_)
		recordList:runAction(seq_)
	end
end

--[[--
--发送获取老虎机中奖信息的消息
--]]
function sendSlotUpAwards()
 	if miniGameType == FRUITMACHINE then
		sendSLOT_RICK_WINNING_RECORD(timeStamp)
	elseif miniGameType == JINHUANGGUAN then
		sendJHG_WINNING_RECORD(timestamp)
	end
end


--[[--
--滚动upAwards
--]]
function scrollUpAwards()
	awardsCount = awardsCount + 1
	if (awardsCount < 5)then
		awardsCount = 5
	end
	for i = 1, scrollShowCount do
		layoutTable[i].labelNickName:setText(mWinrecordArray[awardsCount - 5 + i].nickname)
		layoutTable[i].labelVIP:setText("vip" .. VIPPub.getUserVipType(mWinrecordArray[awardsCount - 5 + i].vipLevel))
		layoutTable[i].labelCoin:setText(mWinrecordArray[awardsCount - 5 + i].coin .. "金币")
		layoutTable[i].labelTimes:setText("比倍X"..mWinrecordArray[awardsCount - 5 + i].playTime)
		if (mWinrecordArray[awardsCount - 5 + i].vipLevel == 0)then
			layoutTable[i].labelVIP:setVisible(false)
			layoutTable[i].labelNickName:setColor(ccc3(235, 145, 67))
		else
			layoutTable[i].labelVIP:setVisible(true)
			layoutTable[i].labelNickName:setColor(ccc3(205, 43, 28))
		end
		if (mWinrecordArray[awardsCount - 5 + i].playTime > 0) then
			layoutTable[i].labelTimes:setVisible(true)
		else
			layoutTable[i].labelTimes:setVisible(false)
		end
	end
end

--[[--
--设置中奖纪录的滚动信息
--]]
function setUpawards(array, time)
	mWinrecordArray = array
	timeStamp = time
end

--------------------------------------小游戏打赏-----------------------------------------



--[[--
--领赏闪动动画
--]]
function receiveRewardBlinkAction(panel)

end



--------------------------------------小游戏打赏end--------------------------------------

--[[--
--切换动画
--]]
function showAnimaReadyByDir(direction, panelAbove, panelBelow, backMusicPath, callBack)
	if direction == DIR_UP then
		--切换比倍机
		--老虎机向下，比倍机向上,比倍机在上
		panelAbove:setZOrder(4);
		panelBelow:setZOrder(5);
		showchangeAnima(panelBelow, panelAbove, nil, direction);
		AudioManager.stopAllSound()
		playBackMusic(backMusicPath, true)
	elseif direction == DIR_DOWN then
		--切换老虎机
		--老虎机向上，比倍机向下,老虎机在上
		panelAbove:setZOrder(5);
		panelBelow:setZOrder(4);
		showchangeAnima(panelAbove, panelBelow, callBack, direction);
		AudioManager.stopAllSound()
		playBackMusic(backMusicPath, true)
	end
end

--[[--
--水果机和比倍机之间切换的动画
--]]
function showchangeAnima(viewUP, viewDown, callBack, direction)
	local viewUP_x = viewUP:getPosition().x;
	local viewUP_y = viewUP:getPosition().y;
	local viewUP_w = viewUP:getSize().width;
	local viewUP_h = viewUP:getSize().height;

	local viewDown_x = viewDown:getPosition().x;
	local viewDown_y = viewDown:getPosition().y;
	local viewDown_w = viewDown:getSize().width;
	local viewDown_h = viewDown:getSize().height;
	if direction == DIR_UP then
		viewDown_h = viewDown_h * 1.3
	elseif direction == DIR_DOWN then
		viewUP_h = viewUP_h * 1.3
	end
	local upMove = CCMoveBy:create(0.3, ccp(0, viewUP_h))
	local downMove = CCMoveBy:create(0.3, ccp(0, -viewDown_h))

	local arrayUp = CCArray:create()
	arrayUp:addObject(upMove)
	if(callBack)then
		arrayUp:addObject(CCCallFuncN:create(callBack))
	end

	viewUP:runAction(CCSequence:create(arrayUp))

	local arrayDown = CCArray:create()
	arrayDown:addObject(downMove)
	arrayDown:addObject(CCCallFunc:create(
		function()
			bonusExplain(4)
		end
	))
	viewDown:runAction(CCSequence:create(arrayDown))
end

--[[--
打赏出"豪"字动画
--]]
function showRewardWordAnimation()

	local resultPicSprite
	resultPicSprite = CCSprite:create(CommonControl.CommonControlGetResource("ui_hongbao_hao.png"))

	resultPicSprite:setScale(10)
	resultPicSprite:setAnchorPoint(ccp(0.5, 0.5))
	resultPicSprite:setPosition(ccp(GameConfig.ScreenWidth/2, GameConfig.ScreenHeight/2))
	view:addChild(resultPicSprite)

	local scaleAction =  CCScaleTo:create(0.5, 1)
	local ease = CCEaseOut:create(scaleAction,0.6)
	local array = CCArray:create()
	array:addObject(ease);
	array:addObject(CCDelayTime:create(1.0))
	array:addObject(CCCallFunc:create(
		function ()
			view:removeChild(resultPicSprite, true)
		end
	))
	local seq = CCSequence:create(array)
	resultPicSprite:setZOrder(100)
	resultPicSprite:runAction(seq)
end

--[[--
连胜动画
@parm	num 连胜次数
--]]
function showWinStreakAnimation(num)
	local spriteTable = {} --动画精灵数组
	local sprite = nil
	for i = 1, 5 do  --动画文字精灵加载
		if i == 3 then
			sprite = CCSprite:create(CommonControl.CommonControlGetResource(string.format("ui_zi_%d.png", num)))
		elseif i == 5 then
			sprite = CCSprite:create(CommonControl.CommonControlGetResource("ui_zi_tanhao.png"))
		else
			sprite = CCSprite:create(CommonControl.CommonControlGetResource(string.format("ui_zi_lian_%d.png", i-1)))
		end
		table.insert(spriteTable, sprite)
	end
	miniGameAnimation(spriteTable) --小游戏特效动画
end

--[[--
彩金奖励动画
--]]
function showWinRewardAnimation()
	local spriteTable = {} --动画精灵数组
	local sprite = nil
	for i = 1, 5 do --动画文字精灵加载
		if i == 5 then
			sprite = CCSprite:create(CommonControl.CommonControlGetResource("ui_zi_tanhao.png"))
		else
			sprite = CCSprite:create(CommonControl.CommonControlGetResource(string.format("ui_zi_cai_%d.png", i-1)))
		end
		table.insert(spriteTable, sprite)
	end
	miniGameAnimation(spriteTable) --小游戏特效动画
end

--[[--
小游戏动画
@parm spriteTable 动画精灵数组
--]]
function miniGameAnimation(spriteTable)
	local spriteBG = CCSprite:create(CommonControl.CommonControlGetResource("ui_yinzhuang.png")) --特效背景印章
	local BGSize = spriteBG:getContentSize() --获得背景印章尺寸
	local spriteTable = spriteTable
	spriteBG:setScale(10)
	spriteBG:setAnchorPoint(ccp(0.5, 0.5))
	spriteBG:setPosition(ccp(GameConfig.ScreenWidth/2, GameConfig.ScreenHeight/2)) --设置印章位于屏幕中央
	local sprite = nil
	for i = 1, #spriteTable do
		local sprite = spriteTable[i]
		sprite:setPosition(ccp(BGSize.width * 0.12 + 56 * i, BGSize.height * 0.35 + 15 * (i-1))) --依次对动画文字进行排序
		spriteBG:addChild(sprite) --将动画文字加到背景印章，
	end
	--设置动画播放速率
	local array = CCArray:create()
	local scaleAction = CCScaleTo:create(0.5, 1)
	local ease = CCEaseOut:create(scaleAction, 0.6)
	array:addObject(ease)
	array:addObject(CCCallFunc:create(
		function()
			for i = 1, #spriteTable do
				local array = CCArray:create()
				local scaleTo  = CCScaleTo:create(0.17, 2)
				local scaleBack = CCScaleTo:create(0.17, 1)
				array:addObject(CCDelayTime:create((i-1) * 0.22))
				array:addObject(scaleTo)
				array:addObject(scaleBack)
				local seq = CCSequence:create(array)
				spriteTable[i]:runAction(seq) --每个文字精灵一次执行动画
			end
		end
	))
	array:addObject(CCDelayTime:create(0.25 * (#spriteTable)))
	array:addObject(CCCallFunc:create(
		function()
			view:removeChild(spriteBG, true) --播放完成后从屏幕中删除
		end
	))
	local seq = CCSequence:create(array)
	view:addChild(spriteBG)
	spriteBG:runAction(seq)
end

--[[--
小喇叭动画
--]]
function trumpetAnimation(panel)
	panel:setVisible(false) --隐藏之前的聊天按钮，显示小喇叭
	local trumpetArmature = nil
	if miniGameType == FRUITMACHINE then
		trumpetArmature = CCArmature:create("fruitTrumpet"); --创建动画
	else
		trumpetArmature = CCArmature:create("trumpet"); --创建动画
	end
	trumpetArmature:getAnimation():playByIndex(0); --播放动画组的第一个动画,非循环
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(6))
	array:addObject(CCCallFunc:create(
		function ()
			trumpetArmature:getAnimation():playByIndex(0); --播放动画组的第一个动画，并设置每六秒播放一次
		end
	))
	local seq = CCSequence:create(array)
	trumpetArmature:setPosition(ccp(panel:getPosition().x, panel:getPosition().y)) --设置动画的位置
	view:addChild(trumpetArmature)
	view:runAction(CCRepeatForever:create(seq))
end


--[[--
--弹出充值引导
--]]
function rechargeGuide(coin)
	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, coin, 0)
end

----- 缓存音效 -----
function preloadSound()
	if miniGameType == FRUITMACHINE then
		preloadBackgroundMusic("fanpaiBackGroundSound.mp3")--水果机背景音乐
		preloadBackgroundMusic("suiguojiButton.mp3")--水果机按钮音乐
		preloadEffect("chufacaijin.mp3")--出发奖金的声音
		preloadEffect("shuiguojiredhand.mp3")--水果机把手的声音
		preloadEffect("shuiguojiScroll.mp3")--水果机滚动的声音
		preloadEffect("shuiguojiScroll.mp3")--水果机停止的声音
		preloadEffect("smallTonghua.mp3")--小奖声音
		preloadEffect("lightshine.mp3")--LED的声音
		-- 缓存比倍机的音效 --
		preloadBackgroundMusic("bibeiBackGround.mp3")--比倍机背景音乐
		preloadEffect("bigOrSmall.mp3")--大小按钮
		preloadEffect("gussWrong.mp3")--猜错
		preloadEffect("gussRight.mp3")--猜对
		preloadEffect("coinDrop.mp3")--落金币的声音
		preloadEffect("coinFlay.mp3")--金币飞的声音
		preloadEffect("pingju.mp3")--平局的声音
		preloadEffect("pukeChenge.mp3")--扑克变换的声音
	elseif miniGameType == JINHUANGGUAN then
		preloadBackgroundMusic("fanpaiBackGroundSound.mp3")--翻拍机背景音乐
		preloadEffect("beginAndChangeButton.mp3")--开始和换牌按钮
		preloadEffect("remainButton.mp3")--保留按钮
		preloadEffect("fapai.mp3")--发牌
		preloadEffect("addButton.mp3")--加注按钮
		preloadEffect("fanpaiAction.mp3")--翻拍的声音
		preloadEffect("bigerTonghua.mp3")--同花以上的中奖声音
		preloadEffect("smallTonghua.mp3")--同花以下的中奖声音
		preloadEffect("chufacaijin.mp3")--出发奖金的声音
		------ 缓存比倍机的音效 ------
		preloadBackgroundMusic("bibeiBackGround.mp3")--比倍机背景音乐
		preloadEffect("bigOrSmall.mp3")--大小按钮
		preloadEffect("gussWrong.mp3")--猜错
		preloadEffect("gussRight.mp3")--猜对
		preloadEffect("coinDrop.mp3")--落金币的声音
		preloadEffect("coinFlay.mp3")--金币飞的声音
		preloadEffect("pingju.mp3")--平局的声音
		preloadEffect("pukeChenge.mp3")--扑克变换的声音
	end

end

--[[--
--小游戏路径
--]]
function miniGameGetResource(path)
	if miniGameType == FRUITMACHINE then
		return Common.getResourcePath("load_res/FruitMachineRes/" .. path)
	elseif miniGameType == JINHUANGGUAN then
		return Common.getResourcePath("load_res/JinHuangGuan/" .. path)
	elseif miniGameType == WANRENFURIT then
		return Common.getResourcePath("load_res/WRSGJ/" .. path)
	end
end

--[[--
--小游戏公共素材路径
--]]
function CommonControlGetResource(path)
	return Common.getResourcePath("load_res/BegMachineAndDropCoin/" .. path)
end


--[[--
--缓存背景音乐
--]]
function preloadBackgroundMusic(file)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(miniGameGetResource(file));
	SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(FilePath)
end

-- 缓存音效
function preloadEffect(file)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(miniGameGetResource(file));
	SimpleAudioEngine:sharedEngine():preloadEffect(FilePath)
end

-- 播放音乐
function playBackMusic(file, loop)
	if GameConfig.getGameMusicOff() then
		local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(miniGameGetResource(file));
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(FilePath, loop);
	end
end
-- 播放音效
function playEffect(file,loop)
	if GameConfig.getGameSoundOff() then
		local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(miniGameGetResource(file));
		SimpleAudioEngine:sharedEngine():playEffect(FilePath, loop);
	end
end

--[[--
释放资源
--]]
function clearCommonData()
	isNewInfo = false
	mLabel_talk = nil
	mTalkRectWidth = 0
	mTalkRectHeight = 0
	mScrollTitleArray = nil
	layoutTable = {}
	awardsCount = 0
	mWinrecordArray = nil
	recordList = nil
	timeStamp = 0
	vipLableTable = nil
	vipLableTable = nil
end
