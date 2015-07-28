module(...,package.seeall);

Load.LuaRequire("script.module.userinfo.logic.tiantibangzhuLogic");

tiantibangzhuController = class("tiantibangzhuController",BaseController);
tiantibangzhuController.__index = tiantibangzhuController;

tiantibangzhuController.moduleLayer = nil;

function tiantibangzhuController:reset()
	tiantibangzhuLogic.view = nil;
end

function tiantibangzhuController:getLayer()
	return tiantibangzhuLogic.view;
end

function tiantibangzhuController:createView()
	tiantibangzhuLogic.createView();
	framework.setOnKeypadEventListener(tiantibangzhuLogic.view, tiantibangzhuLogic.onKeypad);
end

function tiantibangzhuController:requestMsg()
	tiantibangzhuLogic.requestMsg();
end

function tiantibangzhuController:addSlot()
	tiantibangzhuLogic.addSlot();
end

function tiantibangzhuController:removeSlot()
	tiantibangzhuLogic.removeSlot();
end

function tiantibangzhuController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_close"), tiantibangzhuLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_pre"), tiantibangzhuLogic.callback_btn_pre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_next"), tiantibangzhuLogic.callback_btn_next, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function tiantibangzhuController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_close"), tiantibangzhuLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_pre"), tiantibangzhuLogic.callback_btn_pre, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(tiantibangzhuLogic.view,"btn_next"), tiantibangzhuLogic.callback_btn_next, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function tiantibangzhuController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function tiantibangzhuController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function tiantibangzhuController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(tiantibangzhuLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(tiantibangzhuLogic);
		tiantibangzhuLogic.releaseData();
	end

	tiantibangzhuLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function tiantibangzhuController:sleepModule()
	framework.releaseOnKeypadEventListener(tiantibangzhuLogic.view);
	tiantibangzhuLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function tiantibangzhuController:wakeModule()
	framework.setOnKeypadEventListener(tiantibangzhuLogic.view, tiantibangzhuLogic.onKeypad);
	tiantibangzhuLogic.view:setTouchEnabled(true);
end
