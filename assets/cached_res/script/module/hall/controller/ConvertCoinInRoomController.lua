module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.ConvertCoinInRoomLogic")

ConvertCoinInRoomController = class("ConvertCoinInRoomController",BaseController)
ConvertCoinInRoomController.__index = ConvertCoinInRoomController

ConvertCoinInRoomController.moduleLayer = nil

function ConvertCoinInRoomController:reset()
	ConvertCoinInRoomLogic.view = nil
end

function ConvertCoinInRoomController:getLayer()
	return ConvertCoinInRoomLogic.view
end

function ConvertCoinInRoomController:createView()
	ConvertCoinInRoomLogic.createView()
	framework.setOnKeypadEventListener(ConvertCoinInRoomLogic.view, ConvertCoinInRoomLogic.onKeypad)
end

function ConvertCoinInRoomController:requestMsg()
	ConvertCoinInRoomLogic.requestMsg()
end

function ConvertCoinInRoomController:addSlot()
	ConvertCoinInRoomLogic.addSlot()
end

function ConvertCoinInRoomController:removeSlot()
	ConvertCoinInRoomLogic.removeSlot()
end

function ConvertCoinInRoomController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_close"),ConvertCoinInRoomLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_cancel"),ConvertCoinInRoomLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_convert"),ConvertCoinInRoomLogic.callback_btn_convert,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"check_show"),ConvertCoinInRoomLogic.callback_check_show,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_add"),ConvertCoinInRoomLogic.callback_btn_add,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_jian"),ConvertCoinInRoomLogic.callback_btn_jian,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"lab_num"),ConvertCoinInRoomLogic.callback_lab_num_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"lab_num"),ConvertCoinInRoomLogic.callback_lab_num,DETACH_WITH_IME)
	end
end

function ConvertCoinInRoomController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_close"),ConvertCoinInRoomLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_cancel"),ConvertCoinInRoomLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_convert"),ConvertCoinInRoomLogic.callback_btn_convert,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"check_show"),ConvertCoinInRoomLogic.callback_check_show,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_add"),ConvertCoinInRoomLogic.callback_btn_add,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"btn_jian"),ConvertCoinInRoomLogic.callback_btn_jian,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"lab_num"),ConvertCoinInRoomLogic.callback_lab_num_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(ConvertCoinInRoomLogic.view,"lab_num"),ConvertCoinInRoomLogic.callback_lab_num,DETACH_WITH_IME)
	end
end

function ConvertCoinInRoomController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function ConvertCoinInRoomController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function ConvertCoinInRoomController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ConvertCoinInRoomLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(ConvertCoinInRoomLogic);
		ConvertCoinInRoomLogic.releaseData();
	end

	ConvertCoinInRoomLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function ConvertCoinInRoomController:sleepModule()
	framework.releaseOnKeypadEventListener(ConvertCoinInRoomLogic.view)
	ConvertCoinInRoomLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function ConvertCoinInRoomController:wakeModule()
	framework.setOnKeypadEventListener(ConvertCoinInRoomLogic.view, ConvertCoinInRoomLogic.onKeypad)
	ConvertCoinInRoomLogic.view:setTouchEnabled(true)
end
