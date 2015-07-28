module("LordGamePub", package.seeall)
--[[--
--判断是否发送破产送金
]]
function logicGiveCoin()
	local isGiveCoin = false;
	Common.log("profile.User.getSelfCoin() === "..profile.User.getSelfCoin())
	Common.log("profile.User.mnRemainCount === "..profile.User.mnRemainCount)
	if tonumber(profile.User.getSelfCoin()) < 1000 and profile.User.mnRemainCount > 0 then
		isGiveCoin = true
	end
	return isGiveCoin
end

--[[--
--得到九宫格精灵
--@param #String imageNamePath 图片地址
--@param #number insetWidth 图片保留宽
--@param #number insetHeight 图片保留高
--@param #number ScaleWidth 图片显示宽
--@param #number ScaleHeight 图片显示高
--]]
function createPointNineSprite(imageNamePath, insetWidth, insetHeight, ScaleWidth, ScaleHeight)
	local tmp = CCSprite:create(imageNamePath);
	local tmpsize = tmp:getContentSize();
	local fullRect = CCRectMake(0,0, tmpsize.width, tmpsize.height);--图片的大小
	local rectInsets = CCRectMake(insetWidth,insetHeight,tmpsize.width-insetHeight*2,tmpsize.height-insetHeight*2);
	local winRect = CCSizeMake(ScaleWidth, ScaleHeight);--设置要拉伸后的的大小
	local m_pNextBG  = CCScale9Sprite:create(imageNamePath, fullRect, rectInsets);
	m_pNextBG:setContentSize(winRect);
	return m_pNextBG
end
--[[--
--得到九宫格精灵--只拉中间
--@param #String imageNamePath 图片地址
--@param #number leftWidth 图片保留左
--@param #number topHeight 图片保留上
--@param #number RightWidth 图片显示右
--@param #number downHeight 图片显示下
--@param #number ScaleWidth 图片显示高
--@param #number ScaleHeight 图片显示宽
--]]
function createPointNineSpriteByScaleWH(imageNamePath, leftWidth, topHeight, RightWidth, downHeight , ScaleWidth, ScaleHeight)
	local tmp = CCSprite:create(imageNamePath);
	local tmpsize = tmp:getContentSize();
	local fullRect = CCRectMake(0,0, tmpsize.width, tmpsize.height);--图片的大小
	local rectInsets = CCRectMake(leftWidth,topHeight,tmpsize.width-RightWidth-leftWidth,tmpsize.height- downHeight - topHeight);
	local winRect = CCSizeMake(ScaleWidth, ScaleHeight);--设置要拉伸后的的大小
	local m_pNextBG  = CCScale9Sprite:create(imageNamePath, fullRect, rectInsets);
	m_pNextBG:setContentSize(winRect);
	return m_pNextBG
end

--呼吸动画
function breathEffect(senter)
	local array = CCArray:create()
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, 0.9), 0.5))
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, 1.05), 0.5))
	local seq = CCSequence:create(array)
	senter:runAction(CCRepeatForever:create(seq))
end

--[[--
--呼吸动画
--small:缩小倍数
--big:放大倍数
--]]
function NewbreathEffect(senter,small,big)
  local array = CCArray:create()
  array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, small), 0.5))
  array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, big), 0.5))
  local seq = CCSequence:create(array)
  senter:runAction(CCRepeatForever:create(seq))
end

--获得当前屏幕截图的精灵
local CurrentSenceSprite = nil
function addCurrentSenceSprite()
	if(CurrentSenceSprite ~= nil)then
		CurrentSenceSprite:removeFromParentAndCleanup(true)
		CurrentSenceSprite = nil
	end
	local runingScene = CCDirector:sharedDirector():getRunningScene();
	local DZJWinSize =  CCDirector:sharedDirector():getVisibleSize()
	local renderTexture = CCRenderTexture:create(DZJWinSize.width, DZJWinSize.height);
	renderTexture:begin();
	runingScene:visit();
	renderTexture:endToLua();
	CurrentSenceSprite = CCSprite:createWithTexture(renderTexture:getSprite():getTexture());
	--CurrentSenceSprite:setColor(ccc3(125,125,125))
	CurrentSenceSprite:setFlipY(true);
	--CurrentSenceSprite:setScale(0.5)
	CurrentSenceSprite:setAnchorPoint(ccp(0,0))
	runingScene:addChild(CurrentSenceSprite)

end

local UP = 1
local DOWN = 2
local LEFT = 3
local RIGHT = 4
local isBackDirection = false

function showBaseLayerAction(view, viewName)
	isBackDirection = true
	mvcEngine.createModule(GameConfig.getTheLastBaseLayer(),LordGamePub.runSenceAction(view, nil, true))
end

--全屏移动动画
--view:最动画的层,comeFrom:从哪个方向来,1:上，2:下,3:左，4:右,time:时间
function runSenceAction(view, callBack, isBack)
	if true then
		if callBack ~= nil then
			callBack()
		end
		return
	end

	local DZJWinSize =  view:getContentSize()
	DZJWinSize.width =  DZJWinSize.width*view:getScaleX()
	DZJWinSize.height =  DZJWinSize.height*view:getScaleY()
	local time = 0.25
	local comeFrom = RIGHT
	if(isBackDirection)then
		if(isBack)then
			comeFrom = RIGHT
		else
			comeFrom = LEFT
		end
	else
		if(isBack)then
			comeFrom = LEFT
		else
			comeFrom = RIGHT
		end
	end
	local beginPosition = nil
	local process = nil
	if(comeFrom == 1)then
		beginPosition = ccp(view:getPositionX(),view:getPositionY()+DZJWinSize.height)
		process = ccp(0,-DZJWinSize.height)
	elseif(comeFrom == 2)then
		beginPosition = ccp(view:getPositionX(),view:getPositionY()-DZJWinSize.height)
		process = ccp(0,DZJWinSize.height)
	elseif(comeFrom == 3)then
		beginPosition = ccp(view:getPositionX() - DZJWinSize.width,view:getPositionY())
		process = ccp(DZJWinSize.width,0)
	elseif(comeFrom == 4)then
		beginPosition = ccp(view:getPositionX() + DZJWinSize.width,view:getPositionY())
		process = ccp(-DZJWinSize.width,0)
	end
	local action = nil
	local moveby = nil
	moveby = CCMoveBy:create(time, process)
	local array = CCArray:create()
	if(not isBack)then
		view:setPosition(beginPosition)
		array:addObject(moveby)
		if callBack ~= nil then
			array:addObject(CCCallFuncN:create(callBack))
		end
		array:addObject(CCCallFuncN:create(function() isBackDirection = false end))
		view:runAction(CCSequence:create(array))
	else
		array:addObject(moveby:reverse())
		return CCSequence:create(array)
	end
end

--[[--
--显示对话框动画
--]]
function showDialogAmin(view, isCentre, callBack)
	--	view:setOpacity(0);
	--	if not(isCentre ~= nil and isCentre) then
	--		view:setAnchorPoint(ccp(0.5, 0.5))
	--		view:setPosition(ccp(view:getPosition().x + view:getSize().width / 2,view:getPosition().y + view:getSize().height / 2))
	--	end
	--	local action = CCFadeIn:create(1);
	--	local array = CCArray:create()
	--	array:addObject(action)
	--	if(callBack)then
	--		array:addObject(CCCallFuncN:create(callBack))
	--	end
	--	view:runAction(CCSequence:create(array))

	view:setScale(0.8)
	if not(isCentre ~= nil and isCentre) then
		view:setAnchorPoint(ccp(0.5, 0.5))
		view:setPosition(ccp(view:getPosition().x + view:getSize().width / 2,view:getPosition().y + view:getSize().height / 2))
	end
	local action = CCScaleTo:create(0.1, 1);
	local array = CCArray:create()
	array:addObject(CCEaseBackOut:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	view:runAction(CCSequence:create(array))
end

--[[--
--隐藏对话框动画
--]]
function closeDialogAmin(view, callBack)
	local action = CCScaleTo:create(0.15, 1.2);
	local array = CCArray:create()
	array:addObject(CCEaseBackIn:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	if view ~= nil then
		view:runAction(CCSequence:create(array))
	end
end

--从icon的位置触发
function comeFromIconPosition(view,iconPosition,callBack,isBack)
	local time = 0.1
	local DZJWinSize =  CCDirector:sharedDirector():getWinSize()
	local scaleAction = CCScaleTo:create(time,1)
	view:ignoreAnchorPointForPosition(false)
	view:setAnchorPoint(ccp(0.5,0.5))
	local moveto = CCMoveTo:create(time,ccp(DZJWinSize.width*0.5,DZJWinSize.height*0.5))
	if(not isBack)then
		view:setScale(0)
		view:setPosition(iconPosition)
	else
		scaleAction = CCScaleTo:create(time,0)
		moveto = CCMoveTo:create(time,iconPosition)
	end

	local array = CCArray:create()
	array:addObject(scaleAction)
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	view:runAction(CCSequence:create(array))
	view:runAction(moveto)
end

--页面快速滑入
function moveinAction(view)
	local DZJWinSize =  CCDirector:sharedDirector():getWinSize()
	view:setPosition(ccp(view:getPosition().x + DZJWinSize.width,view:getPosition().y))
	view:runAction(CCEaseOut:create(CCMoveBy:create(0.25,ccp(-DZJWinSize.width,0)),0.8))
end

--[[--
--列表展示效果
--@param #table itemList 列表队列
--]]
function showLandscapeList(itemList, callback, callBackEnd)
	for i = 1, #itemList do
		itemList[i]:setOpacity(0);
	end
	local index = 1;
	local function showItemAmin()
		if index <= #itemList then
			local FadeInAction = CCFadeIn:create(0.2);
			local ScaleBigAction = CCScaleTo:create(0.06, 1.05);
			local ScaleSmallAction = CCScaleTo:create(0.1, 1);
			local arrayFadeIn = CCArray:create();
			local arrayScale = CCArray:create();
			arrayFadeIn:addObject(FadeInAction);
			arrayScale:addObject(ScaleBigAction);
			arrayScale:addObject(CCCallFunc:create(showItemAmin));
			arrayScale:addObject(ScaleSmallAction);
			itemList[index]:runAction(CCSequence:create(arrayFadeIn));
			itemList[index]:runAction(CCSequence:create(arrayScale));

			if callback ~= nil then
				callback(index);
			end

			if index == #itemList and callBackEnd ~= nil then
				--0.1秒后的回调是为了解决大厅按钮的半透明问题
				local array = CCArray:create()
				array:addObject(CCDelayTime:create(0.1))
				array:addObject(CCCallFunc:create(callBackEnd))
				itemList[index]:runAction(CCSequence:create(array));
			end

			index = index + 1;
		end
	end
	showItemAmin();
end

local orginalScale = 1;

--[[--
--按钮按下点击效果
--@param #uiWidget btn 控件
--@param #float byScale 缩放倍数
--@param #boolean isBlack 是否变黑
--@param #function func 回调函数
--@param #string event 点击事件
--]]
function buttonActionPress(btn, byScale, isBlack, func, event)
	if btn:numberOfRunningActions() > 0 then
		return;
	end
	--btn:stopAllActions();
	local time = 0.1;
	orginalScale = btn:getScale();
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale * byScale), 0.5));
	if(func ~= nil and event ~= nil)then
		local function callBack()
			func(event);
		end
		array:addObject(CCCallFunc:create(callBack));
	end
	btn:runAction(CCSequence:create(array));
	if(isBlack)then
		btn:runAction(CCTintTo:create(time, 255*0.7, 255*0.7, 255*0.7));
	end
end

--[[--
--按钮抬起点击效果
--@param #uiWidget btn 控件
--@param #float byScale 缩放倍数
--@param #function func 回调函数
--@param #string event 点击事件
--]]
function buttonActionUp(btn, byScale, func, event)
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale * byScale), 0.5));

	array:addObject(CCSpawn:createWithTwoActions((CCTintTo:create(time, 255, 255, 255)), CCEaseIn:create(CCScaleTo:create(time, orginalScale), 0.5)));

	if(func ~= nil and event ~= nil)then
		local function callBack()
			func(event);
		end
		array:addObject(CCCallFunc:create(callBack));
	end
	btn:runAction(CCSequence:create(array));
end

--设置动画效果
function setActionAnimate(btn, noIcon, func)
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale*0.95), 0.5));
	array:addObject(CCEaseIn:create(CCScaleTo:create(time, orginalScale), 0.5));
	if(func ~= nil)then
		noIcon:setScale(8);
		noIcon:setVisible(true);
		noIcon:setOpacity(125);
		noIcon:runAction(CCEaseOut:create(CCScaleTo:create(time, 1), 0.8));
		noIcon:runAction(CCFadeTo:create(time, 255));
		array:addObject(CCDelayTime:create(time));
		array:addObject(CCCallFunc:create(func));
	else
		noIcon:setVisible(false);
	end
	btn:runAction(CCSequence:create(array));
end

--感叹号动画
function getGanTanHao()
	local GanTanHao = UIImageView:create()
	GanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local move1 = CCEaseInOut:create(CCMoveBy:create(0.13, ccp(0,20)), 0.8)
	local move2 = move1:reverse()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(3))
	array:addObject(move1)
	array:addObject(move2)
	array:addObject(move2:reverse())
	array:addObject(move1:reverse())
	GanTanHao:runAction(CCRepeatForever:create(CCSequence:create(array)))
	return GanTanHao
end

--[[--
--左摇右摆动画
--]]
function showShakeAnimate(view)
	local array = CCArray:create()
	array:addObject(CCRotateBy:create(0.08, 20))
	array:addObject(CCRotateBy:create(0.08, -40))
	array:addObject(CCRotateBy:create(0.08, 40))
	array:addObject(CCRotateBy:create(0.08, -20))
	array:addObject(CCDelayTime:create(0.8))
	view:runAction(CCRepeatForever:create(CCSequence:create(array)))
end

function showBoxPrizeAnimate(box, prize, callBack)
	local BoxArray = CCArray:create()
	local PrizeArray = CCArray:create()
	local FadeInAction = CCFadeIn:create(0.12);
	local ScaleBigAction = CCScaleTo:create(0.24, 2.3);
	local time = CCDelayTime:create(0.12);
	local FadeOutAction = CCFadeOut:create(0.24);
	BoxArray:addObject(CCSpawn:createWithTwoActions(FadeOutAction, ScaleBigAction));
	PrizeArray:addObject(time);
	PrizeArray:addObject(FadeInAction);
	if callBack ~= nil then
		PrizeArray:addObject(CCDelayTime:create(0.5));
		PrizeArray:addObject(CCCallFunc:create(callBack));
	end
	box:runAction(CCSequence:create(BoxArray));
	prize:runAction(CCSequence:create(PrizeArray));
end

function showOtherBoxPrizeAnimate(box, prize, callBack, timer)
	local BoxArray = CCArray:create()
	local PrizeArray = CCArray:create()
	local FadeInAction = CCFadeIn:create(0.12);
	local time = CCDelayTime:create(0.12);
	local FadeOutAction = CCFadeOut:create(0.24);
	BoxArray:addObject(FadeOutAction);
	PrizeArray:addObject(time);
	PrizeArray:addObject(FadeInAction);
	if callBack ~= nil and timer > 0 then
		PrizeArray:addObject(CCDelayTime:create(timer));
		PrizeArray:addObject(CCCallFunc:create(callBack));
	end
	box:runAction(CCSequence:create(BoxArray));
	prize:runAction(CCSequence:create(PrizeArray));
end

--[[
根据字符分割字符串
]]
function split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--[[--
--分享到微信 isCircle 是否分享到朋友圈,1为朋友圈,0为好友
--]]--
function shareToWX(isCircle, showTil, showMsg)
	local params = 0
	if isCircle ~= nil and isCircle == true then
		params = 1
	end
	local userID = profile.User.getSelfUserID()
	local showTitle = showTil
	local showMessage = showMsg
	local function shareCallBack(parameters)
		if parameters == nil or parameters == "" then
			return
		end

		if parameters == "OK" then
			Common.log("shareCallBack OK")
			local mTimeStamp = os.time()
			local ShareCompleteTable = Common.LoadShareTable("ShareCompleteTable")
			if ShareCompleteTable == nil then
				Common.log("getSharingReward ShareCompleteTable == nil mTimeStamp is " .. mTimeStamp)
				ShareCompleteTable = {}
			end
			ShareCompleteTable[profile.User.getSelfUserID() .. ""] = {}
			ShareCompleteTable[profile.User.getSelfUserID() .. ""].TimeStamp = mTimeStamp
			Common.SaveShareTable("ShareCompleteTable", ShareCompleteTable)
			if CommShareConfig.SHARETYPE == CommShareConfig.SHARE_TYPE_INITIATIVE then
				InitiativeShareLogic.close()
			elseif CommShareConfig.SHARETYPE == CommShareConfig.SHARE_TYPE_PASSIVE then
				CommShareLogic.close()
			elseif CommShareConfig.isRedGiftShareFirst() == true then
				RedGiftShareLogic.close()
				CommShareConfig.isSuccessShare = true
				if CommShareConfig.isNewUserBLoginShare == false then
					CommShareConfig.setRedGiftShareReceiveRewardEnabled(true)
					local nowStamp = Common.getServerTime()
					Common.setDataForSqlite("REDGIFTSHARETIME", nowStamp);
				end
			end
			Common.showToast("分享成功  O(∩_∩)O",2)
		elseif parameters == "CANCEL" then
			Common.showToast("不要啦,分享一下下嘛 %>_<%",2)
		elseif parameters == "DENIDE" then
			Common.showToast("分享失败了  %>_<%",2)
		elseif parameters == "OTHER" then
			Common.showToast("分享出错了  %>_<%",2)
		elseif parameters == "HAVE_NO_WX" then
			--      if CommShareConfig.isRedGiftShareFirst() == true then
			--        if Common.platform == Common.TargetAndroid then
			--          --android平台
			--          local javaClassName = "com.tongqu.client.utils"
			--          local javaMethodName = "doSendSMSTo"
			--          local javaParams = {
			--            "0",
			--            "我在疯狂斗地主里给你准备了一个价值1000元的大红包，快来领取吧！"..profile.ShareToWX.getAppDownLoadURL(),
			--          }
			--          luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			--        elseif Common.platform == Common.TargetIos then
			--          local args = {
			--            mobilevalue = "0",
			--            messagevalue = "我在疯狂斗地主里给你准备了一个价值1000元的大红包，快来领取吧！"..profile.ShareToWX.getAppDownLoadURL()
			--          }
			--          local ok, ret = luaoc.callStaticMethod("Helper", "openSendMessage", args)
			--          if ok then
			--            if CommShareConfig.isRedGiftShareFirst() == true then
			--              RedGiftShareLogic.close()
			--              CommShareConfig.isSuccessShare = true
			--              if CommShareConfig.isNewUserBLoginShare == false then
			--                CommShareConfig.setRedGiftShareReceiveRewardEnabled(true)
			--                local nowStamp = Common.getServerTime()
			--                Common.setDataForSqlite("REDGIFTSHARETIME", nowStamp);
			--              end
			--            end
			--            return true
			--          else
			--            return false
			--          end
			--        end
			--      else
			Common.showToast("安装微信才可以分享哟 O(∩_∩)O",2)
			--      end
		end
	end
	if Common.platform == Common.TargetIos then
		--ios平台
		--Common.log("ios版本暂未开放分享功能,敬请期待!")
		local AppDownLoadURL = profile.ShareToWX.getAppDownLoadURL();

		local args = {
			params = params,
			AppDownLoadURL = AppDownLoadURL,
			showTitle = showTitle,
			showMessage = showMessage,
			shareCallBack = shareCallBack,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "weixinShare", args);
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local javaClassName = "com.tongqu.client.utils.WXShareUtils"
		local javaMethodName = "luaCallWXShare"
		local javaParams = {
			params,
			userID,
			shareCallBack,
			showTitle,
			showMessage,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--下载图片（判断本地是否有对应图片）
--]]
function downloadImageForNative(picUrl, nResID, bHighPri, callBackFunction)
	--金币：
	--新手引导/牌桌宝盒：http://f.99sai.com/assets/coin/coin_0001.png
	--月签：http://f.99sai.com/assets/coin/coin_0007.png
	--包中："ic_recharge_guide_jinbi.png"
	if picUrl == "http://f.99sai.com/assets/coin/coin_0001.png" or picUrl == "http://f.99sai.com/assets/coin/coin_0007.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_recharge_guide_jinbi.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_recharge_guide_jinbi.png"))
			return
		end
	end

	--碎片：
	--新手引导/牌桌宝盒：http://f.99sai.com/assets/pieces/pieces_0006.png
	--月签：http://f.99sai.com/assets/pieces/pieces_0004.png
	--包中
	if picUrl == "http://f.99sai.com/assets/pieces/pieces_0006.png" or picUrl == "http://f.99sai.com/assets/pieces/pieces_0004.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_sign_dasuipian.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_sign_dasuipian.png"))
			return
		end
		return
	end
	--元宝：
	--新手引导：http://f.99sai.com/assets/yuanbao/yuanbao_0001.png
	--包中：ic_activity_yuanbao.png
	if picUrl == "http://f.99sai.com/assets/yuanbao/yuanbao_0001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_activity_yuanbao.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_activity_yuanbao.png"))
			return
		end
		return
	end

	--1元话费：
	--http://f.99sai.com/assets/cash-award/cash-award_0004.png
	--包中没有

	--合成符：
	--月签http://f.99sai.com/assets/item/item18_003.png
	--牌桌宝盒http://f.99sai.com/assets/item/item18_001.png
	--包中：ic_hecheng_hechengfu.png
	if picUrl == "http://f.99sai.com/assets/item/item18_003.png" or picUrl == "http://f.99sai.com/assets/item/item18_001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_hecheng_hechengfu.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_hecheng_hechengfu.png"))
			return
		end
		return
	end

	--复活石：
	--月签：http://f.99sai.com/assets/item/item26_001.png
	--包中：ic_chuangguan_fuhuoshi.png
	if picUrl == "http://f.99sai.com/assets/item/item26_001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_chuangguan_fuhuoshi.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_chuangguan_fuhuoshi.png"))
			return
		end
		return
	end

	Common.getPicFile(picUrl, nResID, bHighPri, callBackFunction)
end

--[[--
--检测客户端安装的应用
--]]
function detectClientInstalledApp()
	if profile.AndroidExit.hasAppNoDownloadCompleted() then
		--如果上一次的应用没下载完
		if Common.getConnectionType() == Common.NET_WIFI or Common.getConnectionType() == Common.NET_4G then
			--当前是WIFI网络或4G网络,则继续下
			local appUrlTable = profile.AndroidExit.getDownloadAppUrlData();
			if appUrlTable ~= nil and appUrlTable.GameID ~= nil and appUrlTable.AppUrl ~= nil then
				--设置下载完成回调的方法 参数：应用ID 回调方法 下载完是否立即安装 true 是 false 否
				Common.setDownloadCompleteCallBack(appUrlTable.GameID, callBackAfterDownloadAppComplete, false);
				--将所有应用设为已安装
				profile.AndroidExit.setAllAppDownloadStatus(1);--1是已安装应用
				--后台下载
				DownloadControler.getDownloadFile(appUrlTable.AppUrl, Common.getAppDownloadPath(), DownloadControler.DOWNLOAD_ACTION_A, true, false, appUrlTable.DownloadTips);
				return;
			end
		end
	end

	if not profile.AndroidExit.isDetectedAppInstalledComplete() then
		--如果已经检测完应用的安装情况, 则检测app是否安装
		checkAppIsInstalled();
	end
end

--[[--
--检查应用是否安装
--]]
function checkAppIsInstalled()
	local appInfoTable = profile.AndroidExit.getAppInfoTable();
	for key, value in pairs(appInfoTable) do
		if tonumber(key) == GameConfig.GAME_ID then
			--GameID为当前游戏,则不用检测 参数：应用英文名 是否安装
			profile.AndroidExit.setAppIsInstalledByName(key, 1);
		else
			--GameID为不为当前游戏,则检测
			--根据应用的名字设置游戏是否安装
			profile.AndroidExit.setAppIsInstalledByName(key, Common.checkAppIsInstalledByPackName(key, appInfoTable[key]["packName"]));
		end
	end
end

--[[--
--加载完应用的回调方法
--]]
function callBackAfterDownloadAppComplete(data)
	local sGameID = "";--应用的ID
	local FilePath = "";--下载的文件路径
	local i, j = string.find(data, "#")
	sGameID = string.sub(data, 1, i-1)
	FilePath = string.sub(data, j+1, -1);
	--删除保存在本地的下载路径
	profile.AndroidExit.deleteDownloadAppUrl(sGameID);
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--如果当前的界面时大厅,则直接安装下载完的应用
		Common.installApp(FilePath);
	else
		--如果当前界面不是大厅,则返回大厅后才安装应用
		GameConfig.NeedToInstallApp = true;
		GameConfig.AppFilePath = FilePath;
	end

end

--[[--
--判断当前的应用的包名是不是"com.tongqu.client.lord"
--@return #boolean true 是 false不是
--]]
function isTQLordPackageName()
	local TQLordPackageName = "com.tongqu.client.lord"; --同趣的包名
	if GameConfig.packageName == TQLordPackageName then
		return true;
	else
		return false;
	end
end

--[[--
-- lua中截取UTF8字符串的方法（无乱码）
--]]
function SubUTF8String(s, n)
  local dropping = string.byte(s, n+1)
  if not dropping then return s end
  if dropping >= 128 and dropping < 192 then
    return SubUTF8String(s, n-1)
  end
  return string.sub(s, 1, n)
end
