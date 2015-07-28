--手牌层的触摸监听
module("TableOnTouch", package.seeall)

local CCTOUCHBEGAN = "began"
local CCTOUCHMOVED = "moved"
local CCTOUCHENDED = "ended"

local m_nTouchStatrIdx = -1;
local m_nTouchEndIdx = 0;
local m_bOneCard = true;

local m_anPopupArray = {};
local bStart = true;

local function inArray(an, n)
	if (an == nil) then
		return false;
	end
	for i = 1, #an do
		if (an[i] == n) then
			return true;
		end
	end
	return false;
end

local function same(srcArray, index, straightLength)
	if (#m_anPopupArray + (#srcArray - index + 1) < straightLength) then
		m_anPopupArray = {};
		return false;
	end

	if (index == #srcArray) then
		return false;
	end

	local nValue = math.abs(srcArray[index] - srcArray[index + 1]);

	if (nValue == 0) then
		if (bStart) then
			table.insert(m_anPopupArray, srcArray[index]);
			table.insert(m_anPopupArray, srcArray[index + 1]);
			bStart = false;
		else
			table.insert(m_anPopupArray, srcArray[index + 1]);
		end
	else
		bStart = true;
	end
	return true;
end


local function continuous(srcArray, index, straightLength)
	-- 如果输出数组长度与源数组剩余长度之和小于顺子长度，不必再判断
	if (#m_anPopupArray + (#srcArray - index + 1) < straightLength) then
		m_anPopupArray = {};
		return false;
	end

	if (index == #srcArray) then
		return false;
	end

	local nValue = math.abs(srcArray[index] - srcArray[index + 1]);

	if (nValue == 1) then
		if (bStart) then
			if (not inArray(m_anPopupArray, srcArray[index])) then
				table.insert(m_anPopupArray, srcArray[index]);
			end
			if (not inArray(m_anPopupArray, srcArray[index + 1])) then
				table.insert(m_anPopupArray, srcArray[index + 1]);
			end
			bStart = false;
		else
			table.insert(m_anPopupArray, srcArray[index + 1]);
		end

	elseif (nValue == 0) then
		bStart = true;
	elseif (nValue > 1) then
		bStart = true;
		if (#m_anPopupArray < straightLength) then
			m_anPopupArray = {};
		else
			return false;
		end
	end
	return true;
end


--[[--
* 判断顺子
*
* @param an
* @param length
* @return
--]]
local function getStraight(an, length)
	if (#an < length) then
		local array = {};
		return array;
	end
	m_anPopupArray = {};
	bStart = true;
	for i = 1, #an do
		if (not continuous(an, i, length)) then
			break;
		end
	end
	if (#m_anPopupArray < length) then
		local array = {};
		return array;
	end
	local array = m_anPopupArray;
	return array;
end

--[[--
* 判定是否为大飞机
*
* @param an
* @param length
* @return
--]]
local function judgeBigPlane(an, length)
	-- TODO Auto-generated method stub
	if (#an < length) then
		return false;
	end
	m_anPopupArray = {};
	local suffix = 1;
	for i = 1, #an - 2 do
		if i >= suffix then
			if (an[i] == an[i + 2] and an[i] == an[i + 1]) then
				-- 三个挨着都相等
				table.insert(m_anPopupArray, an[i]);
				suffix = suffix + 2;
			end
		end
	end
	-- 判断是不是顺子
	local array = {};
	array = m_anPopupArray;
	local temp = getStraight(array, 3);
	if (#temp ~= 0) then
		return true;
	end
	return false;
end

--[[--
* 判断连对
*
* @param an
* @param length
* @return
--]]
local function getManyTwo(an, length)
	if (#an < length) then
		local array = {};
		return array;
	end
	m_anPopupArray = {};
	bStart = true;
	-- 先找出数组中所有相等的元素
	for i = 1, #an do
		if (not same(an, i, length)) then
			break;
		end
	end
	if (#m_anPopupArray == 0) then
		local array = {};
		return array;
	end
	-- 判断是不是顺子
	local array = {};
	array = m_anPopupArray;
	local temp = getStraight(array, length / 2);
	if (#temp ~= 0) then
		local n = #temp;
		for i = 1, n do
			table.insert(temp,(i * 2), temp[i * 2 - 1]);
		end
	end
	return temp;
end

--[[--
--按下
--]]
local function onTouchBegan(x, y)
	if TableCardLayer.isShowReservedCards == true then
		TableCardLayer.refreshHandCards()
		TableCardLayer.stopReservedCardsTips()
		TableCardLayer.isShowReservedCards = false
	end
	m_nTouchStatrIdx = -1;
	for i = 1 ,table.maxn(TableCardLayer.getSelfCards()) do
		if TableCardLayer.getSelfCards()[i] ~= nil then
			if TableCardLayer.getSelfCards()[i]:click(x, y) then
				--判断选中
				m_nTouchStatrIdx  = i;--设置触摸起点
				m_nTouchEndIdx = m_nTouchStatrIdx;--设置触摸终点
				TableCardLayer.getSelfCards()[i]:setTouchMarked(true);
			end
		end
	end
end

--[[--
--滑动
--]]
local function onTouchMoved(x, y)
	if (m_nTouchStatrIdx ~= -1) then

		for i = 1 ,table.maxn(TableCardLayer.getSelfCards()) do
			if TableCardLayer.getSelfCards()[i] ~= nil then
				if TableCardLayer.getSelfCards()[i]:click(x, y) then
					--判断选中
					m_nTouchEndIdx = i;--设置触摸终点
				end
			end
		end

		if (m_nTouchStatrIdx ~= m_nTouchEndIdx) then
			--选中多张牌
			m_bOneCard = false;
			local nMinIdx;
			local nMaxIdx;
			if (m_nTouchStatrIdx < m_nTouchEndIdx) then
				nMinIdx = m_nTouchStatrIdx;
				nMaxIdx = m_nTouchEndIdx;
			else
				nMinIdx = m_nTouchEndIdx;
				nMaxIdx = m_nTouchStatrIdx;
			end
			for i = 1 ,table.maxn(TableCardLayer.getSelfCards()) do
				if TableCardLayer.getSelfCards()[i] ~= nil then
					if (i <= nMaxIdx and i >= nMinIdx) then
						TableCardLayer.getSelfCards()[i]:setTouchMarked(true);
					else
						TableCardLayer.getSelfCards()[i]:setTouchMarked(false);
					end
				end
			end

		else
			-- 只点击了一张牌
			m_bOneCard = true;
			for i = 1 ,table.maxn(TableCardLayer.getSelfCards()) do
				if TableCardLayer.getSelfCards()[i] ~= nil then
					if (i == m_nTouchEndIdx) then
						TableCardLayer.getSelfCards()[i]:setTouchMarked(true);
					else
						TableCardLayer.getSelfCards()[i]:setTouchMarked(false);
					end
				end
			end
		end

	end
end

--[[--
--抬起
--]]
local function onTouchEnded(x, y)

	if (m_nTouchStatrIdx ~= -1) then
		if (m_bOneCard) then
			if TableCardLayer.getSelfCards()[m_nTouchStatrIdx] == nil then
				return
			end

			TableCardLayer.getSelfCards()[m_nTouchStatrIdx]:setTouchMarked(false);
			TableCardLayer.getSelfCards()[m_nTouchStatrIdx]:OnSelected()

			if (TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_bSelected) then
				AudioManager.playLordSound(AudioManager.TableSound.SOUND_SELECT, false, AudioManager.SOUND);
			else
				AudioManager.playLordSound(AudioManager.TableSound.SOUND_INVERSE, false, AudioManager.SOUND);
			end

			-- 智能选牌，弹出大过上家的对子
			--			if (TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() and TableCardLayer.getHandCardsCnt() > 1) then
			--				local nWhat = -1;
			--				for i = 2, 1, -1 do
			--					if (TableCardLayer.getPlayerTableCards()[i + 1] ~= nil and #TableCardLayer.getPlayerTableCards()[i + 1] > 0) then
			--						-- 自己上家（或下家）有牌
			--						if (TableConsole.m_anPlayerCardType[i + 1] == TableCardManage.TYPE_TWO) then
			--							-- 是对牌
			--							nWhat = TableCardLayer.getPlayerTableCards()[i + 1][1].m_nWhat;
			--						end
			--						break;
			--					end
			--				end
			--				if (nWhat ~= -1) then
			--					if (not TableConsole.isLaizi(TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat)) then
			--						-- 如果选中的不是癞子,可以继续智能选择对牌
			--						if (TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat > nWhat) then
			--							if (m_nTouchStatrIdx == 1) then
			--								-- 选中的是第一张，看后一张是否相同
			--								if (TableCardLayer.getSelfCards()[m_nTouchStatrIdx + 1].m_nWhat == TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat) then
			--									TableCardLayer.getSelfCards()[m_nTouchStatrIdx + 1]:setSelected(TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_bSelected);
			--								end
			--							elseif (m_nTouchStatrIdx == TableCardLayer.getHandCardsCnt()) then
			--								-- 选中的是最后一张，看前一张是否相同
			--								if (TableCardLayer.getSelfCards()[m_nTouchStatrIdx - 1].m_nWhat == TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat) then
			--									TableCardLayer.getSelfCards()[m_nTouchStatrIdx - 1]:setSelected(TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_bSelected);
			--								end
			--							else
			--								-- 选中的是中间一张
			--								if (TableCardLayer.getSelfCards()[m_nTouchStatrIdx - 1].m_nWhat == TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat) then
			--									-- 看前一张是否相同
			--									TableCardLayer.getSelfCards()[m_nTouchStatrIdx - 1]:setSelected(TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_bSelected);
			--									for i = 1, TableCardLayer.getHandCardsCnt() do
			--										-- 将其他的牌全部放下
			--										if (i ~= m_nTouchStatrIdx and i ~= (m_nTouchStatrIdx - 1)) then
			--											TableCardLayer.getSelfCards()[i]:setSelected(false);
			--										end
			--									end
			--								elseif (TableCardLayer.getSelfCards()[m_nTouchStatrIdx + 1].m_nWhat == TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_nWhat) then
			--									-- 看后一张是否相同
			--									TableCardLayer.getSelfCards()[m_nTouchStatrIdx + 1]:setSelected(TableCardLayer.getSelfCards()[m_nTouchStatrIdx].m_bSelected);
			--									for i = 1, TableCardLayer.getHandCardsCnt() do
			--										-- 将其他的牌全部放下
			--										if (i ~= m_nTouchStatrIdx and i ~= (m_nTouchStatrIdx + 1)) then
			--											TableCardLayer.getSelfCards()[i]:setSelected(false);
			--										end
			--									end
			--								end
			--							end
			--						end
			--					end
			--				end
			--			end
		else
			local anCardsWhat = {};
			for i = 1, TableCardLayer.getHandCardsCnt() do
				if (TableCardLayer.getSelfCards()[i].m_bTouchMarked) then
					if (TableCardLayer.getSelfCards()[i].m_nWhat == 12 or TableCardLayer.getSelfCards()[i].m_nValue >= 52) then
					else
						table.insert(anCardsWhat, TableCardLayer.getSelfCards()[i].m_nWhat);
					end
				end
			end
			-- 智能选牌，弹出连对或顺子
			local an2 = getStraight(anCardsWhat, 5);
			for i = 1, #an2 do
				Common.log("an2----" .. an2[i]);
			end
			local an1_6 = getManyTwo(anCardsWhat, 6);
			local an1_8 = getManyTwo(anCardsWhat, 8);
			local an1 = {};
			if #an1_8 > 0 then
				an1 = an1_8;
			else
				if #an1_6 > 0 then
					an1 = an1_6;
				end
			end
			for i = 1, #an1 do
				Common.log("an1----" .. an1[i]);
			end
			if (#an1 ~= 0) then
				-- 判定大飞机
				if (judgeBigPlane(anCardsWhat, 9)) then
					an1 = {};
				end
			end
			if (#an2 ~= 0 and #an1 ~= 0) then
				if (#an1 / 2 == #an2) then
					-- 连对
					TableCardLayer.popupTouchCards(an1);
				else
					-- 顺子
					TableCardLayer.popupTouchCards(an2);
				end
			elseif (#an2 ~= 0) then
				TableCardLayer.popupTouchCards(an2);
			elseif (#an1 ~= 0) then
				TableCardLayer.popupTouchCards(an1);
			else
				for i = 1, table.maxn(TableCardLayer.getSelfCards()) do
					if TableCardLayer.getSelfCards()[i] ~= nil then
						if (TableCardLayer.getSelfCards()[i].m_bTouchMarked) then
							TableCardLayer.getSelfCards()[i]:OnSelected();
						end
					end
				end
			end
		end

		--if (TableConsole.m_nCurrPlayer == TableConsole.getSelfSeat()) {
		--TableConsole.refreshTakeOutBtnStatus(true);
		--}
		m_nTouchStatrIdx = -1;
		m_bOneCard = true;
	end
	for i = 1, table.maxn(TableCardLayer.getSelfCards()) do
		if TableCardLayer.getSelfCards()[i] ~= nil then
			if (TableCardLayer.getSelfCards()[i].m_bTouchMarked) then
				TableCardLayer.getSelfCards()[i]:setTouchMarked(false);
			end
		end
	end

	if TableConsole.getCurrPlayer() == TableConsole.getSelfSeat() then
		--自己的回合时，判断出牌按钮是否可用
		TableLogic.logicTakeoutButtonEnabled();
	end

	--设置明牌标志的位置
	local selfCards = TableCardLayer.getSelfCards()
	for i = 1, table.maxn(selfCards) do
		if selfCards[i] ~= nil then
			if i ==  table.maxn(selfCards) then
				TableCardLayer.setMingpaiFlagSprite(selfCards[i].m_CardSprite)
			end
		end
	end
end

--[[--
--牌桌触摸监听
--]]
function OnTouchEvent(eventType, x, y)

	if y < 45 + TableConfig.cardHeight and
		y > 45 and
		x > TableCardLayer.getCardsLeftX() and
		x < TableCardLayer.getCardsLeftX() + TableCardLayer.getAllCardsW() then
		--手牌的显示区域
		if eventType == CCTOUCHBEGAN then
			onTouchBegan(x, y)
			return true
		elseif eventType == CCTOUCHMOVED then
			onTouchMoved(x, y)
		elseif eventType == CCTOUCHENDED then
			onTouchEnded(x, y)
		end
	elseif TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE and
		x > TableConfig.StandardPos[2][1] - 50 and
		x < TableConfig.StandardPos[2][1] + 50 and
		y > TableConfig.StandardPos[2][2] - 50 and
		y < TableConfig.StandardPos[2][2] + 50 then
	--下家用户
	--		if eventType == CCTOUCHBEGAN then
	--			return true
	--		elseif eventType == CCTOUCHMOVED then
	--
	--		elseif eventType == CCTOUCHENDED then
	--			--			local player = TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(1));
	--			--			if player ~= nil then
	--			--				TableOtherUserInfoLogic.setUserPos(1)
	--			--				mvcEngine.createModule(GUI_TABLE_OTHER_USER_INFO)
	--			--				TableOtherUserInfoLogic.setOtherUserInfo(player.m_nUserID)
	--			--			end
	--			TableCardLayer.CardsPrompt()
	--		end
	elseif TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE and
		x > TableConfig.StandardPos[3][1] - 50 and
		x < TableConfig.StandardPos[3][1] + 50 and
		y > TableConfig.StandardPos[3][2] - 50 and
		y < TableConfig.StandardPos[3][2] + 50 then

	--上家用户
	--		if eventType == CCTOUCHBEGAN then
	--			return true
	--		elseif eventType == CCTOUCHMOVED then
	--
	--		elseif eventType == CCTOUCHENDED then
	--		--			local player = TableConsole.getPlayer(TableConsole.getPlayerSeatByPos(2));
	--		--			if player ~= nil then
	--		--				TableOtherUserInfoLogic.setUserPos(2)
	--		--				mvcEngine.createModule(GUI_TABLE_OTHER_USER_INFO)
	--		--				TableOtherUserInfoLogic.setOtherUserInfo(player.m_nUserID)
	--		--			end
	--		TableConsole.takeOut()
	--		end
	else
		--点击空白区域
		if eventType == CCTOUCHBEGAN then
--			Common.log("点击空白区域")
--			TableElementLayer.showTextEnd()
			m_nTouchStatrIdx = -1;
			if TableLogic.isShowTakeoutButton()then
				--出牌按钮显示中
				if x > (TableConfig.TableDefaultWidth - 600) / 2 and
					x < TableConfig.TableDefaultWidth/2 + 400 and
					y > 230 and
					y < 330 then
					Common.log("点击出牌按钮")
				else
					TableCardLayer.unSelectAllHandCards()
				end
			else
				TableCardLayer.unSelectAllHandCards()
			end
			return true
		elseif eventType == CCTOUCHMOVED then

		elseif eventType == CCTOUCHENDED then
			onTouchEnded(x, y)
		end
	end
end