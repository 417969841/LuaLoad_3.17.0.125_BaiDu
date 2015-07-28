module(...,package.seeall)

Load.LuaRequire("script.loadModule.jinhuapop.logic.JinHuaTableTextPopLogic")

JinHuaTableTextPopController = class("JinHuaTableTextPopController",BaseController)
JinHuaTableTextPopController.__index = JinHuaTableTextPopController

JinHuaTableTextPopController.moduleLayer = nil

function JinHuaTableTextPopController:reset()
	JinHuaTableTextPopLogic.view = nil
end

function JinHuaTableTextPopController:getLayer()
	return JinHuaTableTextPopLogic.view;
end

function JinHuaTableTextPopController:createView()
	JinHuaTableTextPopLogic.createView();
	framework.setOnKeypadEventListener(JinHuaTableTextPopLogic.view, JinHuaTableTextPopLogic.onKeypad);
end

function JinHuaTableTextPopController:requestMsg()
	JinHuaTableTextPopLogic.requestMsg()
end

function JinHuaTableTextPopController:addSlot()
	JinHuaTableTextPopLogic.addSlot()
end

function JinHuaTableTextPopController:removeSlot()
	JinHuaTableTextPopLogic.removeSlot()
end

function JinHuaTableTextPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaTableTextPopLogic.view,"btn_close"),JinHuaTableTextPopLogic.callback_btn_close,BUTTON_CLICK)
end

function JinHuaTableTextPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaTableTextPopLogic.view,"btn_close"),JinHuaTableTextPopLogic.callback_btn_close,BUTTON_CLICK)
end

function JinHuaTableTextPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function JinHuaTableTextPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function JinHuaTableTextPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaTableTextPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaTableTextPopLogic);
		JinHuaTableTextPopLogic.releaseData();
	end

	JinHuaTableTextPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaTableTextPopController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaTableTextPopLogic.view);
	JinHuaTableTextPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaTableTextPopController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaTableTextPopLogic.view, JinHuaTableTextPopLogic.onKeypad);
	JinHuaTableTextPopLogic.view:setTouchEnabled(true);
end

