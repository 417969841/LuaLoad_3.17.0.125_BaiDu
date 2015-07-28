module(...,package.seeall);

Load.LuaRequire("script.module.match.logic.matchjijiangkaisaiLogic");

matchjijiangkaisaiController = class("matchjijiangkaisaiController",BaseController);
matchjijiangkaisaiController.__index = matchjijiangkaisaiController;

matchjijiangkaisaiController.moduleLayer = nil;

function matchjijiangkaisaiController:reset()
	matchjijiangkaisaiLogic.view = nil;
end

function matchjijiangkaisaiController:getLayer()
	return matchjijiangkaisaiLogic.view;
end

function matchjijiangkaisaiController:createView()
	matchjijiangkaisaiLogic.createView();
	framework.setOnKeypadEventListener(matchjijiangkaisaiLogic.view, matchjijiangkaisaiLogic.onKeypad);
end

function matchjijiangkaisaiController:requestMsg()
	matchjijiangkaisaiLogic.requestMsg();
end

function matchjijiangkaisaiController:addSlot()
	matchjijiangkaisaiLogic.addSlot();
end

function matchjijiangkaisaiController:removeSlot()
	matchjijiangkaisaiLogic.removeSlot();
end

function matchjijiangkaisaiController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"btn_xiaoyouxi"), matchjijiangkaisaiLogic.callback_btn_xiaoyouxi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"btn_tuisai"), matchjijiangkaisaiLogic.callback_btn_tuisai, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"BackButton"), matchjijiangkaisaiLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function matchjijiangkaisaiController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"btn_xiaoyouxi"), matchjijiangkaisaiLogic.callback_btn_xiaoyouxi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"btn_tuisai"), matchjijiangkaisaiLogic.callback_btn_tuisai, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(matchjijiangkaisaiLogic.view,"BackButton"), matchjijiangkaisaiLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function matchjijiangkaisaiController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function matchjijiangkaisaiController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function matchjijiangkaisaiController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(matchjijiangkaisaiLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(matchjijiangkaisaiLogic);
		matchjijiangkaisaiLogic.releaseData();
	end

	matchjijiangkaisaiLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function matchjijiangkaisaiController:sleepModule()
	framework.releaseOnKeypadEventListener(matchjijiangkaisaiLogic.view);
	matchjijiangkaisaiLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function matchjijiangkaisaiController:wakeModule()
	framework.setOnKeypadEventListener(matchjijiangkaisaiLogic.view, matchjijiangkaisaiLogic.onKeypad);
	matchjijiangkaisaiLogic.view:setTouchEnabled(true);
end
