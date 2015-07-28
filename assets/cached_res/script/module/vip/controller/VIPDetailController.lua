module(...,package.seeall)

Load.LuaRequire("script.module.vip.logic.VIPDetailLogic")

VIPDetailController = class("VIPDetailController",BaseController)
VIPDetailController.__index = VIPDetailController

VIPDetailController.moduleLayer = nil

function VIPDetailController:reset()
	VIPDetailLogic.view = nil
end

function VIPDetailController:getLayer()
	return VIPDetailLogic.view
end

function VIPDetailController:createView()
	VIPDetailLogic.createView()
	framework.setOnKeypadEventListener(VIPDetailLogic.view, VIPDetailLogic.onKeypad)
end

function VIPDetailController:requestMsg()
	VIPDetailLogic.requestMsg()
end

function VIPDetailController:addSlot()
	VIPDetailLogic.addSlot()
end

function VIPDetailController:removeSlot()
	VIPDetailLogic.removeSlot()
end

function VIPDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(VIPDetailLogic.view,"btn_close"),VIPDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function VIPDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(VIPDetailLogic.view,"btn_close"),VIPDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function VIPDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function VIPDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function VIPDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(VIPDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(VIPDetailLogic);
		VIPDetailLogic.releaseData();
	end

	VIPDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function VIPDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(VIPDetailLogic.view)
	VIPDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function VIPDetailController:wakeModule()
	framework.setOnKeypadEventListener(VIPDetailLogic.view, VIPDetailLogic.onKeypad)
	VIPDetailLogic.view:setTouchEnabled(true)
end
