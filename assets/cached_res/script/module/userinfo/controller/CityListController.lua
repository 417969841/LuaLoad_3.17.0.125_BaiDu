module(...,package.seeall)

Load.LuaRequire("script.module.userinfo.logic.CityListLogic")

CityListController = class("CityListController",BaseController)
CityListController.__index = CityListController

CityListController.moduleLayer = nil

function CityListController:reset()
	CityListLogic.view = nil
end

function CityListController:getLayer()
	return CityListLogic.view
end

function CityListController:createView()
	CityListLogic.createView()
	framework.setOnKeypadEventListener(CityListLogic.view, CityListLogic.onKeypad)
end

function CityListController:requestMsg()
	CityListLogic.requestMsg()
end

function CityListController:addSlot()
	CityListLogic.addSlot()
end

function CityListController:removeSlot()
	CityListLogic.removeSlot()
end

function CityListController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CityListLogic.view,"btn_save"),CityListLogic.callback_btn_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(CityListLogic.view,"lab_province"),CityListLogic.callback_lab_province,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(CityListLogic.view,"lab_city"),CityListLogic.callback_lab_city,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(CityListLogic.view,"btn_cancel"),CityListLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)

end

function CityListController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CityListLogic.view,"btn_save"),CityListLogic.callback_btn_save,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(CityListLogic.view,"lab_province"),CityListLogic.callback_lab_province,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(CityListLogic.view,"lab_city"),CityListLogic.callback_lab_city,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(CityListLogic.view,"btn_cancel"),CityListLogic.callback_btn_cancel,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function CityListController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CityListController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CityListController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CityListLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CityListLogic);
		CityListLogic.releaseData();
	end

	CityListLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CityListController:sleepModule()
	framework.releaseOnKeypadEventListener(CityListLogic.view)
	CityListLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CityListController:wakeModule()
	framework.setOnKeypadEventListener(CityListLogic.view, CityListLogic.onKeypad)
	CityListLogic.view:setTouchEnabled(true)
end
