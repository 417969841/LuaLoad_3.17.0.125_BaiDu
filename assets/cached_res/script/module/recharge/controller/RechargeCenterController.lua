module(...,package.seeall)

Load.LuaRequire("script.module.recharge.logic.RechargeCenterLogic")

RechargeCenterController = class("RechargeCenterController",BaseController)
RechargeCenterController.__index = RechargeCenterController

RechargeCenterController.moduleLayer = nil

function RechargeCenterController:reset()
	RechargeCenterLogic.view = nil
end

function RechargeCenterController:getLayer()
	return RechargeCenterLogic.view
end

function RechargeCenterController:createView()
	RechargeCenterLogic.createView()
	framework.setOnKeypadEventListener(RechargeCenterLogic.view, RechargeCenterLogic.onKeypad)
end

function RechargeCenterController:requestMsg()
	RechargeCenterLogic.requestMsg()
end

function RechargeCenterController:addSlot()
	RechargeCenterLogic.addSlot()
end

function RechargeCenterController:removeSlot()
	RechargeCenterLogic.removeSlot()
end

function RechargeCenterController:addCallback()
	--top
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_back"),RechargeCenterLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_addcoin"),RechargeCenterLogic.callback_btn_addcoin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_addyuanbao"),RechargeCenterLogic.callback_btn_addyuanbao,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_vip"),RechargeCenterLogic.callback_btn_vip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--left tab
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_czhistory"),RechargeCenterLogic.callback_btn_recharge_history,BUTTON_CLICK)--充值历史
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_czk"),RechargeCenterLogic.callback_btn_recharge_card,BUTTON_CLICK)--充值卡
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_duanxin"),RechargeCenterLogic.callback_btn_sms,BUTTON_CLICK)--短信
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yinlian"),RechargeCenterLogic.callback_btn_union,BUTTON_CLICK)--银联
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_alipay"),RechargeCenterLogic.callback_btn_alipay,BUTTON_CLICK)--支付宝
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_wechat"),RechargeCenterLogic.callback_img_wechat,BUTTON_CLICK)--微信
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_iap"),RechargeCenterLogic.callback_btn_iap,BUTTON_CLICK)--iap
	--充值卡界面
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yidong"),RechargeCenterLogic.callback_img_yidong,BUTTON_CLICK)--
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_dianxin"),RechargeCenterLogic.callback_img_dianxin,BUTTON_CLICK)--
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_liantong"),RechargeCenterLogic.callback_img_liantong,BUTTON_CLICK)--
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Button_chongzhi"), RechargeCenterLogic.callback_Button_chongzhi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_czkok"), RechargeCenterLogic.callback_btn_czkok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT );
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yidong1"),RechargeCenterLogic.callback_img_yidong1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_dianxin1"),RechargeCenterLogic.callback_img_dianxin1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_liantong1"),RechargeCenterLogic.callback_img_liantong1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Image_YuanBao"), RechargeCenterLogic.callback_Image_YuanBao, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Image_Operators"), RechargeCenterLogic.callback_Image_Operators, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox1"), RechargeCenterLogic.callback_CheckBox1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox2"), RechargeCenterLogic.callback_CheckBox2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox3"), RechargeCenterLogic.callback_CheckBox3, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox4"), RechargeCenterLogic.callback_CheckBox4, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox5"), RechargeCenterLogic.callback_CheckBox5, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_card_number"),RechargeCenterLogic.callback_tf_card_number_ios,BUTTON_CLICK)
		--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_password"),RechargeCenterLogic.callback_tf_password_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_card_number"),RechargeCenterLogic.callback_tf_card_number,DETACH_WITH_IME)
		--framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_password"),RechargeCenterLogic.callback_tf_password,DETACH_WITH_IME)
	end
end

function RechargeCenterController:removeCallback()
	--top
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_back"),RechargeCenterLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_addcoin"),RechargeCenterLogic.callback_btn_addcoin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_addyuanbao"),RechargeCenterLogic.callback_btn_addyuanbao,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_vip"),RechargeCenterLogic.callback_btn_vip,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	--left tab
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_czhistory"),RechargeCenterLogic.callback_btn_recharge_history,BUTTON_CLICK)--充值历史
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_czk"),RechargeCenterLogic.callback_btn_recharge_card,BUTTON_CLICK)--充值卡
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_duanxin"),RechargeCenterLogic.callback_btn_sms,BUTTON_CLICK)--短信
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yinlian"),RechargeCenterLogic.callback_btn_union,BUTTON_CLICK)--银联
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_alipay"),RechargeCenterLogic.callback_btn_alipay,BUTTON_CLICK)--支付宝
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_wechat"),RechargeCenterLogic.callback_img_wechat,BUTTON_CLICK)--微信
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_iap"),RechargeCenterLogic.callback_btn_iap,BUTTON_CLICK)--iap
	--充值卡界面
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yidong"),RechargeCenterLogic.callback_img_yidong,BUTTON_CLICK)--
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_dianxin"),RechargeCenterLogic.callback_img_dianxin,BUTTON_CLICK)--
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_liantong"),RechargeCenterLogic.callback_img_liantong,BUTTON_CLICK)--
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Button_chongzhi"), RechargeCenterLogic.callback_Button_chongzhi, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_czkok"), RechargeCenterLogic.callback_btn_czkok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT );
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_yidong1"),RechargeCenterLogic.callback_img_yidong1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_dianxin1"),RechargeCenterLogic.callback_img_dianxin1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_liantong1"),RechargeCenterLogic.callback_img_liantong1,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)--
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Image_YuanBao"), RechargeCenterLogic.callback_Image_YuanBao, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Image_Operators"), RechargeCenterLogic.callback_Image_Operators, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox1"), RechargeCenterLogic.callback_CheckBox1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox2"), RechargeCenterLogic.callback_CheckBox2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox3"), RechargeCenterLogic.callback_CheckBox3, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox4"), RechargeCenterLogic.callback_CheckBox4, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"CheckBox5"), RechargeCenterLogic.callback_CheckBox5, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_card_number"),RechargeCenterLogic.callback_tf_card_number_ios,BUTTON_CLICK)
		--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_password"),RechargeCenterLogic.callback_tf_password_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_card_number"),RechargeCenterLogic.callback_tf_card_number,DETACH_WITH_IME)
		--framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"tf_password"),RechargeCenterLogic.callback_tf_password,DETACH_WITH_IME)
	end
end

function RechargeCenterController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RechargeCenterController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RechargeCenterController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargeCenterLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RechargeCenterLogic);
		RechargeCenterLogic.releaseData();
	end

	RechargeCenterLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RechargeCenterController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargeCenterLogic.view)
	RechargeCenterLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RechargeCenterController:wakeModule()
	framework.setOnKeypadEventListener(RechargeCenterLogic.view, RechargeCenterLogic.onKeypad)
	RechargeCenterLogic.view:setTouchEnabled(true)
end
