module(...,package.seeall)

Load.LuaRequire("script.module.hall.logic.SettingLogic")

SettingController = class("SettingController",BaseController)
SettingController.__index = SettingController

SettingController.moduleLayer = nil

function SettingController:reset()
	SettingLogic.view = nil
end

function SettingController:getLayer()
	return SettingLogic.view
end

function SettingController:createView()
	SettingLogic.createView()
	framework.setOnKeypadEventListener(SettingLogic.view, SettingLogic.onKeypad)
end

function SettingController:requestMsg()
	SettingLogic.requestMsg()
end

function SettingController:addSlot()
	SettingLogic.addSlot()
end

function SettingController:removeSlot()
	SettingLogic.removeSlot()
end

function SettingController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_close"),SettingLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_music"),SettingLogic.callback_btn_music,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_yinxiao"),SettingLogic.callback_btn_yinxiao,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_help"),SettingLogic.callback_btn_help,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_kefu"),SettingLogic.callback_btn_kefu,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_version"),SettingLogic.callback_btn_version,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_logout"),SettingLogic.callback_btn_logout,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_tishi"),SettingLogic.callback_btn_tishi,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_table_music"),SettingLogic.callback_btn_table_music,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_table_yinxiao"),SettingLogic.callback_btn_table_yinxiao,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_zhendong"), SettingLogic.callback_btn_zhendong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SettingController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_close"),SettingLogic.callback_btn_close,BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_music"),SettingLogic.callback_btn_music,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_yinxiao"),SettingLogic.callback_btn_yinxiao,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_help"),SettingLogic.callback_btn_help,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_kefu"),SettingLogic.callback_btn_kefu,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_version"),SettingLogic.callback_btn_version,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_logout"),SettingLogic.callback_btn_logout,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_tishi"),SettingLogic.callback_btn_tishi,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_table_music"),SettingLogic.callback_btn_table_music,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_table_yinxiao"),SettingLogic.callback_btn_table_yinxiao,BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(SettingLogic.view,"btn_zhendong"), SettingLogic.callback_btn_zhendong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SettingController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function SettingController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function SettingController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SettingLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(SettingLogic);
		SettingLogic.releaseData();
	end

	SettingLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function SettingController:sleepModule()
	framework.releaseOnKeypadEventListener(SettingLogic.view)
	SettingLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function SettingController:wakeModule()
	framework.setOnKeypadEventListener(SettingLogic.view, SettingLogic.onKeypad)
	SettingLogic.view:setTouchEnabled(true)
end
