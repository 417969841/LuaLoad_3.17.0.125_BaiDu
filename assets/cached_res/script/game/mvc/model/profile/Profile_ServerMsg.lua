module(..., package.seeall)

local ServerMsgTable = {}
local ServerTime = {}
ServerTime["TimeDifference"] = 0;

--[[--
获取服务器消息数据
]]
function getServerMsgTable()
	return ServerMsgTable
end

function getTimeDifference()
	return ServerTime["TimeDifference"];
end

--[[--
接收服务器通知
]]
function readGAMEID_SERVER_MSG(dataTable)
	-- Type Byte 类型 1:充值弹窗 2:飘字 3:比赛播报 4.系统公告 5.强制退出 6.Toast,7.冲榜飘字,8.普通弹框
	ServerMsgTable["nType"] = dataTable["nType"]
	-- Msg text 比赛状态的客户端提示语
	ServerMsgTable["sMsg"] = dataTable["sMsg"]
	-- 充值是否成功（充值特有）1成功，0失败
	ServerMsgTable["isSucceed"] = dataTable["isSucceed"]

	framework.emit(GAMEID_SERVER_MSG)
end

--[[--
--同步服务器时间
--]]
function readBASEID_TIMESTAMP_SYNC(dataTable)
	local serverTime = dataTable["TimeStamp"];
	Common.log("serverTime/1000 == "..serverTime/1000)
	ServerTime["TimeDifference"] = os.time() - serverTime/1000;
	framework.emit(BASEID_TIMESTAMP_SYNC)
end

registerMessage(GAMEID_SERVER_MSG, readGAMEID_SERVER_MSG)
registerMessage(BASEID_TIMESTAMP_SYNC, readBASEID_TIMESTAMP_SYNC)