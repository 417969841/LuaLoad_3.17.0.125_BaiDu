module("JinHuaTableGoodsBuyPopLogic",package.seeall)

view = nil

local product
local position
tv_intro = nil;
tv_price = nil;
tv_cnt = nil;
iv_pic = nil;
isTableGoodsBuyPopShowing = false

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableGoodsBuyPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	tv_intro = cocostudio.getUILabel(view,"tv_intro")
	tv_price = cocostudio.getUILabel(view,"tv_price")
	tv_cnt = cocostudio.getUILabel(view,"tv_cnt")
	iv_pic = cocostudio.getUIImageView(view,"iv_pic")
	isTableGoodsBuyPopShowing = true
end

function requestMsg()

end

--[[--
--  点击按钮btn_close,手指抬起后做的事
--]]
local function releaseUpForBtnClose()
	if (QuickPay.Pay_Guide_changecard_GuideTypeID == product.type) then
		Common.setUmengUserDefinedInfo("table_inner_btn_click", "换牌-取消")
	elseif (QuickPay.Pay_Guide_biaoqing_GuideTypeID == product.type) then
		ChatPopLogic.clearSendChatSuperiorPosition()
	end
	mvcEngine.destroyModule(GUI_JINHUA_TABLEGOODSBUYPOP)
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
		releaseUpForBtnClose();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_confirm,手指抬起后做的事
--]]
local function releaseUpForBtnConfirm()
	if (QuickPay.Pay_Guide_changecard_GuideTypeID == product.type) then
		Common.setUmengUserDefinedInfo("table_inner_btn_click", "换牌-确定")
	end
	if profile.User.getSelfYuanBao() < product.price * 10 then
		local num =  product.price * 10 - profile.User.getSelfYuanBao()
		CommDialogConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, num, RechargeGuidePositionID.TablePositionD)
	else
		if product.type == QuickPay.GOODS_TYPE_TIME then
			sendDBID_PAY_GOODS(product.GiftID,1)
		else
			sendDBID_PAY_GOODS(product.GiftID,product.num)
		end
		mvcEngine.destroyModule(GUI_JINHUA_TABLEGOODSBUYPOP)
	end
end

function callback_btn_confirm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
		releaseUpForBtnConfirm();
	elseif component == CANCEL_UP then
	--取消
	end
end

--设置购买道具信息
function setGoodsInfo(GuideType, Position)
	position = Position
	product = QuickPay.getSMSProductDetail(GuideType)
	Common.log("setGoodsInfo")
	Common.log(product)
	if product then
		iv_pic:loadTexture(Common.getResourcePath(product.picName, pathTypeInApp))
		if product.type == QuickPay.GOODS_TYPE_TIME then
			tv_intro:setText("您没有【"..product.name.."】，是否购买？")
			tv_cnt:setText("数量："..product.num.."天")
		else
			tv_intro:setText("您的【"..product.name.."】数量不够，是否购买？")
			tv_cnt:setText("数量："..product.num.."个")
		end
		tv_price:setText(product.price * 10 .."元宝")
	else
		mvcEngine.destroyModule(GUI_JINHUA_TABLEGOODSBUYPOP)

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end


function addSlot()
--framework.addSlot2Signal(signal, slot)

end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
