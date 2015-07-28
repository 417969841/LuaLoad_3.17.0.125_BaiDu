module(..., package.seeall)

--踢人消息返回Table
local kickResultTable = {}
--被踢消息Table
local beKickResultTable = {}
--是否显示被踢提示框
local isShowBeKick = false
function getKickResultTable()
	return kickResultTable
end

function getBeKickResultTable()
	return beKickResultTable
end

function readKickResultTable(dataTable)
	kickResultTable = dataTable
	framework.emit(ROOMID_KICK_OUT_PLAYER)
end

function readBeKickResultTable(dataTable)
	Common.log("readBeKickResultTable")
	beKickResultTable = dataTable
	profile.TableKick.setIsShowBeKick(true)
	framework.emit(ROOMID_PLAYER_BE_KICKED_OUT)
end

--[[--
-- 获取踢人结果 Boolean
--]]
function getKickResult()
	local result = false
	Common.log("kickResultTable ... " .. #kickResultTable)
	if kickResultTable ~= nil and kickResultTable["result"] ~= nil then
		if kickResultTable["result"] == 1 then
			Common.log("result ... " .. kickResultTable["result"])
			result = true
		end
	end
	return result
end

--[[--
-- 获取踢人者vipLevel
--]]
function getBeKickVipLevel()
	local result = nil
	if beKickResultTable ~= nil and beKickResultTable["VipLevel"] ~= nil then
		result = beKickResultTable["VipLevel"]
	end
	return result
end

--[[--
-- 获取踢人者昵称
--]]
function getBeKickNickName()
	local resultText = nil
	if beKickResultTable ~= nil and beKickResultTable["NickName"] ~= nil then
		resultText = beKickResultTable["NickName"]
	end
	return resultText
end

--[[--
--获取被踢提示 String
--]]
function getBeKickResultText()
	local resultText = nil
	if beKickResultTable ~= nil and beKickResultTable["BeKickedOutMsg"] ~= nil then
		resultText = beKickResultTable["BeKickedOutMsg"]
	end
	return resultText
end

--[[--
--设置是否显示被踢提示框 Boolean
--]]
function setIsShowBeKick(isShow)
	isShowBeKick = isShow
end

--[[--
--获取是否显示被踢提示框 Boolean
--]]
function getIsShowBeKick()
	return isShowBeKick
end

registerMessage(ROOMID_KICK_OUT_PLAYER, readKickResultTable)
registerMessage(ROOMID_PLAYER_BE_KICKED_OUT, readBeKickResultTable)