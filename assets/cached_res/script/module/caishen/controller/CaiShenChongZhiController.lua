module(...,package.seeall)

Load.LuaRequire("script.module.caishen.logic.CaiShenChongZhiLogic")

CaiShenChongZhiController = class("CaiShenChongZhiController",BaseController)
CaiShenChongZhiController.__index = CaiShenChongZhiController

CaiShenChongZhiController.moduleLayer = nil

function CaiShenChongZhiController:reset()
	CaiShenChongZhiLogic.view = nil
end

function CaiShenChongZhiController:getLayer()
	return CaiShenChongZhiLogic.view
end

function CaiShenChongZhiController:createView()
	CaiShenChongZhiLogic.createView()
	framework.setOnKeypadEventListener(CaiShenChongZhiLogic.view, CaiShenChongZhiLogic.onKeypad)
end

function CaiShenChongZhiController:requestMsg()
	CaiShenChongZhiLogic.requestMsg()
end

function CaiShenChongZhiController:addSlot()
	CaiShenChongZhiLogic.addSlot()
end

function CaiShenChongZhiController:removeSlot()
	CaiShenChongZhiLogic.removeSlot()
end

function CaiShenChongZhiController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CaiShenChongZhiLogic.view,"BackButton"),CaiShenChongZhiLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(CaiShenChongZhiLogic.view,"Button_ChongZhi"),CaiShenChongZhiLogic.callback_Button_ChongZhi,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenChongZhiController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenChongZhiLogic.view,"BackButton"),CaiShenChongZhiLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(CaiShenChongZhiLogic.view,"Button_ChongZhi"),CaiShenChongZhiLogic.callback_Button_ChongZhi,BUTTON_CLICK,BUTTON_SOUND_CLICK+BUTTON_ANIMATION_ZOOM_OUT)
end

function CaiShenChongZhiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function CaiShenChongZhiController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function CaiShenChongZhiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CaiShenChongZhiLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
	--销毁数据
		framework.moduleCleanUp(CaiShenChongZhiLogic);
		CaiShenChongZhiLogic.releaseData();
	end

	CaiShenChongZhiLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function CaiShenChongZhiController:sleepModule()
	framework.releaseOnKeypadEventListener(CaiShenChongZhiLogic.view)
	CaiShenChongZhiLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function CaiShenChongZhiController:wakeModule()
	framework.setOnKeypadEventListener(CaiShenChongZhiLogic.view, CaiShenChongZhiLogic.onKeypad)
	CaiShenChongZhiLogic.view:setTouchEnabled(true)
end
