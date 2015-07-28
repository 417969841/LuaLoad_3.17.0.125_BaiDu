module(..., package.seeall)

local TreasureChestsProTable = {} -- 宝箱进度
local TreasureChestsListTable = {} -- 宝箱列表
local TreasureChestsPrizeTable = {} -- 宝箱领奖
local PreReadNewUserPrizeTable = {}; --新手预读奖励

--[[--
--是不是第二次打开宝盒
--]]
function IsSecondOpenTime()
	for i =1 , #TreasureChestsListTable["TreasureBoxList"] do
		if TreasureChestsListTable["TreasureBoxList"][i].state == 1 then
			-- state 0：未打开 1：已打开
			return true;
		end
	end
	return false;
end

--[[--
--设置宝盒状态
--@parm #number index 宝盒下标
--]]
function setTreasureChestsState(index)
	if TreasureChestsListTable["TreasureBoxList"] ~= nil and TreasureChestsListTable["TreasureBoxList"][index] ~= nil then
		TreasureChestsListTable["TreasureBoxList"][index].state = 1;
	end
end

--[[--
--获取能开几次宝盒
--]]
function getOpenCountMax()
	return TreasureChestsListTable["openCountMax"];
end

--[[--
--获取宝箱进度
--]]
function getTreasureChestsPro()
	return TreasureChestsProTable;
end

--[[--
--获取宝箱列表
--]]
function getTreasureChestsList()
	return TreasureChestsListTable;
end

--[[--
--获取宝箱进度
--]]
function getTreasureChestsPrize()
	return TreasureChestsPrizeTable;
end

--[[--
--获取宝盒V4新手预读奖励
--]]
function getPreReadNewUserPrizeTable()
	return PreReadNewUserPrizeTable["Treasure"];
end

--[[--
--获取宝盒V4新手预读奖励可打开宝盒次数
--]]
function getPreReadNewUserOpenBoxTimes()
	return PreReadNewUserPrizeTable["count"];
end

--[[--
--读取宝箱领奖
--]]
function readTreasureChestsProTable(dataTable)
	TreasureChestsProTable = dataTable
	framework.emit(BAOHE_V4_GET_PRO)
end

--[[--
--读取宝箱列表
--]]
function readTreasureChestsListTable(dataTable)
	TreasureChestsListTable = dataTable
	framework.emit(BAOHE_V4_GET_LIST)
end

--[[--
--读取宝领奖
--]]
function readTreasureChestsPrizeTable(dataTable)
	--Result	Byte	1 成功 0 失败
	TreasureChestsPrizeTable["Result"] = dataTable["Result"]

	--ResultMsg	Text	提示语
	TreasureChestsPrizeTable["ResultMsg"] = dataTable["ResultMsg"]

	--TreasureCnt	Loop	奖励物品个数
	TreasureChestsPrizeTable["TreasurePrizeList"] = {}
	TreasureChestsPrizeTable["TreasurePrizeList"] = dataTable["TreasurePrizeList"]

	if TreasureChestsPrizeTable["Result"] == 1 then
		--只有在领奖成功时才对列表赋值（失败时会没有数据）
		--TreasureBoxList	loop	宝盒列表
		TreasureChestsPrizeTable["TreasureBoxList"] = {}
		TreasureChestsPrizeTable["TreasureBoxList"] = dataTable["TreasureBoxList"]
	end

	--Progress	Short	已完成局数
	TreasureChestsPrizeTable["Progress"] = dataTable["Progress"]
	--Max  总局数
	TreasureChestsPrizeTable["Max"] = dataTable["Max"]
	--Position	byte	宝盒编号（从左至右0，1，2）
	TreasureChestsPrizeTable["Position"] = dataTable["Position"]

	framework.emit(BAOHE_V4_GET_PRIZE)
end

--[[--
--读取宝盒V4新手预读奖励
--]]
function readNewUserTreasureChestsPrizeTable(dataTable)
	PreReadNewUserPrizeTable = dataTable
	framework.emit(OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD)
end

registerMessage(BAOHE_V4_GET_PRO, readTreasureChestsProTable)
registerMessage(BAOHE_V4_GET_LIST, readTreasureChestsListTable)
registerMessage(BAOHE_V4_GET_PRIZE, readTreasureChestsPrizeTable)
registerMessage(OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD, readNewUserTreasureChestsPrizeTable)