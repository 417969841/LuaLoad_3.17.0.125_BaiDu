module(...,package.seeall);

Load.LuaRequire("script.loadModule.jinHuaHall.logic.JinHuaUserInfoLogic");

JinHuaUserInfoController = class("JinHuaUserInfoController",BaseController);
JinHuaUserInfoController.__index = JinHuaUserInfoController;

JinHuaUserInfoController.moduleLayer = nil;

function JinHuaUserInfoController:reset()
	JinHuaUserInfoLogic.view = nil;
end

function JinHuaUserInfoController:getLayer()
	return JinHuaUserInfoLogic.view;
end

function JinHuaUserInfoController:createView()
	JinHuaUserInfoLogic.createView();
	framework.setOnKeypadEventListener(JinHuaUserInfoLogic.view, JinHuaUserInfoLogic.onKeypad);
end

function JinHuaUserInfoController:requestMsg()
	JinHuaUserInfoLogic.requestMsg();
end

function JinHuaUserInfoController:addSlot()
	JinHuaUserInfoLogic.addSlot();
end

function JinHuaUserInfoController:removeSlot()
	JinHuaUserInfoLogic.removeSlot();
end

function JinHuaUserInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JinHuaUserInfoLogic.view,"Panel_Info"), JinHuaUserInfoLogic.callback_Panel_Info, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function JinHuaUserInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JinHuaUserInfoLogic.view,"Panel_Info"), JinHuaUserInfoLogic.callback_Panel_Info, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function JinHuaUserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JinHuaUserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JinHuaUserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JinHuaUserInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JinHuaUserInfoLogic);
		JinHuaUserInfoLogic.releaseData();
	end

	JinHuaUserInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JinHuaUserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(JinHuaUserInfoLogic.view);
	JinHuaUserInfoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JinHuaUserInfoController:wakeModule()
	framework.setOnKeypadEventListener(JinHuaUserInfoLogic.view, JinHuaUserInfoLogic.onKeypad);
	JinHuaUserInfoLogic.view:setTouchEnabled(true);
end
