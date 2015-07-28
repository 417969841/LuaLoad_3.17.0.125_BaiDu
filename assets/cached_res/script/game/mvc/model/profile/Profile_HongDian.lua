module(..., package.seeall)

local profile_HongDian_datatable = {}
local List_ChildIsNewtable = {}




--------------获取红点数据------------------------
function getMANAGERID_REQUEST_REDP_HongDian_Table()
	return profile_HongDian_datatable
end

-------------获取是否为空-------------------------
function getProfile_HongDian_datatable()
	return profile_HongDian_datatable["isNil"]
end
-------------获取活动子项是否为新--------------------
function getList_ChildIsNewtable()
	return List_ChildIsNewtable
end
--------------读取红点数据------------------------
function readMANAGERID_REQUEST_REDP(dataTable)
	Common.log("readMANAGERID_REQUEST_REDP ")
	profile_HongDian_datatable = dataTable
	profile_HongDian_datatable["isNil"] = 0
	for i = 1, #dataTable do

		if dataTable[i]["isRed"] ~="" then
			if i ==1 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_FuLi_isRed"] = 1
			elseif i ==2 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_HuoDong_isRed"] = 1
			elseif i ==3 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_SysEmali_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_XiaoXi"] = 1
			elseif i ==4 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_PersonalEmali_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_XiaoXi"] = 1
			elseif i ==5 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_Shop_DaoJu_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_Shop_isRed"] = 1
				profile_HongDian_datatable[i]["AllModule_secend_isRed"] = 1
			elseif i ==6 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_LiBao_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_Shop_isRed"] = 1
				profile_HongDian_datatable[i]["AllModule_secend_isRed"] = 1
			elseif i ==7 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_DuiJiang_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 1
				profile_HongDian_datatable[i]["AllModule_secend_isRed"] = 1
			elseif i ==8 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_SuiPian_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 1
				profile_HongDian_datatable[i]["AllModule_secend_isRed"] = 1
			elseif i ==9 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_Mygift_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 1
				profile_HongDian_datatable[i]["AllModule_secend_isRed"] = 1
			elseif i ==10 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_LianXiKeFu_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_GengDuo_isRed"] = 1
			elseif i ==11 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_Update_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_GengDuo_isRed"] = 1
			elseif i == 12 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
					Common.log("profile_HongDian_datatable===="..LordGamePub.split(dataTable[i]["isRed"], ",")[j])
				end
				Common.log("showHallHongDian==="..dataTable[i]["isRed"])
				profile_HongDian_datatable[i]["Hall_FreeCoin_isRed"] = 1
			elseif i ==13 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
					profile_HongDian_datatable[i]["ID"][j] = "1"
				end
				profile_HongDian_datatable[i]["Hall_Update_isRed"] = 1
				profile_HongDian_datatable[i]["Hall_GengDuo_isRed"] = 1
			elseif i == 14 then
				profile_HongDian_datatable[i]["ID"] = {}
				for j = 1, #LordGamePub.split(dataTable[i]["isRed"], ",") do
					profile_HongDian_datatable[i]["ID"][j] = LordGamePub.split(dataTable[i]["isRed"], ",")[j]
				end
				profile_HongDian_datatable[i]["Hall_PaiHangBang_isRed"] = 1
			end
		elseif dataTable[i]["isRed"] ==""  then
			profile_HongDian_datatable[i]["isRed"] = 0
			if i ==1    then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_FuLi_isRed"] = 0
			elseif i ==2 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_HuoDong_isRed"] = 0
			elseif i ==3 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_SysEmali_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_XiaoXi"] = 0
			elseif i ==4 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_PersonalEmali_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_XiaoXi"] = 0
			elseif i ==5 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_Shop_DaoJu_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_Shop_isRed"] = 0
			elseif i ==6 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_LiBao_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_Shop_isRed"] = 0
			elseif i ==7 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_DuiJiang_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 0
			elseif i ==8 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_SuiPian_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 0
			elseif i ==9 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_Mygift_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_Exchange_isRed"] = 0
			elseif i ==10 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_LianXiKeFu_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_GengDuo_isRed"] = 0
			elseif i ==11 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_Update_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_GengDuo_isRed"] = 0
			elseif i == 12 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_FreeCoin_isRed"] = 0
			elseif i ==13 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_Update_isRed"] = 0
				profile_HongDian_datatable[i]["Hall_CaiShen_isRed"] = 0
			elseif i == 14 then
				profile_HongDian_datatable[i]["ID"] = {}
				profile_HongDian_datatable[i]["Hall_PaiHangBang_isRed"] = 0
--				profile_HongDian_datatable[i]["Hall_PaiHangBang_isRed"] = 0
			end
		end
	end
	framework.emit(MANAGERID_REQUEST_REDP)
end

registerMessage(MANAGERID_REQUEST_REDP, readMANAGERID_REQUEST_REDP)