module("CommShareLogic",package.seeall)

view = nil;

--自定义变量
local isSelect = nil --分享类型 false 分享到好友 true 分享到朋友圈
local showText = nil --分享弹窗展示文本
local showImage = nil --分享弹窗展示图片
local showImageChild = nil --分享弹窗展示实物图片
local showNum = nil --分享弹窗展示数字
local currentShareType = nil --当前分享类型
local showTitle = nil

Panel_14 = nil;--
Button_close = nil;--
Show_Image = nil;--分享弹窗展示图片
Show_Image_Child = nil;--分享弹窗展示实物图片
Show_Number = nil;--
Left_Select_Image = nil;--
Right_Select_Image = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function close()
	mvcEngine.destroyModule(GUI_COMMSHARE);
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Show_Image = cocostudio.getUIImageView(view, "Show_Image");
	Show_Image_Child = cocostudio.getUIImageView(view, "Show_Image_Child");
	Show_Number = cocostudio.getUILabelAtlas(view, "Show_Number");
	Left_Select_Image = cocostudio.getUIImageView(view, "Left_Select_Image");
	Right_Select_Image = cocostudio.getUIImageView(view, "Right_Select_Image");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CommShare.json")
	local gui = GUI_COMMSHARE
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	showTitle = "分享一个好玩的斗地主游戏"
	--标记是被动分享弹窗
	CommShareConfig.SHARETYPE = CommShareConfig.SHARE_TYPE_PASSIVE
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView();
	initData();
end

--[[--
--初始化弹出框展示信息
@parm gameType 分享类型
@parm showBgChild 分享背景图片
@parm parameter 例如连胜几次牌桌多少倍或是实物图片地址
--]]
--function initCommShareMessage()
--	if currentShareType == CommShareConfig.MINIGAMESTREAK or currentShareType == CommShareConfig.MINIGAMEPRIZE then
--		showMiniGamePanel()
--	elseif currentShareType == CommShareConfig.PACKTABLESTREAK or currentShareType == CommShareConfig.PACKTABLEMULTIPLE then
--		showNormalTablePanel()
--	elseif currentShareType == CommShareConfig.EXCHANGEENTITY then
--		showExchangeSharePanel()
--	elseif currentShareType == CommShareConfig.COINRANKING then
--		showCoinRankingSharePanel()
--	elseif currentShareType == CommShareConfig.MATCHENTITY or gameType == CommShareConfig.MATCHRANKING then
--		showMatchSharePanel()
--	elseif currentShareType == CommShareConfig.CRAZYLEVEL then
--		showCrazySharePanel()
--	end
--end

--[[--
--小游戏连续比倍或获得彩金分享
@parm shareType 分享类型
@parm num 连续比倍多少次
--]]
function showMiniGamePanel()
	if currentShareType == CommShareConfig.MINIGAMESTREAK then --小游戏连续比倍
		showText = string.format("我在斗地主比倍机中连续猜对%d次，大家快来跟我一起来攒人品！", showNum)
		showNum = ""
	elseif currentShareType == CommShareConfig.MINIGAMEPRIZE then --小游戏赢得彩金
		showText = "我在斗地主水果机中转得特等奖，大家快来跟我一起来攒人品!"
	end
end

--[[--
--普通牌桌连胜或高倍分享
--]]
function showNormalTablePanel()
	if currentShareType == CommShareConfig.PACKTABLESTREAK then --牌桌连胜
		showText = string.format("我在斗地主中连赢%d局！技术太高了！孤独求虐！", showNum)
	elseif currentShareType == CommShareConfig.PACKTABLEMULTIPLE then --牌桌高倍
		showText = string.format("斗地主中居然打出了%d倍!我和我的小伙伴都惊呆了,不服就来挑战我~!", showNum)
	end
end

--[[--
--兑奖券兑换实物分享
--]]
function showExchangeSharePanel()
	showText = "Hi,我在斗地主中免费获得了实物奖，看清楚了是免费的哦！快来一起免费拿奖吧！"
end

--[[--
--赚金排行榜Top100分享
--]]
function showCoinRankingSharePanel()
	showText = string.format("哈哈！我在斗地主里面获得赚金榜第%d名，想超过我就来一起斗地主!", showNum)
end

--[[--
--比赛赢实物或前三名分享
--]]
function showMatchSharePanel()
	if currentShareType == CommShareConfig.MATCHENTITY then
		showText = "我在斗地主中打比赛赢得了实物奖！快来和我一起赢奖吧！"
	elseif currentShareType == CommShareConfig.MATCHRANKING then
		showText = string.format("我在斗地主比赛中获得第%d名！小伙伴们快来跟我一绝高下吧！", showNum)
	end
end

--[[--
--闯关赛分享
--]]
function showCrazySharePanel()
	showText = "想要跟我体验一览众山小的感觉吗？同趣斗地主等你来玩！"
end

--[[--
--初始化页面数据
--]]
function initData()
	isSelect = true --默认分享到朋友圈
	if showNum == nil then
		showNum = ""
	end
	if showImage == nil then
		showImage = Common.getResourcePath("logo.png")
		--Show_Image:setScale(0.7)
	end
	if showText == nil then
		showText = "疯狂斗地主好好玩噢，大家快来跟我一起玩吧^_^"
	end
	if showImageChild == nil then
		showImageChild = ""
	end
	Show_Image:loadTexture(showImage)
	Show_Number:setStringValue(showNum)
	initShowNumPos()
	Show_Image_Child:loadTexture(showImageChild)
	Show_Image_Child:setScale(1)
	local pos = Show_Image_Child:getPosition()
	Show_Image_Child:setPosition(ccp(pos.x + 55, pos.y + 25))
end

--[[--
--初始化分享基本信息
--]]
function setShareBaseInfo(shareType, imageUrl)
	currentShareType = shareType
	showImage = imageUrl
	if currentShareType == CommShareConfig.MINIGAMESTREAK or currentShareType == CommShareConfig.MINIGAMEPRIZE then
		showMiniGamePanel()
	elseif currentShareType == CommShareConfig.PACKTABLESTREAK or currentShareType == CommShareConfig.PACKTABLEMULTIPLE then
		showNormalTablePanel()
	elseif currentShareType == CommShareConfig.EXCHANGEENTITY then
		showExchangeSharePanel()
	elseif currentShareType == CommShareConfig.COINRANKING then
		showCoinRankingSharePanel()
	elseif currentShareType == CommShareConfig.MATCHENTITY or currentShareType == CommShareConfig.MATCHRANKING then
		showMatchSharePanel()
	elseif currentShareType == CommShareConfig.CRAZYLEVEL then
		showCrazySharePanel()
	end
end

--[[--
--初始化分享数字位置
--]]
function initShowNumPos()
	local pos = Show_Image:getSize()
	if currentShareType == CommShareConfig.PACKTABLESTREAK then
		Show_Number:setPosition(ccp(pos.width*0.2, pos.height*0.27))
	elseif currentShareType == CommShareConfig.PACKTABLEMULTIPLE then

	elseif currentShareType == CommShareConfig.COINRANKING then
		Show_Number:setPosition(ccp(-pos.width*0.24, 0))
	elseif currentShareType == CommShareConfig.MATCHRANKING then
		Show_Number:setPosition(ccp(-pos.width*0.24, 0))
	elseif currentShareType == CommShareConfig.CRAZYLEVEL then
		Show_Number:setPosition(ccp(pos.width*0.07, pos.height*0.33))
	end
end

--[[--
--初始化分享展示数字
@parm num 左边展示数字，例如第几名，多少倍，连胜几次等
--]]
function setShowNum(num)
	showNum = num
end

--[[--
--初始化分享展示实物图片
@parm url 实物图片地址
--]]
function setShowImageChild(url)
	showImageChild = url
end

function requestMsg()
end

--[[--
--关闭弹窗
--]]
function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		mvcEngine.destroyModule(GUI_COMMSHARE)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--分享到朋友圈按钮回调
--]]
function callback_Right_Select_Image(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		isSelect = true
		LordGamePub.shareToWX(isSelect, showTitle, showText)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--分享给好友回调
--]]
function callback_Left_Select_Image(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		isSelect = false
		LordGamePub.shareToWX(isSelect, showTitle, showText)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	showNum = nil
	showImage = nil
	showText = nil
	showImageChild = nil
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
