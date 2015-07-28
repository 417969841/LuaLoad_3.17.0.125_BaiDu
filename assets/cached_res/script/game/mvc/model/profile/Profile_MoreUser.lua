module(..., package.seeall)

local MoreUserTable = {}

MoreUserTable["cnt"] = 0
MoreUserTable["usernameTable"] = {}
MoreUserTable["telnum"] = 0
MoreUserTable["LoginWithMore"] = ""

local NickCnt = 0;

function initProfile()
	for key, value in pairs(MoreUserTable) do
		MoreUserTable[key] = nil
	end
end

function getNickNameNum()
	return NickCnt;
end

function setMoreUserData(dataTable)
	MoreUserTable["cnt"] = dataTable["TotalBindCnt"]
	NickCnt = MoreUserTable["cnt"]
	for i = 1, NickCnt do
		MoreUserTable["usernameTable"][i] = {}
		--…NickName  昵称
		MoreUserTable["usernameTable"][i].NickName = dataTable["NickTable"][i].NickName
		MoreUserTable["usernameTable"][i].UserAvator = dataTable["NickTable"][i].UserAvator
	end
	MoreUserTable["telnum"] = dataTable["BindingMobile"]


	framework.emit(BASEID_GET_IMEIUSERS)
end

function getCnt()
	local value = MoreUserTable["cnt"]
	if value == nil then
		return 0
	else
		return value
	end
end

function getTelnum()
	local value = MoreUserTable["telnum"]
	if value == nil then
		return 0
	else
		return value
	end
end

function getUsernameTable()
	local value = MoreUserTable["usernameTable"]
	if value == nil then
		return 0
	else
		return value
	end
end

--[[--
--LoginWithMore
]]
function getLoginWithMore()
	local value = MoreUserTable["LoginWithMore"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setLoginWithMore(loginWithMore)
	--此方法为客户端信号，不用注册
	MoreUserTable["LoginWithMore"] = loginWithMore
	framework.emit(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME)
end

--[[--
--删除一条用户信息
--]]
function deleteOneUserInfo(index)
	table.remove(MoreUserTable["usernameTable"], index);
end

registerMessage(BASEID_GET_IMEIUSERS, setMoreUserData)