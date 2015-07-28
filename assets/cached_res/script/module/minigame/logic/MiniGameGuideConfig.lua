module("MiniGameGuideConfig",package.seeall)

miniGameRewarderId = 0 --跳转小游戏打赏者ID

--[[--
--小游戏引导(牌桌连胜和破产)
--]]--
function miniGameGuide()
--	if true then return end
	if HallGiftShowLogic.isShow == false then
		local miniGameGuideInfoTable = profile.MiniGame.getMiniGameGuideInfoTable()
		MiNiGameGuideTanChuKuangLogic.setChatTable(miniGameGuideInfoTable)
		mvcEngine.createModule(GUI_MINIGAMEGUIDETANCHUKUANG)
	end
end

--[[--
--设置跳转小游戏打赏者ID
--]]--
function setMiniGameRewarderId(Type)
	miniGameRewarderId = Type
end