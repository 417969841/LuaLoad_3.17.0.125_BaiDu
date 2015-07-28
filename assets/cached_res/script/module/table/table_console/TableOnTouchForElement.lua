--控件层的触摸监听
module("TableOnTouchForElement", package.seeall)

local CCTOUCHBEGAN = "began"
local CCTOUCHMOVED = "moved"
local CCTOUCHENDED = "ended"

--[[--
--牌桌触摸监听
--]]
function OnTouchEvent(eventType, x, y)
	if TableConsole.m_nGameStatus >= TableConsole.STAT_SETOUT and
		x > TableConfig.StandardPos[2][1] - 50 and
		x < TableConfig.StandardPos[2][1] + 50 and
		y > TableConfig.StandardPos[2][2] - 50 and
		y < TableConfig.StandardPos[2][2] + 50 then
		--下家用户

		if eventType == CCTOUCHBEGAN then
			return true
		elseif eventType == CCTOUCHMOVED then

		elseif eventType == CCTOUCHENDED then
			local player = TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(1));
			if player ~= nil then
				if TableConsole.mode == TableConsole.MATCH then
					--如果是比赛模式，则不弹出其他用户信息弹窗
					Common.showToast("比赛中不能查看个人资料", 1)
					return
				end
				TableOtherUserInfoLogic.setUserPos(1)
				TableOtherUserInfoLogic.setOtherUserInfo(player.m_nUserID)
				--				TableOtherUserInfoLogic.setFromFlag(TableOtherUserInfoLogic.FROM_TABLE);--跳转标记
				TableOtherUserInfoLogic.setFromFlag(3) --3 由牌桌跳转而来
				mvcEngine.createModule(GUI_TABLE_OTHER_USER_INFO)
			end
		end
	elseif TableConsole.m_nGameStatus >= TableConsole.STAT_SETOUT and
		x > TableConfig.StandardPos[3][1] - 50 and
		x < TableConfig.StandardPos[3][1] + 50 and
		y > TableConfig.StandardPos[3][2] - 50 and
		y < TableConfig.StandardPos[3][2] + 50 then
		--上家用户
		if eventType == CCTOUCHBEGAN then
			return true
		elseif eventType == CCTOUCHMOVED then

		elseif eventType == CCTOUCHENDED then
			local player = TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(2));
			if player ~= nil then
				if TableConsole.mode == TableConsole.MATCH then
					--如果是比赛模式，则不弹出其他用户信息弹窗
					Common.showToast("比赛中不能查看个人资料", 1)
					return
				end
				TableOtherUserInfoLogic.setUserPos(2)
				TableOtherUserInfoLogic.setFromFlag(3)  --3 由牌桌跳转而来
				TableOtherUserInfoLogic.setOtherUserInfo(player.m_nUserID)
				--				TableOtherUserInfoLogic.setFromFlag(TableOtherUserInfoLogic.FROM_TABLE);--跳转标记
				mvcEngine.createModule(GUI_TABLE_OTHER_USER_INFO)
			end
		end
	end
end