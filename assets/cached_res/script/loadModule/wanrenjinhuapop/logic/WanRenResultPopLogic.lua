module("WanRenResultPopLogic",package.seeall)

view = nil

dealerNameLabel = nil -- 庄家名字
dealerWinCoinLabel = nil -- 庄家赢金币
selfNameLabel = nil -- 自己名字
selfWinCoinLabel = nil -- 自己赢金币
bigWinerNameLabel = nil -- 最大赢家名字
bigWinerWinCoinLable = nil -- 最大赢家赢金币

isShowing = false -- 是否在显示中

function onKeypad(event)
	if event == "backClicked" then
		callback_wanrenjinhua_result_bg_panel()
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/WanRenJinHua/WanRenResultPop.json")
	local gui = GUI_WANRENJINHUA_RESULT
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
	GameStartConfig.addChildForScene(view)

	dealerNameLabel = cocostudio.getUILabel(view,"wanren_dealer_name_label")
	dealerWinCoinLabel = cocostudio.getUILabel(view,"wanren_dealer_coin_label")
	selfNameLabel = cocostudio.getUILabel(view,"wanren_self_name_label")
	selfWinCoinLabel = cocostudio.getUILabel(view,"wanren_self_coin_label")
	bigWinerNameLabel = cocostudio.getUILabel(view,"wanren_bigwiner_name_label")
	bigWinerWinCoinLable = cocostudio.getUILabel(view,"wanren_bigwiner_coin_label")
	isShowing = true
end

-- 处理显示的数字
local function dealShowCount(label, countValue)
	local winCoinText
	if tonumber(countValue) < 0 then
		winCoinText = countValue
		label:setColor(ccc3(159, 234, 129))
	else
		winCoinText = "+"..countValue
		label:setColor(ccc3(255, 173, 173))
	end
	label:setText(winCoinText)
end

-- 设置数据
function setResultData(dealerWinCoin, bigWinerName, bigWinerWinCoin)
	dealerNameLabel:setText(WanRenJinHuaDealerInfo.getDealerName())
	selfNameLabel:setText(profile.User.getSelfNickName())
	bigWinerNameLabel:setText(bigWinerName)

	dealShowCount(dealerWinCoinLabel, dealerWinCoin)
	dealShowCount(selfWinCoinLabel, WanRenJinHuaSelfWinCoinNum.getAllSelfWinCoinNum())
	dealShowCount(bigWinerWinCoinLable, bigWinerWinCoin)
end

function requestMsg()
end

function callback_wanrenjinhua_result_bg_panel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_WANRENJINHUA_RESULT)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_wanrenjinhua_result_bg_image(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end


function addSlot()
end

function removeSlot()
end