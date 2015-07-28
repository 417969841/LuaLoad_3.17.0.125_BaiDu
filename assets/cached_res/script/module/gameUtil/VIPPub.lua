VIPPub = {}

VIPPub.VIP_PAST = -1 -- 过期VIP用户
VIPPub.VIP_NO = 0;--普通用户
VIPPub.VIP_1 = 1;--vip1
VIPPub.VIP_2 = 2;-- vip2
VIPPub.VIP_3 = 3;-- vip3
VIPPub.VIP_4 = 4;-- vip4
VIPPub.VIP_5 = 5;-- vip5
VIPPub.VIP_6 = 6;-- vip6
VIPPub.VIP_7 = 7;-- vip7
VIPPub.VIP_8 = 8;-- vip8
VIPPub.VIP_9 = 9;-- vip9


--VIPPub.VipCzje = {3,20,50,100,300,600,1000}--vip充值金额
VIPPub.VipCzje = {10,30,60,150,300,800,2000}--vip充值金额
VIPPub.VipInfo = {
	"5项特权奖励，需累计充值3元",
	"6项特权奖励，需累计充值20元",
	"9项特权奖励，需累计充值50元",
	"10项特权奖励，需累计充值100元",
	"10项升级特权，需累计充值300元",
	"10项豪华特权，需累计充值600元",
	"10项至尊特权，需累计充值1000元"}
VIPPub.vipImage = {"vip_1.png","vip_2.png","vip_3.png","vip_4.png","vip_5.png","vip_6.png","vip_7.png","vip_8.png","vip_9.png"}

--获取vip图标
function VIPPub.getVipImage(mnVipType)
	return VIPPub.vipImage[mnVipType]
end

--获得VIP类型
function VIPPub.getUserVipType(mnVipLevel)
	local mnVipType = -1
	if mnVipLevel > 0 then
		local level = math.floor(mnVipLevel%100/10)
		if level == 1 then
			mnVipType = VIPPub.VIP_1
		elseif level == 2 then
			mnVipType = VIPPub.VIP_2
		elseif level == 3 then
			mnVipType = VIPPub.VIP_3
		elseif level == 4 then
			mnVipType = VIPPub.VIP_4
		elseif level == 5 then
			mnVipType = VIPPub.VIP_5
		elseif level == 6 then
			mnVipType = VIPPub.VIP_6
		elseif level == 7 then
			mnVipType = VIPPub.VIP_7
		elseif level == 8 then
			mnVipType = VIPPub.VIP_8
		elseif level == 9 then
			mnVipType = VIPPub.VIP_9
		else
			mnVipType = VIPPub.VIP_NO
		end
	elseif mnVipLevel == 0 then--普通
		mnVipType = VIPPub.VIP_NO
	else--过期
		mnVipType = VIPPub.VIP_PAST
	end
	return mnVipType
end
--判断是否是体验VIP
function VIPPub.isExperienceVip(mnVipLevel)
	local isExperience = false
	if (((mnVipLevel % 100) % 10) / 5 == 0) then
		isExperience = true
	end
	return isExperience
end

--得到Vip名称
function VIPPub.getUserVipName(mnVipType)
	local name = ""
	if mnVipType == VIPPub.VIP_1 then
		name = "VIP1"
	elseif mnVipType == VIPPub.VIP_2 then
		name = "VIP2"
	elseif mnVipType == VIPPub.VIP_3 then
		name = "VIP3"
	elseif mnVipType == VIPPub.VIP_4 then
		name = "VIP4"
	elseif mnVipType == VIPPub.VIP_5 then
		name = "VIP5"
	elseif mnVipType == VIPPub.VIP_6 then
		name = "VIP6"
	elseif mnVipType == VIPPub.VIP_7 then
		name = "VIP7"
	elseif mnVipType == VIPPub.VIP_8 then
		name = "VIP8"
	elseif mnVipType == VIPPub.VIP_9 then
		name = "VIP9"
	end
	return name
end

--获取传入的vip和自己的vip差需要支付的金额
--返回的是元宝数
function VIPPub.getUserVipChaNeedMoney(vipnum)
	if vipnum <= 0 then
		return 0
	end

	local selfvip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
	local selfczje = 0
	if selfvip > 0 then
		selfczje = VIPPub.VipCzje[selfvip]
	end
	return (VIPPub.VipCzje[vipnum] - selfczje) * GameConfig.MONEY_TO_YUANBAO
end

--获取传入的vip和自己的vip差需要支付的金额
--返回的是人民币
function VIPPub.getUserVipChaNeedMoneyRMB(vipnum)
	if vipnum <= 0 then
		return 0
	end

	local selfvip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
	local selfczje = 0
	if selfvip > 0 then
		selfczje = VIPPub.VipCzje[selfvip]
	end
	return VIPPub.VipCzje[vipnum] - selfczje
end

return VIPPub