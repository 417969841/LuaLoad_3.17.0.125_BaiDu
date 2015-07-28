module(...,package.seeall)

Load.LuaRequire("script.module.renwu.logic.RenWuChongZhiLogic")

RenWuChongZhiController = class("RenWuChongZhiController",BaseController)
RenWuChongZhiController.__index = RenWuChongZhiController

RenWuChongZhiController.moduleLayer = nil

function RenWuChongZhiController:reset()
	RenWuChongZhiLogic.view = nil
end

function RenWuChongZhiController:getLayer()
	return RenWuChongZhiLogic.view
end

function RenWuChongZhiController:createView()
	RenWuChongZhiLogic.createView()
	framework.setOnKeypadEventListener(RenWuChongZhiLogic.view, RenWuChongZhiLogic.onKeypad)
end

function RenWuChongZhiController:requestMsg()
	RenWuChongZhiLogic.requestMsg()
end

function RenWuChongZhiController:addSlot()
	RenWuChongZhiLogic.addSlot()
end

function RenWuChongZhiController:removeSlot()
	RenWuChongZhiLogic.removeSlot()
end

function RenWuChongZhiController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RenWuChongZhiLogic.view,"BackButton"),RenWuChongZhiLogic.callback_BackButton,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RenWuChongZhiLogic.view,"btn_chongZhi"),RenWuChongZhiLogic.callback_btn_chongZhi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuChongZhiController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RenWuChongZhiLogic.view,"BackButton"),RenWuChongZhiLogic.callback_BackButton,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuChongZhiLogic.view,"btn_chongZhi"),RenWuChongZhiLogic.callback_btn_chongZhi,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuChongZhiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RenWuChongZhiController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RenWuChongZhiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RenWuChongZhiLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RenWuChongZhiLogic);
		RenWuChongZhiLogic.releaseData();
	end

	RenWuChongZhiLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RenWuChongZhiController:sleepModule()
	framework.releaseOnKeypadEventListener(RenWuChongZhiLogic.view)
	RenWuChongZhiLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RenWuChongZhiController:wakeModule()
	framework.setOnKeypadEventListener(RenWuChongZhiLogic.view, RenWuChongZhiLogic.onKeypad)
	RenWuChongZhiLogic.view:setTouchEnabled(true)
end
