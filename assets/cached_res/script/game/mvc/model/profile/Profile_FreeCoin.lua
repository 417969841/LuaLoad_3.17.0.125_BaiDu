--
-- 免费金币profile
--

module(..., package.seeall)

local freeCoinInfoTable = {};--免费金币详情table
local moduleConstantDataTable = {}; --模块常量数据 table

--[[--
--获取模块常量数据 table
--]]
function getModuleConstantDataTable()
	return moduleConstantDataTable;
end

--[[--
--初始化模块常量数据 table
--]]
local function initModuleConstantDataTable()
	--月签 [模块ID] : 1001 [模块按钮状态] : 0:未签1:已签
	moduleConstantDataTable.MonthSign = {};
	moduleConstantDataTable.MonthSign.ID = 1001;
	moduleConstantDataTable.MonthSign.NoSign = 0;
	moduleConstantDataTable.MonthSign.HasSign = 1;
	--每日任务 [模块ID] : 1002 [模块按钮状态] : 0:没红点(无可领奖的任务)1:有红点(有可领奖的任务)
	moduleConstantDataTable.DailyTask = {};
	moduleConstantDataTable.DailyTask.ID = 1002;
	moduleConstantDataTable.DailyTask.NoTanHao = 0;
	moduleConstantDataTable.DailyTask.HasTanHao = 1;
	--分享 [模块ID] : 1003 [模块按钮状态] : 0:未分享1:已领奖
	moduleConstantDataTable.Share = {};
	moduleConstantDataTable.Share.ID = 1003;
	moduleConstantDataTable.Share.NoShare = 0;
	moduleConstantDataTable.Share.HasAward = 1;
	--开启房间宝盒 [模块ID] : 1004 [模块按钮状态] : -1:无任何状态
	moduleConstantDataTable.OpenBaoHe = {};
	moduleConstantDataTable.OpenBaoHe.ID = 1004;
	--红包分享[模块ID] : 1005 [模块按钮状态] : -1:无任何状态
	moduleConstantDataTable.RedGift = {};
	moduleConstantDataTable.RedGift.ID = 1005;
	--邀请码兑换[模块ID] : 1006
	moduleConstantDataTable.InvitationCode = {};
	moduleConstantDataTable.InvitationCode.ID = 1006;
	--绑定手机[模块ID] : 1007
	moduleConstantDataTable.BindPhone = {};
	moduleConstantDataTable.BindPhone.ID = 1007;
end

initModuleConstantDataTable();

--[[--
--获取免费金币数据
--]]
function getFreeCoinInfoTable()
	return freeCoinInfoTable;
end

--[[--
--读取免费金币数据
--]]
function readOPERID_FREE_COIN(dataTable)
	freeCoinInfoTable = {}
	if not Common.getCurrentNameOfAppPackageIsTQ() then
		--如果不是同趣的包名,则不显示微信支付数据
		for i=1, #dataTable do
			if moduleConstantDataTable.Share.ID ~= dataTable[i].ModuleID then
				table.insert(freeCoinInfoTable, dataTable[i]);
			end
		end
	else
		freeCoinInfoTable = dataTable;
	end
	framework.emit(OPERID_FREE_COIN);
end

registerMessage(OPERID_FREE_COIN , readOPERID_FREE_COIN);