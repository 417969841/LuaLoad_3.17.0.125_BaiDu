module("JinHuaTableSetPopLogic",package.seeall)

view = nil
--复选框：背景音乐，音效，震动
cb_bgmusic = nil;
cb_effect = nil;
cb_shake = nil;
img_bgmusic = nil;
img_effect = nil;
img_shake = nil;

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableSetPop.json")
	view:setTag(getDiffTag())
	CCDirector:sharedDirector():getRunningScene():addChild(view)
	cb_bgmusic = cocostudio.getUICheckBox(view,"cb_bgmusic")
	cb_effect = cocostudio.getUICheckBox(view,"cb_effect")
	cb_shake = cocostudio.getUICheckBox(view,"cb_shake")
	img_bgmusic = cocostudio.getUIImageView(view,"img_bgmusic")
	img_effect = cocostudio.getUIImageView(view,"img_effect")
	img_shake = cocostudio.getUIImageView(view,"img_shake")

	--IOS 去掉震动选项
	if Common.platform == Common.TargetIos then
		cb_shake:setVisible(false)
		cb_shake:setTouchEnabled(false)
		img_shake:setVisible(false)

		cb_bgmusic:setAnchorPoint(ccp(0.5, 0.5))
		cb_bgmusic:setPosition(ccp(69,0))

		img_bgmusic:setAnchorPoint(ccp(0.5, 0.5))
		img_bgmusic:setPosition(ccp(127,48))

		cb_effect:setAnchorPoint(ccp(0.5, 0.5))
		cb_effect:setPosition(ccp(68,0))

		img_effect:setAnchorPoint(ccp(0.5, 0.5))
		img_effect:setPosition(ccp(310,48))
	end

	if JinHuaTableSound.isBackgroundMusicOn then
		cb_bgmusic:setSelectedState(true)
	else
		cb_bgmusic:setSelectedState(false)
	end

	if JinHuaTableSound.isEffectMusicOn then
		cb_effect:setSelectedState(true)
	else
		cb_effect:setSelectedState(false)
	end

	if JinHuaTableSound.isVibrateOn then
		cb_shake:setSelectedState(true)
	else
		cb_shake:setSelectedState(false)
	end
end

function requestMsg()
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_JINHUA_TABLESETPOP)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮cb_shake,手指抬起后做的事
--]]
local function releaseUpForBtnCbShake()
	local selected = cb_shake:getSelectedState()
	Common.log("cb_shake")
	Common.log(selected)
	if selected then
		JinHuaTableSound.isVibrateOn = false
		Common.setDataForSqlite(KEY_SET_VIBRATE,false)
	else
		JinHuaTableSound.isVibrateOn = true
		Common.setDataForSqlite(KEY_SET_VIBRATE,true)
	end
end

function callback_cb_shake(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnCbShake();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮cb_effect,手指抬起后做的事
--]]
local function releaseUpForBtnCbEffect()
	local selected = cb_effect:getSelectedState()
	Common.log("cb_effect")
	Common.log(selected)
	if selected then
		JinHuaTableSound.isEffectMusicOn = false
		Common.setDataForSqlite(KEY_SET_EFFECT,false)
	else
		JinHuaTableSound.isEffectMusicOn = true
		Common.setDataForSqlite(KEY_SET_EFFECT,true)
	end
end

function callback_cb_effect(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnCbEffect();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--  点击按钮cb_bgmusic,手指抬起后做的事
--]]
local function releaseUpForBtnCbBgmusic()
	local selected = cb_bgmusic:getSelectedState()
	Common.log("cb_bgmusic")
	Common.log(selected)
	if selected then
		JinHuaTableSound.isBackgroundMusicOn = false
		Common.setDataForSqlite(KEY_SET_BGMUSIC,false)
	else
		JinHuaTableSound.isBackgroundMusicOn = true
		Common.setDataForSqlite(KEY_SET_BGMUSIC,true)
	end
	if JinHuaTableSound.isBackgroundMusicOn then
		JinHuaTableSound.playBackgroundMusic()
	else
		JinHuaTableSound.stopPlayBackgroundMusic()
	end
end

function callback_cb_bgmusic(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		releaseUpForBtnCbBgmusic();
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
