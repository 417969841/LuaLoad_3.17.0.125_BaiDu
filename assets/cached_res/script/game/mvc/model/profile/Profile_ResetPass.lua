module(..., package.seeall)

local ResetPassTable = {}

ResetPassTable["ResetPass"]={}
ResetPassTable["ResetPass"].Result = -1
ResetPassTable["ResetPass"].ResultTxt = ""
ResetPassTable["ResetPass"].NewPassword = ""

--[[--
--Result
]]
function getResult()
    local value = ResetPassTable["ResetPass"].Result
    if value == nil then
        return -1
    else
        return value
    end
end

function setResult(result)
    ResetPassTable["ResetPass"].Result = result
end

--[[--
--ResultText
]]
function getResultText()
    local value = ResetPassTable["ResetPass"].ResultTxt
    if value == nil then
        return ""
    else
        return value
    end
end

function setResultText(resultText)
    ResetPassTable["ResetPass"].ResultTxt = resultText
end


--[[--
--NewPassword
]]
function getNewPassword()
    local value = ResetPassTable["ResetPass"].NewPassword
    if value == nil then
        return ""
    else
        return value
    end
end

function setNewPassword(newpassword)
    ResetPassTable["ResetPass"].NewPassword = newpassword
end

function setResetPass(dataTable)
    ResetPassTable["ResetPass"] = dataTable
    framework.emit(DBID_FIND_PASSWORD)
end

registerMessage(DBID_FIND_PASSWORD, setResetPass)