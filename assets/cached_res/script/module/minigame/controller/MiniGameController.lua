module(...,package.seeall)

Load.LuaRequire("script.module.minigame.logic.MiniGameLogic")

MiniGameController = class("MiniGameController",BaseController)
MiniGameController.__index = MiniGameController

MiniGameController.moduleLayer = nil

function MiniGameController:reset()
	MiniGameLogic.view = nil
end

function MiniGameController:getLayer()
	return MiniGameLogic.view
end

function MiniGameController:createView()
	MiniGameLogic.createView()
	framework.setOnKeypadEventListener(MiniGameLogic.view, MiniGameLogic.onKeypad)
end

function MiniGameController:requestMsg()
	MiniGameLogic.requestMsg()
end

function MiniGameController:addSlot()
	MiniGameLogic.addSlot()
end

function MiniGameController:removeSlot()
	MiniGameLogic.removeSlot()
end

function MiniGameController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MiniGameLogic.view,"BackButton"),MiniGameLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MiniGameController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MiniGameLogic.view,"BackButton"),MiniGameLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MiniGameController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MiniGameController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MiniGameController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MiniGameLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MiniGameLogic);
		MiniGameLogic.releaseData();
	end

	MiniGameLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MiniGameController:sleepModule()
	framework.releaseOnKeypadEventListener(MiniGameLogic.view)
	MiniGameLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MiniGameController:wakeModule()
	framework.setOnKeypadEventListener(MiniGameLogic.view, MiniGameLogic.onKeypad)
	MiniGameLogic.view:setTouchEnabled(true)
end
