module(...,package.seeall)

Load.LuaRequire("script.module.match.logic.MatchDetailLogic")

MatchDetailController = class("MatchDetailController",BaseController)
MatchDetailController.__index = MatchDetailController

MatchDetailController.moduleLayer = nil

function MatchDetailController:reset()
	MatchDetailLogic.view = nil
end

function MatchDetailController:getLayer()
	return MatchDetailLogic.view
end

function MatchDetailController:createView()
	MatchDetailLogic.createView()
	framework.setOnKeypadEventListener(MatchDetailLogic.view, MatchDetailLogic.onKeypad)
end

function MatchDetailController:requestMsg()
	MatchDetailLogic.requestMsg()
end

function MatchDetailController:addSlot()
	MatchDetailLogic.addSlot()
end

function MatchDetailController:removeSlot()
	MatchDetailLogic.removeSlot()
end

function MatchDetailController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_bm"),MatchDetailLogic.callback_btn_bm,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_close"),MatchDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_detail_bm"), MatchDetailLogic.callback_btn_detail_bm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_jiangli_bm"), MatchDetailLogic.callback_btn_jiangli_bm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_detail"), MatchDetailLogic.callback_btn_detail, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_paiming"), MatchDetailLogic.callback_btn_paiming, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_jiangli"), MatchDetailLogic.callback_btn_jiangli, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);

end

function MatchDetailController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_bm"),MatchDetailLogic.callback_btn_bm,BUTTON_CLICK,BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_close"),MatchDetailLogic.callback_btn_close,BUTTON_CLICK,BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT)
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_detail_bm"), MatchDetailLogic.callback_btn_detail_bm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_jiangli_bm"), MatchDetailLogic.callback_btn_jiangli_bm, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_detail"), MatchDetailLogic.callback_btn_detail, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_paiming"), MatchDetailLogic.callback_btn_paiming, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MatchDetailLogic.view,"btn_jiangli"), MatchDetailLogic.callback_btn_jiangli, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);

end

function MatchDetailController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer
end

function MatchDetailController:getModuleLayer(moduleLayer)
	return self.moduleLayer
end

function MatchDetailController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MatchDetailLogic.view)
	self:destroy()

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MatchDetailLogic);
		MatchDetailLogic.releaseData();
	end

	MatchDetailLogic.view:removeFromParentAndCleanup(true)
	self:reset()
	framework.emit(signal.common.Signal_DestroyModule_Done)
end

function MatchDetailController:sleepModule()
	framework.releaseOnKeypadEventListener(MatchDetailLogic.view)
	MatchDetailLogic.view:setTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done)
end

function MatchDetailController:wakeModule()
	framework.setOnKeypadEventListener(MatchDetailLogic.view, MatchDetailLogic.onKeypad)
	MatchDetailLogic.view:setTouchEnabled(true)
end
