module("HongDianLogic",package.seeall)


--------------------红点------------------------
local HongDian_datatable = {}
local HongDian_image = {}
local HongDian_Shop_table ={}
local HongDian_More_Verson ={}
local HongDian_Shop_list_table = {}
local HongDian_Data_isTure = {}
local HongDian_Data_isTure_ID = {}
local HongDian_GengDuo = {}

HongDian_Data_isTure_ID[1] = {}
HongDian_Data_isTure_ID[2] = {}
HongDian_Data_isTure_ID[3] = {}
HongDian_Data_isTure_ID[4] = {}
HongDian_Data_isTure_ID[5] = {}
HongDian_Data_isTure_ID[6] = {}
HongDian_Data_isTure_ID[7] = {}
HongDian_Data_isTure_ID[8] = {}
HongDian_Data_isTure_ID[9] = {}
HongDian_Data_isTure_ID[10] = {}
HongDian_Data_isTure_ID[11] = {}

HongDian_Data_isTure[1] ={}
HongDian_Data_isTure[2] ={}
HongDian_Data_isTure[5] ={}
HongDian_Data_isTure[6] ={}
HongDian_Data_isTure[7] ={}
HongDian_Data_isTure[8] ={}
HongDian_Data_isTure[9] ={}
HongDian_Shop_list_table[1] ={}
HongDian_Shop_list_table[2] ={}
HongDian_Shop_list_table[3] ={}
HongDian_Shop_list_table[4] ={}
HongDian_Shop_list_table[5] ={}
HongDian_Shop_list_table[6] ={}
HongDian_Shop_list_table[7] ={}
HongDian_Shop_list_table[8] ={}
HongDian_Shop_list_table[9] ={}
HongDian_Shop_list_table[10] ={}
HongDian_Shop_list_table[11] ={}
HongDian_datatable["FuLi"] = {} 	--福利
HongDian_datatable["CaiShen"] = {}  --财神
HongDian_datatable["HuoDong"] = {}	--活动
HongDian_datatable["XiaoXi"] = {}	--消息
HongDian_datatable["Shop"] = {}		--商城
HongDian_datatable["Exchange"] = {}	--兑奖
HongDian_datatable["GengDuo"] = {}	--更多
HongDian_datatable["PaiHangBang"] = {}	--排行榜

local HongDian_Fuli = 1					 --1.福利(每日任务)
local HongDian_CaiShen = 2				--2.活动
local HongDian_HuoDong = 3				--3.系统邮件消息
local HongDian_XiaoXi = 4				--4.个人邮件消息
local HongDian_Shop = 5					--5.商城--道具
local HongDian_Exchange = 6				--6.商城--超值礼包
--local HongDian_GengDuo = 7				--7.兑奖卷专区有新的
local HongDian_isRed = 1			--是否显示红点

local HongDian_datatable = {}
---当前版本要请求的红点个数
HongDian_datatable[1] = {}
HongDian_datatable[2] = {}
HongDian_datatable[3] = {}
HongDian_datatable[4] = {}
HongDian_datatable[5] = {}
HongDian_datatable[6] = {}
HongDian_datatable[7] = {}
HongDian_datatable[8] = {}
HongDian_datatable[9] = {}
HongDian_datatable[10] = {}
HongDian_datatable[11] = {}
HongDian_datatable[12] = {}
HongDian_datatable[13] = {}
HongDian_datatable[14] = {}
HongDian_datatable[1]["RedPointId"] = 1   --1.福利(每日任务)
HongDian_datatable[2]["RedPointId"] = 2	  --2.活动
HongDian_datatable[3]["RedPointId"] = 3	  --3.系统邮件消息
HongDian_datatable[4]["RedPointId"] = 4	  --4.个人邮件消息
HongDian_datatable[5]["RedPointId"] = 5	  --5.商城--道具
HongDian_datatable[6]["RedPointId"] = 6	  --6.商城--超值礼包
HongDian_datatable[7]["RedPointId"] = 7   --7.兑奖卷专区有新的
HongDian_datatable[8]["RedPointId"] = 8   --8.碎片专区有新的
HongDian_datatable[9]["RedPointId"] = 9   --9.我当奖品 有可兑奖
HongDian_datatable[10]["RedPointId"] = 10 --10.联系客服
HongDian_datatable[11]["RedPointId"] = 11 --11.版本更新
HongDian_datatable[12]["RedPointId"] = 12 --12.福利列表
HongDian_datatable[13]["RedPointId"] = 13 --13.财神
HongDian_datatable[14]["RedPointId"] = 14 --14.排行榜
local HongDian_local_FuLi = nil
---活动模块中子项模块是有NEW标签
local HongDian_listChild_table = {}
--------------获取红点数据------------------------
function getMANAGERID_REQUEST_REDP_HongDian_Table()
	return HongDian_datatable
end
----------获得子模块数据
function getHongDian_Shop_table()
	return HongDian_Shop_table
end

----------获得子模块list数据
function getHongDian_Shop_list_table()
	return HongDian_Shop_list_table
end
----------获得更多数据数据
function getHongDian_GengDuo_table()
	return HongDian_GengDuo
end
----------获取福利红点的对象
function getHongDian_local_FuLi()
	return HongDian_local_FuLi
end
----------设置福利红点的对象为空
function setHongDian_local_FuLi()
	HongDian_local_FuLi = nil
end
----------显示福利红点-------------
function showHallHongDian_Fuli()
	Common.log("showHallHongDian_Fuli   1")
	btnGanTanHao_1 = UIImageView:create()
	btnGanTanHao_1:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao_1:setPosition(ccp(20, 35));
	HongDian_local_FuLi = btnGanTanHao_1
	HallLogic.btn_FreeCoin:addChild(btnGanTanHao_1)
end

----------显示财神红点-------------
function showHallHongDian_CaiShen()
	Common.log("showHallHongDian_caishen   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(20, 35));
	HallLogic.btn_caishen:addChild(btnGanTanHao)
	HongDian_More_Verson[13] = btnGanTanHao
end

----------显示活动红点-------------
function showHallHongDian_HuoDong()
	Common.log("showHallHongDian_HuoDong   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(20, 35));
	HallLogic.btn_hall_huodong:addChild(btnGanTanHao)
end



----------显示消息红点-------------
function showHallHongDian_XiaoXi()
	Common.log("showHallHongDian_Xiaoxi   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(43, 15));
	HallLogic.btn_message:addChild(btnGanTanHao)
end

----------显示商城红点-------------
function showHallHongDian_Shop()
	Common.log("showHallHongDian_Shop   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(43, 15));
	HallLogic.btn_shop:addChild(btnGanTanHao)
end
----------显示商城红点子项道具的红点---------
function showHongDian_Shop_DaoJu()
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	btnGanTanHao:setPosition(ccp(43, 15));
end
----------显示兑奖红点-------------
function showHallHongDian_Exchange()
	Common.log("showHallHongDian_exchage   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(43, 15));
	HallLogic.btn_gift:addChild(btnGanTanHao)
end

----------显示更多红点-------------
function showHallHongDian_GengDuo()
	Common.log("showHallHongDian_gengduo   1")
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(43, 15));
	HongDian_GengDuo[1] = btnGanTanHao
	HallLogic.btn_setting:addChild(btnGanTanHao)
end

----------显示排行榜红点-------------
function showHallHongDian_PaiHangBang()
	btnGanTanHao = UIImageView:create()
	btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
	local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
	btnGanTanHao:setPosition(ccp(43, 15));
	HallLogic.btn_rankinglist:addChild(btnGanTanHao)
end

--显示大厅红点
function showHallHongDian()
	HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	for i = 1, #HongDian_datatable do
		if #HongDian_datatable[i]["ID"] >=1 then
			if i == 1 then
--				showHallHongDian_Fuli()
			elseif i==2 then
				showHallHongDian_HuoDong()
			elseif i==3 or i==4 then
			--	showHallHongDian_XiaoXi()
			elseif i==5 or i==6 then
				showHallHongDian_Shop()
			elseif i==7 or i==8 or i==9 then
				showHallHongDian_Exchange()
			elseif i==10 or i==11 then
				showHallHongDian_GengDuo()
			elseif i == 12 then
				showHallHongDian_Fuli()
			elseif i==13 then
				showHallHongDian_CaiShen()
			elseif i == 14 then
				showHallHongDian_PaiHangBang()
			end
		end
	end
end

------显示模块子项列表NEW标签
function showAllChild_List_NewLabel(moduleID, ID, layout)
	Common.log("layout:addChild(isNewLabel)")
	HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	for i = 1, #HongDian_datatable do
		if moduleID == i then
			for j = 1, #HongDian_datatable[i]["ID"] do

				if HongDian_datatable[i]["ID"][j] == ID.."" then

					if moduleID == 2  then
						Common.log("moduleID2_CCSprite")
						local HongDian_New_lable = UIImageView:create()
						HongDian_New_lable:loadTexture(Common.getResourcePath("new_hongdian.png"))
						Common.log("moduleID2_CCSprite")
						HongDian_New_lable:setPosition(ccp(-520, layout:getContentSize().height-40))
						Common.log("moduleID2_CCSprite")
						layout:addChild(HongDian_New_lable)
						Common.log("moduleID2_CCSprite")
						HongDian_Shop_list_table[moduleID][ID] = HongDian_New_lable
					elseif moduleID == 5 or  moduleID == 6 then
						local btnGanTanHao = UIImageView:create()
						btnGanTanHao:loadTexture(Common.getResourcePath("new_hongdian.png"))
						btnGanTanHao:setPosition(ccp(-75, layout:getContentSize().height+45))
						layout:addChild(btnGanTanHao)
						HongDian_Shop_list_table[moduleID][ID] = btnGanTanHao
					elseif moduleID == 7 or  moduleID == 8 or moduleID == 9  then
						local btnGanTanHao_7_8 = UIImageView:create()
						btnGanTanHao_7_8:loadTexture(Common.getResourcePath("new_hongdian.png"))
						btnGanTanHao_7_8:setPosition(ccp(-90, layout:getContentSize().height-140))
						layout:addChild(btnGanTanHao_7_8)
						HongDian_Shop_list_table[moduleID][ID] = btnGanTanHao_7_8
					end
				end
			end
		end
	end
end







----显示子模块红点
function showAllModule_HongDian(ModuleID,layout)
	HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	if ModuleID==5 or ModuleID==6 then
		if #HongDian_datatable[ModuleID]["ID"] >= 1 then
			btnGanTanHao = UIImageView:create()
			btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
			btnGanTanHao:setPosition(ccp(50, 15));
			btnGanTanHao:setTag(1)

			layout:addChild(btnGanTanHao)
			HongDian_Shop_table[ModuleID] = btnGanTanHao
		end
	end
	if ModuleID==7 or ModuleID==8 or ModuleID==9 then
		if #HongDian_datatable[ModuleID]["ID"] >= 1 then
			btnGanTanHao = UIImageView:create()
			btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
			btnGanTanHao:setPosition(ccp(75, 15));
			btnGanTanHao:setTag(1)

			layout:addChild(btnGanTanHao)
			HongDian_Shop_table[ModuleID] = btnGanTanHao
		end
	end


end
----显示大厅---更多红点中联系客服红点
function showHall_more_Verson(layout,layoutVerson)
	HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	if HongDian_datatable[10]["isRed"] =="1" then
		btnGanTanHao = UIImageView:create()
		btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
		local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
		local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
		btnGanTanHao:setPosition(ccp(40, 40));
		SettingLogic.btn_kefu:addChild(btnGanTanHao)
		Common.log("HongDian_More_Verson[10]")
		HongDian_More_Verson[10] = btnGanTanHao
	end
	if HongDian_datatable[11]["isRed"] =="1" then
		Common.log("HongDian_datatable[11]")
		btnGanTanHao = UIImageView:create()
		btnGanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
		local HongdDian_X = HallLogic.btn_FreeCoin:getSize().width / 2
		local HongdDian_Y = HallLogic.btn_FreeCoin:getSize().height / 2
		btnGanTanHao:setPosition(ccp(65, 15));
		SettingLogic.btn_version:addChild(btnGanTanHao)
		Common.log("HongDian_More_Verson[11]")
		HongDian_More_Verson[11] = btnGanTanHao
	end
end

-----消除列表中new标签
function removeList_New_Label(moduleId,layout, taskId)
	HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	Common.log("sendMANAGERID_REMOVE_REDPmac"..taskId)
	for i = 1 , #HongDian_datatable [moduleId]["ID"] do
		Common.log("sendMANAGERID_REMOVE_REDPmac"..taskId)
		if HongDian_datatable [moduleId]["ID"][i] == taskId.."" then
			HongDian_datatable [moduleId]["ID"][i] =nil
			if moduleId == 2 then
				HongDian_Shop_list_table[moduleId][taskId]:setVisible(false)
			else
				Common.log("sendMANAGERID_REMOVE_REDPmac"..taskId)
				if HongDian_Shop_list_table[moduleId][taskId] ~= nil then
					HongDian_Shop_list_table[moduleId][taskId]:setVisible(false)
					Common.log("sendMANAGERID_REMOVE_REDPmac"..taskId)
					sendMANAGERID_REMOVE_REDP(moduleId,taskId)
				end
			end
		end
	end

end


-----清楚数据
function setHongDian_Shop_table_null()
	HongDian_Shop_table ={}
end
---清楚list数据
function setHongDian_Shop_list_table_null()
	HongDian_Shop_list_table = {}
	HongDian_Shop_list_table[1] ={}
	HongDian_Shop_list_table[2] ={}
	HongDian_Shop_list_table[3] ={}
	HongDian_Shop_list_table[4] ={}
	HongDian_Shop_list_table[5] ={}
	HongDian_Shop_list_table[6] ={}
	HongDian_Shop_list_table[7] ={}
	HongDian_Shop_list_table[8] ={}
	HongDian_Shop_list_table[9] ={}
	HongDian_Shop_list_table[10] ={}
	HongDian_Shop_list_table[11] ={}
end

function removeshowHall_more_Verson(id)
	if id == 10 then
		if 	HongDian_More_Verson[10] ~= nil then
			--HongDian_More_Verson[id]:setVisible(false)
			HongDian_More_Verson[id]= nil
			HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
			HongDian_datatable[10]["isRed"] = ""
			sendMANAGERID_REMOVE_REDP(10, 1)
		end
	end
	Common.log("HongDian_More_Verson")
	if id == 11 then
		if HongDian_More_Verson[11] ~= nil  then
			Common.log("HongDian_More_Verson11")
			HongDian_More_Verson[id]:setVisible(false)
			HongDian_More_Verson[id]= nil
			HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
			HongDian_datatable[11]["isRed"] = ""
			Common.log("HongDian_More_Verson")
			sendMANAGERID_REMOVE_REDP(11, 1)
		end
	end
	if id == 13 then
		Common.log("HongDian_More_Verson[13]")
		if HongDian_More_Verson[13] ~= nil and HongDian_More_Verson[13] ~= "" then
			HongDian_More_Verson[13]:setVisible(false)
			HongDian_More_Verson[13]= nil
			HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
			HongDian_datatable[13]["isRed"] = ""
		end
		sendMANAGERID_REMOVE_REDP(13, 1)
	end
end

-------红点服务器数据监测方法-------------
function getHongDian_Data_isTure(moduleId, i, taskId, complete)
	HongDian_Data_isTure[moduleId][i] = taskId
	Common.log("HongDian_Data_isTure[moduleId][i]"..taskId)
	if complete ~= nil then
		Common.log("HongDian_Data_isTure[moduleId][i]complete"..taskId)
		HongDian_Data_Table_isTure_profile = {}
		HongDian_Data_Table_isTure_profile = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
		for j = 1 , #HongDian_Data_isTure[moduleId] do
			if HongDian_Data_Table_isTure_profile[moduleId] ~= nil then
				for z = 1 , #HongDian_Data_Table_isTure_profile[moduleId]["ID"] do
					if HongDian_Data_Table_isTure_profile[moduleId]["ID"][z] == HongDian_Data_isTure[moduleId][j].."" then
						HongDian_Data_isTure_ID[moduleId][j] = z
						Common.log("HongDian_Data_isTure_ID z and j is " .. z .. ";" .. j .. "HongDian_Data_Table_isTure_profile " .. HongDian_Data_Table_isTure_profile[moduleId]["ID"][z])
					end
				end
			end
		end


		if HongDian_Data_Table_isTure_profile[moduleId] ~= nil then

			for f = 1,	#HongDian_Data_Table_isTure_profile[moduleId]["ID"]  do
				local ID_profile_ISture = false
				for x = 1 , #HongDian_Data_isTure_ID[moduleId] do
					if HongDian_Data_isTure_ID[moduleId][x] == f then
						ID_profile_ISture = true
					end
				end
				if ID_profile_ISture == false then

					local TaskId_tonumber = tonumber(HongDian_Data_Table_isTure_profile[moduleId]["ID"][f])

					sendMANAGERID_REMOVE_REDP(moduleId, TaskId_tonumber)
					HongDian_Data_Table_isTure_profile[moduleId]["ID"][f] = nil
				end
			end
		end
	end
end
