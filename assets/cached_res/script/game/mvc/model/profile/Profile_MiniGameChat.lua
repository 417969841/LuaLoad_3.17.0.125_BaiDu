module(..., package.seeall)

local miniGameChatInfoTable = {} --小游戏发言信息
local miniGameRewardsInfoTable = {} --小游戏打赏基本信息
local miniGameRewardResultInfo = {} --小游戏打赏结果
local miniGameIsExistRewardInfo = {} --小游戏是否存在打赏记录
local miniGameRewardRecordInfoTable = {} --小游戏打赏记录

--[[
--获取服务器推送的用户发言
--]]
function readIMID_MINI_SEND_MESSAGE(dataTable)
	miniGameChatInfoTable = dataTable
	framework.emit(IMID_MINI_SEND_MESSAGE)
end

function getMiniGameChatInfoTable()
	return miniGameChatInfoTable
end

--[[
--获取打赏基本信息
--]]
function readIMID_MINI_REWARDS_BASEINFO(dataTable)
	miniGameRewardsInfoTable = dataTable
	framework.emit(IMID_MINI_REWARDS_BASEINFO)
end

function getMiniGameRewardsInfoTable()
	return miniGameRewardsInfoTable
end

--[[
--获取打赏结果
--]]
function readIMID_MINI_REWARDS_RESULT(dataTable)
	miniGameChatRewardResultInfo = dataTable
	framework.emit(IMID_MINI_REWARDS_RESULT)
end

function getMiniGameRewardResultInfo()
	return miniGameChatRewardResultInfo
end

--[[
--获取是否有赏金可取
--]]
function readIMID_MINI_REWARDS_JUDGE(dataTable)
	miniGameIsExistRewardInfo = dataTable
	framework.emit(IMID_MINI_REWARDS_JUDGE)
end

function getMiniGameIsExistRewardInfo()
	return miniGameIsExistRewardInfo
end

--[[
--获取小游戏打赏记录
--]]
function readIMID_MINI_REWARDS_COLLECT(dataTable)
	miniGameRewardRecordInfoTable = dataTable
	framework.emit(IMID_MINI_REWARDS_COLLECT)
end

function getMiniGameRewardRecordInfoTable()
	return miniGameRewardRecordInfoTable
end

registerMessage(IMID_MINI_SEND_MESSAGE, readIMID_MINI_SEND_MESSAGE)
registerMessage(IMID_MINI_REWARDS_BASEINFO, readIMID_MINI_REWARDS_BASEINFO)
registerMessage(IMID_MINI_REWARDS_RESULT, readIMID_MINI_REWARDS_RESULT)
registerMessage(IMID_MINI_REWARDS_JUDGE, readIMID_MINI_REWARDS_JUDGE)
registerMessage(IMID_MINI_REWARDS_COLLECT, readIMID_MINI_REWARDS_COLLECT)