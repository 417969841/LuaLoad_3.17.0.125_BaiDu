module(...,package.seeall)

Load.LuaRequire("script.module.commondialog.logic.BeKickedLogic")

BeKickedController = class("BeKickedController",BaseController)
BeKickedController.__index = BeKickedController

BeKickedController.moduleLayer = nil

function BeKickedController:reset()
	BeKickedLogic.view = nil
end

function BeKickedController:getLayer()
	return BeKickedLogic.view
end

function BeKickedController:createView()
	BeKickedLogic.createView()
	framework.setOnKeypadEventListener(BeKickedLogic.view, BeKickedLogic.onKeypad)
end

function BeKickedController:requestMsg()
	BeKickedLogic.requestMsg()
end

function BeKickedController:addSlot()
	BeKickedLogic.addSlot()
end

function BeKickedController:removeSlot()
	BeKickedLogic.removeSlot()
end

function BeKickedController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BeKickedLogic.view,"btn_item_close"), BeKickedLogic.callback_btn_item_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(BeKickedLogic.view,"btn_item_buy_vip"), BeKickedLogic.callback_btn_item_buy_vip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function BeKickedController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BeKickedLogic.view,"btn_item_close"), BeKickedLogic.callback_btn_item_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(BeKickedLogic.view,"btn_item_buy_vip"), BeKickedLogic.callback_btn_item_buy_vip, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function BeKickedController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function BeKickedController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function BeKickedController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BeKickedLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(BeKickedLogic);
		BeKickedLogic.releaseData();
	end

	BeKickedLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function BeKickedController:sleepModule()
	framework.releaseOnKeypadEventListener(BeKickedLogic.view)
	BeKickedLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function BeKickedController:wakeModule()
	framework.setOnKeypadEventListener(BeKickedLogic.view, BeKickedLogic.onKeypad)
	BeKickedLogic.view:setTouchEnabled(true)
end
