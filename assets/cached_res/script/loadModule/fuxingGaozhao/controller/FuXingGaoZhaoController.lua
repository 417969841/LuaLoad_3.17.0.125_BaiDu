module(...,package.seeall);

Load.LuaRequire("script.loadModule.fuxingGaozhao.logic.FuXingGaoZhaoLogic");

FuXingGaoZhaoController = class("FuXingGaoZhaoController",BaseController);
FuXingGaoZhaoController.__index = FuXingGaoZhaoController;

FuXingGaoZhaoController.moduleLayer = nil;

function FuXingGaoZhaoController:reset()
	FuXingGaoZhaoLogic.view = nil;
end

function FuXingGaoZhaoController:getLayer()
	return FuXingGaoZhaoLogic.view;
end

function FuXingGaoZhaoController:createView()
	FuXingGaoZhaoLogic.createView();
	framework.setOnKeypadEventListener(FuXingGaoZhaoLogic.view, FuXingGaoZhaoLogic.onKeypad);
end

function FuXingGaoZhaoController:requestMsg()
	FuXingGaoZhaoLogic.requestMsg();
end

function FuXingGaoZhaoController:addSlot()
	FuXingGaoZhaoLogic.addSlot();
end

function FuXingGaoZhaoController:removeSlot()
	FuXingGaoZhaoLogic.removeSlot();
end

function FuXingGaoZhaoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"BackButton"), FuXingGaoZhaoLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"Button_startGame"), FuXingGaoZhaoLogic.callback_Button_startGame, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"Button_AddYuanBao"), FuXingGaoZhaoLogic.callback_Button_AddYuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function FuXingGaoZhaoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"BackButton"), FuXingGaoZhaoLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"Button_startGame"), FuXingGaoZhaoLogic.callback_Button_startGame, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(FuXingGaoZhaoLogic.view,"Button_AddYuanBao"), FuXingGaoZhaoLogic.callback_Button_AddYuanBao, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function FuXingGaoZhaoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function FuXingGaoZhaoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function FuXingGaoZhaoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(FuXingGaoZhaoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(FuXingGaoZhaoLogic);
		FuXingGaoZhaoLogic.releaseData();
	end

	FuXingGaoZhaoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function FuXingGaoZhaoController:sleepModule()
	framework.releaseOnKeypadEventListener(FuXingGaoZhaoLogic.view);
	FuXingGaoZhaoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function FuXingGaoZhaoController:wakeModule()
	framework.setOnKeypadEventListener(FuXingGaoZhaoLogic.view, FuXingGaoZhaoLogic.onKeypad);
	FuXingGaoZhaoLogic.view:setTouchEnabled(true);
end
