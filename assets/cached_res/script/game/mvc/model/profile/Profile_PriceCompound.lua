module(..., package.seeall)

local PriceCompound = {}
local comtable = {}--合成的成功信息
local lastNum = 0 --合成走马灯上次显示的最后一条
local getNum = 20 --合成走马灯每次去多少条信息
local hasMoreInfo = true --服务器是否还有走马灯数据

--碎片合成
PriceCompound["Result"] = 2 -- 2是初始值，0是成功 1是失败
PriceCompound["ResultMsg"] = ""

--[[--
--Result
]]
function getResult()
	local value = PriceCompound["Result"]
	if value == nil then
		return 2
	else
		return value
	end
end

function setResult(result)
	PriceCompound["Result"] = result
end

--[[--
--ResultText
]]
function getResultText()
	local value = PriceCompound["ResultMsg"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setResultText(resultText)
	PriceCompound["ResultMsg"] = resultText
end


function setPriceCompoundInfo(dataTable)
	local result = dataTable["Result"]
	local resultText = dataTable["ResultMsg"]

	PriceCompound["Result"] = result
	PriceCompound["ResultMsg"] = resultText

	framework.emit(MANAGERID_COMPOUND_V2)
end

-----碎片合成成功的信息
function setCompoundSucessMsg(table)
	comtable = table
	--如果消息回来,走马灯没有数据,那么就停止再发送请求
	if comtable["secStrTable"] == nil and comtable["firstStrTable"] == nil then
		hasMoreInfo = false
	elseif #comtable["secStrTable"] == 0 and #comtable["firstStrTable"] == 0 then
		hasMoreInfo = false
	end
	framework.emit(OPERID_ACTIVITY_MARQUEE)
end

function getCompoundSucessMsg()
	if hasMoreInfo == true then
		if comtable["secStrTable"] == nil and comtable["firstStrTable"] == nil then
		--table长度为0时,也就是所有走马灯消息播放完成时,去请求新的走马灯消息
			local marqueeTable = {}
			marqueeTable["gameID"] = GameConfig.GAME_ID
			marqueeTable["position"] = 2
			sendOPERID_ACTIVITY_MARQUEE(marqueeTable)
			return nil
		elseif #comtable["secStrTable"] == 0 and #comtable["firstStrTable"] == 0 then
			local marqueeTable = {}
			marqueeTable["gameID"] = GameConfig.GAME_ID
			marqueeTable["position"] = 2
			sendOPERID_ACTIVITY_MARQUEE(marqueeTable)
			return nil
		end
	end
	local msg = nil
	--走马灯消息没播放完时,每次返回一个走马灯消息

	--firstStrTable是游戏内部的消息,优先级低
	--secStrTable是想让用户看到的消息,优先级高
	if #comtable["secStrTable"] > 0 then
		msg = comtable["secStrTable"][1]
		table.remove(comtable["secStrTable"], 1)
	end
	if msg == nil and #comtable["firstStrTable"] > 0 then
		msg = comtable["firstStrTable"][1]
		table.remove(comtable["firstStrTable"], 1)
	end
	return msg
--	return "我是一个粉刷匠,粉刷本领强!"
end

function resetComtable()
	comtable = {}
	hasMoreInfo = true
end

registerMessage(MANAGERID_COMPOUND_V2, setPriceCompoundInfo)
--registerMessage(OPERID_ACTIVITY_MARQUEE, setCompoundSucessMsg)