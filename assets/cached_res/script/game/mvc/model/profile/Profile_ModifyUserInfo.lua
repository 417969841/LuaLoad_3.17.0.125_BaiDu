module(..., package.seeall)

local ModifyUserInfo = {}

ModifyUserInfo["Result"] = 2 -- 2是初始值，0是成功 1是失败
ModifyUserInfo["ResultText"] = ""

--[[--
--Result
]]
function getResult()
	local value = ModifyUserInfo["Result"]
	if value == nil then
		return 2
	else
		return value
	end
end

function setResult(result)
	ModifyUserInfo["Result"] = result
end

--[[--
--ResultText
]]
function getResultText()
	local value = ModifyUserInfo["ResultText"]
	if value == nil then
		return ""
	else
		return value
	end
end

function setResultText(resultText)
	ModifyUserInfo["ResultText"] = resultText
end

--[[--
--获取修改个人信息
]]
function setModifyUserInfo(dataTable)
	local result = dataTable["Result"]
	local resultText = dataTable["ResultTxt"]
	ModifyUserInfo["Result"] = result
	ModifyUserInfo["ResultText"] = resultText

	framework.emit(BASEID_EDIT_BASEINFO)
end

registerMessage(BASEID_EDIT_BASEINFO, setModifyUserInfo)