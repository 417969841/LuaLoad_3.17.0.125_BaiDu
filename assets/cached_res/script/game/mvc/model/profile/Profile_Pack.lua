module(..., package.seeall)

local PackTable = {};
PackTable["PackList"] = {};
local PriceCompound = nil;
local AllTable = {};
AllTable["PackList"] = {};
local readPackTableDone = false;
local readPriceCompoundDone = false;
local TICKET_GET_TICKET_LISTTable = {};
local MANAGERID_GET_UNUSED_TICKET_CNTTable = {};--请求剩余门票数

function getMANAGERID_GET_UNUSED_TICKET_CNTTable()
	return MANAGERID_GET_UNUSED_TICKET_CNTTable
end

--[[--
--设置背包是否已接收数据
--]]
function setPackTableDone(isPackTableDone)
	readPackTableDone = isPackTableDone;
end

--[[--
--设置碎片合成是否已接收数据
--]]
function setPriceCompoundDone(isPriceCompoundDone)
	readPriceCompoundDone = isPriceCompoundDone;
end

--判断是否有高级包情报
function hasGaojiEmtionBag()
	for i=1,#PackTable["PackList"] do
		if PackTable["PackList"][i].backpackName == "高级表情包" or
			PackTable["PackList"][i].backpackName == "高级表情包(2天)" or
			PackTable["PackList"][i].backpackName == "高级表情包(7天)" or
			PackTable["PackList"][i].backpackName == "高级表情包(30天)" then
			GameConfig.remainSuperiorFaceTime = 1;
			break;
		end
	end
end

--[[
设置记牌器有效期
vd:记牌器有效期，单位为秒
]]
function setJipaiqiValidDate(vd)
	Common.log("setJipaiqiValidDate")
	Common.log("vd = "..vd)
	local jipaiqiTable = {}
	for i=1,#PackTable["PackList"] do
		if PackTable["PackList"][i].backpackName == "记牌器" then
			jipaiqiTable = PackTable["PackList"][i]
			--把单位转换为小时
			local validDate = tonumber(vd/3600)
			jipaiqiTable.VipUpperLimit = validDate

			return
		end
	end

	--如果没有记牌器数据时
	jipaiqiTable.backpackName = "记牌器"
	local validDate = tonumber(vd/3600) --把单位转换为小时
	jipaiqiTable.VipUpperLimit = validDate

	--将记牌器数据插入
	PackTable["PackList"][table.maxn(PackTable["PackList"])+1] = jipaiqiTable
end

--[[
返回记牌器的有效期，单位为小时
]]
function getJipaiqiValidDate()
	for i=1,#PackTable["PackList"] do
		if PackTable["PackList"][i].backpackName == "记牌器" then
			return PackTable["PackList"][i].VipUpperLimit;
		end
	end

	--没有记牌器
	return 0
end

-- 剩余门票(MANAGERID_GET_UNUSED_TICKET_CNT)
function readMANAGERID_GET_UNUSED_TICKET_CNT(dataTable)
	MANAGERID_GET_UNUSED_TICKET_CNTTable = dataTable
	framework.emit(MANAGERID_GET_UNUSED_TICKET_CNT)
end

function getTICKET_GET_TICKET_LISTTable()
	return TICKET_GET_TICKET_LISTTable["TicketLoop"]
end

-- 门票基本信息(TICKET_GET_TICKET_LIST)
function readTICKET_GET_TICKET_LIST(dataTable)
	TICKET_GET_TICKET_LISTTable = dataTable
	framework.emit(TICKET_GET_TICKET_LIST)
end

function setPackTable(dataTable)
	PackTable["PackList"] = {}
	PackTable["PackList"] = dataTable["BackPackData"]
	hasGaojiEmtionBag();
	readPackTableDone = true;
	setAll();
end

function setDBID_BACKPACK_GOODS_COUNT(dataTable)
	if dataTable["ItemID"] == 4 then
		--记牌器
		setJipaiqiValidDate(dataTable["Num"])
	end
end

function getPackTable()
	return PackTable["PackList"]
end

--碎片合成兑奖券
function setPriceCompoundList(dataTable)
	PriceCompound = {};
	PriceCompound = dataTable;
	readPriceCompoundDone = true;
	framework.emit(MANAGERID_PIECES_COMPOUND_DETAILS_V2)
end

function getPriceCompoundList()
	return PriceCompound
end

function setPriceCompoundNull()
	PriceCompound = {}
end

--合并数据
function setAll()
--	if readPackTableDone then
		--碎片兌換
		--		if PriceCompound ~= nil then
		--			AllTable["PackList"] = {}
		--			AllTable["PackList"][1] = {}
		--			AllTable["PackList"][1].ID = PriceCompound["PiecesID"]
		--			AllTable["PackList"][1].backpackName = PriceCompound["Name"]
		--			AllTable["PackList"][1].Title = PriceCompound["PiecesIntro"]
		--			AllTable["PackList"][1].itemNum = PriceCompound["ExistingNum"]
		--			AllTable["PackList"][1].goodsProperty = 1
		--			AllTable["PackList"][1].IconURL = PriceCompound["IconURL"]
--		for i = 1,#PackTable["PackList"] do
--			AllTable["PackList"][i+1] = {}
			AllTable["PackList"] = {}
			AllTable["PackList"] = PackTable["PackList"]
--		end

		framework.emit(DBID_BACKPACK_LIST)
		--			framework.emit(MANAGERID_PIECES_COMPOUND_DETAILS_V2)
		--		end
--		readPackTableDone = false;
--		readPriceCompoundDone = false;
--	end
end

function getAll()
	return AllTable["PackList"]
end

registerMessage(MANAGERID_GET_UNUSED_TICKET_CNT, readMANAGERID_GET_UNUSED_TICKET_CNT)
registerMessage(TICKET_GET_TICKET_LIST, readTICKET_GET_TICKET_LIST)
registerMessage(DBID_BACKPACK_LIST, setPackTable)
registerMessage(DBID_BACKPACK_GOODS_COUNT, setDBID_BACKPACK_GOODS_COUNT)
registerMessage(MANAGERID_PIECES_COMPOUND_DETAILS_V2, setPriceCompoundList)



