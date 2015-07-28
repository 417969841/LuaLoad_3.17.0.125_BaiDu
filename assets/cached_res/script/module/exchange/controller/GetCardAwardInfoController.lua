module(...,package.seeall);

Load.LuaRequire("script.module.exchange.logic.GetCardAwardInfoLogic");

GetCardAwardInfoController = class("GetCardAwardInfoController",BaseController);
GetCardAwardInfoController.__index = GetCardAwardInfoController;

GetCardAwardInfoController.moduleLayer = nil;

function GetCardAwardInfoController:reset()
	GetCardAwardInfoLogic.view = nil;
end

function GetCardAwardInfoController:getLayer()
	return GetCardAwardInfoLogic.view;
end

function GetCardAwardInfoController:createView()
	GetCardAwardInfoLogic.createView();
	framework.setOnKeypadEventListener(GetCardAwardInfoLogic.view, GetCardAwardInfoLogic.onKeypad);
end

function GetCardAwardInfoController:requestMsg()
	GetCardAwardInfoLogic.requestMsg();
end

function GetCardAwardInfoController:addSlot()
	GetCardAwardInfoLogic.addSlot();
end

function GetCardAwardInfoController:removeSlot()
	GetCardAwardInfoLogic.removeSlot();
end

function GetCardAwardInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"btn_close"), GetCardAwardInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"btn_save"), GetCardAwardInfoLogic.callback_btn_save, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phone"),GetCardAwardInfoLogic.callback_txt_phone_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phonecheck"),GetCardAwardInfoLogic.callback_txt_phonecheck_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_username"),GetCardAwardInfoLogic.callback_txt_username_ios,BUTTON_CLICK)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_id"),GetCardAwardInfoLogic.callback_txt_id_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phone"),GetCardAwardInfoLogic.callback_txt_phone,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phonecheck"),GetCardAwardInfoLogic.callback_txt_phonecheck,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_username"),GetCardAwardInfoLogic.callback_txt_username,DETACH_WITH_IME)
		framework.bindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_id"),GetCardAwardInfoLogic.callback_txt_id,DETACH_WITH_IME)
	end
end

function GetCardAwardInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"btn_close"), GetCardAwardInfoLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"btn_save"), GetCardAwardInfoLogic.callback_btn_save, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

	if Common.platform == Common.TargetWindows then
	elseif Common.platform == Common.TargetIos then
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phone"),GetCardAwardInfoLogic.callback_txt_phone_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phonecheck"),GetCardAwardInfoLogic.callback_txt_phonecheck_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_username"),GetCardAwardInfoLogic.callback_txt_username_ios,BUTTON_CLICK)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_id"),GetCardAwardInfoLogic.callback_txt_id_ios,BUTTON_CLICK)
	elseif Common.platform == Common.TargetAndroid then
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phone"),GetCardAwardInfoLogic.callback_txt_phone,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_phonecheck"),GetCardAwardInfoLogic.callback_txt_phonecheck,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_username"),GetCardAwardInfoLogic.callback_txt_username,DETACH_WITH_IME)
		framework.unbindEventCallback(cocostudio.getComponent(GetCardAwardInfoLogic.view,"txt_id"),GetCardAwardInfoLogic.callback_txt_id,DETACH_WITH_IME)
	end
end

function GetCardAwardInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function GetCardAwardInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function GetCardAwardInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GetCardAwardInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(GetCardAwardInfoLogic);
		GetCardAwardInfoLogic.releaseData();
	end

	GetCardAwardInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function GetCardAwardInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(GetCardAwardInfoLogic.view);
	GetCardAwardInfoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function GetCardAwardInfoController:wakeModule()
	framework.setOnKeypadEventListener(GetCardAwardInfoLogic.view, GetCardAwardInfoLogic.onKeypad);
	GetCardAwardInfoLogic.view:setTouchEnabled(true);
end
