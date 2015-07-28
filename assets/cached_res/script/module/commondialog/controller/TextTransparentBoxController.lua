module(...,package.seeall);

Load.LuaRequire("script.module.commondialog.logic.TextTransparentBoxLogic");

TextTransparentBoxController = class("TextTransparentBoxController",BaseController);
TextTransparentBoxController.__index = TextTransparentBoxController;

TextTransparentBoxController.moduleLayer = nil;

function TextTransparentBoxController:reset()
	TextTransparentBoxLogic.view = nil;
end

function TextTransparentBoxController:getLayer()
	return TextTransparentBoxLogic.view;
end

function TextTransparentBoxController:createView()
	TextTransparentBoxLogic.createView();
	framework.setOnKeypadEventListener(TextTransparentBoxLogic.view, TextTransparentBoxLogic.onKeypad);
end

function TextTransparentBoxController:requestMsg()
	TextTransparentBoxLogic.requestMsg();
end

function TextTransparentBoxController:addSlot()
	TextTransparentBoxLogic.addSlot();
end

function TextTransparentBoxController:removeSlot()
	TextTransparentBoxLogic.removeSlot();
end

function TextTransparentBoxController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Panel_Box"), TextTransparentBoxLogic.callback_Panel_Box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Button_close"), TextTransparentBoxLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Button_goto_guan_0"),TextTransparentBoxLogic.btn_goto_guan,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TextTransparentBoxController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Panel_Box"), TextTransparentBoxLogic.callback_Panel_Box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Button_close"), TextTransparentBoxLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TextTransparentBoxLogic.view,"Button_goto_guan_0"),TextTransparentBoxLogic.btn_goto_guan,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
end

function TextTransparentBoxController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TextTransparentBoxController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TextTransparentBoxController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TextTransparentBoxLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TextTransparentBoxLogic);
		TextTransparentBoxLogic.releaseData();
	end

	TextTransparentBoxLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TextTransparentBoxController:sleepModule()
	framework.releaseOnKeypadEventListener(TextTransparentBoxLogic.view);
	TextTransparentBoxLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TextTransparentBoxController:wakeModule()
	framework.setOnKeypadEventListener(TextTransparentBoxLogic.view, TextTransparentBoxLogic.onKeypad);
	TextTransparentBoxLogic.view:setTouchEnabled(true);
end
