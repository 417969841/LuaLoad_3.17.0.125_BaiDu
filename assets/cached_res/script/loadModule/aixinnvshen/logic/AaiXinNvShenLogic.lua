module("AaiXinNvShenLogic",package.seeall)

view = nil
OPERID_GODDESS_GET_INFOInfo = {}
NvShenDaoJiShi = 0
--刷新排行榜
freshTableView = nil

Panel_20 = nil;--
BackButton = nil;--
Label_DaoJiShi = nil;--
Button_GuiZe = nil;--
Button_ShuaXin = nil;--
Button_DaPai = nil;--
Label_PaiMing = nil;--
Label_XiaoHao = nil;--
LoadingBar = nil;--

tableView = nil;

function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.showBaseLayerAction(view)
	elseif event == "menuClicked" then
	end
end

local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	Label_DaoJiShi = cocostudio.getUILabel(view, "Label_DaoJiShi");
	Button_GuiZe = cocostudio.getUIButton(view, "Button_GuiZe");
	Button_ShuaXin = cocostudio.getUIButton(view, "Button_ShuaXin");
	Button_DaPai = cocostudio.getUIButton(view, "Button_DaPai");
	Label_PaiMing = cocostudio.getUILabel(view, "Label_PaiMing");
	Label_XiaoHao = cocostudio.getUILabel(view, "Label_XiaoHao");
	LoadingBar = cocostudio.getUILoadingBar(view, "LoadingBar_1");
	Label_PaiMing:setText(0);

	tableView = ccTableView.create(CCSize(winSize.width*0.4,winSize.height*0.3))
	tableView:setPosition(winSize.width*0.2,winSize.height*0.87)
	tableView.SeparatorWidth = 2
	view:addChild(tableView)
	--刷新排行榜
	freshTableView = function (dataTable)
		if(not dataTable)then
			return
		end
		function tableView.numberOfrow()--返回行数
			return #dataTable
		end

		function tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度
			return 35
		end

		function tableView.CellOfAtNumberOfRow(cell,i)--设置cell
			local num = #dataTable + 1 - i
			local cellSize = cell:getContentSize()
			cell:setColor(ccc3(255,255,255))
			cell:setOpacity(0)
			local rankLabel = CCLabelTTF:create("No."..num,"",20)
			rankLabel:setAnchorPoint(ccp(0,0.5))
			rankLabel:setPosition(cellSize.width*0.1,cellSize.height*0.5)
			local nameLabel = CCLabelTTF:create(""..dataTable[num].username,"",20)
			nameLabel:setPosition(cellSize.width*0.5,cellSize.height*0.5)
			local scoreLabel = CCLabelTTF:create("爱心值:"..dataTable[num].Likeability,"",20)
			scoreLabel:setAnchorPoint(ccp(0,0.5))
			scoreLabel:setPosition(cellSize.width*0.7,cellSize.height*0.5)
			cell:addChild(rankLabel)
			cell:addChild(nameLabel)
			cell:addChild(scoreLabel)
		end

		ccTableView.reloadData(tableView)
	end

	setTime(NvShenDaoJiShi)
	local delay = CCDelayTime:create(1)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(setTime))
	local seq = CCSequence:create(array)
	Label_DaoJiShi:runAction(CCRepeatForever:create(seq))
	for i = 1,4 do
		local Label_Atlas = cocostudio.getUILabelAtlas(view, "LabelAtlas_"..i)
		Label_Atlas:setStringValue(0)
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/activity_res/AaiXinNvShen.json")
	local gui = GUI_AIXINNVSHEN
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
	GameConfig.setTheCurrentBaseLayer(GUI_AIXINNVSHEN)
	GameStartConfig.addChildForScene(view)

	initView()

	local function delaySentMessage()
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_GET_INFO(dataTable)
	end
	LordGamePub.runSenceAction(view,delaySentMessage,false)
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

function callback_Button_GuiZe(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_AIXINNVSHENGUIZE)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_ShuaXin(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		for i  = 1 ,4 do
			if(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 1)then
				Common.showToast("您还有未领取的宝箱！",2)
				return
			end
		end
		local dataTable = {}
		dataTable["gameID"] = GameConfig.GAME_ID
		sendOPERID_GODDESS_RESET(dataTable)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_DaPai(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showProgressDialog("正在转入牌桌...")
		sendQuickEnterRoom(2)

	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_ImageView_1(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 1
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftStatus == 0 then
			Common.showToast("再进行".. OPERID_GODDESS_GET_INFOInfo["GiftList"][1].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局癞子房游戏即可领取",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_ImageView_2(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 2
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftStatus == 0 then
			Common.showToast("再进行".. OPERID_GODDESS_GET_INFOInfo["GiftList"][2].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局癞子房游戏即可领取",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_ImageView_3(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 3
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftStatus == 0 then
			Common.showToast("再进行".. OPERID_GODDESS_GET_INFOInfo["GiftList"][3].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局癞子房游戏即可领取",2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_ImageView_4(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftStatus == 1)then
			local dataTable = {}
			dataTable["gameID"] = GameConfig.GAME_ID
			dataTable["GiftID"] = 4
			sendOPERID_GODDESS_GET_GIFT(dataTable)
		elseif OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftStatus == 0 then
			Common.showToast("再进行".. OPERID_GODDESS_GET_INFOInfo["GiftList"][4].giftLevel - OPERID_GODDESS_GET_INFOInfo.completeNum .."局癞子房游戏即可领取",2)
		end

	elseif component == CANCEL_UP then
	--取消
	end
end

--设置时间
function setTime()
	if(NvShenDaoJiShi >= 1000)then
		NvShenDaoJiShi = NvShenDaoJiShi - 1000
	else
		NvShenDaoJiShi = 0
	end

	local sounds = ((NvShenDaoJiShi/1000)%60) - ((NvShenDaoJiShi/1000)%60)%1
	local minute = ((NvShenDaoJiShi/60000)%60) - ((NvShenDaoJiShi/60000)%60)%1
	local ours = (NvShenDaoJiShi/(1000*3600)) - (NvShenDaoJiShi/(1000*3600))%1
	local dates = ours/24 - (ours/24)%1
	ours = ours%24
	local oursString = ours > 9 and tostring(ours) or ("0" .. ours)
	local minuteString = minute > 9 and tostring(minute) or ("0" .. minute)
	local soundsString = sounds > 9 and tostring(sounds) or ("0" .. sounds)
	if(dates > 1)then
		Label_DaoJiShi:setText(dates.."天")
	else
		Label_DaoJiShi:setText(ours..":"..minuteString..":"..soundsString)
	end
end

function updata()
	---------------------初始化数据
	--进度条
	LoadingBar:setPercent(OPERID_GODDESS_GET_INFOInfo.rateofprogress)
	--我的名次
	if(OPERID_GODDESS_GET_INFOInfo.SelfRank>0)then
		Label_PaiMing:setText(OPERID_GODDESS_GET_INFOInfo.SelfRank)
	else
		Label_PaiMing:setText("999")
	end
	--元宝消耗
	Label_XiaoHao:setText("消耗"..OPERID_GODDESS_GET_INFOInfo.expend.."元宝");
	NvShenDaoJiShi = tonumber(OPERID_GODDESS_GET_INFOInfo.Time)
	--初始化礼包状态及其数量
	for i = 1,4 do
		--初始化数量
		local numLabel = cocostudio.getUILabel(view, "Label_"..i.."1")

		numLabel:setText(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftnum1 > 0 and OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftnum1 or 0)
		numLabel = cocostudio.getUILabel(view, "Label_"..i.."2")
		numLabel:setText(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftnum2 > 0 and OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftnum2 or 0)
		local function getImage1(path)
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
			if photoPath ~= nil and photoPath ~= "" then
				local ImageView = cocostudio.getUIImageView(view, "ImageView_"..i.."1")
				ImageView:loadTexture(photoPath)
			end
		end
		--下载奖品的icon
		Common.getPicFile(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].gifturl1, 1, true, getImage1)
		--初始化获得奖品所需要的盘数
		local Label_Atlas = cocostudio.getUILabelAtlas(view, "LabelAtlas_"..i)
		Label_Atlas:setStringValue(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftLevel)
		--初始化礼包状态
		local ImageView_BaoXiang = cocostudio.getUIImageView(view, "ImageView_"..i)
		for j = 101,102 do
			if(ImageView_BaoXiang:getChildByTag(j))then
				ImageView_BaoXiang:getChildByTag(j):removeFromParent()
			end
		end
		if(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 0)then
			local wintSprite = UIImageView:create()
			wintSprite:loadTexture(Common.getResourcePath("load_res/activity_res/bg_activity_lovegoddess_jiangpin_zhezhao.png"))
			ImageView_BaoXiang:addChild(wintSprite)
			wintSprite:setTag(101)
			wintSprite:setZOrder(101)
		elseif(OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus == 2)then
			local wintSprite = UIImageView:create()
			wintSprite:loadTexture(Common.getResourcePath("load_res/activity_res/ic_login_sign_pass.png"))
			ImageView_BaoXiang:addChild(wintSprite)
			wintSprite:setZOrder(100)
			wintSprite:setTag(102)
			wintSprite = UIImageView:create()
			wintSprite:loadTexture(Common.getResourcePath("load_res/activity_res/bg_activity_lovegoddess_jiangpin_zhezhao.png"))
			ImageView_BaoXiang:addChild(wintSprite)
			wintSprite:setTag(101)
			wintSprite:setZOrder(101)
		else
			LordGamePub.breathEffect(ImageView_BaoXiang)
			ImageView_BaoXiang:setZOrder(10)
		end
	end
	--刷新排行榜
	freshTableView(OPERID_GODDESS_GET_INFOInfo.LikeabilityList)
end


--获得女神的基本信息
function getOPERID_GODDESS_GET_INFOInfo()
	OPERID_GODDESS_GET_INFOInfo = profile.HuoDong.getOPERID_GODDESS_GET_INFOTable()
	updata()
end

--刷新奖励状态
function getOPERID_GODDESS_RESETInfo()
	local itemTable = profile.HuoDong.getOPERID_GODDESS_RESETTable()
	if(itemTable.isSuccesse == 1) then
		for i = 1,4 do
			local ImageView_BaoXiang = cocostudio.getUIImageView(view, "ImageView_"..i)
			ImageView_BaoXiang:stopAllActions()
			for j = 101,102 do
				if(ImageView_BaoXiang:getChildByTag(j))then
					ImageView_BaoXiang:getChildByTag(j):removeFromParent()
				end
			end
			if(view:getChildByTag(1001))then
				view:getChildByTag(1001):removeFromParentAndCleanup(true)
			end
			OPERID_GODDESS_GET_INFOInfo["GiftList"][i].giftStatus = 0
			local wintSprite = UIImageView:create()
			wintSprite:loadTexture(Common.getResourcePath("load_res/activity_res/bg_activity_lovegoddess_jiangpin_zhezhao.png"))
			wintSprite:setZOrder(101)
			ImageView_BaoXiang:addChild(wintSprite)
		end
		LoadingBar:setPercent(OPERID_GODDESS_GET_INFOInfo.rateofprogress)
	end

	Common.showToast(itemTable["Mes"], 2)
end


--领取奖励
function getOPERID_GODDESS_GET_GIFTInfo()
	local dataTable = profile.HuoDong.getOPERID_GODDESS_GET_GIFTTable()
	Common.log("收到奖品信息：",dataTable["isSuccesse"],dataTable["Mes"])

	if(dataTable["isSuccesse"] == 1) then
		OPERID_GODDESS_GET_INFOInfo["GiftList"][dataTable["GiftID"]].giftStatus = 2
		local ImageView = cocostudio.getUILabel(view,"ImageView_"..dataTable["GiftID"])
		ImageView:stopAllActions()
		ImageView:setScale(1)
		local wintSprite = CCSprite:create(Common.getResourcePath("load_res/activity_res/ic_login_sign_pass.png"))
		wintSprite:setScale(8)
		wintSprite:setZOrder(100)
		wintSprite:setAnchorPoint(ccp(0.1,0.2))
		wintSprite:setTag(1001)
		wintSprite:setPosition(ImageView:getParent():convertToWorldSpace(ImageView:getPosition()))
		view:addChild(wintSprite)

		local scaleAction =  CCScaleTo:create(0.25, 1)
		local ease = CCEaseOut:create(scaleAction,0.8)
		local array = CCArray:create()
		array:addObject(ease)
		array:addObject(CCDelayTime:create(2))
		local seq = CCSequence:create(array)
		wintSprite:setZOrder(10)
		wintSprite:runAction(seq)
		for i = 1,#dataTable["Awardlist"] do
			ImageToast.createView(dataTable["Awardlist"][i].url,nil,dataTable["Awardlist"][i].mes,nil,#dataTable["Awardlist"] - i + 1)
		end

		if(OPERID_GODDESS_GET_INFOInfo.SelfRank ~= dataTable.SelfRank)then
			freshTableView(dataTable.LikeabilityList)
			if(dataTable.SelfRank > 0)then
				Label_PaiMing:setText(dataTable.SelfRank)
			else
				Label_PaiMing:setText("999")
			end
		end
	end
	Common.showToast(dataTable["Mes"], 2)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(OPERID_GODDESS_GET_INFO,getOPERID_GODDESS_GET_INFOInfo)
	framework.addSlot2Signal(OPERID_GODDESS_RESET,getOPERID_GODDESS_RESETInfo)
	framework.addSlot2Signal(OPERID_GODDESS_GET_GIFT,getOPERID_GODDESS_GET_GIFTInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(OPERID_GODDESS_GET_INFO,getOPERID_GODDESS_GET_INFOInfo)
	framework.removeSlotFromSignal(OPERID_GODDESS_RESET,getOPERID_GODDESS_RESETInfo)
	framework.removeSlotFromSignal(OPERID_GODDESS_GET_GIFT,getOPERID_GODDESS_GET_GIFTInfo)
end
