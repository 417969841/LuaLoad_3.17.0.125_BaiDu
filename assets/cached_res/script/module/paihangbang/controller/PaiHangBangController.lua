module(...,package.seeall)

Load.LuaRequire("script.module.paihangbang.logic.PaiHangBangLogic")

PaiHangBangController = class("PaiHangBangController",BaseController)
PaiHangBangController.__index = PaiHangBangController

PaiHangBangController.moduleLayer = nil

function PaiHangBangController:reset()
	PaiHangBangLogic.view = nil
end

function PaiHangBangController:getLayer()
	return PaiHangBangLogic.view
end

function PaiHangBangController:createView()
	PaiHangBangLogic.createView()
	framework.setOnKeypadEventListener(PaiHangBangLogic.view, PaiHangBangLogic.onKeypad)
end

function PaiHangBangController:requestMsg()
	PaiHangBangLogic.requestMsg()
end

function PaiHangBangController:addSlot()
	PaiHangBangLogic.addSlot()
end

function PaiHangBangController:removeSlot()
	PaiHangBangLogic.removeSlot()
end

function PaiHangBangController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"BackButton"),PaiHangBangLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_addCoin"), PaiHangBangLogic.callback_Button_addCoin, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_addYuanbao"), PaiHangBangLogic.callback_Button_addYuanbao, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirizhuanjinbang"),PaiHangBangLogic.callback_meirizhuanjinbang,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirichongzhibang"),PaiHangBangLogic.callback_meirichongzhibang,BUTTON_CLICK)
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"tuhaobang"),PaiHangBangLogic.callback_tuhaobang,BUTTON_CLICK)
--	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_chongzhibang"), PaiHangBangLogic.callback_Panel_chongzhibang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_chongzhongmianban"), PaiHangBangLogic.callback_Panel_chongzhongmianban, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_jinri"), PaiHangBangLogic.callback_Button_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_zuori"), PaiHangBangLogic.callback_Button_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirichongzhibang"), PaiHangBangLogic.callback_meirichongzhibang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_Help"), PaiHangBangLogic.callback_Button_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
--	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_tuhaobang"), PaiHangBangLogic.callback_Panel_tuhaobang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.bindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_geren"), PaiHangBangLogic.callback_Panel_geren, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end
function PaiHangBangController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"BackButton"),PaiHangBangLogic.callback_BackButton,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_addCoin"), PaiHangBangLogic.callback_Button_addCoin, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_addYuanbao"), PaiHangBangLogic.callback_Button_addYuanbao, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirizhuanjinbang"),PaiHangBangLogic.callback_meirizhuanjinbang,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirichongzhibang"),PaiHangBangLogic.callback_meirichongzhibang,BUTTON_CLICK)
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"tuhaobang"),PaiHangBangLogic.callback_tuhaobang,BUTTON_CLICK)
--	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_chongzhibang"), PaiHangBangLogic.callback_Panel_chongzhibang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_chongzhongmianban"), PaiHangBangLogic.callback_Panel_chongzhongmianban, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_jinri"), PaiHangBangLogic.callback_Button_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_zuori"), PaiHangBangLogic.callback_Button_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"meirichongzhibang"), PaiHangBangLogic.callback_meirichongzhibang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Button_Help"), PaiHangBangLogic.callback_Button_Help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
--	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_tuhaobang"), PaiHangBangLogic.callback_Panel_tuhaobang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
--	framework.unbindEventCallback(cocostudio.getComponent(PaiHangBangLogic.view,"Panel_geren"), PaiHangBangLogic.callback_Panel_geren, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function PaiHangBangController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function PaiHangBangController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function PaiHangBangController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(PaiHangBangLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(PaiHangBangLogic);
		PaiHangBangLogic.releaseData();
	end

	PaiHangBangLogic.view:removeFromParentAndCleanup(true)
	self:reset()

	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function PaiHangBangController:sleepModule()
	framework.releaseOnKeypadEventListener(PaiHangBangLogic.view)
	PaiHangBangLogic.view:setTouchEnabled(false)
--	if zhuanjinLayer.tableView ~= nil then
--		zhuanjinLayer.tableView:setTouchEnabled(false)
--	elseif tuhaoLayer.tableView ~= nil then
--		tuhaoLayer.tableView:setTouchEnabled(false)
--	elseif chongzhiLayer.tableView ~= nil then
--		chongzhiLayer.tableView:setTouchEnabled(false)
--	end
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function PaiHangBangController:wakeModule()
	framework.setOnKeypadEventListener(PaiHangBangLogic.view, PaiHangBangLogic.onKeypad)
	PaiHangBangLogic.view:setTouchEnabled(true)
--	if zhuanjinLayer.tableView ~= nil then
--		zhuanjinLayer.tableView:setTouchEnabled(true)
--	elseif tuhaoLayer.tableView ~= nil then
--		tuhaoLayer.tableView:setTouchEnabled(true)
--	elseif chongzhiLayer.tableView ~= nil then
--		chongzhiLayer.tableView:setTouchEnabled(true)
--	end
end
