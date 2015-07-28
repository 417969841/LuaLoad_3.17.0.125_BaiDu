--
--幸运转盘profile
--

module(..., package.seeall)

local turnTableBasicInfoTable = {}; --转盘基本信息
turnTableBasicInfoTable["timeStamp"] = 0; --时间戳
turnTableBasicInfoTable["turnTablePlayIntroduction"] = ""; --转盘玩法详情
turnTableBasicInfoTable["turnTablePrize"] = {};--奖品列表
local lotteryType = -1;--抽奖类型 0免费抽奖 1消耗金币 2消耗元宝 -1出错
local  lotteryNum = 0;--抽奖次数
local turnTableLotteryInfoTable = {};---转盘抽奖信息

--[[--
--加载转盘基本信息本地数据
--]]
local function loadTurnTableBasicInfoTable()
	if turnTableBasicInfoTable["timeStamp"] == 0 then
		turnTableBasicInfoTable = Common.LoadTable("TurnTableBasicInfoTable");
		if turnTableBasicInfoTable == nil then
			turnTableBasicInfoTable = {};
			turnTableBasicInfoTable["timeStamp"] = 0;
			turnTableBasicInfoTable["turnTablePlayIntroduction"] = "";
			turnTableBasicInfoTable["turnTablePrize"] = {};
		end
	end
end

loadTurnTableBasicInfoTable()

--[[--
--获取转盘基本信息时间戳
--]]
function getTurnTableBasicInfoTimeStamp()
	return turnTableBasicInfoTable["timeStamp"];
end

--[[--
--获取转盘奖品
--]]
function getTurnTablePrizeTable()
	loadTurnTableBasicInfoTable()
	return turnTableBasicInfoTable["turnTablePrize"];
end

--[[--
--获取转盘玩法介绍
--]]
function getTurnTablePlayIntroduction()
	return turnTableBasicInfoTable["turnTablePlayIntroduction"];
end

--[[--
--获取抽奖类型
--]]
function getLotteryType()
	return lotteryType;
end

--[[--
--获取抽奖次数
--]]
function getLotteryNum()
	return lotteryNum;
end

--[[--
--获取转盘抽奖信息数据
--]]
function getTurnTableLotteryInfoTable()
	return turnTableLotteryInfoTable;
end

--[[--
--保存转盘基本信息数据
--]]
function readTURNTABLE_BASIC_INFO(dataTable)
	if tonumber(turnTableBasicInfoTable["timeStamp"]) > tonumber(dataTable["timeStamp"]) then
		--如果本地时间戳大于服务器的时间戳,证明数据有错,时间戳重置为0
		turnTableBasicInfoTable["timeStamp"] = 0;
		sendTURNTABLE_BASIC_INFO(turnTableBasicInfoTable["timeStamp"]);
		return;
	end

	lotteryType =  dataTable["lotteryType"];
	lotteryNum = dataTable["lotteryCnt"];
	--dataTable["turnTablePrize"] 转盘奖品
	if turnTableBasicInfoTable["timeStamp"] == dataTable["timeStamp"] and #dataTable["turnTablePrize"] == 0 then
		Common.log("使用本地数据")
		loadTurnTableBasicInfoTable()
	else
		turnTableBasicInfoTable["timeStamp"] = dataTable["timeStamp"];
		turnTableBasicInfoTable["turnTablePlayIntroduction"] = dataTable["turnTablePlayIntroduction"];
		turnTableBasicInfoTable["turnTablePrize"] = dataTable["turnTablePrize"];
		--保存转盘基本信息数据
		Common.SaveTable("TurnTableBasicInfoTable", turnTableBasicInfoTable)
	end
	framework.emit(TURNTABLE_BASIC_INFO);
end

--[[--
--读取转盘抽奖信息数据
--]]
function readTURNTABLE_LOTTERY_INFO(dataTable)
	lotteryNum = dataTable["lotteryCnt"];
	turnTableLotteryInfoTable = dataTable;
	framework.emit(TURNTABLE_LOTTERY_INFO);
end

--[[--
--清除数据
--]]
function clearData()
	lotteryType = -1;
	lotteryNum = 0;
	turnTableLotteryInfoTable = {};
end

registerMessage(TURNTABLE_BASIC_INFO , readTURNTABLE_BASIC_INFO);
registerMessage(TURNTABLE_LOTTERY_INFO , readTURNTABLE_LOTTERY_INFO);
