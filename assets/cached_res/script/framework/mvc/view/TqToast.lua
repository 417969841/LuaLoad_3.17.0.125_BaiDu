--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 14-1-4
-- Time: 下午3:00
-- To change this template use File | Settings | File Templates.
--

--提示的TqToast 自动消息
module("TqToast", package.seeall)


pWinSize=CCDirector:sharedDirector():getWinSize()
local mLayer 			= nil

--设置默认的值
local mDefApperTimeSec  = 1.5
local mDefHideTimeSec  = 0.8

function getDefApperTime()
	return mDefApperTimeSec
end

function getDefHideTime()
	return mDefHideTimeSec
end
--[[
--toast弹出框
]]
function Toast(parent, strText, apperTimeSec, hideTimeSec)
	--str太长，弹出弹出框
	local strlength = Common.utfstrlen(strText)
	if(strlength>25) then
		Common.showDialog(strText)
		return
	end

	if mLayer ~= nil then
		hide()
	end
	if strText==nil or string.len(strText)<=0 then
		return
	end

	local showSec = mDefApperTimeSec
	if apperTimeSec ~= nil then
		showSec = apperTimeSec
	end
	local hideTime = mDefHideTimeSec
	if hideTimeSec ~= nil then
		hideTime = hideTimeSec
	end
	createTqToast(parent, showSec, hideTime, strText)
	--createTqToast(parent, showSec, hideTime, "发送大黄蜂哈师大尽快发货和发生地方和教案上看到合肥金卡和数据库和健康韩国进口和前任黑哦为前一日哦·1")
end
--[[
--弹出框：参数1：scene，参数2：显示时间，参数3：延迟时间，参数4显示文字
]]
function createTqToast(parent, apperTime, delayTime, strText)

	mLayer = CCLayer:create()
	parent:addChild(mLayer, 9)

	--文字
	local labelWidth = pWinSize.width*0.8

	local contentStr=string.format("<label>%s</label>",strText )
	local label=CCLabelTTF:create(strText,"黑体",25)
	if label:getContentSize().width<labelWidth then
		labelWidth= label:getContentSize().width
	end
	local labelHeight =  label:getContentSize().height

	--背景框
	local bgSprite = CCSprite:create(Common.getResourcePath("toast.png"))
	bgSprite:setScaleX(labelWidth/bgSprite:getContentSize().width*1.1)
	bgSprite:setScaleY(1)
	bgSprite:setAnchorPoint(CCPoint(0,0))
	bgSprite:setPosition(CCPoint(400-labelWidth*1.1/2,180))
	mLayer:addChild(bgSprite, 0)
	mLayer:addChild(label)

	--文字设置位置
	local startY = 210
	label:setPosition(CCPoint(pWinSize.width/2,startY))

	--居中显示
	mLayer:setAnchorPoint(CCPoint(0,0))
	mLayer:setPosition(CCPoint(0,0))

	local secondAction = CCSequence:createWithTwoActions(CCFadeOut:create(apperTime ),
		CCCallFuncN:create(TqToast.hide))
	local  action = CCSequence:createWithTwoActions(CCDelayTime:create(apperTime),secondAction)
	mLayer:runAction(action)
	--mLayer:registerOnExit("TqToast.onExit")

end

function hide()
	if mLayer~= nil then
		mLayer:getParent():removeChild(mLayer, true)
		mLayer=nil
	end
end

function onExit()
	if mLayer~= nil then
		mLayer:stopAllActions()
		mLayer = nil
	end
end
--[[
--弹出框2，带背景框
]]
function show2(parent, strText, apperTimeSec, hideTimeSec)
	if mLayer ~= nil then
		hide()
	end
	if strText==nil or string.len(strText)<=0 then
		return
	end

	local showSec = mDefApperTimeSec
	if apperTimeSec ~= nil then
		showSec = apperTimeSec
	end
	local hideTime = mDefHideTimeSec
	if hideTimeSec ~= nil then
		hideTime = hideTimeSec
	end
	createTqToast2(parent, showSec, hideTime, strText)
end
function createTqToast2(parent, apperTime, delayTime, strText,posState)
	if mLayer ~= nil then
		hide()
	end
	mLayer = CCLayer:create()

	--背景框
	local bgSprite = CCSprite:create(Common.getResourcePath("panle_1045.png"))
	bgSprite:setScaleX(pWinSize.width*0.25/bgSprite:getContentSize().width)
	bgSprite:setScaleY(pWinSize.height*0.4/bgSprite:getContentSize().height)
	bgSprite:setAnchorPoint(CCPoint(0,0))
	bgSprite:setPosition(CCPoint(0,0))
	mLayer:addChild(bgSprite, 0)

	--文字
	local labelWidth=pWinSize.width*0.25*0.88
	local contentStr=string.format("<label color='%d,%d,%d' >%s</label>",0,0,0,strText )
	local contentLabel = TqMultiLabel:new(contentStr,labelWidth,FONT_NAME,FONT_FM_SIZE)
	contentLabel:addto(mLayer,0)
	--设置文字图大小
	local bgHeight=contentLabel:getContentSize().height+pWinSize.height*0.03>pWinSize.height*0.2
		and contentLabel:getContentSize().height+pWinSize.height*0.03 or pWinSize.height*0.2
	local size =SZ(pWinSize.width*0.3,bgHeight)

	--文字图拉伸
	--	bgSprite:setScaleX(size.width/bgSprite:getContentSize().width)
	bgSprite:setScaleY(size.height/bgSprite:getContentSize().height)


	--文字设置位置
	--	local startY=bgSprite:getPosition().y+size.height-pWinSize.height*0.02
	local startY=bgSprite:getPosition().y+size.height*0.75
	contentLabel:setPosition(CCPoint(bgSprite:getPosition().x+pWinSize.width*0.037,
		startY-contentLabel:getContentSize().height))
	if posState then
		bgSprite:setScaleX(-1)
		contentLabel:setPosition(CCPoint(bgSprite:getPosition().x-bgSprite:getContentSize().width+pWinSize.width*0.01,
			startY-contentLabel:getContentSize().height))
	end
	--居中显示
	mLayer:setAnchorPoint(CCPoint(0,0))
	mLayer:setPosition(CCPoint(0,0))

	local secondAction = CCSequence:createWithTwoActions(CCFadeOut:create(delayTime ),
		CCCallFuncN:create(TqToast.hide))
	local  action = CCSequence:createWithTwoActions(
		CCDelayTime:create(apperTime),secondAction)
	mLayer:runAction(action)
	--mLayer:registerOnExit("TqToast.onExit")
	return mLayer
end
