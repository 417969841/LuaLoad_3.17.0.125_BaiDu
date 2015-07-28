module("JinHuaTableFunctions", package.seeall)

-- 预加载动画加载动画
function preloadTableArmatureData()
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getJinHuaResource("putongbiaoqing0.png", pathTypeInApp),getJinHuaResource("putongbiaoqing0.plist", pathTypeInApp),getJinHuaResource("putongbiaoqing.ExportJson", pathTypeInApp));
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getJinHuaResource("gaojibiaoqing0.png", pathTypeInApp),getJinHuaResource("gaojibiaoqing0.plist", pathTypeInApp),getJinHuaResource("gaojibiaoqing.ExportJson", pathTypeInApp));
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getJinHuaResource("yaman0.png", pathTypeInApp),getJinHuaResource("yaman0.plist", pathTypeInApp),getJinHuaResource("yaman.ExportJson", pathTypeInApp));
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getJinHuaResource("change_card_click_prompt_anim.png", pathTypeInApp),getJinHuaResource("change_card_click_prompt_anim.plist", pathTypeInApp),getJinHuaResource("change_card_click_prompt_anim.ExportJson", pathTypeInApp));
end

--获取全下金额数组
function getAllInChipArray(thisTimeBetCoins)
	local coinTable = {}
	--最高位拆分个数，余数
	local divCnt,remain
	--最高位单位
	local unit
	--亿
	if thisTimeBetCoins > 99999999 then
		divCnt = math.modf(thisTimeBetCoins / 100000000)
		remain = thisTimeBetCoins % 100000000
		unit = "1亿"
		--千万
	elseif thisTimeBetCoins > 9999999 then
		divCnt = math.modf(thisTimeBetCoins / 10000000)
		remain = thisTimeBetCoins % 10000000
		unit = "1千万"

		--百万
	elseif thisTimeBetCoins > 999999 then
		divCnt = math.modf(thisTimeBetCoins / 1000000)
		remain = thisTimeBetCoins % 1000000
		unit = "1百万"

		--十万
	elseif thisTimeBetCoins > 99999 then
		divCnt = math.modf(thisTimeBetCoins / 100000)
		remain = thisTimeBetCoins % 100000
		unit = "十万"

		--万
	elseif thisTimeBetCoins > 9999 then
		divCnt = math.modf(thisTimeBetCoins / 10000)
		remain = thisTimeBetCoins % 10000
		unit = "1万"
		--不拆分
	else

	end
	--将拆分后的金币放到table中
	if divCnt then --拆分
		for i=1, divCnt do
			coinTable[i] = unit
	end
	if remain~=0 then
		if remain>=1000000 then
			local div = math.modf(remain / 1000000)
			coinTable[#coinTable+1] = div.."M"
		elseif remain>=1000 then
			local div = math.modf(remain / 1000)
			coinTable[#coinTable+1] = div.."K"
		else
			coinTable[#coinTable+1] = remian
		end
	end
	else --不需要拆分
		coinTable[1] = ""..thisTimeBetCoins
	end
	return coinTable
end

-- 得到一个数字的位数
function getDigitCount(digit)
	digit = tonumber(digit)
	local count = 0
	while digit >= 1 do
		digit = digit / 10
		count = count + 1
	end
	return count
end