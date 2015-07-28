module(...,package.seeall);

Load.LuaRequire("script.module.exchange.logic.RedeemLogic");

RedeemController = class("RedeemController",BaseController);
RedeemController.__index = RedeemController;

RedeemController.moduleLayer = nil;

function RedeemController:reset()
	RedeemLogic.view = nil;
end

function RedeemController:getLayer()
	return RedeemLogic.view;
end

function RedeemController:createView()
	RedeemLogic.createView();
	framework.setOnKeypadEventListener(RedeemLogic.view, RedeemLogic.onKeypad);
end

function RedeemController:requestMsg()
	RedeemLogic.requestMsg();
end

function RedeemController:addSlot()
	RedeemLogic.addSlot();
end

function RedeemController:removeSlot()
	RedeemLogic.removeSlot();
end

function RedeemController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RedeemLogic.view,"btn_close"), RedeemLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RedeemLogic.view,"btn_duihuan"), RedeemLogic.callback_btn_duihuan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(RedeemLogic.view,"txt_code"),RedeemLogic.callback_text_code_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(RedeemLogic.view,"txt_code"),RedeemLogic.callback_text_code,DETACH_WITH_IME)
	end
end

function RedeemController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RedeemLogic.view,"btn_close"), RedeemLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RedeemLogic.view,"btn_duihuan"), RedeemLogic.callback_btn_duihuan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(RedeemLogic.view,"txt_code"),RedeemLogic.callback_text_code_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(RedeemLogic.view,"txt_code"),RedeemLogic.callback_text_code,DETACH_WITH_IME)
	end
end

function RedeemController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RedeemController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RedeemController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RedeemLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RedeemLogic);
		RedeemLogic.releaseData();
	end

	RedeemLogic.view:removeFromParentAndCleanup(true);
	self:reset();
	--如果今日是第一次红包分享且是新用户则分享后进行新手引导判断
	if CommShareConfig.isSuccessShare == false and CommShareConfig.isContinueNewGuide == true and RedGiftShareLogic.getIosBindRedGiftRewardState() == false then
		--请求新手引导，并请求奖励
		if 	profile.NewUserGuide.getisNewUserGuideisEnable()== true then
			sendCOMMONS_GET_NEWUSERGUIDE_AWARD(1);
		end
		CommShareConfig.isContinueNewGuide = false
	end
	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RedeemController:sleepModule()
	framework.releaseOnKeypadEventListener(RedeemLogic.view);
	RedeemLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RedeemController:wakeModule()
	framework.setOnKeypadEventListener(RedeemLogic.view, RedeemLogic.onKeypad);
	RedeemLogic.view:setTouchEnabled(true);
end
