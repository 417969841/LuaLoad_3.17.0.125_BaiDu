module(..., package.seeall)

local PaiHangBangTable = {}--排行榜信息
local PaiHangBangNoticeInfo = {}--排行榜提示信息

--[[--
--获取排行榜信息
]]
function getPaiHangBangInfo()
	return PaiHangBangTable
end

--获取排行榜提示信息
function getPaiHangBangNoticeInfo()
	return PaiHangBangNoticeInfo
end

-- 排行榜提示信息(RankListCheckSelfRankingBean)

function readRankListCheckSelfRankingBean(dataTable)
	PaiHangBangNoticeInfo = dataTable
	framework.emit(RankListCheckSelfRankingBean)
end


--排行榜信息 (RankListGetRankDataBean)
function readRankListGetRankDataBean(dataTable)
	PaiHangBangTable = dataTable
	framework.emit(RankListGetRankDataBean)
end

registerMessage(RankListCheckSelfRankingBean, readRankListCheckSelfRankingBean)
registerMessage(RankListGetRankDataBean, readRankListGetRankDataBean)