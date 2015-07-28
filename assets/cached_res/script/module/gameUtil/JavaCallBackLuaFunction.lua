
if Common.platform == Common.TargetIos then

elseif Common.platform == Common.TargetAndroid then
	local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
	local javaMethodName = "setLuaCallBackFunction"
	local javaParams = {
		Common.AndroidExitSendOnlineTime,
	}
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
end