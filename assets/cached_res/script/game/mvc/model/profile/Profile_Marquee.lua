module(..., package.seeall)
local MARQUEE_TABLE = {}
local hasMarquee = true
local position = nil
function readOPERID_ACTIVITY_MARQUEE(dataTable)
	MARQUEE_TABLE = dataTable
	--如果消息回来,走马灯没有数据,那么就停止再发送请求
	if MARQUEE_TABLE["secStrTable"] == nil and MARQUEE_TABLE["firstStrTable"] == nil then
		hasMarquee = false
	elseif #MARQUEE_TABLE["secStrTable"] == 0 and #MARQUEE_TABLE["firstStrTable"] == 0 then
		hasMarquee = false
	end
	framework.emit(OPERID_ACTIVITY_MARQUEE)
end

function getOPERID_ACTIVITY_MARQUEE()
	if hasMarquee == true then
		if MARQUEE_TABLE["secStrTable"] == nil and MARQUEE_TABLE["firstStrTable"] == nil then
		--table长度为0时,也就是所有走马灯消息播放完成时,去请求新的走马灯消息
			local marqueeTable = {}
			marqueeTable["gameID"] = GameConfig.GAME_ID
			marqueeTable["position"] = position
			Common.log("read8061000b position===" .. position);
			sendOPERID_ACTIVITY_MARQUEE(marqueeTable)
			return nil
		elseif #MARQUEE_TABLE["secStrTable"] == 0 and #MARQUEE_TABLE["firstStrTable"] == 0 then
			local marqueeTable = {}
			marqueeTable["gameID"] = GameConfig.GAME_ID
			marqueeTable["position"] = position
			sendOPERID_ACTIVITY_MARQUEE(marqueeTable)
			return nil
		end
	end
	local msg = nil
	--走马灯消息没播放完时,每次返回一个走马灯消息

	--firstStrTable是游戏内部的消息,优先级低
	--secStrTable是想让用户看到的消息,优先级高
	if #MARQUEE_TABLE["secStrTable"] > 0 then
		msg = MARQUEE_TABLE["secStrTable"][1]
		table.remove(MARQUEE_TABLE["secStrTable"], 1)
	end
	if msg == nil and #MARQUEE_TABLE["firstStrTable"] > 0 then
		msg = MARQUEE_TABLE["firstStrTable"][1]
		table.remove(MARQUEE_TABLE["firstStrTable"], 1)
	end

	return msg
end

function resetMARQUEE_TABLE(value)
	MARQUEE_TABLE = {}
	hasMarquee = true
	position = value
end

registerMessage(OPERID_ACTIVITY_MARQUEE, readOPERID_ACTIVITY_MARQUEE)