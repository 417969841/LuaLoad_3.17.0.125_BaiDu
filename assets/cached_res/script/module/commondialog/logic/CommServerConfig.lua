module("CommServerConfig", package.seeall)

function callServerConfig()
	local javaClassName = "com.tongqu.client.utils.SMSMobileBroadCast"
	local javaMethodName = "storeMATCHES"
	dataTable = profile.ServerConfig.getJINHUA_DENY_SMS_LIST()
	for i = 1, #dataTable["ConfigValueData"] do
		local javaParams = { profile.ServerConfig.getJINHUA_DENY_SMS_LIST()["ConfigValueData"][1].VarValue }
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

