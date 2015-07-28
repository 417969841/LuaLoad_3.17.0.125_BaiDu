module("ImageToast",package.seeall)

toastArray = {}
OverFunction = nil

view = nil;
ImageWindow = nil;
ImageView = nil;

--[[--
--@param #String Imageurl 网络图片地址
--@param #String ImagePath 本地图片
--@param #String strTitle 标题
--@param #String strDetails 内容
--@param #number time 显示时间
--]]
function createView(Imageurl, ImagePath, strTitle, strDetails, time)
	--如果当前有未完成的toast,则存入队列等待展示
	local params = {}
	if(#toastArray > 0)then

		params.Imageurl = Imageurl
		params.ImagePath = ImagePath
		params.strTitle = strTitle
		params.strDetails = strDetails
		params.time = time * 3

		table.insert(toastArray,params);
		return
	end

	table.insert(toastArray,params);
	showToast(Imageurl, ImagePath, strTitle, strDetails, time * 3);
end

local function moveMySelf()
	ImageView = nil;
	if ImageWindow ~= nil then
		ImageWindow:stopAllActions();
		ImageWindow = nil
	end
	if view ~= nil then
		view:removeFromParentAndCleanup(true);
		view = nil;
	end
	table.remove(toastArray,1);
	if(toastArray[1])then
		showToast(toastArray[1].Imageurl, toastArray[1].ImagePath, toastArray[1].strTitle, toastArray[1].strDetails, toastArray[1].time)
	elseif(OverFunction ~= nil)then
		OverFunction()
		OverFunction = nil
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--如果手机当前的分比率小于1.6且大于1.4,使用960x640的UI工程
		view = cocostudio.createView("ReceiveItem_960_640.json");
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, nil, 960, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--如果手机当前的分比率小于等于1.4,使用2048x1536的UI工程(本期Pad版留黑边)
		view = cocostudio.createView("ReceiveItem.json");
		--view = cocostudio.createView("Hall_2048_1536.json");
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, nil, 1136, 640, kResolutionShowAll);
	elseif GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
		--如果手机当前的分比率大于等于1.6,使用1136x640的UI工程
		view = cocostudio.createView("ReceiveItem.json");
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, nil, 1136, 640, kResolutionExactFit);
	end
end

function showToast(Imageurl, ImagePath, strTitle, strDetails, time)
	AudioManager.playLordSound(AudioManager.TableSound.GET_AWARD, false, AudioManager.SOUND);
	--初始化当前界面
	initLayer()
	ImageWindow = cocostudio.getUIPanel(view,"ImageView_35")
	ImageView = cocostudio.getUIImageView(view, "ImageView_TuPian")
	ImageWindow:setScale(0)
	local touchLayer = CCLayer:create()
	view:addChild(touchLayer)

	view:setZOrder(10)
	GameStartConfig.addChildForScene(view)

	touchLayer:setTouchPriority(-99999)
	touchLayer:registerScriptTouchHandler(moveMySelf, false, -99999, true)
	touchLayer:setTouchEnabled(true)


	local function getImage(path)
		local photoPath = nil
		if Common.platform == Common.TargetIos then
			photoPath = path["useravatorInApp"]
			id = path["id"]
		elseif Common.platform == Common.TargetAndroid then
			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
			local i, j = string.find(path, "#")
			local id = string.sub(path, 1, i - 1)
			photoPath = string.sub(path, j + 1, -1)
		end

		if photoPath ~= nil and photoPath ~= "" and ImageView ~= nil then
			ImageView:loadTexture(photoPath);
		end
	end

	if ImageView ~= nil and ImagePath ~= nil then
		ImageView:loadTexture(ImagePath);
	end

	local Label = cocostudio.getUILabel(view, "Label_ShuZhi");
	Label:setText(strTitle);

	Label = cocostudio.getUILabel(view, "Label_24");
	if(strDetails)then
		Label:setText(strDetails);
	end

	if(Imageurl ~= nil)then
		--如果服务器如没回来,使用默认的金币图
		--ImageView:loadTexture(Common.getResourcePath("ic_recharge_guide_jinbi.png"));
		LordGamePub.downloadImageForNative(Imageurl, 1, true, getImage);
	end
	showPrizeAmin(time);
end

function showPrizeAmin(time)
	local scaleBig = CCScaleTo:create(0.2,1.1);
	local scaleSmall = CCScaleTo:create(0.1,1.0)
	local delay = CCDelayTime:create(time/8);
	local array = CCArray:create();
	array:addObject(scaleBig);
	array:addObject(scaleSmall);
	array:addObject(delay);
	array:addObject(CCSpawn:createWithTwoActions(CCMoveBy:create(time/8,ccp(0,50)),CCFadeOut:create(time/8)))
	array:addObject(CCCallFuncN:create(moveMySelf));
	if ImageWindow ~= nil then
		ImageWindow:runAction(CCRepeatForever:create(CCSequence:create(array)));
	end
end