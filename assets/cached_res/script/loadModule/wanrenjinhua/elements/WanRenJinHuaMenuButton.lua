local WanRenJinHuaBackBtn = 1
local WanRenJinHuaApplyDealerBtn = 2
local WanRenJinHuaHelpBtn = 3
local WanRenJinHuaHistoryBtn = 4
local WanRenJinHuaBuyCoinBtn = 5
local BtnGroup = {}

function onClickWanRenJinHuaBackBtn()
	WanRenJinHuaLogic.showQuitPop()
end

function onClickWanRenJinHuaApplyDealerBtn()
	Common.showToast("玩家上庄暂未开放, 敬请期待！", 2);
end

function onClickWanRenJinHuaHelpBtn()
	local WanRenJinHuaHelpDataTable = profile.WanRenJinHua.getWanRenJinHuaHelpDataTable()
	if WanRenJinHuaHelpDataTable then
		mvcEngine.createModule(GUI_WANRENJINHUA_CARD_TYPE)
	end
end

function onClickWanRenJinHuaHistoryBtn()
	local WanRenJinHuaHistoryDataTable = profile.WanRenJinHua.getWanRenJinHuaHistoryDataTable()
	if WanRenJinHuaHistoryDataTable then
		mvcEngine.createModule(GUI_WANRENJINHUA_HISTORY)
	end
end

--充值
function onClickWanRenJinHuaBuyCoinBtn()
	CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, 10000, RechargeGuidePositionID.WanRenJinHuaPositionA)
end

-- 绘制下注列表
-- layer 要加的层
-- 数据
function createWanRenJinHuaMenuButton(layer)
	BtnGroup[WanRenJinHuaBackBtn] = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("btn_hall_jingdianchang_return_nor.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("btn_hall_jingdianchang_return_press.png"))
	BtnGroup[WanRenJinHuaBackBtn]:setAnchorPoint(ccp(0, 1))
	BtnGroup[WanRenJinHuaBackBtn]:setPosition(WanRenJinHuaConfig.WanRenJinHuaBtnX.upDealer - 20, TableConfig.TableRealHeight-4-WanRenJinHuaConfig.fitY)
	layer:addChild(BtnGroup[WanRenJinHuaBackBtn])
	BtnGroup[WanRenJinHuaBackBtn]:registerScriptTapHandler(onClickWanRenJinHuaBackBtn)

	BtnGroup[WanRenJinHuaApplyDealerBtn] = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_shangzhuang_nor.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("ic_wanrenjinhua_shangzhuang_press.png"))
	BtnGroup[WanRenJinHuaApplyDealerBtn]:setAnchorPoint(ccp(0, 0.5))
	BtnGroup[WanRenJinHuaApplyDealerBtn]:setPosition(WanRenJinHuaConfig.WanRenJinHuaBtnX.upDealer,WanRenJinHuaConfig.WanRenJinHuaBtnY.upDealer)
	layer:addChild(BtnGroup[WanRenJinHuaApplyDealerBtn])
	BtnGroup[WanRenJinHuaApplyDealerBtn]:registerScriptTapHandler(onClickWanRenJinHuaApplyDealerBtn)

	BtnGroup[WanRenJinHuaHelpBtn] = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("btn_wanrenjinhua_bangzhu_nor.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("btn_wanrenjinhua_bangzhu_press.png"))
	BtnGroup[WanRenJinHuaHelpBtn]:setAnchorPoint(ccp(0, 0.5))
	BtnGroup[WanRenJinHuaHelpBtn]:setPosition(WanRenJinHuaConfig.WanRenJinHuaBtnX.help,WanRenJinHuaConfig.WanRenJinHuaBtnY.help)
	layer:addChild(BtnGroup[WanRenJinHuaHelpBtn])
	BtnGroup[WanRenJinHuaHelpBtn]:registerScriptTapHandler(onClickWanRenJinHuaHelpBtn)

	BtnGroup[WanRenJinHuaHistoryBtn] = CCMenuItemImage:create(WanRenJinHuaConfig.getWanRenJinHuaResource("btn_wanrenjinhua_lishi_nor.png"), WanRenJinHuaConfig.getWanRenJinHuaResource("btn_wanrenjinhua_lishi_press.png"))
	BtnGroup[WanRenJinHuaHistoryBtn]:setAnchorPoint(ccp(0, 0.5))
	BtnGroup[WanRenJinHuaHistoryBtn]:setPosition(WanRenJinHuaConfig.WanRenJinHuaBtnX.history,WanRenJinHuaConfig.WanRenJinHuaBtnY.history)
	layer:addChild(BtnGroup[WanRenJinHuaHistoryBtn])
	BtnGroup[WanRenJinHuaHistoryBtn]:registerScriptTapHandler(onClickWanRenJinHuaHistoryBtn)

	local buyCoinBtnNormalSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_btn_recharge_normal.png", pathTypeInApp))
	buyCoinBtnNormalSprite:setAnchorPoint(ccp(0.5, 0.5))
	local buyCoinBtnSelectedSprite = CCSprite:create(WanRenJinHuaConfig.getWanRenJinHuaResource("desk_btn_recharge_normal.png", pathTypeInApp))
	buyCoinBtnSelectedSprite:setAnchorPoint(ccp(0.5, 0.5))
	buyCoinBtnSelectedSprite:setScale(1.2)
	BtnGroup[WanRenJinHuaBuyCoinBtn] = CCMenuItemSprite:create(buyCoinBtnNormalSprite, buyCoinBtnSelectedSprite)
	BtnGroup[WanRenJinHuaBuyCoinBtn]:setAnchorPoint(ccp(0.5, 0.5))
	BtnGroup[WanRenJinHuaBuyCoinBtn]:setPosition(WanRenJinHuaConfig.SelfUserInfoElementsPositionX.selfUserRecharge,WanRenJinHuaConfig.SelfUserInfoElementsPositionY.selfUserRecharge)
	layer:addChild(BtnGroup[WanRenJinHuaBuyCoinBtn])
	BtnGroup[WanRenJinHuaBuyCoinBtn]:registerScriptTapHandler(onClickWanRenJinHuaBuyCoinBtn)
end
