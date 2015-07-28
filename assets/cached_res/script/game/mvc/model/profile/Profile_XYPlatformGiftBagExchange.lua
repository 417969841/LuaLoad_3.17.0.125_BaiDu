module(..., package.seeall)
--
--XY平台新用户兑奖
--

local XYGiftBagDataTable = {};--XY礼包数据
local ExchangeResult = -1;--兑换结果1 成功 2 失败
local ExchangeMsg = "";--兑换成功或失败的提示语

--[[--
--获取兑换结果
--@return #number 1 成功 2 失败
--]]
function getExchangeResult()
	return ExchangeResult;
end

--[[--
--兑换成功或失败的提示语
--@return #String 提示语
--]]
function getExchangeMsg()
	return ExchangeMsg;
end

--[[--
--获取兑换的奖品列表
--@return #table 奖品列表
--]]
function getExchangePrizeList()
	return XYGiftBagDataTable;
end

--[[--
--保存XY平台礼包兑换数据
--]]
function readOPERID_XYPLATFORM_GIFTBAG_EXCHANGE(dataTable)
	XYGiftBagDataTable = dataTable["Prize"];
	ExchangeResult = dataTable["Result"];
	ExchangeMsg = dataTable["Msg"];
	framework.emit(OPERID_XYPLATFORM_GIFTBAG_EXCHANGE);
end

registerMessage(OPERID_XYPLATFORM_GIFTBAG_EXCHANGE , readOPERID_XYPLATFORM_GIFTBAG_EXCHANGE);