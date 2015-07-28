module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.GameResultLogic")

GameResultController = class("GameResultController",BaseController)
GameResultController.__index = GameResultController

GameResultController.moduleLayer = nil

function GameResultController:reset()
	GameResultLogic.view = nil
end

function GameResultController:getLayer()
	return GameResultLogic.view
end

function GameResultController:createView()
	GameResultLogic.createView()
	framework.setOnKeypadEventListener(GameResultLogic.view, GameResultLogic.onKeypad)
end

function GameResultController:requestMsg()
	GameResultLogic.requestMsg()
end

function GameResultController:addSlot()
	GameResultLogic.addSlot()
end

function GameResultController:removeSlot()
	GameResultLogic.removeSlot()
end

function GameResultController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(GameResultLogic.view,"Panel_20"), GameResultLogic.callback_panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(GameResultLogic.view,"Button_close"),GameResultLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function GameResultController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(GameResultLogic.view,"Panel_20"), GameResultLogic.callback_panel_20, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(GameResultLogic.view,"Button_close"),GameResultLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function GameResultController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function GameResultController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function GameResultController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GameResultLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(GameResultLogic);
		GameResultLogic.releaseData();
	end

	GameResultLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function GameResultController:sleepModule()
	framework.releaseOnKeypadEventListener(GameResultLogic.view)
	GameResultLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function GameResultController:wakeModule()
	framework.setOnKeypadEventListener(GameResultLogic.view, GameResultLogic.onKeypad)
	GameResultLogic.view:setTouchEnabled(true)
end
