module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.PayGuidePromptLogic")

PayGuidePromptController = class("PayGuidePromptController",BaseController)
PayGuidePromptController.__index = PayGuidePromptController

PayGuidePromptController.moduleLayer = nil

function PayGuidePromptController:reset()
	PayGuidePromptLogic.view = nil
end

function PayGuidePromptController:getLayer()
	return PayGuidePromptLogic.view
end

function PayGuidePromptController:createView()
	PayGuidePromptLogic.createView()
	framework.setOnKeypadEventListener(PayGuidePromptLogic.view, PayGuidePromptLogic.onKeypad)
end

function PayGuidePromptController:requestMsg()
	PayGuidePromptLogic.requestMsg()
end

function PayGuidePromptController:addSlot()
	PayGuidePromptLogic.addSlot()
end

function PayGuidePromptController:removeSlot()
	PayGuidePromptLogic.removeSlot()
end

function PayGuidePromptController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_close"), PayGuidePromptLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_sms_ok"), PayGuidePromptLogic.callback_Button_sms_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_weixin"), PayGuidePromptLogic.callback_Button_weixin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_alipay"), PayGuidePromptLogic.callback_Button_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function PayGuidePromptController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_close"), PayGuidePromptLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_sms_ok"), PayGuidePromptLogic.callback_Button_sms_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_weixin"), PayGuidePromptLogic.callback_Button_weixin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(PayGuidePromptLogic.view,"Button_alipay"), PayGuidePromptLogic.callback_Button_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function PayGuidePromptController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function PayGuidePromptController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function PayGuidePromptController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(PayGuidePromptLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(PayGuidePromptLogic);
		PayGuidePromptLogic.releaseData();
	end

	PayGuidePromptLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function PayGuidePromptController:sleepModule()
	framework.releaseOnKeypadEventListener(PayGuidePromptLogic.view)
	PayGuidePromptLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function PayGuidePromptController:wakeModule()
	framework.setOnKeypadEventListener(PayGuidePromptLogic.view, PayGuidePromptLogic.onKeypad)
	PayGuidePromptLogic.view:setTouchEnabled(true)
end
