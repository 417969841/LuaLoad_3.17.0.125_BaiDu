module(..., package.seeall)

--[[--
--建立连接失败(每连续出现三次，则弹出网络异常对话框)
--]]
function readNETERR_CONN_FAILED(dataTable)
	framework.emit(NETERR_CONN_FAILED)
end

--[[--
--网络断开(开始重连)
--]]
function readNETERR_NET_BROKEN(dataTable)
	framework.emit(NETERR_NET_BROKEN)
end

--[[--
--重连成功(如果是没有出现连接失败的成功，则不是重连)
--]]
function readNETERR_CONN_SUCC(dataTable)
	framework.emit(NETERR_CONN_SUCC)
end

--[[--
--切出游戏
--]]
function readGAME_ENTER_BACKGROUND(dataTable)
	framework.emit(GAME_ENTER_BACKGROUND)
end

--[[--
--进入游戏
--]]
function readGAME_ENTER_FOREGROUND(dataTable)
	framework.emit(GAME_ENTER_FOREGROUND)
end

registerMessage(NETERR_CONN_FAILED, readNETERR_CONN_FAILED);
registerMessage(NETERR_NET_BROKEN, readNETERR_NET_BROKEN);
registerMessage(NETERR_CONN_SUCC, readNETERR_CONN_SUCC);
registerMessage(GAME_ENTER_BACKGROUND, readGAME_ENTER_BACKGROUND);
registerMessage(GAME_ENTER_FOREGROUND, readGAME_ENTER_FOREGROUND);