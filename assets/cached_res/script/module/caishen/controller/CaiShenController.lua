module(...,package.seeall)

Load.LuaRequire("script.module.caishen.logic.CaiShenLogic")

CaiShenController = class("CaiShenController",BaseController)
CaiShenController.__index = CaiShenController

CaiShenController.moduleLayer = nil

function CaiShenController:reset()
	CaiShenLogic.view = nil
end

function CaiShenController:getLayer()
	return CaiShenLogic.view
end

function CaiShenController:createView()
	CaiShenLogic.createView()
	framework.setOnKeypadEventListener(CaiShenLogic.view, CaiShenLogic.onKeypad)
end

function CaiShenController:requestMsg()
	CaiShenLogic.requestMsg()
end

function CaiShenController:addSlot()
	CaiShenLogic.addSlot()
end

function CaiShenController:removeSlot()
	CaiShenLogic.removeSlot()
end

function CaiShenController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"BackButton"), CaiShenLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_ShangXiang"), CaiShenLogic.callback_Button_ShangXiang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_GuiZe"), CaiShenLogic.callback_Button_GuiZe, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_lingqu"), CaiShenLogic.callback_Button_lingqu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CaiShenController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"BackButton"), CaiShenLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_ShangXiang"), CaiShenLogic.callback_Button_ShangXiang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_GuiZe"), CaiShenLogic.callback_Button_GuiZe, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenLogic.view,"Button_lingqu"), CaiShenLogic.callback_Button_lingqu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CaiShenController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CaiShenController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CaiShenController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CaiShenLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CaiShenLogic);
		CaiShenLogic.releaseData();
	end

	CaiShenLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CaiShenController:sleepModule()
	framework.releaseOnKeypadEventListener(CaiShenLogic.view)
	CaiShenLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CaiShenController:wakeModule()
	framework.setOnKeypadEventListener(CaiShenLogic.view, CaiShenLogic.onKeypad)
	CaiShenLogic.view:setTouchEnabled(true)
end
