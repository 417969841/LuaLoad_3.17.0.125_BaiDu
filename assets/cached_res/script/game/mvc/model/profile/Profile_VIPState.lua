--[[--
--大厅VIP状态
--]]--
module(..., package.seeall)


local vipSatausInfoTable = {}
local openGifttable = {}

--[[--
--加载本地vip数据
]]
local function loadLocalVipTable()
	vipSatausInfoTable = Common.LoadTable("vipSatausInfoTable")
	if vipSatausInfoTable == nil then
		vipSatausInfoTable = {}
		vipSatausInfoTable["VipLevel"] = 0
		vipSatausInfoTable["Status"] = 4
		vipSatausInfoTable["RMB"] = 0
	end
end

loadLocalVipTable()

--[[--
--获取VIP等级
--]]
function getVipLevel()
	if vipSatausInfoTable["VipLevel"] ~= nil then
		return vipSatausInfoTable["VipLevel"]
	else
		return 0
	end
end

--[[--
--获取VIP状态
--]]
function getVipStatus()
	if vipSatausInfoTable["Status"] ~= nil then
		return vipSatausInfoTable["Status"]
	else
		return 4
	end
end

--[[--
--获取开通金额
--]]
function getVipPrice()
	if vipSatausInfoTable["RMB"] ~= nil then
		return vipSatausInfoTable["RMB"]
	else
		return 0
	end
end

--[[--
--提示信息
--]]--
function readAlert_INFO(dataTable)
	--	VipLevel	Int	vip等级	当用户由vipn(n>0)变为vip0时，此数值传负数，相应的数值为变为vip0时上一级vip
	vipSatausInfoTable["VipLevel"] = dataTable["VipLevel"]
	--Status Byte 状态信息	1：开通2：优惠 3：续费 4:空白
	vipSatausInfoTable["Status"] = dataTable["Status"]
	--RMB	Int	充值引导金额	当Status为2或1时此数值为礼包金额，当Status为3时传相应的充值引导金额，当Status为4时为0
	vipSatausInfoTable["RMB"] = dataTable["RMB"]
	Common.SaveTable("vipSatausInfoTable", vipSatausInfoTable)
	framework.emit(MANAGERID_VIPV2_TIP_INFO)
end

--[[--
--得到提示信息
--]]--
function getAlertInfo()
	return vipSatausInfoTable
end

--[[--
--开通礼包信息
--]]--
function readOpen_GIFT(dataTable)
	openGifttable = dataTable
	framework.emit(MANAGERID_VIPV2_GET_GIFTBAG)
end

--[[--
--得到开通礼包信息
--]]--
function getAlert_INFO()
	return openGifttable
end


registerMessage(MANAGERID_VIPV2_TIP_INFO , readAlert_INFO);
registerMessage(MANAGERID_VIPV2_GET_GIFTBAG , readOpen_GIFT);