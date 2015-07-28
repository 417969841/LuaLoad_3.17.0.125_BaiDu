module("WanRenCardTypePopLogic",package.seeall)

view = nil
wanren_card_type_bg_image = nil;--万人金花image
baoziBeiLabel = nil;--豹子label
shunjinBeiLabel = nil;--顺子label
jinhuaLabel = nil;--金花label
shunziBeiLabel = nil;--顺子倍数label
duiziBeiLabel = nil;--对子倍数label
sanpaiBeiLabel = nil;--散牌倍数label
dilongBeiLabel = nil; --235 倍数label

WanRenJinHuaHelpDataTable = {};--万人金花帮助数据

--[[--
--关闭弹出框
--]]
local function closeTheBox()
	mvcEngine.destroyModule(GUI_WANRENJINHUA_CARD_TYPE);
end

function onKeypad(event)
	if event == "backClicked" then
		LordGamePub.closeDialogAmin(wanren_card_type_bg_image,closeTheBox);
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化控件
--]]
local function initView()
	wanren_card_type_bg_image = cocostudio.getUIImageView(view,"wanren_card_type_bg_image")

	baoziBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_baozi_beishu")
	shunjinBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_shunjin_beishu")
	jinhuaLabel = cocostudio.getUILabel(view,"wanren_card_type_jinhua_beishu")
	shunziBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_shunzi_beishu")
	duiziBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_duizi_beishu")
	sanpaiBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_sanpai_beishu")
	dilongBeiLabel = cocostudio.getUILabel(view,"wanren_card_type_235_beishu")
end

--[[--
--初始化label数据
--]]
local function initLabelData()
	baoziBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["baozi"]].cardBeishu))
	shunjinBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["tonghuashun"]].cardBeishu))
	jinhuaLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["tonghua"]].cardBeishu))
	shunziBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["shunzi"]].cardBeishu))
	duiziBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["duizi"]].cardBeishu))
	sanpaiBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["gaopai"]].cardBeishu))
	dilongBeiLabel:setText(tostring(WanRenJinHuaHelpDataTable["card"][WanRenJinHuaConfig.CardTypeName["dilong"]].cardBeishu))
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("load_res/WanRenJinHua/WanRenCardTypePop.json")
	local gui = GUI_WANRENJINHUA_CARD_TYPE
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

	WanRenJinHuaHelpDataTable = profile.WanRenJinHua.getWanRenJinHuaHelpDataTable()
	initView();
	initLabelData();

end

function requestMsg()
end

function callback_wanren_card_type_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		LordGamePub.closeDialogAmin(wanren_card_type_bg_image,closeTheBox);
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
