module(...,package.seeall)

Load.LuaRequire("script.module.renwu.logic.RenWuJiangLiInfoLogic")

RenWuJiangLiInfoController = class("RenWuJiangLiInfoController",BaseController)
RenWuJiangLiInfoController.__index = RenWuJiangLiInfoController

RenWuJiangLiInfoController.moduleLayer = nil

function RenWuJiangLiInfoController:reset()
	RenWuJiangLiInfoLogic.view = nil
end

function RenWuJiangLiInfoController:getLayer()
	return RenWuJiangLiInfoLogic.view
end

function RenWuJiangLiInfoController:createView()
	RenWuJiangLiInfoLogic.createView()
	framework.setOnKeypadEventListener(RenWuJiangLiInfoLogic.view, RenWuJiangLiInfoLogic.onKeypad)
end

function RenWuJiangLiInfoController:requestMsg()
	RenWuJiangLiInfoLogic.requestMsg()
end

function RenWuJiangLiInfoController:addSlot()
	RenWuJiangLiInfoLogic.addSlot()
end

function RenWuJiangLiInfoController:removeSlot()
	RenWuJiangLiInfoLogic.removeSlot()
end

function RenWuJiangLiInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RenWuJiangLiInfoLogic.view,"Button_Ok"),RenWuJiangLiInfoLogic.callback_Button_Ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuJiangLiInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RenWuJiangLiInfoLogic.view,"Button_Ok"),RenWuJiangLiInfoLogic.callback_Button_Ok,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuJiangLiInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RenWuJiangLiInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RenWuJiangLiInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RenWuJiangLiInfoLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RenWuJiangLiInfoLogic);
		RenWuJiangLiInfoLogic.releaseData();
	end

	RenWuJiangLiInfoLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RenWuJiangLiInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(RenWuJiangLiInfoLogic.view)
	RenWuJiangLiInfoLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RenWuJiangLiInfoController:wakeModule()
	framework.setOnKeypadEventListener(RenWuJiangLiInfoLogic.view, RenWuJiangLiInfoLogic.onKeypad)
	RenWuJiangLiInfoLogic.view:setTouchEnabled(true)
end
