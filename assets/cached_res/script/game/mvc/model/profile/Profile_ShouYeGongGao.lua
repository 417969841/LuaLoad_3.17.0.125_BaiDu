module(..., package.seeall)

local BindPhoneTable = {}
local BASEID_V2_GET_POP_NOTICETable = {}
local LastNoticeTimeStamp = 0;--上一个公告的时间

--[[--
--加载上一次公告时间戳
--]]
local function loadLastNoticeTimeStamp()
	LastNoticeTimeStamp = Common.LoadTable("LastNoticeTimeStamp");
	if LastNoticeTimeStamp == nil then
		LastNoticeTimeStamp = 0;
	end
end

loadLastNoticeTimeStamp();

function getLastNoticeTimeStamp()
	return LastNoticeTimeStamp;
end

--[[--
--获取公告内容
]]
function getBASEID_V2_GET_POP_NOTICETable()
	return BASEID_V2_GET_POP_NOTICETable
end

function readBASEID_V2_GET_POP_NOTICE(dataTable)
	BASEID_V2_GET_POP_NOTICETable = dataTable
	Common.SaveTable("LastNoticeTimeStamp", BASEID_V2_GET_POP_NOTICETable["time"])
	framework.emit(BASEID_V2_GET_POP_NOTICE)
end

registerMessage(BASEID_V2_GET_POP_NOTICE, readBASEID_V2_GET_POP_NOTICE)