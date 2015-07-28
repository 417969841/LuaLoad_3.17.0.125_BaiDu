module(...,package.seeall)

Load.LuaRequire("script.module.shop.logic.ConvertCoinLogic")

ConvertCoinController = class("ConvertCoinController",BaseController)
ConvertCoinController.__index = ConvertCoinController

ConvertCoinController.moduleLayer = nil

function ConvertCoinController:reset()
	ConvertCoinLogic.view = nil
end

function ConvertCoinController:getLayer()
	return ConvertCoinLogic.view
end

function ConvertCoinController:createView()
	ConvertCoinLogic.createView()
	framework.setOnKeypadEventListener(ConvertCoinLogic.view, ConvertCoinLogic.onKeypad)
end

function ConvertCoinController:requestMsg()
	ConvertCoinLogic.requestMsg()
end

function ConvertCoinController:addSlot()
	ConvertCoinLogic.addSlot()
end

function ConvertCoinController:removeSlot()
	ConvertCoinLogic.removeSlot()
end

function ConvertCoinController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_gb"),ConvertCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_add"),ConvertCoinLogic.callback_btn_add,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_jian"),ConvertCoinLogic.callback_btn_jian,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_convert"),ConvertCoinLogic.callback_btn_convert,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"txt_num"),ConvertCoinLogic.callback_txt_num_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"txt_num"),ConvertCoinLogic.callback_txt_num,DETACH_WITH_IME)
	end
end

function ConvertCoinController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_gb"),ConvertCoinLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_add"),ConvertCoinLogic.callback_btn_add,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_jian"),ConvertCoinLogic.callback_btn_jian,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"btn_convert"),ConvertCoinLogic.callback_btn_convert,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)

  	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
  		framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"txt_num"),ConvertCoinLogic.callback_txt_num_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
  		framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinLogic.view,"txt_num"),ConvertCoinLogic.callback_txt_num,DETACH_WITH_IME)
	end
end

function ConvertCoinController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ConvertCoinController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ConvertCoinController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ConvertCoinLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ConvertCoinLogic);
		ConvertCoinLogic.releaseData();
	end

	ConvertCoinLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ConvertCoinController:sleepModule()
	framework.releaseOnKeypadEventListener(ConvertCoinLogic.view)
	ConvertCoinLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ConvertCoinController:wakeModule()
	framework.setOnKeypadEventListener(ConvertCoinLogic.view, ConvertCoinLogic.onKeypad)
	ConvertCoinLogic.view:setTouchEnabled(true)
end
