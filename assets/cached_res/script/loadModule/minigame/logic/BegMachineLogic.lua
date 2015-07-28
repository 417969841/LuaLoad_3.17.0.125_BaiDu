module("BegMachineLogic",package.seeall)

--自定义变量
local WIN = 1
local LOSE = 2
local DEUCE = 3
local winStreak = nil --连续猜对比倍的次数
isWinReward = false --是否获得大奖并获得彩金
isShareEnabled = true --是否能够弹出小游戏被动分享

--历史记录相关图片的路径
local HIS_BACK_PATH_NOR = "ui_lhj_bbjl02.png"
local HIS_BACK_PATH = "ui_lhj_bbjl.png"
local HIS_KIND_NOR = "ui_lhj_jc2.png"
local HIS_KIND_TEN = "ui_lhj_jc10.png"
local HIS_KIND_FIF = "ui_lhj_jc50.png"
local HIS_KIND_FOUR = "ui_lhj_X2.png"

local JHG_HIS_BACK_PATH_NOR = "ui_lhj_bbjl.png"
local JHG_HIS_BACK_PATH = "ui_lhj_bbjl02.png"
local JHG_HIS_KIND_NOR = "ui_jhg_jc2.png"
local JHG_HIS_KIND_TEN = "ui_jhg_jc10.png"
local JHG_HIS_KIND_FIF = "ui_jhg_jc50.png"
local JHG_HIS_KIND_FOUR = "ui_jhg_X2.png"

local BIG = 1
local SMALL = 2

--游戏类型
local FRUITMACHINE = 1
local JINHUANGGUAN = 2



--[[--
比倍机的相关逻辑
--]]
miniGameType = 1 -- 小游戏类型 1 水果机 2 金皇冠 3 ...\
isExistReward = false --是否有可领奖记录
pokerImg = nil --由主界面传回来的扑克牌的Img
pokerRedPic = {} --红色扑克牌数字的table
pokerBlackPic = {} --黑色扑克牌数字的table
pokerGoldPic = {} --金色扑克牌数字的table
pokerKind = {} --扑克牌的花色的table
winCoinLabel = nil --记录赢钱数量的
pokerNumImg = nil --扑克牌显示数字图片
pokerKindImg = nil --扑克牌显示花色图片
handselInfo = nil --记录彩金的信息
isCollectEnabled = true --判断是否可收钱
local imageRewardPanel = nil --打赏头像panel
local imageReward = nil --打赏头像
local imagerewardLabel = nil --打赏展示文字
local imageNameReward = nil --打赏头像名称
IMAGEREWARDGIRL = "imagerewardgirl" --美女感谢
IMAGEREWARDRECEIVE = "imagerewardreceive" --领取打赏

pokerHistory = nil --历史扑克纪录，历史记录的背景图片，花色图片，数字图片
buttonTable = nil --button的table，主要是记录比倍机大，小，加倍
userWinTimes = 0 --玩家赢的次数
local allowWinTimes = 0 --允许玩家比倍的次数
resultAnimaCoor = nil --记录飞入输赢动画时候的输赢坐标点
view = nil --记录当前界面
totalCoinLabel = nil --记录金币飞往地方的总金币数量,比倍机界面的
mainCoinLabel = nil --记录金币飞往地方的总金币数量,游戏主界面的
lightChange = true --大小闪动标识
doubleArray = {} --记录传过来的比倍记录array
coinMoveToPoint = {} --记录金币落点
coinBatchNode = nil --承载金币的精灵
windowSize = {} --屏幕大小
coinMoveToPoint = {} --记录金币落点
coinBatchNode = nil --承载金币的精灵
windowSize = {} --屏幕大小
BelleSpeech = nil --

--[[--
初始化比倍机的数据，由每个小游戏一开始的时候进行调用.主要是对比倍机的内容进行初始化，并且传入需要用到的相关控件的指针(将所有的空间全部传入进来)
@param #Userdata gameType 小游戏类型 1 水果机 2 金皇冠 3 ...
@param #Userdata poker 扑克牌图片
@param #Userdata double 加倍按钮
@param #Userdata winLabel 赢钱数的label
@param #Userdata coinLabel 总金币数量的label
@param #Userdata numImg 不停切换的扑克牌展示数字的图片控件
@param #Userdata kindImg 不停切换的扑克牌展示花色的图片控件
@param #Userdata history 扑克牌历史记录的控件table，里面有8个table，每个table里面包含3个字段，back(每一个历史记录的背景图片)，kind(历史记录的花色图片)，num(历史记录的数字图片)
@param #Userdata button 比倍机按钮的table，里面包含字段big(按钮大),small(按钮小),double(按钮加倍)
@param #Userdata animaPoint 盖章动画的落点坐标，里面包含字段x,y
@param #Userdata currentView 当前界面的View
@param #Userdata SpriteBatchNode 承载金币的精灵
--]]

function initBegData(gameType, poker, winLabel, coinLabel, mainPanelCoinLabel, numImg, kindImg, history, button, animaPoint, currentView, coinMoveToPosit, SpriteBatchNode)
	miniGameType = gameType
	pokerImg = poker
	winCoinLabel = winLabel
	totalCoinLabel = coinLabel
	mainCoinLabel = mainPanelCoinLabel
	pokerNumImg = numImg
	pokerKindImg = kindImg
	pokerHistory = history
	buttonTable = button
	resultAnimaCoor = animaPoint
	view = currentView
	coinMoveToPoint = coinMoveToPosit
	coinBatchNode = SpriteBatchNode
	doubleArray = {}
	pokerRedPic = {}
	pokerBlackPic = {}
	pokerGoldPic = {}
	pokerKind = {}
	--获得当前屏幕的大小
	windowSize["width"] = CCDirector:sharedDirector():getWinSize().width
	windowSize["height"] = CCDirector:sharedDirector():getWinSize().height
	releaseRecordPic()
	isWinBeg = -1 --比倍是否赢了
	--初始化3钟牌型数字
	for i=1, 13 do
		pokerRedPic[i] = CommonControl.CommonControlGetResource(string.format("Pai_red_%d.png", (i-3)%13))
		pokerBlackPic[i] = CommonControl.CommonControlGetResource(string.format("Pai_black_%d.png", (i-3)%13))
		pokerGoldPic[i] = CommonControl.CommonControlGetResource(string.format("Pai_green_%d.png", (i-3)%13))
	end

	--初始化4钟花色
	for i=1, 4 do
		pokerKind[i] = CommonControl.CommonControlGetResource(string.format("Pai_coler_%d.png",i - 1))
	end
end

--[[--
扑克牌改变函数
--]]
function changePoker()
	local delay = CCDelayTime:create(0.1)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(
		function()
			local pokerNum = math.random(1,13)
			local pokerKind = math.random(1,4)
			createPoker(pokerNum,pokerKind)
		end
	))
	array:addObject(CCCallFuncN:create(changePoker))
	local seq = CCSequence:create(array)
	pokerImg:runAction(seq)
end

--[[--
当Poker停止的时候，展示与你点击的时候相对应的图片(存在两秒钟)
--]]
function pokerResult()
	pokerImg:stopAllActions()
	local isDropCoin = false;
	local delay = CCDelayTime:create(2)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(resultAction))
	local seq = CCSequence:create(array)
	isFirstBack = true
	pokerImg:runAction(seq)
end
--[[--
停止扑克牌的切换
--]]
function stopPokerChange()
	pokerImg:stopAllActions()
end

--[[--
设置彩金数组
--]]
function setHandselInfo(handsel)
	handselInfo = handsel
end

--[[--
设置金币所飞的方向的label控件,在切换界面的时候进行设置
--]]
function setTotalCoinLabel(coinLabel)
	totalCoinLabel = coinLabel
end

--[[--
扑克牌显示胜负以后调用的函数
--]]
function resultAction()
	if (isWinBeg == LOSE) then
		--输钱则发送收钱消息
		winStreak = #doubleArray - 1
		collectMoney()
		return
	end

	if (isWinBeg == DEUCE) then
		--平局则可以继续操作，但是不可以点击加倍按钮，移除doubleArray最后的数据
		isDropCoin = false
		begCanPress()
		buttonBegSetState(false)
		table.remove(doubleArray, #doubleArray)
		winStreak = #doubleArray
		view:setTouchEnabled(true)
		deleteResultPic()
	end

	if (isWinBeg == WIN) then
		--赢了以后，如果5或者8次则执行彩金掉落，其他的执行赢后的操作
		--收钱所需要做的相关操作
		winStreak = #doubleArray
		Common.log("handselInfo[#doubleArray]=="..handselInfo[#doubleArray])
		if (handselInfo[#doubleArray] ~= 0) then
			--有彩金所要执行的效果
			deleteResultPic()
			local coinNum = math.floor(handselInfo[#doubleArray] / 200) --金币的数量
			if coinNum < 1 then
				coinNum = 1
			end
			Common.showToast("比倍x" .. #doubleArray .. "，获得" .. handselInfo[#doubleArray] .. "彩金",3)
			isDropCoin = true;
			if (#doubleArray == 8)then
				if miniGameType == FRUITMACHINE then
					FruitMachineLogic.Label_beg_total_rate_eight:setVisible(false)
				end
				CommonControl.showWinStreakAnimation(8)
				CommonControl.playEffect("chufacaijin.mp3",false)
				DropCoinLogic.dropCoin(coinNum, totalCoinLabel, 200, collectMoney, ccp(coinMoveToPoint.x, coinMoveToPoint.y), coinBatchNode, windowSize.width, windowSize.height)
			elseif #doubleArray == 5 then
				if miniGameType == FRUITMACHINE then
					FruitMachineLogic.updateRaiseRate()
					FruitMachineLogic.Label_beg_total_rate_five:setVisible(false)
				end
				CommonControl.showWinStreakAnimation(5)
				CommonControl.playEffect("chufacaijin.mp3",false)
				DropCoinLogic.dropCoin(coinNum, totalCoinLabel, 200, begFiveHandsel, ccp(coinMoveToPoint.x, coinMoveToPoint.y), coinBatchNode, windowSize.width, windowSize.height)
			elseif #doubleArray == 4 then
				CommonControl.bonusExplain(6)
				CommonControl.playEffect("chufacaijin.mp3",false)
				DropCoinLogic.dropCoin(coinNum, totalCoinLabel, 200, begFiveHandsel, ccp(coinMoveToPoint.x, coinMoveToPoint.y), coinBatchNode, windowSize.width, windowSize.height)
			elseif #doubleArray == 6 then
				CommonControl.playEffect("chufacaijin.mp3",false)
				DropCoinLogic.dropCoin(coinNum, totalCoinLabel, 200, begFiveHandsel, ccp(coinMoveToPoint.x, coinMoveToPoint.y), coinBatchNode, windowSize.width, windowSize.height)
			end
		else
			--赢所要执行的代码
			begWin()
		end
	end
	if not isDropCoin and isWinBeg ~= LOSE then
		changePoker()
	end

end


--比倍机猜中以后，应该在掉落完金币以后执行的方法（比倍机猜中5次中彩金后需要执行的回调方法）
function begWin()
	view:setTouchEnabled(true)
	pokerImg:stopAllActions()
	begCanPress()
	isDouble = 0
	deleteResultPic()
	changePoker()
end

--比倍机猜中5次以后所需要执行的回调函数
function begFiveHandsel()
	begWin()
	changePoker()
end

--[[--
--比倍机启动的按钮（在点击大小比倍的时候可以按下）
--]]
function begCanPress()
	buttonTable.big:setTouchEnabled(true)
	buttonTable.small:setTouchEnabled(true)
	buttonBegSetState(true)
	begLightBigSmall()--当按钮可以点击的时候，开始闪动
end

--[[--
--比倍机停止的按钮（在点击大小比倍的时候禁止按下）
--]]
function begCanNotPress()
	buttonTable.big:setTouchEnabled(false)
	buttonTable.small:setTouchEnabled(false)
	buttonBegSetState(false)
	stopBigSmallLight()
end


--[[--
比倍机加倍按钮设置是否可以点击的状态
--]]
function buttonBegSetState(isEnabled)
	if isEnabled then
		buttonTable.double:loadTextures(CommonControl.miniGameGetResource("btn_jiabei.png"),CommonControl.miniGameGetResource("btn_jiabei.png"),"")
		buttonTable.double:setTouchEnabled(true)
	else
		buttonTable.double:loadTextures(CommonControl.miniGameGetResource("double_unpress.png"),CommonControl.miniGameGetResource("double_unpress.png"),"")
		buttonTable.double:setTouchEnabled(false)
	end
end


--[[--
比倍点击时的回调函数
@param #int ButtonNum 点击的是大还是小
@param #int dArray doubleArray,每次点击需要穿过来，再点击的时候添加
--]]
function begCallBack(ButtonNum, dArray)-----1代表大，2代表小

	begCanNotPress()
	doubleArray = dArray

	local pokerNum = nil;
	local pokerColor = nil;

	local isDeuce = math.random(1, 13)
	if (isDeuce == 7) then
		CommonControl.playEffect("pingju.mp3",false)
		isWinBeg = DEUCE
		pokerColor = math.random(1,4)
		createPoker(7,pokerColor)
		resultAnimation(isWinBeg)
		return
	end
	--wxf此处之前有一个BUG，这是修改过后的
	userWinTimes = userWinTimes + 1 --玩家的赢的次数+1
	if (userWinTimes <= allowWinTimes) then
		CommonControl.playEffect("gussRight.mp3",false)
		-- 玩家还可以赢的情况
		if(ButtonNum==BIG) then --1表示大，2表示小
			pokerNum = math.random(9,13)
			pokerColor = math.random(1,4)
		else
			pokerNum = math.random(1,6)
			pokerColor = math.random(1,4)
		end
		--以下要做的是创建牌的显示
		isWinBeg = WIN
		createPoker(pokerNum,pokerColor)
		createGoldpoker(#doubleArray,pokerNum,pokerColor)

		--赢钱后重设金币额
		local coinNum = tonumber(winCoinLabel:getStringValue())
		setWinCoin(coinNum)
		--此处添加---加倍按钮可以点击
	else -- 玩家可以赢的局数已经超过了上限
		CommonControl.playEffect("gussWrong.mp3",false)
		if(ButtonNum==BIG) then
			pokerNum = math.random(1,6)
			pokerColor = math.random(1,4)
		else
			pokerNum = math.random(9,13)
			pokerColor = math.random(1,4)
		end
		isWinBeg = LOSE
		createPoker(pokerNum,pokerColor)
		winCoinLabel:setStringValue("0")
		--比倍大小后，胜利还是输的盖章动画
	end --比倍结束
	--盖章动画
	resultAnimation(isWinBeg)
end

--[[--
--收钱所需要做的相关操作
--]]
function collectMoney()
	begCanNotPress()
	stopBigSmallLight()
	deleteResultPic()

	if miniGameType == FRUITMACHINE then
		sendSLOT_RICK_COLLECT_MONEY(doubleArray)
	elseif miniGameType == JINHUANGGUAN then
		sendJHG_RICK_COLLECT_MONEY(doubleArray)
	end

	pokerImg:stopAllActions()
end


--[[--
删除印章的小效果（赢，输，平）
@param #View view 金皇冠或者老虎机的界面
--]]
function deleteResultPic()
	if (view:getChildByTag(1001) ~= nil) then
		view:removeChildByTag(1001,  true);
		SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
	end
end

--[[--
--加倍并且进行设置
@param #int coin 当前赢得钱数
--]]
function setWinCoin(coin)
	coin = coin*2
	winCoinLabel:setStringValue(tostring(coin))
end


--[[--
设置历史记录的背景图片路径
@param #path path 历史记录图片的路径（不知道金皇冠和老虎机历史记录的差别有多大，因此手动设置，如果一样，可以吧图片路径写成local的值）
--]]
hisBackPath = nil--记录历史记录背景图片的路径
function setHistoryBackPath(path)
	hisBackPath = path
end
--[[--
--比倍机历史记录
@param #Userdata position 当前应该设置第几个历史记录（赢的次数）
@param #Userdata pokerNum 历史记录扑克牌数字
@param #Userdata pokerColor 历史记录扑克牌花色
--]]
function createGoldpoker(position, pokerNum,pokerColor)
	pokerHistory[position].back:loadTexture(CommonControl.CommonControlGetResource(hisBackPath))
	pokerHistory[position].kind:loadTexture(pokerKind[pokerColor])
	pokerHistory[position].num:setVisible(true)
	pokerHistory[position].num:loadTexture(pokerGoldPic[pokerNum])
end


--[[--
--比倍大小动画，当没有点击的时候，此界面始终运行，点击以后停止
@param #boolean isCanPress 大小是否可以点击，用来标识是否执行回调函数
@param #Userdata Button_big 比倍机大小按钮大
@param #Userdata Button_small 比倍机大小按钮小
--]]
function begLightBigSmall()
	if miniGameType == FRUITMACHINE then
		if (lightChange)then
			buttonTable.big:loadTextures(CommonControl.miniGameGetResource("btn_lhj_da02.png"),CommonControl.miniGameGetResource("btn_lhj_da02.png"),CommonControl.miniGameGetResource("btn_lhj_da02.png"))
			buttonTable.small:loadTextures(CommonControl.miniGameGetResource("btn_lhj_xuao01.png"),CommonControl.miniGameGetResource("btn_lhj_xuao01.png"),CommonControl.miniGameGetResource("btn_lhj_xuao01.png"))
		else
			buttonTable.big:loadTextures(CommonControl.miniGameGetResource("btn_lhj_da01.png"),CommonControl.miniGameGetResource("btn_lhj_da01.png"),CommonControl.miniGameGetResource("btn_lhj_da01.png"))
			buttonTable.small:loadTextures(CommonControl.miniGameGetResource("btn_lhj_xuao02.png"),CommonControl.miniGameGetResource("btn_lhj_xuao02.png"),CommonControl.miniGameGetResource("btn_lhj_xuao02.png"))
		end
	elseif miniGameType == JINHUANGGUAN then
		if (lightChange)then
			buttonTable.big:loadTextures(CommonControl.miniGameGetResource("btn_jhg_da02.png"),CommonControl.miniGameGetResource("btn_jhg_da02.png"),CommonControl.miniGameGetResource("btn_jhg_da02.png"))
			buttonTable.small:loadTextures(CommonControl.miniGameGetResource("btn_jhg_xiao01.png"),CommonControl.miniGameGetResource("btn_jhg_xiao01.png"),CommonControl.miniGameGetResource("btn_jhg_xiao01.png"))
		else
			buttonTable.big:loadTextures(CommonControl.miniGameGetResource("btn_jhg_da01.png"),CommonControl.miniGameGetResource("btn_jhg_da01.png"),CommonControl.miniGameGetResource("btn_jhg_da01.png"))
			buttonTable.small:loadTextures(CommonControl.miniGameGetResource("btn_jhg_xiao02.png"),CommonControl.miniGameGetResource("btn_jhg_xiao02.png"),CommonControl.miniGameGetResource("btn_jhg_xiao02.png"))
		end
	end



	lightChange = not lightChange
	local delay = CCDelayTime:create(0.1)
	local array = CCArray:create()

	array:addObject(delay)

	array:addObject(CCCallFuncN:create(begLightBigSmall))
	local seq = CCSequence:create(array)
	buttonTable.big:runAction(seq)
end

--[[--
停止大小按钮的闪动
--]]
function stopBigSmallLight()
	buttonTable.big:stopAllActions()
end

--[[--
设置可以赢的次数，每次切换的时候设置
@param #int time 能赢的次数
--]]
function setWinTimes(time)
	allowWinTimes = time
end

---- 生成赢或者输的牌 ----
function createPoker(pokerNum, pokerColor)
	--pukeNum:1-13:A-K,pukeColor:0-3:方块，梅花，红桃，黑桃
	local picNum = 0;
	picNum = (pokerNum - 3) %  13
	if (pokerColor%2 ~= 0) then --pokerColor的值为1-4（1为方片）
		pokerNumImg:loadTexture(pokerRedPic[pokerNum])
	else
		pokerNumImg:loadTexture(pokerBlackPic[pokerNum])
	end
	pokerKindImg:loadTexture(pokerKind[pokerColor])
end


--[[--
--飞入输赢的动画
--isWin:1赢2输3平
--@param #boolean isWin 是否是胜利
--]]
function resultAnimation(isWin)
	SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
	--扑克牌锚点的坐标
	local resultPicSprite
	if (isWin == 1) then
		resultPicSprite = CCSprite:create(CommonControl.CommonControlGetResource("poker_win.png"))
	elseif (isWin == 2) then
		resultPicSprite = CCSprite:create(CommonControl.CommonControlGetResource("poker_lose.png"))
	elseif (isWin == 3) then
		resultPicSprite = CCSprite:create(CommonControl.CommonControlGetResource("poker_deuce.png"))
	end
	resultPicSprite:setScale(20)
	--	resultPicSprite:setZOrder(10)
	resultPicSprite:setAnchorPoint(ccp(0.5,0.5))
	resultPicSprite:setTag(1001)
	resultPicSprite:setPosition(ccp(resultAnimaCoor.x, resultAnimaCoor.y))
	view:addChild(resultPicSprite);

	local scaleAction =  CCScaleTo:create(0.5, 2);
	local ease = CCEaseOut:create(scaleAction,0.6);
	local array = CCArray:create();
	array:addObject(ease);
	local seq = CCSequence:create(array);
	resultPicSprite:setZOrder(100);
	resultPicSprite:runAction(seq);
end

--------------------打赏领奖-------------------------
--[[--
--加载打赏者头像
--]]
local function updataImage(dataInApp)
	local photoPath = nil
	if Common.platform == Common.TargetIos then
		photoPath = dataInApp["useravatorInApp"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(dataInApp, "#")
		local id = string.sub(dataInApp, 1, i-1)
		photoPath = string.sub(dataInApp, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and currentShareType ~= nil then
		imageReward:loadTexture(Common.getResourcePath(photoPath))
	end
end

--[[--
--打赏领奖和美女感谢
--]]
function getMiniGameRewards(panel, image, label, rewardType)
	Common.log("getMiniGameRewards--有打赏")
	imageReward = image
	imageRewardPanel = panel
	imagerewardLabel = label
	imageRewardPanel:setVisible(true)
	imageRewardPanel:setTouchEnabled(true)

	if rewardType == IMAGEREWARDGIRL then
		imagerewardLabel:setText("爱你~")
		showRewardBelleImage()
	elseif rewardType == IMAGEREWARDRECEIVE then
		local dataTable =  profile.MiniGameChat.getMiniGameRewardRecordInfoTable()
		local recordArray = Common.copyTab(dataTable.PromptMsg)
		--加载头像
		if recordArray[1].UserPic == "" or recordArray[1].UserPic == nil then
			imageReward:loadTexture(Common.getResourcePath("hall_portrait_default.png"))
		else
			Common.getPicFile(recordArray[1].UserPic, 0, true, updataImage)
		end

		--加载展示文字
		imagerewardLabel:setText("领赏")
	end

	--	CommonControl.playEffect("chufacaijin.mp3",false)
	--头像闪动动画
	getMiniGameRewardsAnimation()
end

--[[--
--打赏头像点击回调
--]]
function getMiniGameRewardsCallBack(rewardType)
	if imageRewardPanel ~= nil then
		imageRewardPanel:stopAllActions()
		imageRewardPanel:setVisible(false)
		imageRewardPanel:setTouchEnabled(false)
	end
	imageReward:loadTexture("")
	imagerewardLabel:setText("")


	if rewardType == IMAGEREWARDGIRL then
		if BelleSpeech ~= nil then
			ImageToast.createView(nil,CommonControl.CommonControlGetResource(imageNameReward),"",BelleSpeech,3)
			BelleSpeech = nil
		else
			ImageToast.createView(nil,CommonControl.CommonControlGetResource(imageNameReward),"","由于您连续比倍成功，一部分女粉丝向您表达爱意~",3)
		end

	elseif rewardType == IMAGEREWARDRECEIVE then
		local dataTable =  profile.MiniGameChat.getMiniGameRewardRecordInfoTable()
		local recordArray = Common.copyTab(dataTable.PromptMsg)
		ImageToast.createView(nil,Common.getResourcePath("ic_recharge_guide_jinbi.png"),"",recordArray[1].Content,3)
	end
end

--[[--
--打赏头像闪烁动画
--]]
function getMiniGameRewardsAnimation(recordArray, coinNum)
	local array = CCArray:create()
	local scaleBig = CCScaleTo:create(0.2, 1.05)
	local scaleSmall = CCScaleTo:create(0.2, 1)
	array:addObject(scaleBig)
	array:addObject(scaleSmall)
	local seq = CCSequence:create(array)
	imageRewardPanel:runAction(CCRepeatForever:create(seq))
end

--[[--
--随机显示美女图片
--]]
function showRewardBelleImage()
	local num =	math.random(0, 100)
	imageNameReward = string.format("reward_meinv%d.png", num%3)
	imageReward:loadTexture(CommonControl.CommonControlGetResource(imageNameReward))
end

--[[--
--请求是否有打赏信息
--]]
function reqIsExistRewardInfo()
	Common.log("reqIsExistRewardInfo============")
	isExistReward = true
end
---------------------------清除数据---------------------

--[[--
将比倍机历史记录图片置为初始的展示情况,初始化历史记录的显示
--]]
function releaseRecordPic()
	local pathKind = nil
	for i = 1, #pokerHistory do
		if (i == 5)then
			if miniGameType == JINHUANGGUAN then
				pathKind = JHG_HIS_KIND_TEN
			else
--				pathKind = HIS_KIND_TEN
				pathKind = "bg_qihuanzhanghu_di.png"
			end
		elseif (i == 8)then
			if miniGameType == JINHUANGGUAN then
				pathKind = JHG_HIS_KIND_FIF
			else
--				pathKind = HIS_KIND_FIF
				pathKind = "bg_qihuanzhanghu_di.png"
			end
		elseif i == 4 then
			if miniGameType == JINHUANGGUAN then
				pathKind = JHG_HIS_KIND_FOUR
			else
				pathKind = HIS_KIND_FOUR
			end
		elseif i == 6 then
			if miniGameType == JINHUANGGUAN then
				pathKind = JHG_HIS_KIND_FOUR
			else
				pathKind = HIS_KIND_FOUR
			end
		else
			if miniGameType == JINHUANGGUAN then
				pathKind = JHG_HIS_KIND_NOR
			else
				pathKind = HIS_KIND_NOR
			end

		end
		if miniGameType == JINHUANGGUAN then
			pokerHistory[i].back:loadTexture(CommonControl.miniGameGetResource(JHG_HIS_BACK_PATH_NOR))
			pokerHistory[i].kind:loadTexture(CommonControl.miniGameGetResource(pathKind))
			pokerHistory[i].num:setVisible(false)
		else
			pokerHistory[i].back:loadTexture(CommonControl.miniGameGetResource(HIS_BACK_PATH_NOR))
			pokerHistory[i].kind:loadTexture(CommonControl.miniGameGetResource(pathKind))
			pokerHistory[i].num:setVisible(false)
		end

	end
end

--[[--
退出小游戏的时候，清空数据
--]]
function clearBegUserData()
	pokerRedPic = {}
	pokerBlackPic = {}
	pokerGoldPic = {}
	pokerKind = {}
	handselInfo = nil
	userWinTimes = 0
	allowWinTimes = 0
	pokerImg = nil
	winCoinLabel = nil
	totalCoinLabel = nil
	pokerNumImg = nil
	pokerKindImg = nil
	pokerHistory = nil
	buttonTable = nil
	resultAnimaCoor = nil
	hisBackPath = nil
	isWinBeg = 0
	doubleArray = nil
end


--[[--
在进行切换的时候，清除比倍机相关数据
--]]
function clearData()
	releaseRecordPic()
	doubleArray = {}
	userWinTimes = 0
	deleteResultPic()
end

function clearShareData()
	winStreak = 0
end

--[[--
--小游戏连续比倍分享
--]]
function miniGameShare()
	if isShareEnabled == true and HallGiftShowLogic.isShow == false then
		if tonumber(winStreak) >= 5 then
			CommShareConfig.showMiniGameSharePanel(CommShareConfig.MINIGAMESTREAK, winStreak)
		elseif isWinReward then
			CommShareConfig.showMiniGameSharePanel(CommShareConfig.MINIGAMEPRIZE)
		end
		isWinReward = false
		winStreak = 0
		isShareEnabled = true
	end
end
