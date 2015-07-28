module(...,package.seeall)

Load.LuaRequire("script.module.tableDialog.logic.MatchRankingLogic")

MatchRankingController = class("MatchRankingController",BaseController)
MatchRankingController.__index = MatchRankingController

MatchRankingController.moduleLayer = nil

function MatchRankingController:reset()
	MatchRankingLogic.view = nil
end

function MatchRankingController:getLayer()
	return MatchRankingLogic.view
end

function MatchRankingController:createView()
	MatchRankingLogic.createView()
	framework.setOnKeypadEventListener(MatchRankingLogic.view, MatchRankingLogic.onKeypad)
end

function MatchRankingController:requestMsg()
	MatchRankingLogic.requestMsg()
end

function MatchRankingController:addSlot()
	MatchRankingLogic.addSlot()
end

function MatchRankingController:removeSlot()
	MatchRankingLogic.removeSlot()
end

function MatchRankingController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MatchRankingLogic.view,"Button_close"),MatchRankingLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MatchRankingController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MatchRankingLogic.view,"Button_close"),MatchRankingLogic.callback_Button_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function MatchRankingController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MatchRankingController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MatchRankingController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MatchRankingLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MatchRankingLogic);
		MatchRankingLogic.releaseData();
	end

	MatchRankingLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MatchRankingController:sleepModule()
	framework.releaseOnKeypadEventListener(MatchRankingLogic.view)
	MatchRankingLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MatchRankingController:wakeModule()
	framework.setOnKeypadEventListener(MatchRankingLogic.view, MatchRankingLogic.onKeypad)
	MatchRankingLogic.view:setTouchEnabled(true)
end
