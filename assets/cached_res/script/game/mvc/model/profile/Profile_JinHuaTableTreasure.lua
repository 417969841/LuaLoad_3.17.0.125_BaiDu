module(..., package.seeall)

local treasureProTable -- 宝箱进度
local treasurePrizeTable -- 宝箱奖励

function readTreasureProTable(dataTable)
    treasureProTable = dataTable
    framework.emit(BAOHE_GET_PRO)
end

function readTreasurePrizeTable(dataTable)
    treasurePrizeTable = dataTable
    framework.emit(BAOHE_GET_TREASURE_V2)
end

function getTreasureProTable()
    return treasureProTable
end

function getTreasurePrizeTable()
    return treasurePrizeTable
end

registerMessage(BAOHE_GET_PRO , readTreasureProTable );
registerMessage(BAOHE_GET_TREASURE_V2 , readTreasurePrizeTable);
