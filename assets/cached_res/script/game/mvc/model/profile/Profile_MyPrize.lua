module(..., package.seeall)

local MyPrizeTable = {}
local MyPrizeTable2 = {}
local AllTable = {}
local flag = 0 -----2是全部消息都回来了

local PrizeChangeTable = {}
local PriceChange = {}
local GET_ALTERNATIVE_PRIZE_V2_table = {}
local myPrizeHasData = false

-----奖品相关    MANAGERID_GET_EXCHANGE_AWARDS
function setPrizeTable(dataTable)
	MyPrizeTable["List"] = {}
	MyPrizeTable["List"] = dataTable["AwardData"]
	flag = flag + 1
	setAll()
end

function setPrizeTable2(dataTable)
	MyPrizeTable2["List"] = {}
	MyPrizeTable2["List"] = dataTable["MyPrize"]
	flag = flag + 1
	setAll()
end

function setAll()
	if flag == 2 then
		AllTable["List"] = {}
		local count = 0
		--比赛赢得
		for j = 1, #MyPrizeTable2["List"] do
			count = count + 1
			AllTable["List"][count] = {}
			AllTable["List"][count].id = MyPrizeTable2["List"][j].PrizeID
			AllTable["List"][count].name = MyPrizeTable2["List"][j].PrizeName
			AllTable["List"][count].status = MyPrizeTable2["List"][j].PrizeStatus
			AllTable["List"][count].date = MyPrizeTable2["List"][j].AwardTime
			AllTable["List"][count].url = MyPrizeTable2["List"][j].PictureUrl
			AllTable["List"][count].Description = MyPrizeTable2["List"][j].prizeMatch
			AllTable["List"][count].type = 1          --1 比赛  2 兑换的
			AllTable["List"][count].Category = MyPrizeTable2["List"][j].Category  --1.卡密类 2 实物类
			AllTable["List"][count].isExpired = MyPrizeTable2["List"][j].isExpired
			AllTable["List"][count].ValidDate = MyPrizeTable2["List"][j].ValidDate--过期时间
		end
		--兑换的

		for i = 1, #MyPrizeTable["List"] do
			count = count + 1
			AllTable["List"][count] = {}
			AllTable["List"][count].id = MyPrizeTable["List"][i].AwardID
			AllTable["List"][count].name = MyPrizeTable["List"][i].Name
			AllTable["List"][count].status = MyPrizeTable["List"][i].Status
			AllTable["List"][count].date = MyPrizeTable["List"][i].Date
			AllTable["List"][count].url = MyPrizeTable["List"][i].PictureUrl
			AllTable["List"][count].Description = MyPrizeTable["List"][i].Description
			AllTable["List"][count].type = 2
			AllTable["List"][count].Category = 2
			AllTable["List"][count].isExpired = MyPrizeTable["List"][i].Status
			AllTable["List"][count].ValidDate = "" --过期时间
		end

		framework.emit(NEW_GET_PRIZE_LIST)
		flag = 0
		myPrizeHasData = true
	end
end

function getPrizeTable()
	local newAllTable = {}

	for i=1,#AllTable["List"] do
		for j=i,#AllTable["List"] do
			if AllTable["List"][i].date < AllTable["List"][j].date then
				newAllTable = AllTable["List"][i]
				AllTable["List"][i] = AllTable["List"][j]
				AllTable["List"][j] = newAllTable
			end
		end
	end
	return AllTable["List"]
end

----充值卡兑换元宝、金币、兑奖
function setPrizeChange(dataTable)
	PrizeChangeTable["List"] = {}
	PrizeChangeTable["List"] = dataTable["AwardChange"]
	framework.emit(NEW_GET_ALTERNATIVE_PRIZE_LIST)
end

function getPrizeChange()
	return PrizeChangeTable["List"]
end

--兑换充值卡      是否成功  提示信息
function setPriceChangeInfo(dataTable)
	PriceChange = dataTable
	framework.emit(NEW_GET_ALTERNATIVE_PRIZE)
end

function getPriceChangeInfo()
	return PriceChange
end

function getMyPrizeHasData()
	return myPrizeHasData
end
----备选奖品消息
function setGET_ALTERNATIVE_PRIZE_V2_Table(dataTable)
	GET_ALTERNATIVE_PRIZE_V2_table = dataTable
	Common.log("profileGET_ALTERNATIVE_PRIZE_V2")
	framework.emit(GET_ALTERNATIVE_PRIZE_V2)
end
function getGET_ALTERNATIVE_PRIZE_V2_Table(dataTable)

	return GET_ALTERNATIVE_PRIZE_V2_table

end

registerMessage(GET_ALTERNATIVE_PRIZE_V2,setGET_ALTERNATIVE_PRIZE_V2_Table)
registerMessage(MANAGERID_GET_EXCHANGE_AWARDS,setPrizeTable)--MANAGERID_GET_EXCHANGE_AWARDS
registerMessage(NEW_GET_PRIZE_LIST, setPrizeTable2)
registerMessage(NEW_GET_ALTERNATIVE_PRIZE_LIST, setPrizeChange)
registerMessage(NEW_GET_ALTERNATIVE_PRIZE, setPriceChangeInfo)