module(...,package.seeall)

Load.LuaRequire("script.module.vip.logic.VIPLogic")

VIPController = class("VIPController",BaseController)
VIPController.__index = VIPController

VIPController.moduleLayer = nil

function VIPController:reset()
	VIPLogic.view = nil
end

function VIPController:getLayer()
	return VIPLogic.view
end

function VIPController:createView()
	VIPLogic.createView()
	framework.setOnKeypadEventListener(VIPLogic.view, VIPLogic.onKeypad)
end

function VIPController:requestMsg()
	VIPLogic.requestMsg()
end

function VIPController:addSlot()
	VIPLogic.addSlot()
end

function VIPController:removeSlot()
	VIPLogic.removeSlot()
end

function VIPController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_cz"),VIPLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_back"),VIPLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_pre"),VIPLogic.callback_btn_pre,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_next"),VIPLogic.callback_btn_next,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_viplibao"),VIPLogic.callback_btn_viplibao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_help"),VIPLogic.callback_btn_help,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function VIPController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_cz"),VIPLogic.callback_btn_cz,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_back"),VIPLogic.callback_btn_back,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_pre"),VIPLogic.callback_btn_pre,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_next"),VIPLogic.callback_btn_next,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_viplibao"),VIPLogic.callback_btn_viplibao,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(VIPLogic.view,"btn_help"),VIPLogic.callback_btn_help,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function VIPController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function VIPController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function VIPController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(VIPLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(VIPLogic);
		VIPLogic.releaseData();
	end

	VIPLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function VIPController:sleepModule()
	framework.releaseOnKeypadEventListener(VIPLogic.view)
	VIPLogic.view:setTouchEnabled(false)
	--隐藏web_view控件
	Common.hideWebView();
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function VIPController:wakeModule()
	framework.setOnKeypadEventListener(VIPLogic.view, VIPLogic.onKeypad)
	--显示web_view控件
	VIPLogic.showVipWebView();
	VIPLogic.view:setTouchEnabled(true)
end
