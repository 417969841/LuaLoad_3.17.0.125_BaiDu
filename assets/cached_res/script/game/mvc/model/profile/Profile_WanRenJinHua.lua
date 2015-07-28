module(..., package.seeall)

local WanRenJinHuaBetDataTable = {} -- 下注
local WanRenJinHuaSendCardDataTable = {} -- 发牌
local WanRenJinHuaHelpDataTable = nil -- 帮助
local WanRenJinHuaHistoryDataTable = nil -- 输赢历史记录
local WanRenJinHuaResultDataTable = {} -- 游戏结果
local WanRenJinHuaSynDataTable = {} -- 牌桌同步
local WanRenJinHuaTimerDataTable = {} -- 在下注和游戏结果时定时推送期间定时推送
local WanRenJinHuaBetFullTable = {} -- 下注满推送

--[[--
--获取下注满提示
--]]
function getWanRenJinHuaBetFullMessage()
    return WanRenJinHuaBetFullTable["message"]
end

--[[--
--下注满推送
--]]
function readJHGAMEID_MINI_JINHUA_FULL_CHIPS(dataTable)
    WanRenJinHuaBetFullTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_FULL_CHIPS)
end

--[[--
--获取下注数据
--]]
function getWanRenJinHuaBetDataTable()
    return WanRenJinHuaBetDataTable
end

--[[--
--下注数据
--]]
function readJHGAMEID_MINI_JINHUA_BET(dataTable)
    WanRenJinHuaBetDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_BET)
end

--[[--
--获取数据发牌
--]]
function getWanRenJinHuaSendCardDataTable()
    return WanRenJinHuaSendCardDataTable
end

--[[--
--保存分发发牌数据
--]]
function readJHGAMEID_MINI_JINHUA_DEAL(dataTable)
    WanRenJinHuaSendCardDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_DEAL)
end

--[[--
--获取帮助数据
--]]
function getWanRenJinHuaHelpDataTable()
    return WanRenJinHuaHelpDataTable
end

--[[--
--保存分发帮助数据
--]]
function readJHGAMEID_MINI_JINHUA_HELP(dataTable)
    WanRenJinHuaHelpDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_HELP)
end

--[[--
--获取输赢历史记录
--]]
function getWanRenJinHuaHistoryDataTable()
    return WanRenJinHuaHistoryDataTable
end

--[[--
--保存分发输赢历史记录数据
--]]
function readJHGAMEID_MINI_JINHUA_HISTORY(dataTable)
    WanRenJinHuaHistoryDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_HISTORY)
end

--[[--
--获取游戏结果
--]]
function getWanRenJinHuaResultDataTable()
    return WanRenJinHuaResultDataTable
end

--[[--
--保存分发游戏结果数据
--]]
function readJHGAMEID_MINI_JINHUA_RESULT(dataTable)
    WanRenJinHuaResultDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_RESULT)
end

--[[--
--获取牌桌同步数据
--]]
function getWanRenJinHuaSynDataTable()
    return WanRenJinHuaSynDataTable
end

--[[--
--保存分发牌桌同步数据
--]]
function readJHGAMEID_MINI_JINHUA_TABLE_SYNC(dataTable)
    WanRenJinHuaSynDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_TABLE_SYNC)
end

--[[--
--获取在下注和游戏结果时定时推送期间定时推送数据
--]]
function getWanRenJinHuaTimerDataTable()
    return WanRenJinHuaTimerDataTable
end

--[[--
--保存分发在下注和游戏结果时定时推送期间定时推送数据
--]]
function readJHGAMEID_MINI_JINHUA_TIMING(dataTable)
    WanRenJinHuaTimerDataTable = dataTable
    framework.emit(JHGAMEID_MINI_JINHUA_TIMING)
end

registerMessage(JHGAMEID_MINI_JINHUA_FULL_CHIPS , readJHGAMEID_MINI_JINHUA_FULL_CHIPS);
registerMessage(JHGAMEID_MINI_JINHUA_BET , readJHGAMEID_MINI_JINHUA_BET);
registerMessage(JHGAMEID_MINI_JINHUA_DEAL , readJHGAMEID_MINI_JINHUA_DEAL);
registerMessage(JHGAMEID_MINI_JINHUA_HELP , readJHGAMEID_MINI_JINHUA_HELP);
registerMessage(JHGAMEID_MINI_JINHUA_HISTORY , readJHGAMEID_MINI_JINHUA_HISTORY);
registerMessage(JHGAMEID_MINI_JINHUA_RESULT , readJHGAMEID_MINI_JINHUA_RESULT);
registerMessage(JHGAMEID_MINI_JINHUA_TABLE_SYNC , readJHGAMEID_MINI_JINHUA_TABLE_SYNC);
registerMessage(JHGAMEID_MINI_JINHUA_TIMING , readJHGAMEID_MINI_JINHUA_TIMING);

