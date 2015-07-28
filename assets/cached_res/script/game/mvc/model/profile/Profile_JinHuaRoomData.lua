module(..., package.seeall)

local JinHuaRoomListTable = {};
JinHuaRoomListTable["TimeStamp"] = 0;
JinHuaRoomListTable["Rooms"] = {};


--[[--
--加载本地房间列表数据
]]
local function loadJinHuaRoomListTable()
	JinHuaRoomListTable = Common.LoadTable("JinHuaRoomListTable");
	if JinHuaRoomListTable == nil then
		JinHuaRoomListTable = {};
		JinHuaRoomListTable["TimeStamp"] = 0;
		JinHuaRoomListTable["Rooms"] = {};
	end
end

loadJinHuaRoomListTable()


--[[--
--获取金花房间信息的时间戳
--]]--
function getTimeStamp()
	--	local value = tonumber(JinHuaRoomListTable["TimeStamp"]);
	local value = 0;
	if value == nil then
		return 0;
	else
		return value;
	end
end

--[[--
--获取金花房间信息的时间戳
--]]--
function setTimeStamp(value)
	JinHuaRoomListTable["TimeStamp"] = value
end

--[[房间列表]]
function readJINHUA_ROOMID_ROOM_LIST(dataTable)
	Common.log("readJINHUA_ROOMID_ROOM_LIST");
	if JinHuaRoomListTable["TimeStamp"] ~= dataTable["TimeStamp"] then
		JinHuaRoomListTable["TimeStamp"] = dataTable["TimeStamp"];

		if #JinHuaRoomListTable["Rooms"] == 0 then
			JinHuaRoomListTable = dataTable
		else
			local NewRoomList = {};--新增的房间列表
			for i=1,#JinHuaRoomListTable["Rooms"] do
				--时间戳虽然改变, 房间列表信息返回的不是全部的全部的房间信息,而是改变的房间信息
				for j=1,#dataTable["Rooms"] do
					if JinHuaRoomListTable["Rooms"][i].roomID == dataTable["Rooms"][j].roomID then
						--如果是已有的房间信息,则重新更新对应ID的房间信息
						JinHuaRoomListTable["Rooms"][i] = {}
						JinHuaRoomListTable["Rooms"][i] = dataTable["Rooms"][j];
						break;
					end
				end
			end
		end
		Common.SaveTable("JinHuaRoomListTable", JinHuaRoomListTable);
	end

	framework.emit(JINHUA_ROOMID_ROOM_LIST);
end

--[[--
--获取金花房间列表信息
--]]
function getJinHuaRoomTable()
	return JinHuaRoomListTable["Rooms"];
end

--[[--
--根据ID获取金花的房间信息
--]]
function getRoomById(roomId)
	if JinHuaRoomListTable["Rooms"] then
		for i = 1,#JinHuaRoomListTable["Rooms"] do

			if JinHuaRoomListTable["Rooms"][i] and JinHuaRoomListTable["Rooms"][i].roomID == roomId then
				return JinHuaRoomListTable["Rooms"][i];
			end

		end
	end

	return nil;
end

function readJHID_ENTER_ROOM(dataTable)
	RoomListTable["enterRoomACK"] = dataTable
	framework.emit(JHID_ENTER_ROOM)
end

registerMessage(JINHUA_ROOMID_ROOM_LIST , readJINHUA_ROOMID_ROOM_LIST);
registerMessage(JHID_ENTER_ROOM , readJHID_ENTER_ROOM);