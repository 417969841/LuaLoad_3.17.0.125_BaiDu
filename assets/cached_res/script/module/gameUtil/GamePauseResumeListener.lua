module("GamePauseResumeListener",package.seeall)

-- 切到后台
function pause()
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
	elseif Common.platform == Common.TargetAndroid then
		Common.log("程序切到后台=================================================")
	end
end

-- 切回游戏
function resume()
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
	elseif Common.platform == Common.TargetAndroid then
		Common.log("程序切到前台=================================================")
		if GameConfig.getTheCurrentBaseLayer() == GUI_WANRENJINHUA then
			WanRenJinHuaLogic.doAfterGameRestart()
		end
	end
end

-- 添加监听事件
function addListener()
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
		local javaMethodName = "initOnStopAndRestartLuaCallBackFunc"
		local javaParams = {
			pause,
			resume,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end