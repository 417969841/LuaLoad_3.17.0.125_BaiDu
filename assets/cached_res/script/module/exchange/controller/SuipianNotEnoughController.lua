module(...,package.seeall)

Load.LuaRequire("script.module.exchange.logic.SuipianNotEnoughLogic")

SuipianNotEnoughController = class("SuipianNotEnoughController",BaseController)
SuipianNotEnoughController.__index = SuipianNotEnoughController

SuipianNotEnoughController.moduleLayer = nil

function SuipianNotEnoughController:reset()
	SuipianNotEnoughLogic.view = nil
end

function SuipianNotEnoughController:getLayer()
	return SuipianNotEnoughLogic.view
end

function SuipianNotEnoughController:createView()
	SuipianNotEnoughLogic.createView()
	framework.setOnKeypadEventListener(SuipianNotEnoughLogic.view, SuipianNotEnoughLogic.onKeypad)
end

function SuipianNotEnoughController:requestMsg()
	SuipianNotEnoughLogic.requestMsg()
end

function SuipianNotEnoughController:addSlot()
	SuipianNotEnoughLogic.addSlot()
end

function SuipianNotEnoughController:removeSlot()
	SuipianNotEnoughLogic.removeSlot()
end

function SuipianNotEnoughController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_close"),SuipianNotEnoughLogic.callback_btn_close,  BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_goconvert"),SuipianNotEnoughLogic.callback_btn_goconvert,  BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_gogame"),SuipianNotEnoughLogic.callback_btn_gogame,  BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function SuipianNotEnoughController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_close"),SuipianNotEnoughLogic.callback_btn_close,  BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_goconvert"),SuipianNotEnoughLogic.callback_btn_goconvert,  BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SuipianNotEnoughLogic.view,"btn_gogame"),SuipianNotEnoughLogic.callback_btn_gogame,  BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function SuipianNotEnoughController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function SuipianNotEnoughController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function SuipianNotEnoughController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SuipianNotEnoughLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(SuipianNotEnoughLogic);
		SuipianNotEnoughLogic.releaseData();
	end

	SuipianNotEnoughLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function SuipianNotEnoughController:sleepModule()
	framework.releaseOnKeypadEventListener(SuipianNotEnoughLogic.view)
	SuipianNotEnoughLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function SuipianNotEnoughController:wakeModule()
	framework.setOnKeypadEventListener(SuipianNotEnoughLogic.view, SuipianNotEnoughLogic.onKeypad)
	SuipianNotEnoughLogic.view:setTouchEnabled(true)
end
