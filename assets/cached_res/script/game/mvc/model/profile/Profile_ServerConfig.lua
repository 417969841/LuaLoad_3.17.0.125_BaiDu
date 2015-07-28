module(..., package.seeall)

local ServerConfigTable = {} --配置内容

function readDBID_GET_SERVER_CONFIG(dataTable)
	for i = 1, #dataTable["ConfigValueData"] do
		ServerConfigTable[ServerConfig.maMessage[i]] = dataTable["ConfigValueData"][i]
		Common.log("readDBID_GET_SERVER_CONFIG ServerConfig.maMessage[i] == "..ServerConfig.maMessage[i])
	end
	framework.emit(DBID_GET_SERVER_CONFIG)
end

function getServerConfigDataTable(key)
	return ServerConfigTable[key];
end

registerMessage(DBID_GET_SERVER_CONFIG, readDBID_GET_SERVER_CONFIG)