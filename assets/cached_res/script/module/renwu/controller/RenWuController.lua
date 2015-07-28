module(...,package.seeall)

Load.LuaRequire("script.module.renwu.logic.RenWuLogic")

RenWuController = class("RenWuController",BaseController)
RenWuController.__index = RenWuController

RenWuController.moduleLayer = nil

function RenWuController:reset()
	RenWuLogic.view = nil
end

function RenWuController:getLayer()
	return RenWuLogic.view
end

function RenWuController:createView()
	RenWuLogic.createView()
	framework.setOnKeypadEventListener(RenWuLogic.view, RenWuLogic.onKeypad)
end

function RenWuController:requestMsg()
	RenWuLogic.requestMsg()
end

function RenWuController:addSlot()
	RenWuLogic.addSlot()
end

function RenWuController:removeSlot()
	RenWuLogic.removeSlot()
end

function RenWuController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"BackButton"),RenWuLogic.callback_BackButton,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"ImageView_DaJiang"),RenWuLogic.callback_ImageView_DaJiang,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"ImageView_GuiZe"),RenWuLogic.callback_ImageView_GuiZe,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_YuanBaoTiaoGuo"),RenWuLogic.callback_Button_YuanBaoTiaoGuo,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_JinBiShuaXin"),RenWuLogic.callback_Button_JinBiShuaXin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_LingQu"),RenWuLogic.callback_Button_LingQu,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"BackButton"),RenWuLogic.callback_BackButton,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"ImageView_DaJiang"),RenWuLogic.callback_ImageView_DaJiang,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"ImageView_GuiZe"),RenWuLogic.callback_ImageView_GuiZe,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_YuanBaoTiaoGuo"),RenWuLogic.callback_Button_YuanBaoTiaoGuo,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_JinBiShuaXin"),RenWuLogic.callback_Button_JinBiShuaXin,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(RenWuLogic.view,"Button_LingQu"),RenWuLogic.callback_Button_LingQu,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
end

function RenWuController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function RenWuController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function RenWuController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RenWuLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		--framework.moduleCleanUp(RenWuLogic);--任务界面有些特殊，暂时先不清空数据
		RenWuLogic.releaseData();
	end

	RenWuLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function RenWuController:sleepModule()
	framework.releaseOnKeypadEventListener(RenWuLogic.view)
	RenWuLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function RenWuController:wakeModule()
	framework.setOnKeypadEventListener(RenWuLogic.view, RenWuLogic.onKeypad)
	RenWuLogic.view:setTouchEnabled(true)
end
