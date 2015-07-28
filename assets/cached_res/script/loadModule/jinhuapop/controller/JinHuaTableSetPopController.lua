module(...,package.seeall)

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableSetPopLogic")

JinHuaTableSetPopController = class("JinHuaTableSetPopController",BaseController)
JinHuaTableSetPopController.__index = JinHuaTableSetPopController

JinHuaTableSetPopController.moduleLayer = nil

function JinHuaTableSetPopController:reset()
	JinHuaTableSetPopLogic.view = nil
end

function JinHuaTableSetPopController:getLayer()
	return JinHuaTableSetPopLogic.view;
end

function JinHuaTableSetPopController:createView()
	JinHuaTableSetPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableSetPopLogic.view, JinHuaTableSetPopLogic.onKeypad);
end

function JinHuaTableSetPopController:requestMsg()
	JinHuaTableSetPopLogic.requestMsg()
end

function JinHuaTableSetPopController:addSlot()
	JinHuaTableSetPopLogic.addSlot()
end

function JinHuaTableSetPopController:removeSlot()
	JinHuaTableSetPopLogic.removeSlot()
end

function JinHuaTableSetPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"btn_close"),JinHuaTableSetPopLogic.callback_btn_close,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_shake"),JinHuaTableSetPopLogic.callback_cb_shake,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_effect"),JinHuaTableSetPopLogic.callback_cb_effect,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_bgmusic"),JinHuaTableSetPopLogic.callback_cb_bgmusic,BUTTON_CLICK)
end

function JinHuaTableSetPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"btn_close"),JinHuaTableSetPopLogic.callback_btn_close,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_shake"),JinHuaTableSetPopLogic.callback_cb_shake,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_effect"),JinHuaTableSetPopLogic.callback_cb_effect,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableSetPopLogic.view,"cb_bgmusic"),JinHuaTableSetPopLogic.callback_cb_bgmusic,BUTTON_CLICK)
end

function JinHuaTableSetPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function JinHuaTableSetPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function JinHuaTableSetPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableSetPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableSetPopLogic);
		JinHuaTableSetPopLogic.releaseData();
	end

	JinHuaTableSetPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableSetPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableSetPopLogic.view);
	JinHuaTableSetPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableSetPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableSetPopLogic.view, JinHuaTableSetPopLogic.onKeypad);
	JinHuaTableSetPopLogic.view:setTouchEnabled(true);
end
