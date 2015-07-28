module("DropCoinLogic",package.seeall)

actionCoinArray = {}--做动画的金币数组
coinSpeed = 1
currentActions = {} --
coinDropScheduleId = nil --比倍音效定时器
local maxCoinNum = 1000
local coinGroupNumber = 0
local wanrenSGJcoin = 0 --万人水果机掉落金币
local coinNum = 0
coinMainArray = {} -------金币楼群数组
coinBeginPositonArray = {} -------金币楼位置数组
coinZorderArray = {} -------金币楼的层次数组
overCallFunction = nil --指向由其他界面传进来的结束函数的变量（指针？），由dropCoin函数传入
coinPoint = nil --记录金币飞向终点的坐标，由dropCoin函数传入
coinValue = 0--记录每一枚金币相当于的钱数，由dropCoin函数传入
coinLabel = nil --记录改变金币总数的LabelAtlas，由dropCoin函数传入
screenH = 0 --记录屏幕的高度，由dropCoin函数传入
theCoinBatchNode = nil --承载金币的层
localSpeed = 2 --默认金币掉落最低加速


function coinDropActionSound()
	CommonControl.playEffect("coinDrop.mp3",false) --播放金币掉落音效
end

function coinFlyActionSound()
	CommonControl.playEffect("coinFlay.mp3",false) --播放金币飞的音效
end

--[[--
当执行完动画的时候执行的函数
--]]
function callbackEnd()
	actionCoinArray = {}
	coinMainArray = {}
	coinBeginPositonArray ={}
	coinZorderArray = {}
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(coinDropScheduleId)
	coinDropScheduleId = nil
	overCallFunction() -- 动画结束后调用的函数
end

--[[--
--触摸监听
--]]
function onTouch(eventType, x, y)
	if eventType == "began" then
		addSpeedDropCoin(localSpeed)
		if localSpeed <= 20 then
			localSpeed = localSpeed * localSpeed
		end
		return true
	end
end

--[[--
当金币飞到指定的位置的时候，执行的操作
--]]
function addMoney(senter)
	senter:removeFromParentAndCleanup(true)
	--动态的加钱
	if WanRenFruitMachineLogic.isWRSGJFlag then
		coinLabel:setStringValue(tostring(wanrenSGJcoin + coinValue))
	else
		coinLabel:setText(tostring(coinLabel:getStringValue() + coinValue))
	end
end

function stopSoundEffect()
	--金币掉落完成的回调函数
	currentActions = {}
	localSpeed = 2
	if coinDropScheduleId ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(coinDropScheduleId)
		coinDropScheduleId = nil
	end
end

--[[--
飞金币的函数
--]]
function moneyAction(senter)
	theCoinBatchNode:setTouchEnabled(false)
	currentActions = {}
	coinDropScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(coinFlyActionSound,0.05,false);----开始飞金币的音效
	--如果金币都已掉落则播放收钱动画

	for i = #actionCoinArray,1,-1 do
		local delay  = CCDelayTime:create(0.125/coinGroupNumber*(#actionCoinArray - i))
		local moveto = CCMoveTo:create(0.25,coinPoint)
		local easeMove = CCEaseInOut:create(moveto, 0.8)
		local callback = CCCallFuncN:create(addMoney)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(easeMove)
		array:addObject(callback)
		if i == 1 then
			array:addObject(CCCallFuncN:create(callbackEnd))
		end
		local seq = CCSequence:create(array)
		local speed = CCSpeed:create(seq, coinSpeed)

		if(actionCoinArray[i]:getPositionY() > screenH) then
			actionCoinArray[i]:runAction(callback)
		else
			actionCoinArray[i]:runAction(speed)
		end
	end
end

--[[--
randomCoinGroup，随机生成金币组
--]]
function randomCoinGroup()
	local randomGroup
	repeat
		randomGroup = math.random(#coinMainArray)
	until coinMainArray[randomGroup] < 20
	return randomGroup
end

--[[--
--此处收钱掉金币的逻辑中，beginPositionX和beginPositionY是一开始金币的掉落前位置（一摞摞的金币已经存在，只是在屏幕的上），然后进行动画，即金币掉落，0.75秒钟掉落（屏幕的高度*一个参数），这个参数是实际实验找到的，是根据一摞摞金币一开始的位置而来的
--]]
function beginAtion(actionNumber, height, SpriteBatchNode)
	theCoinBatchNode = SpriteBatchNode
	coinDropScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(coinDropActionSound,0.05,false); ----开始金币掉落的音效

	for i = 1, actionNumber do
		local coin = CCSprite:create(CommonControl.CommonControlGetResource("slot_drop_coin_img.png"))
		--随机一个金币楼用来装金币
		local randomGroup = randomCoinGroup()

		local beginPositionX = math.random(coinBeginPositonArray[randomGroup].x-5,coinBeginPositonArray[randomGroup].x+5)
		local beginPositionY = height*(coinBeginPositonArray[randomGroup].y+0.025*coinMainArray[randomGroup])
		coinMainArray[randomGroup] = coinMainArray[randomGroup] + 1
		coin:setZOrder(coinZorderArray[randomGroup])
		if(coinMainArray[randomGroup] == 20) then
			table.remove(coinMainArray,randomGroup)
			table.remove(coinBeginPositonArray,randomGroup)
			table.remove(coinZorderArray,randomGroup)
		end
		coin:setPosition(beginPositionX,beginPositionY)
		SpriteBatchNode:addChild(coin)

		table.insert(actionCoinArray, coin)

		local delay  = CCDelayTime:create(0.04*i)
		--掉落的距离
		local moveto =  CCMoveBy:create(0.75, ccp(0,-height*1.05))
		local moveBounce = CCEaseBounceOut:create(moveto)
		local callback = CCCallFuncN:create(moneyAction)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(moveBounce)
		array:addObject(CCCallFunc:create(
			function ()
				table.remove(currentActions, 1)
			end
		))
		if(i == actionNumber) then
			array:addObject(CCCallFuncN:create(stopSoundEffect))
			array:addObject(CCDelayTime:create(1))
			array:addObject(callback)
		end
		local seq = CCSequence:create(array)
		local speed = CCSpeed:create(seq, coinSpeed)
		table.insert(currentActions, speed)
		coin:runAction(speed)
	end
	SpriteBatchNode:setTouchEnabled(true)
end

--[[--
加速掉落金币
--]]
function addSpeedDropCoin(num)
	Common.log("addSpeedDropCoin============="..num)
	--设置最大掉落速度不超过20
	if num <= 20 then
		for i = 1, #currentActions do
			currentActions[i]:setSpeed(num)
		end
	end
end

--[[--
dropCoin掉落金币的函数
@param #int dropCoinNum 掉落金币的数量
@param #Label LabelAtlas 总钱数的LabelAtlas
@param #int perAdd 收钱时的每次增长效果
@param #function overCallBack 动画结束以后的回调函数
@param #ccp coinMoveToPoint 金币移动到的点坐标
@param #sprite SpriteBatchNode 精灵
--]]
function dropCoin(dropCoinNum, LabelAtlas, perAdd, overCallBack, coinMoveToPoint, SpriteBatchNode, width, height)

	coinMainArray = {}
	coinBeginPositonArray = {}
	coinZorderArray = {}
	overCallFunction = overCallBack
	coinPoint = coinMoveToPoint
	coinValue = perAdd
	coinLabel = LabelAtlas
	screenH = height
	actionCoinArray = {}

	if(dropCoinNum > maxCoinNum)then
		dropCoinNum = maxCoinNum
	end
	wanrenSGJcoin = coinLabel:getStringValue() - perAdd
	coinGroupNumber = dropCoinNum/20 + 1

	local ALLlie = coinGroupNumber/10

	ALLlie = ALLlie - ALLlie%1
	for i = 1,coinGroupNumber do
		coinMainArray[i] = 0
		if(coinGroupNumber <= 31) then
			coinBeginPositonArray[i] = ccp(math.random(width*0.5-i*width/30,width*0.5+i*width/30),1.1)
			coinZorderArray[i] = 9999999 - i
		else
			if(i<=10) then
				coinBeginPositonArray[i] = ccp(math.random(width*0.5-i*width/30,width*0.5+i*width/30),1.1)
				coinZorderArray[i] = 9999999 - i
			else
				local lie = i/10
				lie = lie - lie%1
				coinZorderArray[i] = 9999999 - lie*10 - i
				coinBeginPositonArray[i] = ccp(math.random(width*0.1,width*0.9),1.1+lie*0.01)
			end
		end

	end

	beginAtion(dropCoinNum, height, SpriteBatchNode)----开始动画,经测试手机最大承载量为2000,现在峰值设置在1000
end

--[[--
清除数据
--]]
function clearDropCoinData()
	stopSoundEffect()
	coinMainArray = {}
	coinBeginPositonArray = {}
	coinZorderArray = {}
	actionCoinArray = {}
	coinSpeed = 1
	currentActions = {}
	coinDropScheduleId = nil
	overCallFunction = nil
	coinPoint = nil
	coinValue = 0
	coinLabel = nil
	screenH = 0
	localSpeed = 2
end

