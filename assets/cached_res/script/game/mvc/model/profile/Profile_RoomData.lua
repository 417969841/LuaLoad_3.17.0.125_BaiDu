module(..., package.seeall)

local RoomListTable = {}

RoomListTable["TimeStamp"] = 0
RoomListTable["Room"] = {}
RoomListTable["SendTimes"] = 0 --发送次数
RoomListTable["updataRoomCnt"] = -1  --0是更新激战人数，大于0更新房间列表

RoomListTable["jzTable"] = {}--激战人数
RoomListTable["enterRoomACK"] = {}--进入牌桌应答


--[[--
--加载本地房间列表数据
]]
local function loadRoomListTable()
	RoomListTable = Common.LoadTable("TordRoomList")
	if RoomListTable == nil then
		RoomListTable = {}
		RoomListTable["TimeStamp"] = 0
		RoomListTable["SendTimes"] = 0
		RoomListTable["updataRoomCnt"] = -1
		RoomListTable["Room"] = {}
	end
end

loadRoomListTable()


--[[时间戳]]
function getTimestamp()
	local value = RoomListTable["TimeStamp"]
	if value == nil then
		return 0
	else
		return value
	end
end

function setTimestamp(value)
	RoomListTable["TimeStamp"] = value
end

--[[更新数量]]
function getUpdataRoomCnt()
	local value = RoomListTable["updataRoomCnt"]
	if value == nil then
		return 0
	else
		return value
	end
end

function setUpdataRoomCnt(value)
	RoomListTable["updataRoomCnt"] = value
end

--[[发送次数]]
function getSendTimes()
	local value = RoomListTable["SendTimes"]
	if value == nil then
		return 0
	else
		return value
	end
end

function setSendTimes(value)
	RoomListTable["SendTimes"] = value
end

--[[房间列表]]
function setRoomTable(dataTable)
	--0是更新激战人数，大于0更新房间列表
	if dataTable["updataRoomCnt"] == 0 then
		--时间戳一样，更新激战人数
		RoomListTable["updataRoomCnt"] = 0
		Common.log("重新加载房间列表---激战人数"..#RoomListTable["Room"]..#dataTable["Room"])
		for i=1,#RoomListTable["Room"] do
			for j=1,#dataTable["Room"] do
				if RoomListTable["Room"][i].RoomID == dataTable["Room"][j].RoomID then
					RoomListTable["Room"][i].playerCnt = dataTable["Room"][j].playerCnt
				end
			end
		end
	else
--		Common.log("重新加载房间列表，时间戳不一样"..RoomListTable["TimeStamp"].."---"..dataTable["TimeStamp"])
		RoomListTable = dataTable
		Common.SaveTable("TordRoomList", RoomListTable)
	end

	framework.emit(ROOMID_ROOM_LIST_NEW)
end

function getRoomTable()
	return RoomListTable["Room"]
end

function getRoomById(roomId)
	if RoomListTable["Room"] then
		for i = 1,#RoomListTable["Room"] do
			if RoomListTable["Room"][i] and RoomListTable["Room"][i].roomID == roomId then
				return RoomListTable["Room"][i]
			end
		end
	end
	return nil
end

function getEnterRoomACK()
	return RoomListTable["enterRoomACK"]
end

registerMessage(ROOMID_ROOM_LIST_NEW, setRoomTable)
