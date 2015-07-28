--AABBCCDD 一共8位，每两位数字表示一个动作类型集合.
--DD：代表按钮音效编号
--CC：代表按钮动画编号
--BB：预留
--AA：预留

--文档配置实例：
--(BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN)-- 202 --点击按钮：普通点击音效和放大动画

SOUND_PREFIX = 1--按钮前缀
ANIMATION_PREFIX = 100--按钮前缀
PREFIX56 = 10000--56前缀
PREFIX78 = 1000000--78前缀

-------------------------音效-------------------------
BUTTON_SOUND_NONE = SOUND_PREFIX * 1;--无点击音效
BUTTON_SOUND_CLICK = SOUND_PREFIX * 2;--普通点击音效
BUTTON_SOUND_BACK = SOUND_PREFIX * 3;--返回点击音效

-------------------------动画-------------------------
BUTTON_ANIMATION_NONE = ANIMATION_PREFIX * 1;--无动画
BUTTON_ANIMATION_ZOOM_IN = ANIMATION_PREFIX * 2;--放大动画(抬起后动画播完执行回调)
BUTTON_ANIMATION_ZOOM_OUT = ANIMATION_PREFIX * 3;--缩小动画(抬起后动画播完执行回调)
BUTTON_ANIMATION_ZOOM_IN_UP_EXECUTE = ANIMATION_PREFIX * 4;--放大动画(抬起后立即执行回调)
BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE = ANIMATION_PREFIX * 5;--缩小动画(抬起后立即执行回调)

--[[--
--获取按钮效果类型
--@param #number btnEffectEvent 按钮效果编号
--]]
function getButtonEffectType(btnEffectEvent)
	local tableData = {}
	tableData.soundType = btnEffectEvent % 100
	tableData.animationType = math.floor(btnEffectEvent / ANIMATION_PREFIX) % 100 * ANIMATION_PREFIX
	tableData.Type56 = math.floor(btnEffectEvent / PREFIX56) % 100 * PREFIX56
	tableData.Type78 = math.floor(btnEffectEvent / PREFIX78) % 100 * PREFIX78
	return tableData;
end

--[[--
--播放按下音效
--]]
local function ButtonDownSound(effectType)
	if effectType == BUTTON_SOUND_NONE then
	--无点击音效
	elseif effectType == BUTTON_SOUND_CLICK then
		--普通点击音效
		AudioManager.playLordSound(AudioManager.TableSound.CLICK, false, AudioManager.SOUND);
	elseif effectType == BUTTON_SOUND_BACK then
		--返回点击音效
		AudioManager.playLordSound(AudioManager.TableSound.BACK, false, AudioManager.SOUND);
	else
		AudioManager.playLordSound(AudioManager.TableSound.CLICK, false, AudioManager.SOUND);
	end
end

--[[--
--播放按钮音效
--@param #number effectType 音效类型
--@param #string event 点击事件
--]]
function playButtonSound(effectType, event)
	if event == PUSH_DOWN  then
	--按下
	elseif event == RELEASE_UP then
		--抬起
		ButtonDownSound(effectType);
	elseif event == CANCEL_UP then
	--取消
	end
end

--[[--
--放大动画(抬起后动画播完执行回调)
--]]
local function zoomInAnimation(component, event, callbackFunction)
	if event == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(component, 1.05, true, callbackFunction, event)
	elseif event == RELEASE_UP then
		--抬起
		LordGamePub.buttonActionUp(component, 0.95, callbackFunction, event)
	elseif event == CANCEL_UP then
		--取消
		LordGamePub.buttonActionUp(component, 0.95, nil)
	end
end

--[[--
--缩小动画(抬起后动画播完执行回调)
--]]
local function zoomOutAnimation(component, event, callbackFunction)
	if event == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(component, 0.95, true, callbackFunction, event)
	elseif event == RELEASE_UP then
		--抬起
		LordGamePub.buttonActionUp(component, 1.2, callbackFunction, event)
	elseif event == CANCEL_UP then
		--取消
		LordGamePub.buttonActionUp(component, 1.2, nil, nil)
	end
end

--[[--
--放大动画(抬起后立即执行回调)
--]]
local function zoomInAnimationUpExecute(component, event, callbackFunction)
	if event == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(component, 1.05, true, callbackFunction, event)
	elseif event == RELEASE_UP then
		--抬起
		LordGamePub.buttonActionUp(component, 0.95, nil, nil)
		callbackFunction(event);
	elseif event == CANCEL_UP then
		--取消
		LordGamePub.buttonActionUp(component, 0.95, nil, nil)
	end
end

--[[--
--缩小动画(抬起后立即执行回调)
--]]
local function zoomOutAnimationUpExecute(component, event, callbackFunction)
	if event == PUSH_DOWN then
		--按下
		LordGamePub.buttonActionPress(component, 0.95, true, callbackFunction, event);
	elseif event == RELEASE_UP then
		--抬起
		LordGamePub.buttonActionUp(component, 1.2, nil, nil);
		callbackFunction(event);
	elseif event == CANCEL_UP then
		--取消
		LordGamePub.buttonActionUp(component, 1.2, nil, nil);
	end
end

--[[--
--播放按钮音效
--@param #uiWidget component 控件
--@param #number effectType 音效类型
--@param #string event 点击事件
--@param #func callbackFunction 回调函数
--]]
function playButtonAnimation(component, effectType, event, callbackFunction)
	if effectType == BUTTON_ANIMATION_NONE then
	--无动画
	callbackFunction(event);
	elseif effectType == BUTTON_ANIMATION_ZOOM_IN then
		--放大动画(抬起后动画播完执行回调)
		zoomInAnimation(component, event, callbackFunction);
	elseif effectType == BUTTON_ANIMATION_ZOOM_OUT then
		--缩小动画(抬起后动画播完执行回调)
		zoomOutAnimation(component, event, callbackFunction);
	elseif effectType == BUTTON_ANIMATION_ZOOM_IN_UP_EXECUTE then
		--放大动画(抬起后立即执行回调)
		zoomInAnimationUpExecute(component, event, callbackFunction);
	elseif effectType == BUTTON_ANIMATION_ZOOM_OUT_UP_EXECUTE then
		--缩小动画(抬起后立即执行回调)
		zoomOutAnimationUpExecute(component, event, callbackFunction);
	end
end
