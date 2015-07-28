module(..., package.seeall)

local ProfileTable = {}

ProfileTable["UserID"] = 10000
ProfileTable["Password"] = 10000
ProfileTable["Result"] = 10000
ProfileTable["ResultTxt"] = 10000

function getResultText()
	return ProfileTable["ResultTxt"]
end

function getResultCode()
	return ProfileTable["Result"]
end

function getResultTable()
	return ProfileTable
end

function readJHID_QUICK_START(dataTable)
	ProfileTable["Result"] = dataTable["Result"]
    ProfileTable["ResultTxt"] = dataTable["ResultTxt"]
	framework.emit(JHID_QUICK_START)
end


registerMessage(JHID_QUICK_START , readJHID_QUICK_START);