module("JinHuaTableConfirmPopLogic",package.seeall)

view = nil
--标志 1退出牌桌 2站起提示3禁比确认4万人金花退出5弃牌提示6换桌提示
local tag = 1
local TableConfirmPopTag = {};
TableConfirmPopTag.TAG_QUIT = 1
TableConfirmPopTag.TAG_STANDUP = 2
TableConfirmPopTag.TAG_NOPK = 3
TableConfirmPopTag.TAG_WANREN_QUIT = 4
TableConfirmPopTag.TAG_FOLD_TIPS = 5 --第6轮点击"放弃"会提示
TableConfirmPopTag.TAG_CHANGE_TABLE_TIPS = 6--第6轮点击"换桌"会提示

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function getTag()
	return TableConfirmPopTag;
end
--提示内容
local tv_content

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableConfirmPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	GameConfig.setHallShowMode(0)--大厅模式
end

--[[--
--获取JinHuaTableConfirmPopLogic的Layer
--@return #CCLayer 返回JinHuaTableConfirmPopLogic的Layer
--]]
function getTableConfirmPopView()
	return view;
end

function requestMsg()

end

function setTag(tagP)
	tv_content = cocostudio.getUILabel(view,"tv_content")
	tag = tagP
	if tag == TableConfirmPopTag.TAG_QUIT then
		tv_content:setText("退出后，您将离开房间，且已下注金币无法收回，确定吗？")
	elseif tag == TableConfirmPopTag.TAG_STANDUP then
		tv_content:setText("站起后，您将进入旁观状态，且已下注金币无法收回，确定吗？")
	elseif tag == TableConfirmPopTag.TAG_NOPK then
		tv_content:setText("使用【禁比】后，本局其它人不能和你比牌，确定使用吗？")
	elseif tag == TableConfirmPopTag.TAG_WANREN_QUIT then
		tv_content:setText("退出后，暂时扣除您下注金币的10倍，本局结束后按结果输赢返还，确定退出吗？")
	elseif tag == TableConfirmPopTag.TAG_FOLD_TIPS then
		tv_content:setText("您确定要弃牌吗？")
	elseif tag == TableConfirmPopTag.TAG_CHANGE_TABLE_TIPS then
		tv_content:setText("您确定换桌吗？")
	end
end

--function callback_btn_close(component)
--	if component == PUSH_DOWN then
--	--按下
--	elseif component == RELEASE_UP then
--	--抬起
----		Common.ViewSacleSmall(view,1,0.3,0.5,0.5,close)
--	close()
--	elseif component == CANCEL_UP then
--	--取消
--	end
--end

--[[--
--关闭界面
--]]
function close()
	mvcEngine.destroyModule(GUI_JINHUA_TABLECONFIRMPOP)
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
--		Common.ViewSacleSmall(view,1,0.3,0.5,0.5,close)
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮btn_confirm,手指抬起后做的事
--]]
local function releaseUpForBtnConfirm()
	mvcEngine.destroyModule(GUI_JINHUA_TABLECONFIRMPOP)
	if tag == TableConfirmPopTag.TAG_QUIT then --确定退出牌桌
		JinHuaTableMyOperation.quitGameRoom()
	elseif tag == TableConfirmPopTag.TAG_STANDUP then --确定站起
		JinHuaTablePlayer.selfStandUp()
	elseif tag == TableConfirmPopTag.TAG_NOPK then  --确定禁比确认
		sendJHID_NO_COMPARE_REQ()
	elseif tag == TableConfirmPopTag.TAG_WANREN_QUIT then --确定万人金花退出
		WanRenJinHuaLogic.quitTable()
	elseif tag == TableConfirmPopTag.TAG_FOLD_TIPS then --确定弃牌
		JinHuaTableMyOperation.afterOnClickBtnFold();
	elseif tag == TableConfirmPopTag.TAG_CHANGE_TABLE_TIPS  then --确定换桌
		JinHuaTableMyOperation.afterOnClickBtnChangeTable();
	end
end

function callback_btn_confirm(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
	--抬起
		releaseUpForBtnConfirm();
	elseif component == CANCEL_UP then
	--取消
	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()

end



function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
