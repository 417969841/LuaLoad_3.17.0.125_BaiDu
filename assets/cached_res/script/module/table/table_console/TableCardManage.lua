module("TableCardManage", package.seeall)

-- 排序类型
SORT_MODE_SAMECOUNT = 0;--以相同牌的数量排序(三带二,四带二)
SORT_MODE_WHAT = 1;--大小排序
SORT_MODE_COLOR = 2;--花色排序

local xCardWhat = -1;-- 癞子牌值

local mnSortMethod = 0;

local m_bFirstSearch = true;
local m_cnSearch;
local m_nCurSearch;
local SelfCards = {};
local m_SearchInfo = {};
local SelfCardsNum;
-- 临时存放手牌
local tempSelfCards = {};
local tempSelfCardsNum;

local newArrayCnt;

local CARD_2 = 12;
local CARD_3 = 0;
local GL_MAX_SEARCHCOUNT = 17;
local GL_MAX_CARDSPERSIDE = 17;

TYPE_INVALIDATE = 0; -- 错误类型
TYPE_ONE = 1; -- 单张
TYPE_TWO = 2; -- 对，要有多少对的说明
TYPE_THREE = 3; -- 三同张，要有多少对的说明
TYPE_STRAIGHT = 4; -- 顺子，5张或更多的连张
TYPE_THREE_ONE = 5; -- 三带1
TYPE_THREE_SAMETWO = 6; -- 三带1对
TYPE_FOUR_TWO = 7; -- 4带二
TYPE_FOUR_SAMETWO = 8; -- 4带1对
TYPE_FOUR_TWOSAMETWO = 9; -- 4带2对
TYPE_MANY_TWO = 10;-- 连对
TYPE_MANY_THREE_ONE = 11;-- 飞机(带一张)
TYPE_MANY_THREE = 12;-- 飞机()
TYPE_MANY_THREE_TWO = 13;-- 飞机(带一对)
TYPE_FOUR = 14; -- 四同张，炸弹
TYPE_TWO_CAT = 15;-- 火箭

CARD_TYPE = { "0-错误类型", "单张", "对", "三同张", "顺子", "三带一", "三带一对", "四带二", "四带一对", "四带二对","连对", "飞机", "飞机", "飞机", "炸弹", "火箭" };

--[[--
--设置是否是第一次搜索
--]]
function setFirstSearch(isFirst)
	m_bFirstSearch = isFirst;
end

--[[--
--初始化数据
--]]
function initData(aSelfCards)
	m_bFirstSearch = true;
	m_cnSearch = 1;
	m_nCurSearch = 1;
	SelfCards = aSelfCards;
	SelfCardsNum = #aSelfCards;
	m_SearchInfo = {};
	if TableConsole.mnTableType == TableConsole.TABLE_TYPE_OMNIPOTENT then
		xCardWhat = TableConsole.mnLaiziCardVal % 13;
	else
		xCardWhat = -1;
	end
	--Common.log("xCardWhat === "..xCardWhat)
	for i = 1, GL_MAX_SEARCHCOUNT do
		local searchInfo = SearchInfo:new();
		table.insert(m_SearchInfo, searchInfo);
	end
end

--[[--
-- 牌比较函数，nVal和nVal2最高位字节用来作为同类牌的计数
--
--]]
local function CardCompare(card1, card2)
	local nVal1 = card1.m_nValue;
	local nVal2 = card2.m_nValue;
	local nWhat1 = card1.m_nWhat;
	local nWhat2 = card2.m_nWhat;
	local nColor1 = card1.m_nColor;
	local nColor2 = card2.m_nColor;
	local nWeight1 = card1.m_nSameCardCnt;
	local nWeight2 = card2.m_nSameCardCnt;

	if mnSortMethod == SORT_MODE_WHAT then
		if (nWhat1 ~= nWhat2) then
			if (TableConsole.isLaizi(nWhat1) and nWhat1 ~= 13 and nWhat1 ~= 14) then
				return true;
			elseif (TableConsole.isLaizi(nWhat2) and nWhat2 ~= 13 and nWhat2 ~= 14) then
				return false;
			end
			return nWhat2 < nWhat1;
		end
		return nColor2 < nColor1;
	elseif mnSortMethod == SORT_MODE_COLOR then
		if (nColor1 ~= nColor2) then
			return nColor2 < nColor1;
		end
		return nWhat2 < nWhat1;
	elseif mnSortMethod == SORT_MODE_SAMECOUNT then
		if (nWeight1 ~= nWeight2) then
			return nWeight2 < nWeight1;
		end
		if (nWhat1 ~= nWhat2) then
			return nWhat2 < nWhat1;
		end
		return nColor2 < nColor1;
	end

	return false;
end

function SortCardVal(cardsTable, nSortMethod)
	if cardsTable == nil then
		return cardsTable
	end
	mnSortMethod = nSortMethod
	local nVal;
	local cnSame = 0;

	if (mnSortMethod == SORT_MODE_SAMECOUNT) then
		-- 只有此类排序需要附加数据，附加数据放在最高字节

		for i = 1, table.maxn(cardsTable) do
			if cardsTable[i] ~= nil then
				cardsTable[i].m_nSameCardCnt = -1;
			end
		end

		for i = 1, table.maxn(cardsTable) do
			if (cardsTable[i] ~= nil and cardsTable[i].m_nSameCardCnt == -1) then
				nVal = cardsTable[i].m_nWhat;
				cnSame = 0;

				for j = 1, table.maxn(cardsTable) do
					if (cardsTable[j] ~= nil and cardsTable[j].m_nWhat == nVal) then
						cnSame = cnSame + 1;
					end
				end

				for j = 1, table.maxn(cardsTable) do
					if (cardsTable[j] ~= nil and cardsTable[j].m_nWhat == nVal) then
						cardsTable[j].m_nSameCardCnt = cnSame;
					end
				end

			end
		end
	end

	table.sort(cardsTable, CardCompare)
end

--[[--
--判断是否同样的牌
--@param #table cardList 纸牌数组
--@param #number Start 开始位置（下标）
--@param #number nCount 判断几张牌
--@param #number nCardCnt 一共几张牌
--]]
local function IsSameCard(cardList, Start, nCount, nCardCnt)
	--lua的数组下表从1开始
	local nStart = Start + 1
	if (cardList[1].m_nValue >= 52) then
		--有王牌
		return false;
	end

	local nWhat = 0;

	if (nStart >= #cardList or nStart + nCount - 1 > #cardList) then
		return false;
	end

	nWhat = cardList[nStart].m_nWhat;
	for i = nStart + 1, nStart + nCount - 1 do
		if (i > nCardCnt) then
			return false;
		end
		if (cardList[i].m_nWhat ~= nWhat) then
			return false;
		end
	end
	return true;
end

--[[--
-- 判断是否所有牌是王
--@param #table cardList 纸牌数组
--@param #number nCardCnt 一共几张牌
--]]
local function IsAllCat(cardList, nCardCnt)
	for i = 1, nCardCnt do
		if (cardList[i].m_nValue < 52) then
			--如果有牌小于52，则不是王牌
			return false;
		end
	end
	return true;
end

--[[--
--判断是否是顺子
--]]
local function IsStraight(cardList, cnCard)
	local nWhat = 0;
	local cnt = 0;

	if (cnCard < 5) then
		return false;
	end

	nWhat = cardList[1].m_nWhat;--如果是顺子，则是最大值
	for j = 1, cnCard do
		if (nWhat ~= cardList[j].m_nWhat) then
			break;
		end
		-- 2 不能在顺子中
		if (cardList[j].m_nWhat == CARD_2) then
			return false;
		end
		nWhat = nWhat - 1;
		cnt = cnt + 1
	end
	if (cnt >= cnCard) then
		return true;
	else
		return false;
	end
end

--[[--
--检查是否有王
--]]
local function HaveCat(cardList, cnCard)
	for i = 1, cnCard do
		if (cardList[i].m_nValue >= 52) then
			return true;
		end
	end
	return false;
end

--[[--
--得到相同多张的数量
--]]
local function HaveMultiSame(cardList, cnCard, nMulti)
	local nSame = 0;
	for i = 1, cnCard, nMulti do
		-- 2 不能出现
		if (cardList[i].m_nWhat == CARD_2) then
			return 0;
		end
		if (not IsSameCard(cardList, i - 1, nMulti, cnCard)) then
			return 0;
		end
		nSame = nSame + 1;
	end
	return nSame;
end

--[[--
--判断是否多个连续
-- @param cardList
-- @param cnCard
-- @param nMulti
-- @return
--]]
local function IsMultiContinue(cardList, cnCard, nMulti)
	local cnt = 0
	local nWhat = cardList[1].m_nWhat;
	for j = 1, cnCard, nMulti do
		if (cardList[j].m_nWhat ~= nWhat) then
			break;
		end
		nWhat = nWhat - 1;
		cnt = cnt + nMulti
	end
	if (cnt >= cnCard) then
		return true;
	else
		return false;
	end
	return false;
end

--[[--
--检查是否多对
--]]
local function IsManySame2(cardList, cnCard)
	if (cnCard < 6) then
		return false;
	end
	if ((cnCard % 2) ~= 0) then
		return false;
	end
	if (HaveCat(cardList, cnCard)) then
		return false;
	end

	if (HaveMultiSame(cardList, cnCard, 2) == 0) then
		return false;
	end

	return IsMultiContinue(cardList, cnCard, 2);
end

local same3CardList = {}
local same2CardList = {}

--[[--
-- 获取飞机中三代的个数
-- @param cardList
-- @param cnCard
-- @param nMulti
-- @param x 三张带的张数（1三带一，2三带二）
--@return
--]]
local function HaveMultiSameForSame3withX(cardList,  cnCard,  nMulti,  x)
	local nSame = 0;
	local index = 1;
	same3CardList = {};
	same2CardList = {};
	for i = 1, cnCard do
		if i >= index  then
			if (x == 2 and IsSameCard(cardList, i - 1, 4, cnCard)) then
				-- 带对的飞机中含有相同四张的话拆成两对
				table.insert(same2CardList, cardList[i]);
				table.insert(same2CardList, cardList[i + 1]);
				table.insert(same2CardList, cardList[i + 2]);
				table.insert(same2CardList, cardList[i + 3]);
				index = index + 4
			end
			if (IsSameCard(cardList, i - 1, nMulti, cnCard)) then
				--是三张相同
				-- 2 不能出现
				if (cardList[i].m_nWhat ~= CARD_2) then
					nSame = nSame + 1;
					table.insert(same3CardList, cardList[i]);
				end
				index = index + nMulti
			else
				if (x == 2) then
					table.insert(same2CardList, cardList[i]);
				end
				index = index + 1;
			end
		end
	end
	return nSame;
end

--[[--
--检查是否多个三带一对
--]]
local function IsManySame3WithSame2(cardList, cnCard)
	if (cnCard < 5 * 2) then
		return false;
	end
	if ((cnCard % 5) ~= 0) then
		return false;
	end

	local nSame = HaveMultiSameForSame3withX(cardList, cnCard, 3, 2);
	if (math.floor((cnCard - nSame * 3) / 2) ~= nSame) then
		return false;
	end

	SortCardVal(same3CardList, SORT_MODE_WHAT);
	if (IsMultiContinue(same3CardList, #same3CardList, 1)) then
		if (#same2CardList == 0) then
			return false;
		end
		SortCardVal(same2CardList, SORT_MODE_WHAT);
		for i = 1, nSame do
			-- ----------------------------------------------------------
			-- 是否有n对
			-- ----------------------------------------------------------
			if (not IsSameCard(same2CardList, 2 * (i - 1), 2, cnCard)) then
				return false;
			end
		end
		return true;
	end

	return false;
end

--[[--
--检查是否三同张
--]]
local function IsManySame3(cardList,  cnCard)
	if (cnCard < 6) then
		return false;
	end
	if ((cnCard % 3) ~= 0) then
		return false;
	end

	local nSame = HaveMultiSame(cardList, cnCard, 3);

	if (nSame * 3 ~= cnCard) then
		return false;
	end

	return IsMultiContinue(cardList, cnCard, 3);
end

--[[--
--检查是否多个三带一
--]]
local function IsManySame3With1(cardList, cnCard)
	if (cnCard < 4 * 2) then
		return false;
	end
	if ((cnCard % 4) ~= 0) then
		return false;
	end

	-- --------------------------------------------------------
	-- 几个三带1
	-- --------------------------------------------------------
	local nSame = HaveMultiSameForSame3withX(cardList, cnCard, 3, 1);
	if ((cnCard - nSame * 3) ~= nSame) then
		return false;
	end
	SortCardVal(same3CardList, SORT_MODE_WHAT);
	return IsMultiContinue(same3CardList, #same3CardList, 1);
end

--[[--
--由牌数组得到牌类型
--@return #number 牌的类型
--]]
function GetCardType(cardList)
	local cnCard = #cardList
	--	local nTmp, i;
	if (cardList == nil) then
		return TYPE_INVALIDATE;
	end

	-- 排序
	SortCardVal(cardList, SORT_MODE_SAMECOUNT);

	if (1 == cnCard) then
		--一个
		return TYPE_ONE;
	end

	if (2 == cnCard) then
		if (IsSameCard(cardList, 0, 2, cnCard)) then
			--一对
			return TYPE_TWO;
		elseif (IsAllCat(cardList, 2)) then
			--火箭
			return TYPE_TWO_CAT;
		else
			return TYPE_INVALIDATE;
		end
	end

	if (3 == cnCard) then
		if (IsSameCard(cardList, 0, 3, cnCard)) then
			--三个
			return TYPE_THREE;
		else
			return TYPE_INVALIDATE;
		end
	end

	if (4 == cnCard) then
		if (IsSameCard(cardList, 0, 4, cnCard)) then
			--炸弹
			return TYPE_FOUR;
		elseif (IsSameCard(cardList, 0, 3, cnCard)) then
			--三带一
			return TYPE_THREE_ONE;
		else
			return TYPE_INVALIDATE;
		end
	end

	-- 大于等于5张牌可以判断是否是顺子
	if (IsStraight(cardList, cnCard)) then
		return TYPE_STRAIGHT;
	end

	--三带一对
	if (5 == cnCard) then
		-- 4带1不合法
		if (IsSameCard(cardList, 0, 4, cnCard) or IsSameCard(cardList, 1, 4, cnCard)) then
			return TYPE_INVALIDATE;
		end
		-- 3带一对
		if (IsSameCard(cardList, 0, 3, cnCard) and IsSameCard(cardList, 3, 2, cnCard)) then
			return TYPE_THREE_SAMETWO;
		end
		if (IsSameCard(cardList, 0, 2, cnCard) and IsSameCard(cardList, 2, 3, cnCard)) then
			--已经排过序，所以不会再出现前两张拍相同，后三张牌相同的情况
			return TYPE_THREE_SAMETWO;
		end
		return TYPE_INVALIDATE;
	end

	--4带二
	if (6 == cnCard and IsSameCard(cardList, 0, 4, cnCard)) then
		return TYPE_FOUR_TWO;
	end

	-- 4带两对
	if (cnCard == 8 and IsSameCard(cardList, 0, 4, cnCard) and IsSameCard(cardList, 4, 2, cnCard) and IsSameCard(cardList, 6, 2, cnCard)) then
		return TYPE_FOUR_TWOSAMETWO;
	end

	-- 连对  如33445566
	if (IsManySame2(cardList, cnCard)) then
		return TYPE_MANY_TWO;
	end

	-- 多个三带，4带(飞机双翅膀)
	if (IsManySame3WithSame2(cardList, cnCard)) then
		return TYPE_MANY_THREE_TWO;
	end

	if (IsManySame3(cardList, cnCard)) then
		-- 三顺（飞机不带翅膀）
		-- 飞机
		return TYPE_MANY_THREE;
	end
	--(飞机单翅膀)
	if (IsManySame3With1(cardList, cnCard)) then
		return TYPE_MANY_THREE_ONE;
	end
	return TYPE_INVALIDATE;
end


--[[--
-- 比较牌的大小
--@param #table cardList1 自己的牌
--@param #number cnCard1 自己牌的数量
--@param #table cardList2 别人的牌
--@param #number cnCard2 别人的牌的数量
--@return #number 返回正数，则表示自己的牌大于别人的
--]]--
function CompareCard(cardList1, cnCard1, cardList2, cnCard2)
	local nType1 = GetCardType(cardList1);
	local nType2 = GetCardType(cardList2);
	--Common.log("nType1 ================= " .. CARD_TYPE[nType1 + 1])
	--Common.log("nType2 ================= " .. CARD_TYPE[nType2 + 1])
	if (nType2 == TYPE_TWO_CAT) then
		return -1;
	end

	-- ----------------------------------------------------------------------
	-- 类型一样的牌,数量不一样
	-- ----------------------------------------------------------------------
	if (nType1 == nType2) then
		if nType1 == TYPE_ONE or
			nType1 == TYPE_TWO or
			nType1 == TYPE_THREE or
			nType1 == TYPE_STRAIGHT or
			nType1 == TYPE_THREE_ONE or
			nType1 == TYPE_THREE_SAMETWO or
			nType1 == TYPE_FOUR_TWO or
			nType1 == TYPE_FOUR_TWOSAMETWO or
			nType1 == TYPE_FOUR or
			nType1 == TYPE_MANY_TWO or
			nType1 == TYPE_MANY_THREE or
			nType1 == TYPE_MANY_THREE_ONE or
			nType1 == TYPE_MANY_THREE_TWO then
			if (cnCard1 ~= cnCard2) then
				return -1;
			end
			SortCardVal(cardList1, SORT_MODE_SAMECOUNT)
			SortCardVal(cardList2, SORT_MODE_SAMECOUNT)
			return cardList1[1].m_nWhat - cardList2[1].m_nWhat;
		else
			return 0;
		end
	end
	-- ------------------------------------------------------------------------------
	-- 牌型不一样的情况下
	-- ------------------------------------------------------------------------------
	if (nType1 == TYPE_TWO_CAT) then
		return 1;
	end
	if (nType1 == TYPE_FOUR and nType2 ~= TYPE_TWO_CAT) then
		return 1;
	end
	if (nType1 == TYPE_FOUR and nType1 > nType2) then
		return 1;
	end

	return -1;
end

--[[--
--剔除重复的
--@param cardList
--]]
function rejectRepeatType(cardList)
	local size = 0;
	for i = 1, #cardList do
		if (cardList[i].mbLaiZi) then
			size = #cardList[i].m_LaiziValues;
			break;
		end
	end

	local cardsSelect = {}

	if size > 0  then
		for i = 1, size do
			local tempData = {};
			--将所有牌型放入临时数组中
			for j = 1, #cardList do
				local data = cardList[j];
				local val;
				if (data.mbLaiZi) then
					val = data.m_LaiziValues[i];
				else
					val = data.m_nValue;
				end
				local card = TableCard:new(val, FACE_FRONT, false)
				card.mbLaiZi = data.mbIsLaiZi
				card.m_CardSprite.setValue(card.m_nColor, card.m_nWhat, data.mbIsLaiZi)
				table.insert(tempData, card)
			end

			local type = GetCardType(tempData)
			--以牌型为下标存放牌型，这样相同牌型数据只存储一个
			if type > 0 then
				if cardsSelect[type] == nil then
					--本牌型第一的数据
					cardsSelect[type] = {}
					cardsSelect[type].cardData = {}
					cardsSelect[type].index = i
					cardsSelect[type].cardData = tempData
				else
					--非第一数据，选择大的数据存放
					local whatOld = cardsSelect[type].cardData[1].m_nValue % 13
					local whatNew = tempData[1].m_nValue % 13
					if whatNew > whatOld then
						cardsSelect[type].index = i;--存放更大的数据的真实下标
						cardsSelect[type].cardData = tempData;--筛选后的数据
					end
				end
			end
		end
	end

	return cardsSelect;
end

--[[--
* 计算混牌的各种情况(3带1，顺子)
*
* @param cardList1
*            自己的牌
* @param cnCard1
*            自己的牌数量
* @param cardList2
*            别人出的牌
* @param cnCard2
*            别人出的牌张数
--]]
function calculateVariousCase(cardList1, cnCard1, cardList2,  cnCard2, type)

	local commonCnt = 0;-- 普通牌数量
	local xCnt = 0;-- 万能牌数量
	local commonArray = {};-- 普通牌数组20
	local xArray = {};-- 万能牌数组4
	for i = 1, cnCard1 do
		if (cardList1[i].mbLaiZi) then
			xCnt = xCnt + 1
			xArray[xCnt] = cardList1[i];
		else
			commonCnt = commonCnt + 1
			commonArray[commonCnt] = cardList1[i];
		end
	end

	if (type == TYPE_THREE_ONE) then
		-- 如果是三带一
		if (cnCard1 ~= 4) then
			return 0;
		end
		local map = {};
		for i = 1, commonCnt do
			--map的下标加一,原因是what的最小是0
			map[commonArray[i].m_nWhat + 1] = commonArray[i].m_nWhat
		end
		local diffWhatCnt = 0--what值不同的牌数
		for i = 1,  table.maxn(map) do
			if map[i] ~= nil then
				diffWhatCnt = diffWhatCnt + 1
			end
		end
		--Common.log("what值不同的牌数 ======== diffWhatCnt == "..diffWhatCnt)
		if (diffWhatCnt > 2) then
			-- 不同数大于2 压不住三带一
			return 0;
		end
		if (xCnt == 1) then
			-- 1张混子牌
			xArray[1].m_LaiziValues = {};
			if (diffWhatCnt == 2) then
				-- 不同牌值数量 aaxb
				for i = 1, table.maxn(map) do
					if map[i] ~= nil then
						local iKey = map[i];
						xArray[1].m_nWhat = iKey;
						local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
						xArray[1].m_nWhat = xCardWhat;
						if (result > 0) then
							xArray[1]:addLaiziValues(iKey);
						end
					end
				end
				if (#xArray[1].m_LaiziValues > 0) then
					-- 如果癞子值大于0
					return 1;
				end
				return 0;
			elseif (diffWhatCnt == 1) then
				-- 三带一 aaax 炸弹 aaax
				-- 炸弹
				xArray[1]:addLaiziValues(commonArray[1].m_nWhat);
				-- 三带一
				if (commonArray[1].m_nWhat == 0) then
					xArray[1].m_nWhat = 1;
				else
					xArray[1].m_nWhat = 0;
				end
				local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
				if (result > 0) then
					xArray[1]:addLaiziValues(xArray[1].m_nWhat);
					xArray[1].m_nWhat = xCardWhat;
				end
				return 1;
			end
		elseif (xCnt == 2) then
			-- 2张混子牌
			xArray[1].m_LaiziValues = {};
			xArray[2].m_LaiziValues = {};
			if (diffWhatCnt == 2) then
				-- axxb
				for i = 1, table.maxn(map) do
					if map[i] ~= nil then
						local iKey = map[i];
						if (iKey <= 12) then
							-- 不是大小王
							xArray[1].m_nWhat = iKey;
							xArray[2].m_nWhat = iKey;
							local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
							xArray[1].m_nWhat = xCardWhat;
							xArray[2].m_nWhat = xCardWhat;
							if (result > 0) then
								xArray[1]:addLaiziValues(iKey);
								xArray[2]:addLaiziValues(iKey);
							end
						end
					end
				end
				if (#xArray[1].m_LaiziValues > 0) then
					-- 如果癞子值大于0
					return 1;
				end
				return 0;
			elseif (diffWhatCnt == 1) then
				-- 三带一 aaxx 炸弹 aaxx
				-- 炸弹
				xArray[1]:addLaiziValues(commonArray[1].m_nWhat);
				xArray[2]:addLaiziValues(commonArray[1].m_nWhat);
				-- 三带一
				xArray[1].m_nWhat = commonArray[1].m_nWhat;
				if (commonArray[1].m_nWhat == 0) then
					xArray[2].m_nWhat = 1;
				else
					xArray[2].m_nWhat = 0;
				end
				local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
				if (result > 0) then
					xArray[1]:addLaiziValues(commonArray[1].m_nWhat);
					xArray[2]:addLaiziValues(xArray[2].m_nWhat);
					xArray[1].m_nWhat = xCardWhat;
					xArray[2].m_nWhat = xCardWhat;
				end
				return 1;
			end
		elseif (xCnt == 3) then
			-- 3张混牌 三带一xxxa 炸弹xxxa
			xArray[1].m_LaiziValues = {};
			xArray[2].m_LaiziValues = {};
			xArray[3].m_LaiziValues = {};
			-- 炸弹
			if (commonArray[1].m_nWhat < 13) then
				xArray[1]:addLaiziValues(commonArray[1].m_nWhat);
				xArray[2]:addLaiziValues(commonArray[1].m_nWhat);
				xArray[3]:addLaiziValues(commonArray[1].m_nWhat);
			end
			-- 三带一
			if (commonArray[1].m_nWhat == 12) then
				xArray[1].m_nWhat = 11;
				xArray[2].m_nWhat = 11;
				xArray[3].m_nWhat = 11;
			else
				xArray[1].m_nWhat = 12;
				xArray[2].m_nWhat = 12;
				xArray[3].m_nWhat = 12;
			end
			local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
			if (result > 0) then
				xArray[1]:addLaiziValues(xArray[1].m_nWhat);
				xArray[2]:addLaiziValues(xArray[2].m_nWhat);
				xArray[3]:addLaiziValues(xArray[3].m_nWhat);
				xArray[1].m_nWhat = xCardWhat;
				xArray[2].m_nWhat = xCardWhat;
				xArray[3].m_nWhat = xCardWhat;
			end
			return 1;
		end
	else
		-- 如果是顺子

		local map = {};
		for i = 1, commonCnt do
			--map的下标加一,原因是what的最小是0
			map[commonArray[i].m_nWhat + 1] = commonArray[i].m_nWhat
		end
		local diffWhatCnt = 0--what值不同的牌数
		for i = 1,  table.maxn(map) do
			if map[i] ~= nil then
				diffWhatCnt = diffWhatCnt + 1
			end
		end

		if (cnCard1 < 4) then
			return 0;
		elseif (cnCard1 == 4) then
			-- 炸弹
			if (diffWhatCnt == 1) then
				for i = 1, xCnt do
					xArray[i].m_LaiziValues = {};
					xArray[i]:addLaiziValues(commonArray[1].m_nWhat);
				end
				return 1;
			end
			return 0;
		else
			-- 顺子
			if (cnCard1 ~= cnCard2 or diffWhatCnt ~= commonCnt) then
				return 0;
			else
				local otherMaxWhat = 0;-- 上家顺子的最大值
				local otherMinWhat = 11; -- 上家顺子的最小值
				for i = 1, cnCard2 do
					local tmp = cardList2[i].m_nWhat;
					if (tmp > otherMaxWhat) then
						otherMaxWhat = tmp;
					end
					if (tmp < otherMinWhat) then
						otherMinWhat = tmp;
					end
				end

				local whatList = {};
				local maxWhat = 0; -- 顺子中最大值
				local minWhat = 11; -- 顺子中最小值
				for i = 1, commonCnt do
					local tmp = commonArray[i].m_nWhat;
					table.insert(whatList, tmp)
					if (tmp > maxWhat) then
						maxWhat = tmp;
					end
					if (tmp < minWhat) then
						minWhat = tmp;
					end
				end
				if (minWhat <= otherMinWhat or maxWhat > 11) then
					-- 不可能大于上家or含有2
					-- 王
					return 0;
				end
				local distance = maxWhat + 1 - minWhat;
				local midNum = distance - commonCnt;-- 顺子中间应该插入的数个数
				if (midNum > xCnt) then
					-- 顺子中间缺数大于混牌数量
					return 0;
				end
				local midWhats = {};
				local index = 0;
				for i = minWhat, maxWhat - 1 do
					local isHave = false
					for j = 1 , #whatList do
						if whatList[j] == i then
							isHave = true;
						end
					end
					if (not isHave) then
						index = index + 1
						midWhats[index] = i;
					end
				end
				if (midNum == 0) then
					-- 插入0个混牌
					--Common.log("插入0个混牌==================")
					if (xCnt == 1) then
						-- 1个混牌
						xArray[1].m_LaiziValues = {};
						if (minWhat - 1 > otherMinWhat) then
							xArray[1]:addLaiziValues(minWhat - 1);
						end
						if (maxWhat + 1 < 12) then
							xArray[1]:addLaiziValues(maxWhat + 1);
						end
						if (#xArray[1].m_LaiziValues > 0) then
							return 1;
						end
					elseif (xCnt == 2) then
						-- 2个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						local values = {};--20
						local valCnt = 0;

						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						if (valCnt < 2) then
							return 0;
						end
						if (valCnt == 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							return 1;
						end
						if (valCnt > 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							return 1;
						end
					elseif (xCnt == 3) then
						-- 3个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						local values = {};--20
						local valCnt = 0;
						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 3 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 3 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						if (valCnt < 3) then
							return 0;
						end
						if (valCnt == 3) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							return 1;
						end
						if (valCnt > 3) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							xArray[3]:addLaiziValues(values[1+valCnt - 3]);
							return 1;
						end
					elseif (xCnt == 4) then
						-- 4个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[4].m_LaiziValues = {};

						local values = {};--20
						local valCnt = 0;
						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 4 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 4 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end

						if (valCnt < 4) then
							return 0;
						end
						if (valCnt == 4) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							xArray[4]:addLaiziValues(values[1+3]);
							return 1;
						end
						if (valCnt > 4) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							xArray[4]:addLaiziValues(values[1+3]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							xArray[3]:addLaiziValues(values[1+valCnt - 3]);
							xArray[4]:addLaiziValues(values[1+valCnt - 4]);
							return 1;
						end
					end
				elseif (midNum == 1) then
					-- 插入一个混牌
					--Common.log("插入1个混牌==================")
					if (xCnt == 1) then
						-- 1个混牌
						xArray[1].m_LaiziValues = {};
						xArray[1]:addLaiziValues(midWhats[1+0]);
						return 1;
					end
					if (xCnt == 2) then
						-- 2个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						if (minWhat - 1 > otherMinWhat) then
							xArray[1]:addLaiziValues(minWhat - 1);
							xArray[2]:addLaiziValues(midWhats[1+0]);
						end
						if (maxWhat + 1 < 12) then
							xArray[1]:addLaiziValues(maxWhat + 1);
							xArray[2]:addLaiziValues(midWhats[1+0]);
						end
						if (#xArray[1].m_LaiziValues) then
							return 1;
						end
					elseif (xCnt == 3) then
						-- 3个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						local values = {};--20
						local valCnt = 0;

						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						if (valCnt < 2) then
							return 0;
						end
						if (valCnt == 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							return 1;
						end
						if (valCnt > 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							return 1;
						end
					elseif (xCnt == 4) then
						-- 4个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[4].m_LaiziValues = {};
						local values = {};--20
						local valCnt = 0;
						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 3 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 3 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						if (valCnt < 3) then
							return 0;
						end
						if (valCnt == 3) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							xArray[4]:addLaiziValues(midWhats[1+0]);
							return 1;
						end
						if (valCnt > 3) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(values[1+2]);
							xArray[4]:addLaiziValues(midWhats[1+0]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							xArray[3]:addLaiziValues(values[1+valCnt - 3]);
							xArray[4]:addLaiziValues(midWhats[1+0]);
							return 1;
						end
					end
				elseif (midNum == 2) then
					-- 插入2个混牌
					--Common.log("插入2个混牌==================")
					if (xCnt == 2) then
						-- 2个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[1]:addLaiziValues(midWhats[1+0]);
						xArray[2]:addLaiziValues(midWhats[1+1]);
						return 1;
					end
					if (xCnt == 3) then
						-- 3个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						if (minWhat - 1 > otherMinWhat) then
							xArray[1]:addLaiziValues(midWhats[1+0]);
							xArray[2]:addLaiziValues(midWhats[1+1]);
							xArray[3]:addLaiziValues(minWhat - 1);
						end
						if (maxWhat + 1 < 12) then
							xArray[1]:addLaiziValues(midWhats[1+0]);
							xArray[2]:addLaiziValues(midWhats[1+1]);
							xArray[3]:addLaiziValues(maxWhat + 1);
						end
						if (#xArray[1].m_LaiziValues > 0) then
							return 1;
						end
					elseif (xCnt == 4) then
						-- 4个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[4].m_LaiziValues = {};
						local values = {};--20
						local valCnt = 0;

						for i = minWhat - 1, otherMinWhat + 1, -1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						for i = maxWhat + 1, 12 - 1 do
							for j = 1, 2 do
								valCnt = valCnt + 1
								values[valCnt] = i;
							end
						end
						if (valCnt < 2) then
							return 0;
						end
						if (valCnt == 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							xArray[4]:addLaiziValues(midWhats[1+1]);
							return 1;
						end
						if (valCnt > 2) then
							xArray[1]:addLaiziValues(values[1+0]);
							xArray[2]:addLaiziValues(values[1+1]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							xArray[4]:addLaiziValues(midWhats[1+1]);
							xArray[1]:addLaiziValues(values[1+valCnt - 1]);
							xArray[2]:addLaiziValues(values[1+valCnt - 2]);
							xArray[3]:addLaiziValues(midWhats[1+0]);
							xArray[4]:addLaiziValues(midWhats[1+1]);
							return 1;
						end
					end
				elseif (midNum == 3) then
					-- 插入3个混牌
					--Common.log("插入3个混牌==================")
					if (xCnt == 3) then
						-- 3个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[1]:addLaiziValues(midWhats[1+0]);
						xArray[2]:addLaiziValues(midWhats[1+1]);
						xArray[3]:addLaiziValues(midWhats[1+2]);
						return 1;
					end
					if (xCnt == 4) then
						-- 4个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[4].m_LaiziValues = {};
						if (minWhat - 1 > otherMinWhat) then
							xArray[1]:addLaiziValues(minWhat - 1);
							xArray[2]:addLaiziValues(midWhats[1+0]);
							xArray[3]:addLaiziValues(midWhats[1+1]);
							xArray[4]:addLaiziValues(midWhats[1+2]);
						end
						if (maxWhat + 1 < 12) then
							xArray[1]:addLaiziValues(maxWhat + 1);
							xArray[2]:addLaiziValues(midWhats[1+0]);
							xArray[3]:addLaiziValues(midWhats[1+1]);
							xArray[4]:addLaiziValues(midWhats[1+2]);
						end
						if (#xArray[1].m_LaiziValues > 0) then
							return 1;
						end
					end
				elseif (midNum == 4) then
					-- 插入4个混牌
					if (xCnt == 4) then
						-- 4个混牌
						xArray[1].m_LaiziValues = {};
						xArray[2].m_LaiziValues = {};
						xArray[3].m_LaiziValues = {};
						xArray[4].m_LaiziValues = {};
						xArray[1]:addLaiziValues(midWhats[1+0]);
						xArray[2]:addLaiziValues(midWhats[1+1]);
						xArray[3]:addLaiziValues(midWhats[1+2]);
						xArray[4]:addLaiziValues(midWhats[1+3]);
						return 1;
					end
				end
			end
		end
	end

	return 0;
end
--[[--
--获得有癞子牌的牌型
--]]
function getCardTypeWithX(cardList)
	xCardWhat = TableConsole.mnLaiziCardVal % 13;

	local cnCard = #cardList
	local commonCnt = 0;-- 普通牌数量
	local xCnt = 0;-- 万能牌数量
	local commonArray = {};-- 普通牌数组20
	local xArray = {};-- 万能牌数组4
	for  i = 1, cnCard do
		if (cardList[i].mbLaiZi) then
			xCnt = xCnt + 1
			xArray[xCnt] = cardList[i];
		else
			commonCnt = commonCnt + 1
			commonArray[commonCnt] = cardList[i];
		end
	end
	--Common.log("getCardTypeWithX xCnt=" .. xCnt);
	-- 没有混子牌
	if (xCnt == 0) then
		return GetCardType(cardList);
	end
	-- 炸弹或三带一
	if (cnCard == 4) then
		if (xCnt == 4) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			xArray[3].m_nWhat = xCardWhat;
			xArray[3].m_LaiziValues = {};
			xArray[3]:addLaiziValues(xCardWhat);
			xArray[4].m_nWhat = xCardWhat;
			xArray[4].m_LaiziValues = {};
			xArray[4]:addLaiziValues(xCardWhat);
			local type = GetCardType(cardList);
			return type;
		end
		local three3one4 = {};-- 3334
		three3one4[1] = TableCard:new(0, FACE_FRONT, false);
		three3one4[2] = TableCard:new(13, FACE_FRONT, false);
		three3one4[3] = TableCard:new(26, FACE_FRONT, false);
		three3one4[4] = TableCard:new(1, FACE_FRONT, false);
		--Common.log("出牌:4张 commonCnt=" .. commonCnt);
		if (commonCnt > 1) then
			local threeCnt = 0;-- 3的个数
			local kingCnt = 0;-- 大小王的数量
			for i = 1, commonCnt do
				if (commonArray[i].m_nWhat == 0) then
					threeCnt = threeCnt + 1;
				elseif (commonArray[i].m_nWhat > 12) then
					kingCnt = kingCnt + 1;
				end
			end
			--Common.log("出牌:4张 threeCnt=" .. threeCnt);
			if (threeCnt == 2) then
				if (xCnt == 2) then
					-- (33 33)(33 34)
					xArray[1].m_LaiziValues = {};
					xArray[2].m_LaiziValues = {};
					xArray[1]:addLaiziValues(0);
					xArray[2]:addLaiziValues(1);
					xArray[1]:addLaiziValues(0);
					xArray[2]:addLaiziValues(0);
				elseif (xCnt == 1) then
					xArray[1]:addLaiziValues(0);
				end
				return TYPE_THREE_ONE;
			elseif (threeCnt == 3) then
				if (xCnt == 1) then
					-- (333 3)(333 4)
					xArray[1].m_LaiziValues = {};
					xArray[1]:addLaiziValues(0);
					xArray[1]:addLaiziValues(1);
				end
				return TYPE_THREE_ONE;
			elseif (threeCnt == 1 and kingCnt == 1) then
				if (xCnt == 2) then
					-- (3 王 33)
					xArray[1].m_LaiziValues = {};
					xArray[2].m_LaiziValues = {};
					xArray[1]:addLaiziValues(0);
					xArray[2]:addLaiziValues(0);
				end
				return TYPE_THREE_ONE;
			end
		end
		local result = calculateVariousCase(cardList, cnCard, three3one4, 4, TYPE_THREE_ONE);
		--Common.log("出牌:4张 result=" .. result);
		if (result > 0) then
			return TYPE_THREE_ONE;
		end
		return TYPE_INVALIDATE;
	end
	-- 顺子
	-- 一张混子牌
	if (xCnt == 1) then
		if (cnCard == 1) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			local type = GetCardType(cardList);
			return type;
		else
			xArray[1].m_LaiziValues = {};
			for i = 0, 12 do
				--what值从0到12,13小王，14大王
				xArray[1].m_nWhat = i;
				local type = GetCardType(cardList);
				if (type ~= TYPE_INVALIDATE) then
					xArray[1]:addLaiziValues(i);
				end
			end
			xArray[1].m_nWhat = xCardWhat;
			if (#xArray[1].m_LaiziValues > 0) then
				return 1;
			end
		end
		xArray[1].m_nWhat = xCardWhat;
	elseif (xCnt == 2) then
		if (cnCard == 2) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			local type = GetCardType(cardList);
			return type;
		else
			xArray[1].m_LaiziValues = {};
			xArray[2].m_LaiziValues = {};
			for i = 0, 12 do
				xArray[1].m_nWhat = i;
				for j = i, 12 do
					xArray[2].m_nWhat = j;
					local type = GetCardType(cardList);
					--Common.log("getCardTypeWithX i=" .. i .. " j=" .. j .. " type=" .. type);
					if (type ~= TYPE_INVALIDATE) then
						xArray[1]:addLaiziValues(i);
						xArray[2]:addLaiziValues(j);
					end
				end
			end
			xArray[1].m_nWhat = xCardWhat;
			xArray[2].m_nWhat = xCardWhat;
			if (#xArray[1].m_LaiziValues > 0) then
				return 1;
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
	elseif (xCnt == 3) then
		if (cnCard == 3) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			xArray[3].m_nWhat = xCardWhat;
			xArray[3].m_LaiziValues = {};
			xArray[3]:addLaiziValues(xCardWhat);
			local type = GetCardType(cardList);
			return type;
		else
			xArray[1].m_LaiziValues = {};
			xArray[2].m_LaiziValues = {};
			xArray[3].m_LaiziValues = {};
			for i = 0, 12 do
				xArray[1].m_nWhat = i;
				for j = i, 12 do
					xArray[2].m_nWhat = j;
					for k = j, 12 do
						xArray[3].m_nWhat = k;
						local type = GetCardType(cardList);
						if (type ~= TYPE_INVALIDATE) then
							xArray[1]:addLaiziValues(i);
							xArray[2]:addLaiziValues(j);
							xArray[3]:addLaiziValues(k);
						end
					end
				end
			end
			xArray[1].m_nWhat = xCardWhat;
			xArray[2].m_nWhat = xCardWhat;
			xArray[3].m_nWhat = xCardWhat;
			if (#xArray[1].m_LaiziValues > 0) then
				return 1;
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
		xArray[3].m_nWhat = xCardWhat;

	elseif (xCnt == 4) then
		if (cnCard == 4) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			xArray[3].m_nWhat = xCardWhat;
			xArray[3].m_LaiziValues = {};
			xArray[3]:addLaiziValues(xCardWhat);
			xArray[4].m_nWhat = xCardWhat;
			xArray[4].m_LaiziValues = {};
			xArray[4]:addLaiziValues(xCardWhat);
			local type = GetCardType(cardList);
			return type;
		else
			xArray[1].m_LaiziValues = {};
			xArray[2].m_LaiziValues = {};
			xArray[3].m_LaiziValues = {};
			xArray[4].m_LaiziValues = {};
			for i = 0, 12 do
				xArray[1].m_nWhat = i;
				for j = i, 12 do
					xArray[2].m_nWhat = j;
					for k = j, 12 do
						xArray[3].m_nWhat = k;
						for l = k, 12 do
							xArray[4].m_nWhat = l;
							local type = GetCardType(cardList);
							if (type ~= TYPE_INVALIDATE) then
								xArray[1]:addLaiziValues(i);
								xArray[2]:addLaiziValues(j);
								xArray[3]:addLaiziValues(k);
								xArray[4]:addLaiziValues(l);
							end
						end
					end
				end
			end
			xArray[1].m_nWhat = xCardWhat;
			xArray[2].m_nWhat = xCardWhat;
			xArray[3].m_nWhat = xCardWhat;
			xArray[4].m_nWhat = xCardWhat;
			if (#xArray[1].m_LaiziValues > 0) then
				return 1;
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
		xArray[3].m_nWhat = xCardWhat;
		xArray[4].m_nWhat = xCardWhat;
	end

	return TYPE_INVALIDATE;
end


--[[--
* 比较牌大小
*
* @param cardList1
*            自己的牌
* @param cnCard1
*            自己的牌数量
* @param cardList2
*            别人出的牌
* @param cnCard2
*            别人出的牌张数
* @return
--]]
function compareCardWithX(cardList1, cnCard1, cardList2, cnCard2)
	initData(cardList1)

	local commonCnt = 0;-- 普通牌数量
	local xCnt = 0;-- 万能牌数量
	local commonArray = {};-- 普通牌数组20
	local xArray = {};-- 万能牌数组4
	for i = 1, cnCard1 do
		if (cardList1[i].mbLaiZi) then
			xCnt = xCnt + 1
			xArray[xCnt] = cardList1[i];
		else
			commonCnt = commonCnt + 1
			commonArray[commonCnt] = cardList1[i];
		end
	end

	local type = GetCardType(cardList2);
	--Common.log("别人的牌type ============== "..CARD_TYPE[type + 1])
	if (type == TYPE_FOUR) then
		local isPureBomb = true;-- 硬炸
		local is4LaiZiBomb = true;-- 4癞子炸
		local isSoftBomb = false;-- 软炸

		for i = 1, cnCard2 do
			if (cardList2[i].mbLaiZi) then
				--有癞子，不是硬炸
				isSoftBomb = true;
				isPureBomb = false;
			else
				--有不是癞子的牌，不是4癞子炸
				is4LaiZiBomb = false;
			end
		end

		if (is4LaiZiBomb) then
			-- 4癞子炸
			local nCat = 0;
			if (cnCard1 > 2) then
				return -1;
			end
			for i = 1, cnCard1 do
				if (cardList1[i].m_nValue >= 52) then
					nCat = nCat + 1;
				end
			end
			if (nCat == 2) then
				return 1;
			end
			return -1;
		end

		if (isSoftBomb) then
			-- 软炸
			if (xCnt == 0 and cnCard1 == 4) then
				local nWhat = cardList1[1].m_nWhat;
				local allEquelWhat = true;
				for i = 1 , cnCard1 do
					if (cardList1[i].m_nWhat ~= nWhat) then
						allEquelWhat = false;
					end
				end
				if (allEquelWhat) then
					return 1;
				end
			end
		else
			-- 硬炸
			if (xCnt ~= 0 and xCnt ~= 4) then
				-- 如果是硬炸 并且有癞子牌
				return -1;
			end
		end
	end
	-- 没有混牌
	if (xCnt == 0) then
		return CompareCard(cardList1, cnCard1, cardList2, cnCard2);
	end
	-- 四张混牌
	if (xCnt == 4 and cnCard1 == 4) then
		xArray[1].m_nWhat = xCardWhat;
		xArray[1].m_LaiziValues = {};
		xArray[1]:addLaiziValues(xCardWhat);
		xArray[2].m_nWhat = xCardWhat;
		xArray[2].m_LaiziValues = {};
		xArray[2]:addLaiziValues(xCardWhat);
		xArray[3].m_nWhat = xCardWhat;
		xArray[3].m_LaiziValues = {};
		xArray[3]:addLaiziValues(xCardWhat);
		xArray[4].m_nWhat = xCardWhat;
		xArray[4].m_LaiziValues = {};
		xArray[4]:addLaiziValues(xCardWhat);
		return 1; -- 混子炸弹仅小于双王
	end
	-- 没有普通牌
	if (commonCnt == 0) then
		for i = 1, xCnt do
			xArray[i].m_nWhat = xCardWhat;
			xArray[i].m_LaiziValues = {};
			xArray[i]:addLaiziValues(xCardWhat);
		end
		return CompareCard(cardList1, cnCard1, cardList2, cnCard2);
	end
	-- 牌型为三带一或顺子
	if (type == TYPE_THREE_ONE or type == TYPE_STRAIGHT) then
		return calculateVariousCase(cardList1, cnCard1, cardList2, cnCard2, type);
	end
	-- 一张混子牌
	if (xCnt == 1) then
		if (cnCard1 == 1) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			return CompareCard(cardList1, cnCard1, cardList2, cnCard2);
		else
			-- if (xArray[1].m_LaiziValues.size() > 0) {
			-- xArray[1].m_nWhat = xArray[1].m_LaiziValues.get(0);
			-- local result = CompareCard(cardList1, cnCard1, cardList2,
			-- cnCard2);
			-- if (result > 0) {
			-- xArray[1].m_nWhat = xCardWhat;
			-- return result;
			-- }
			-- }
			for i = 12, 0, -1 do
				xArray[1].m_nWhat = i;
				xArray[1].m_LaiziValues = {};
				xArray[1]:addLaiziValues(i);
				local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
				if (result > 0) then
					xArray[1].m_nWhat = xCardWhat;
					return result;
				end
			end
		end
		xArray[1].m_nWhat = xCardWhat;
	elseif (xCnt == 2) then
		if (cnCard1 == 2) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			return CompareCard(cardList1, cnCard1, cardList2, cnCard2);
		else
			-- if (xArray[1].m_LaiziValues.size() > 0 and
			-- xArray[2].m_LaiziValues.size() > 0) {
			-- xArray[1].m_nWhat = xArray[1].m_LaiziValues.get(0);
			-- xArray[2].m_nWhat = xArray[2].m_LaiziValues.get(0);
			-- local result = CompareCard(cardList1, cnCard1, cardList2,
			-- cnCard2);
			-- if (result > 0) {
			-- xArray[1].m_nWhat = xCardWhat;
			-- xArray[2].m_nWhat = xCardWhat;
			-- return result;
			-- }
			-- }
			for  i = 12, 0, -1 do
				xArray[1].m_nWhat = i;
				xArray[1].m_LaiziValues = {};
				xArray[1]:addLaiziValues(i);
				for  j = i, 0, -1 do
					xArray[2].m_nWhat = j;
					xArray[2].m_LaiziValues = {};
					xArray[2]:addLaiziValues(j);
					local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
					if (result > 0) then
						xArray[1].m_nWhat = xCardWhat;
						xArray[2].m_nWhat = xCardWhat;
						return result;
					end
				end
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
	elseif (xCnt == 3) then
		if (cnCard1 == 3) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			xArray[3].m_nWhat = xCardWhat;
			xArray[3].m_LaiziValues = {};
			xArray[3]:addLaiziValues(xCardWhat);
			return CompareCard(cardList1, cnCard1, cardList2, cnCard2);
		else
			-- if (xArray[1].m_LaiziValues.size() > 0 and
			-- xArray[2].m_LaiziValues.size() > 0 and
			-- xArray[3].m_LaiziValues.size() > 0) {
			-- xArray[1].m_nWhat = xArray[1].m_LaiziValues.get(0);
			-- xArray[2].m_nWhat = xArray[2].m_LaiziValues.get(0);
			-- xArray[3].m_nWhat = xArray[3].m_LaiziValues.get(0);
			-- local result = CompareCard(cardList1, cnCard1, cardList2,
			-- cnCard2);
			-- if (result > 0) {
			-- xArray[1].m_nWhat = xCardWhat;
			-- xArray[2].m_nWhat = xCardWhat;
			-- xArray[3].m_nWhat = xCardWhat;
			-- return result;
			-- }
			-- }
			for  i = 12, 0, -1 do
				xArray[1].m_nWhat = i;
				xArray[1].m_LaiziValues = {};
				xArray[1]:addLaiziValues(i);
				for  j = i, 0, -1 do
					xArray[2].m_nWhat = j;
					xArray[2].m_LaiziValues = {};
					xArray[2]:addLaiziValues(j);
					for  k = j, 0, -1 do
						xArray[3].m_nWhat = k;
						xArray[3].m_LaiziValues = {};
						xArray[3]:addLaiziValues(k);
						local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
						if (result > 0) then
							xArray[1].m_nWhat = xCardWhat;
							xArray[2].m_nWhat = xCardWhat;
							xArray[3].m_nWhat = xCardWhat;
							return result;
						end
					end
				end
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
		xArray[3].m_nWhat = xCardWhat;

	elseif (xCnt == 4) then
		if (cnCard1 == 4) then
			xArray[1].m_nWhat = xCardWhat;
			xArray[1].m_LaiziValues = {};
			xArray[1]:addLaiziValues(xCardWhat);
			xArray[2].m_nWhat = xCardWhat;
			xArray[2].m_LaiziValues = {};
			xArray[2]:addLaiziValues(xCardWhat);
			xArray[3].m_nWhat = xCardWhat;
			xArray[3].m_LaiziValues = {};
			xArray[3]:addLaiziValues(xCardWhat);
			xArray[4].m_nWhat = xCardWhat;
			xArray[4].m_LaiziValues = {};
			xArray[4]:addLaiziValues(xCardWhat);
			return 1; -- 混子炸弹仅小于双王
		else
			-- if (xArray[1].m_LaiziValues.size() > 0 and
			-- xArray[2].m_LaiziValues.size() > 0 and
			-- xArray[3].m_LaiziValues.size() > 0 and
			-- xArray[4].m_LaiziValues.size() > 0) {
			-- xArray[1].m_nWhat = xArray[1].m_LaiziValues.get(0);
			-- xArray[2].m_nWhat = xArray[2].m_LaiziValues.get(0);
			-- xArray[3].m_nWhat = xArray[3].m_LaiziValues.get(0);
			-- xArray[4].m_nWhat = xArray[4].m_LaiziValues.get(0);
			-- local result = CompareCard(cardList1, cnCard1, cardList2,
			-- cnCard2);
			-- if (result > 0) {
			-- xArray[1].m_nWhat = xCardWhat;
			-- xArray[2].m_nWhat = xCardWhat;
			-- xArray[3].m_nWhat = xCardWhat;
			-- xArray[4].m_nWhat = xCardWhat;
			-- return result;
			-- }
			-- }
			for  i = 12, 0, -1 do
				xArray[1].m_nWhat = i;
				xArray[1].m_LaiziValues = {};
				xArray[1]:addLaiziValues(i);
				for  j = i, 0, -1 do
					xArray[2].m_nWhat = j;
					xArray[2].m_LaiziValues = {};
					xArray[2]:addLaiziValues(j);
					for  k = j, 0, -1 do
						xArray[3].m_nWhat = k;
						xArray[3].m_LaiziValues = {};
						xArray[3]:addLaiziValues(k);
						for  l = k, 0, -1 do
							xArray[4].m_nWhat = l;
							xArray[4].m_LaiziValues = {};
							xArray[4]:addLaiziValues(l);
							local result = CompareCard(cardList1, cnCard1, cardList2, cnCard2);
							if (result > 0) then
								-- --Common.log("可以管住 xArray[1]="+xArray[1].m_LaiziValues.get(0)+"  xArray[2]="+xArray[2].m_LaiziValues.get(0)+" xArray[3]="+xArray[3].m_LaiziValues.get(0)+" xArray[4]="+xArray[4].m_LaiziValues.get(0));
								xArray[1].m_nWhat = xCardWhat;
								xArray[2].m_nWhat = xCardWhat;
								xArray[3].m_nWhat = xCardWhat;
								xArray[4].m_nWhat = xCardWhat;
								return result;
							end
						end
					end
				end
			end
		end
		xArray[1].m_nWhat = xCardWhat;
		xArray[2].m_nWhat = xCardWhat;
		xArray[3].m_nWhat = xCardWhat;
		xArray[4].m_nWhat = xCardWhat;
	end
	return 0;
end

--[[--
-- 排序查找信息
--]]
local function SortSearchInfo(list)
	--[[--
	--比较函数
	--]]
	local function SortCompare(SearchInfo1, SearchInfo2)
		if SearchInfo1.nWeight == 0 then
			return false
		elseif SearchInfo2.nWeight == 0 then
			return true
		else
			return SearchInfo1.nWeight < SearchInfo2.nWeight;
		end
	end

	if list ~= nil then
		table.sort(list, SortCompare)
	end
end

--[[--
-- 判断是否有两个王
--]]
local function IsHaveTwoCat(cardList, cardNum)
	local catNum = 0;
	for i = 1, cardNum do
		if (cardList[i].m_nValue >= 52) then
			catNum = catNum + 1;
		end
	end
	if (catNum == 2) then
		return true;
	end
	return false;
end

--[[--
--一个数组插入到另一个数组
--]]
local function insertArrayIntoArray(array, insertCard)

	local newArray = {};

	for i = 1, #array do
		table.insert(newArray, array[i]);
	end

	for i = 1, #insertCard do
		table.insert(newArray, insertCard[i]);
	end
	if newArray ~= nil then
		--[[--
		--比较函数
		--]]
		local function SortCompare(Card1, Card2)
			return Card1.m_nWhat > Card2.m_nWhat;
		end
		table.sort(newArray, SortCompare)
		newArrayCnt = #newArray;
	end
	return newArray;
end

--[[--
-- 将搜索信息中的牌显示弹出
--@return #number 弹出牌的数量
--]]
local function PopupSearchCards(si)
	local nValue;
	local card = nil;
	local nCount = 0;

	--Common.log("si.cnCard ============= "..si.cnCard)

	for i = 1, si.cnCard do
		card = si:GetCard(i);
		nValue = card:getValue();
		for j = 1, SelfCardsNum do
			if (SelfCards[j]:getValue() == nValue) then
				SelfCards[j]:setSelected(true);
				nCount = nCount + 1;
			end
		end
	end

	return nCount;
end

--[[--
--取消标记
--]]
local function ClearMark()
	for i = 1, #SelfCards do
		if (SelfCards[i] ~= nil) then
			SelfCards[i].m_bMarked = false;
			SelfCards[i].m_bSame = false;
		end
	end
end

--[[--
-- 增加牌到搜索列表中
--]]
local function AddSearch(nWeight)
	local nIndex = 0;

	if (m_cnSearch >= GL_MAX_SEARCHCOUNT) then
		return false;
	end

	local cnCard = 0;
	local xCnt = 0;
	local laiziValue = 0;
	for i = 1, SelfCardsNum do
		if (SelfCards[i]:IsMarked()) then
			cnCard = cnCard + 1;
			if (SelfCards[i].mbLaiZi) then
				laiziValue = SelfCards[i].m_nWhat;
				xCnt = xCnt + 1;
			end
		end
	end
	--Common.log("增加牌到搜索 位置::AddSearch1 cnCard=" .. cnCard .. " xCnt=" .. xCnt .. " nWeight=" .. nWeight .. " xCardWhat=" .. xCardWhat);
	if (cnCard == 0) then
		return false;
	end
	local changeXWhat = false;
	if (cnCard == xCnt) then
		-- 如果混牌牌值>本身值 就添加失败(不是四个癞子)
		if (laiziValue > xCardWhat and cnCard < 4) then
			return false;
		end
		changeXWhat = true;

	end

	--Common.log("m_cnSearch ========== ".. m_cnSearch)

	-- 增加到搜索列表中
	m_SearchInfo[m_cnSearch]:SetCardsNum(cnCard);
	m_SearchInfo[m_cnSearch].cnCard = cnCard;
	m_SearchInfo[m_cnSearch].nWeight = nWeight;
	for i = 1, SelfCardsNum do
		if (SelfCards[i]:IsMarked()) then
			if (changeXWhat) then
				SelfCards[i].m_LaiziValues = {};
				SelfCards[i]:addLaiziValues(xCardWhat);
			end
			nIndex = nIndex + 1
			m_SearchInfo[m_cnSearch]:InsertCard(nIndex, SelfCards[i]);
		end
	end
	m_cnSearch = m_cnSearch + 1;

	return true;
end

--[[--
*
* @param nStart  开始位置
* @param nWhat 开始值
* @param n
* @param nMulti
* @return 返回0：不符合牌型
--]]
local function SearchSingleSame(nStart, nWhat, n, nMulti)
	local bNotEqual = false;

	for i = 1, nMulti - 1 do
		if (nStart + i > SelfCardsNum) then
			bNotEqual = true;
			break;
		end
		if (SelfCards[nStart + i].m_nWhat ~= nWhat) then
			bNotEqual = true;
			break;
		end
	end
	if (bNotEqual) then
		return 0;
	end

	ClearMark();
	-- ---------------------------------------------------------------------------
	-- 只一个三同张
	-- ---------------------------------------------------------------------------
	if (n == 1) then
		for i = 0, nMulti - 1 do
			SelfCards[nStart + i]:Mark();
		end
		return 1;
	end

	return n;
end

local function SearchMultiSame(nStart, nWhat, n, nMulti)
	local bNotEqual = false;

	-- ---------------------------------------------------------------------------
	-- 需要nWhat nWhat-1 nWhat -2 ... m，共n对
	-- ---------------------------------------------------------------------------
	local m = nWhat - n + 1;
	-- ---------------------------------------------------------------------------
	-- 最小不能小于
	-- ---------------------------------------------------------------------------
	if (m < CARD_3) then
		return false;
	end

	local abStraight = {};
	for i = 1,  GL_MAX_CARDSPERSIDE do
		table.insert(abStraight, false);
	end

	for i = 1, n do
		abStraight[i] = false;
	end

	local suffix = nStart;

	for i = nStart, SelfCardsNum - nMulti + 1 do
		if i >= suffix then
			for j = 1, nMulti - 1 do
				if (SelfCards[i].m_nWhat ~= SelfCards[i + j].m_nWhat) then
					bNotEqual = true;
					break;
				end
			end
			if (bNotEqual) then
				suffix = suffix + 1;
			else
				local nIndexTmp = nWhat - SelfCards[i].m_nWhat;
				-- ---------------------------------------------------------------------------
				-- 不能含2
				-- ---------------------------------------------------------------------------
				if (SelfCards[i].m_nWhat == CARD_2) then
					suffix = suffix + nMulti;
				else
					if (nIndexTmp >= 0 and nIndexTmp < n) then
						abStraight[nIndexTmp + 1] = true;
						for j = 1, nMulti do
							SelfCards[i + j - 1]:Mark();
						end
					end
					local nWhatTmp = SelfCards[i].m_nWhat;
					while (suffix <= SelfCardsNum and SelfCards[suffix].m_nWhat == nWhatTmp) do
						suffix = suffix + 1;
					end
				end
			end
		end
	end
	for i = 1, n do
		if (not abStraight[i]) then
			ClearMark();
			return false;
		end
	end

	return true;
end

--[[--
* 查找对或连对
--]]
local function SearchSame2(nStart, nWhat, n)
	--Common.log("查找对或连对 n ========== "..n)
	local nRet = SearchSingleSame(nStart, nWhat, n, 2);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		return true;
	end

	return SearchMultiSame(nStart, nWhat, n, 2);
end

--[[--
* 查找三同张或连三同张，以nWhat作为起始值
--]]
local function SearchSame3(nStart, nWhat, n)
	local nRet = SearchSingleSame(nStart, nWhat, n, 3);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		return true;
	end

	return SearchMultiSame(nStart, nWhat, n, 3);
end

--[[--
* 查找三同张带一或连三同张带一，以nWhat作为起始值
--]]
local function SearchSame3With1(nStart, nWhat, n)
	local bFound = false;

	local nRet = SearchSingleSame(nStart, nWhat, n, 3);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		for i = SelfCardsNum, 1, -1 do

			if (SelfCards[i]:IsMarked() or SelfCards[i].m_bSame) then
			--continue;
			else
				if (i == SelfCardsNum) then
					if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
						SelfCards[i].m_bSame = true;
						SelfCards[i - 1].m_bSame = true;
					else
						SelfCards[i]:Mark();
						bFound = true;
						break;
					end
				elseif (i == 1) then
					if (SelfCards[i].m_nWhat == SelfCards[i + 1].m_nWhat) then
						SelfCards[i].m_bSame = true;
						SelfCards[i + 1].m_bSame = true;
					else
						SelfCards[i]:Mark();
						bFound = true;
						break;
					end
				else
					if (SelfCards[i].m_nWhat == SelfCards[i + 1].m_nWhat) then
						SelfCards[i].m_bSame = true;
						SelfCards[i + 1].m_bSame = true;
					elseif (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
						SelfCards[i].m_bSame = true;
						SelfCards[i - 1].m_bSame = true;
					else
						SelfCards[i]:Mark();
						bFound = true;
						break;
					end
				end
			end
		end
		if (bFound) then
			return true;
		else
		-- ClearMark();
		-- return false;
		end

		for i = SelfCardsNum, 1, -1 do
			if (SelfCards[i]:IsMarked()) then
			else
				SelfCards[i]:Mark();
				bFound = true;
				break;
			end
		end

		if (bFound) then
			return true;
		else
			ClearMark();
			return false;
		end
	end

	if (not SearchMultiSame(nStart, nWhat, n, 3)) then
		return false;
	end
	-- -----------------------------------------------------------------------
	-- n个same 3已经找到，再找n个单牌
	-- -----------------------------------------------------------------------
	local cnSingle = 0;

	-- 先把相同牌值的牌过滤出去，(为了不拆对或三张炸弹)
	for i = SelfCardsNum, 1, -1 do
		if (SelfCards[i]:IsMarked() or SelfCards[i].m_bSame) then
		else
			if (i == SelfCardsNum) then
				if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
					SelfCards[i].m_bSame = true;
					SelfCards[i - 1].m_bSame = true;
				else
					cnSingle = cnSingle + 1;
					SelfCards[i]:Mark();

					if (cnSingle == n) then
						break;
					end
				end
			elseif (i == 1) then
				if (SelfCards[i].m_nWhat == SelfCards[i + 1].m_nWhat) then
					SelfCards[i].m_bSame = true;
					SelfCards[i + 1].m_bSame = true;
				else
					cnSingle = cnSingle + 1;
					SelfCards[i]:Mark();

					if (cnSingle == n) then
						break;
					end
				end
			else
				if (SelfCards[i].m_nWhat == SelfCards[i + 1].m_nWhat) then
					SelfCards[i].m_bSame = true;
					SelfCards[i + 1].m_bSame = true;
				elseif (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
					SelfCards[i].m_bSame = true;
					SelfCards[i - 1].m_bSame = true;
				else
					cnSingle = cnSingle + 1;
					SelfCards[i]:Mark();

					if (cnSingle == n) then
						break;
					end
				end
			end
		end
	end

	if (cnSingle == n) then
		return true;
	end

	-- 如果上面没有找到，就随意找
	for i = SelfCardsNum, 1, -1 do
		if (SelfCards[i]:IsMarked()) then
		else
			cnSingle = cnSingle + 1;
			SelfCards[i]:Mark();
			if (cnSingle == n) then
				break;
			end
		end
	end

	if (cnSingle == n) then
		return true;
	else
		ClearMark();
		return false;
	end
end

--[[--
* 查找,一个或多个三带二（一对）
--]]
local function SearchSame3WithSame2(nStart, nWhat, n)
	--Common.log("找三带二");
	local nRet = SearchSingleSame(nStart, nWhat, n, 3);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		local bFindSameTwo = false;
		for i = SelfCardsNum, 2, -1 do
			if (SelfCards[i]:IsMarked()) then

			elseif (SelfCards[i - 1]:IsMarked()) then

			else
				if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
					SelfCards[i]:Mark();
					SelfCards[i - 1]:Mark();
					bFindSameTwo = true;
					break;
				end
			end
		end
		if (bFindSameTwo) then
			return true;
		else
			ClearMark();
			return false;
		end
	end

	--Common.log("找飞机");
	if (not SearchMultiSame(nStart, nWhat, n, 3)) then
		return false;
	end
	--Common.log("找到飞机，找连对");
	-- -----------------------------------------------------------------------
	-- n个same 3已经找到，再找n个对
	-- -----------------------------------------------------------------------
	local cnSameTwo = 0;
	for i = SelfCardsNum, 2, - 1 do
		if (SelfCards[i]:IsMarked()) then
		elseif (SelfCards[i - 1]:IsMarked()) then
		else
			if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
				SelfCards[i]:Mark();
				SelfCards[i - 1]:Mark();
				cnSameTwo = cnSameTwo + 1;
				if (cnSameTwo == n) then
					break;
				end
			end
		end
	end

	if (cnSameTwo == n) then
		return true;
	else
		ClearMark();
		return false;
	end
end

--[[--
* 查找顺子，在nColor~=-1时，查找同花顺
--]]
local function SearchStraight(nStart, nWhat, n, nColor)
	local m = nWhat - n + 1;
	if (m < CARD_3) then
		return false;
	end

	ClearMark();

	local abStraight = {};
	for i = 1, GL_MAX_CARDSPERSIDE do
		table.insert(abStraight, false);
	end

	local cnHandCard = SelfCardsNum;
	local suffix = 1;
	for i = 1, cnHandCard do
		if i >= suffix then
			if (SelfCards[i].m_nWhat == CARD_2 or SelfCards[i].m_nValue >= 52) then
				-- 如果是猫或者是2
				-- 跳过
				suffix = suffix + 1;
			else
				local nWhatTmp = nWhat - SelfCards[i].m_nWhat;

				if (nWhatTmp >= 0 and nWhatTmp < n) then
					abStraight[nWhatTmp + 1] = true;
					SelfCards[i]:Mark();
				end

				nWhatTmp = SelfCards[i].m_nWhat;
				if (nColor == -1) then
					while (suffix <= cnHandCard and SelfCards[suffix].m_nWhat == nWhatTmp) do
						suffix = suffix + 1;
					end
				else
					suffix = suffix + 1;
				end
			end

		end
	end
	for i = 1, n do
		if (not abStraight[i]) then
			ClearMark();
			return false;
		end
	end
	return true;
end

--[[--
* 查找炸弹 ,也就是 4，5，6，7，8同张
--]]
local function SearchSameCard(nStart, nWhat, nCardNum)
	local nRet = 0;
	local index = nStart;
	local cnHandCard = SelfCardsNum;
	for i = nStart, cnHandCard do
		if (SelfCards[i].m_nWhat == nWhat) then
			index = index + 1
		end
	end
	if (index - nStart < nCardNum) then
		return 0;
	end

	ClearMark();

	for i = nStart, cnHandCard do
		if (SelfCards[i].m_nWhat == nWhat) then
			SelfCards[i]:Mark();
		end
	end

	return index - nStart;
end

--[[--
* 查找4带2(单张),或多个4带2
--]]
local function SearchSame4With2(nStart, nWhat, n)
	local nRet = SearchSingleSame(nStart, nWhat, n, 4);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		-- --------------------------------------------------------------------
		-- 找两个单牌
		-- --------------------------------------------------------------------
		local cnSingle = 0;
		for i = SelfCardsNum, 1, -1 do
			if (SelfCards[i]:IsMarked()) then
			else
				SelfCards[i]:Mark();
				cnSingle = cnSingle + 1;
				if (cnSingle == 2) then
					break;
				end
			end
		end
		if (cnSingle == 2) then
			return true;
		else
			ClearMark();
			return false;
		end
	end

	if (not SearchMultiSame(nStart, nWhat, n, 4)) then
		return false;
	end
	-- -----------------------------------------------------------------------
	-- n个same 4已经找到，再找2n个单牌
	-- -----------------------------------------------------------------------
	local cnSingle = 0;
	for i = SelfCardsNum, 1, -1 do
		if (SelfCards[i]:IsMarked()) then
		else
			cnSingle = cnSingle + 1;
			SelfCards[i]:Mark();
			if (cnSingle == 2 * n) then
				break;
			end
		end
	end

	if (cnSingle == 2 * n) then
		return true;
	else
		ClearMark();
		return false;
	end
end

--[[--
* 查找4带一对,或多个4带一对
--]]
local function SearchSame4WithSame2(nStart, nWhat, n)
	local nRet = SearchSingleSame(nStart, nWhat, n, 4);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		local bFindSameTwo = false;
		for i = SelfCardsNum, 2, -1 do
			if (SelfCards[i]:IsMarked()) then
			elseif (SelfCards[i - 1]:IsMarked()) then
			else
				if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
					SelfCards[i]:Mark();
					SelfCards[i - 1]:Mark();
					bFindSameTwo = true;
					break;
				end
			end
		end
		if (bFindSameTwo) then
			return true;
		else
			ClearMark();
			return false;
		end
	end

	if (not SearchMultiSame(nStart, nWhat, n, 4)) then
		return false;
	end
	-- -----------------------------------------------------------------------
	-- n个same4 已经找到，再找n个对
	-- -----------------------------------------------------------------------
	local cnSameTwo = 0;
	for i = SelfCardsNum ,2, -1 do
		if (SelfCards[i]:IsMarked()) then
		elseif (SelfCards[i - 1]:IsMarked()) then
		else
			if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
				cnSameTwo = cnSameTwo + 1;
				SelfCards[i]:Mark();
				SelfCards[i - 1]:Mark();
				if (cnSameTwo == n) then
					break;
				end
			end
		end
	end

	if (cnSameTwo == n) then
		return true;
	else
		ClearMark();
		return false;
	end
end

--[[--
* 查找4带2对,或多个4带2对
--]]
local function SearchSame4WithTwoSame2(nStart, nWhat, n)
	local nRet = SearchSingleSame(nStart, nWhat, n, 4);
	if (0 == nRet) then
		return false;
	elseif (1 == nRet) then
		local cnSameTwo = 0;
		for i = SelfCardsNum, 2, -1 do
			if (SelfCards[i]:IsMarked()) then
			elseif (SelfCards[i - 1]:IsMarked()) then
			else
				if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
					SelfCards[i]:Mark();
					SelfCards[i - 1]:Mark();
					cnSameTwo = cnSameTwo + 1
					if ((cnSameTwo) == 2) then
						break;
					end
				end
			end
		end
		if (cnSameTwo == 2) then
			return true;
		else
			ClearMark();
			return false;
		end
	end

	if (not SearchMultiSame(nStart, nWhat, n, 4)) then
		return false;
	end
	-- -----------------------------------------------------------------------
	-- n个same 4已经找到，再找2n个对
	-- -----------------------------------------------------------------------
	local cnSameTwo = 0;
	for i = SelfCardsNum, 1, -1 do
		if (SelfCards[i]:IsMarked()) then
		elseif (SelfCards[i - 1]:IsMarked()) then
		else
			if (SelfCards[i].m_nWhat == SelfCards[i - 1].m_nWhat) then
				cnSameTwo = cnSameTwo + 1;
				if (cnSameTwo == 2 * n) then
					break;
				end
				SelfCards[i]:Mark();
				SelfCards[i - 1]:Mark();
			end
		end
	end

	if (cnSameTwo == 2 * n) then
		return true;
	else
		ClearMark();
		return false;
	end
end

--[[--
-- 按下提示出牌时，搜索可出的牌
--]]
local function oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, mp_MyCards, mp_nMyCardsNum)
	ClearMark();
	local lastCards = m_ayCardsLast;
	local nlastCardsNum = m_nLastCardsNum;
	local cnHandCard = mp_nMyCardsNum;
	local nSameCard = 0;

	if (m_bFirstSearch) then
		--Common.log("开始搜索.....")
		local i, n;
		local nWhat;

		m_cnSearch = 1;
		-- 得到上家出的牌...

		-- 上家出牌的类型
		local nType = GetCardType(lastCards);
		--Common.log("Search nType=" .. CARD_TYPE[nType + 1] .. " m_nLastCardsNum= " .. m_nLastCardsNum);
		--Common.log("mp_nMyCardsNum=" .. mp_nMyCardsNum);

		-- SortArrayCards(mp_MyCards, mp_nMyCardsNum);

		ClearMark();
		if (cnHandCard >= nlastCardsNum) then
			if nType == TYPE_TWO_CAT then
				return false;
			elseif nType == TYPE_ONE then
				-- ---------------------------------------------------------------------------
				-- 单张
				-- ---------------------------------------------------------------------------
				local add = false;
				local isHaveTwoCat = IsHaveTwoCat(mp_MyCards, mp_nMyCardsNum);-- 是否有两个王

				local suffix = 1;

				for i = 1, mp_nMyCardsNum do
					-- 单牌中找
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						--Common.log("单牌中找 === "..TableCard_NUM[nWhat + 1])
						-- 只要比上家出的大的牌都放入
						if (nWhat > lastCards[1].m_nWhat) then
							local isAdd = false;
							if (isHaveTwoCat and nWhat == CARD_2) then
								-- 有两个王并且是2的牌(有两个王的时候优先从2中取单牌)
								isAdd = true;
							end
							if (isAdd or SearchSingleSame(i, nWhat, -1, 4) == 0) then
								-- 去掉炸弹
								if (isAdd or SearchSingleSame(i, nWhat, -1, 3) == 0) then
									-- 去掉三同张
									if (isAdd or SearchSingleSame(i, nWhat, -1, 2) == 0) then
										-- 去掉对牌
										mp_MyCards[i]:Mark();
										AddSearch(nWhat);
										add = true;
										mp_MyCards[i]:Unmark();
										while (suffix <= mp_nMyCardsNum and mp_MyCards[suffix].m_nWhat == nWhat) do
											suffix = suffix + 1;
										end
									else
										suffix = suffix + 2;
									end
								else
									suffix = suffix + 3;
								end
							else
								suffix = suffix + 4;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
				if (not add) then
					local suffix = 1;

					for i = 1, mp_nMyCardsNum do
						-- 对牌中取
						--Common.log("对牌中取")
						if i >= suffix  then
							nWhat = mp_MyCards[i].m_nWhat;
							-- 只要比上家出的大的牌都放入
							if (nWhat > lastCards[1].m_nWhat) then
								if (SearchSingleSame(i, nWhat, -1, 2) == -1) then
									-- 对牌中取
									if (SearchSingleSame(i, nWhat, -1, 3) == 0) then
										-- 去掉三同张
										if (SearchSingleSame(i, nWhat, -1, 4) == 0) then
											-- 去掉炸弹
											mp_MyCards[i]:Mark();
											AddSearch(nWhat);
											add = true;
											mp_MyCards[i]:Unmark();
											while (suffix <= mp_nMyCardsNum and mp_MyCards[suffix].m_nWhat == nWhat) do
												suffix = suffix + 1;
											end
										else
											suffix = suffix + 4;
										end
									else
										suffix = suffix + 3;
									end
								else
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						end
					end
				end
				if (not add) then
					local suffix = 1;
					for i = 1, mp_nMyCardsNum do
						-- 三同张中取
						--Common.log("三同张中取")
						if i >= suffix then
							nWhat = mp_MyCards[i].m_nWhat;
							-- 只要比上家出的大的牌都放入
							if (nWhat > lastCards[1].m_nWhat) then
								if (SearchSingleSame(i, nWhat, -1, 3) == -1) then
									-- 三同张中取
									if (SearchSingleSame(i, nWhat, -1, 4) == 0) then
										-- 去掉炸弹
										mp_MyCards[i]:Mark();
										AddSearch(nWhat);
										add = true;
										mp_MyCards[i]:Unmark();
										while (suffix <= mp_nMyCardsNum and mp_MyCards[suffix].m_nWhat == nWhat) do
											suffix = suffix + 1;
										end
									else
										suffix = suffix + 4;
									end
								else
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						end
					end
				end
				if (not add) then
					local suffix = 1;
					for i = 1, mp_nMyCardsNum do
						-- 炸弹中取
						--Common.log("炸弹中取")
						if i >= suffix  then
							nWhat = mp_MyCards[i].m_nWhat;
							-- 只要比上家出的大的牌都放入
							if (nWhat > lastCards[1].m_nWhat) then
								if (SearchSingleSame(i, nWhat, -1, 4) == -1) then
									-- 炸弹中取
									mp_MyCards[i]:Mark();
									AddSearch(nWhat);
									add = true;
									mp_MyCards[i]:Unmark();
									while (suffix <= mp_nMyCardsNum and mp_MyCards[suffix].m_nWhat == nWhat) do
										suffix = suffix + 1;
									end
								else
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						end
					end
				end
			elseif nType == TYPE_TWO then
				-- ---------------------------------------------------------------------------
				-- 对
				-- ---------------------------------------------------------------------------
				local m_anTypeTwo = {}
				local suffix = 1;
				for i = 1, mp_nMyCardsNum - 1 do
					if i >= suffix then
						nWhat = mp_MyCards[i].m_nWhat;
						local x = 0;
						-- 只要比上家出的大的牌都放入
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame2(i, nWhat, math.floor(nlastCardsNum / 2))) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
									x = x + 1;
								end
								if (m_cnSearch > 1) then
									m_anTypeTwo[m_cnSearch - 1] = x;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
				if (m_cnSearch > 1) then
					local cnt2 = 0;
					for k = 1, table.maxn(m_anTypeTwo) do
						if (m_anTypeTwo[k] ~= nil and m_anTypeTwo[k] == 2) then
							cnt2 = cnt2 + 1;
						end
					end
					local k = 1;
					while (k <= table.maxn(m_anTypeTwo)) do
						if m_anTypeTwo[k] ~= nil and m_anTypeTwo[k] == 4 then
							table.remove(m_SearchInfo, k)
							m_cnSearch = m_cnSearch - 1;
							table.remove(m_anTypeTwo, k)
						else
							k = k + 1
						end
					end

					if (cnt2 > 0) then
						local k = 1;
						while (k <= table.maxn(m_anTypeTwo)) do
							if m_anTypeTwo[k] ~= nil and m_anTypeTwo[k] == 3 then
								table.remove(m_SearchInfo, k)
								m_cnSearch = m_cnSearch - 1;
								table.remove(m_anTypeTwo, k)
							else
								k = k + 1
							end
						end
					end

					ClearMark();
				end
			elseif nType == TYPE_MANY_TWO then
				-- ---------------------------------------------------------------------------
				-- 连对
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, mp_nMyCardsNum - 1 do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						-- 只要比上家出的大的牌都放入
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame2(i, nWhat, math.floor(nlastCardsNum / 2))) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end

				end
			elseif nType == TYPE_THREE or nType == TYPE_MANY_THREE then
				-- ---------------------------------------------------------------------------
				-- 三同张或连三同张
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, mp_nMyCardsNum do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame3(i, nWhat, math.floor(nlastCardsNum / 3))) then
								-- ----------------------------------去除炸弹------------------------
								if (SearchSingleSame(i, nWhat, -1, 4) == 0) then
									-- ----------------------------------去除炸弹------------------------
									AddSearch(nWhat);
								end
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end

				end

			elseif nType == TYPE_THREE_ONE or nType == TYPE_MANY_THREE_ONE then
				-- ---------------------------------------------------------------------------
				-- 三带一或连三带一
				-- ---------------------------------------------------------------------------
				--Common.log("位置:: 3带1");
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame3With1(i, nWhat, math.floor(nlastCardsNum / 4))) then
								-- ----------------------------------去除炸弹------------------------
								if (SearchSingleSame(i, nWhat, -1, 4) == 0) then
									-- ----------------------------------去除炸弹------------------------
									AddSearch(nWhat);
								end
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_THREE_SAMETWO or nType == TYPE_MANY_THREE_TWO then
				-- ---------------------------------------------------------------------------
				-- 三带一对或连三带一对
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame3WithSame2(i, nWhat, math.floor(nlastCardsNum / 5))) then
								-- ----------------------------------去除炸弹------------------------
								if (SearchSingleSame(i, nWhat, -1, 4) == 0) then
									-- ----------------------------------去除炸弹------------------------
									AddSearch(nWhat);
								end
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_STRAIGHT then
				-- ---------------------------------------------------------------------------
				-- 顺子
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						-- ---------------------------------------------------------------------------
						-- 猫排除在外
						-- ---------------------------------------------------------------------------
						if (mp_MyCards[i].m_nValue < 52 and nWhat > lastCards[1].m_nWhat) then
							if (SearchStraight(i, nWhat, nlastCardsNum, -1)) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_FOUR then
				-- ---------------------------------------------------------------------------
				-- 炸弹，4或更多的同张
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						n = SearchSameCard(i, nWhat, 4);
						if (n == nlastCardsNum and nWhat > lastCards[1].m_nWhat) then
							AddSearch(nWhat);
							while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_FOUR_TWO then
				-- ---------------------------------------------------------------------------
				-- 一个4带二
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame4With2(i, nWhat, math.floor(nlastCardsNum / 6))) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_FOUR_SAMETWO then
				-- ---------------------------------------------------------------------------
				-- 一个4带一对
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame4WithSame2(i, nWhat, math.floor(nlastCardsNum / 6))) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			elseif nType == TYPE_FOUR_TWOSAMETWO then
				-- ---------------------------------------------------------------------------
				-- 一个4带两对
				-- ---------------------------------------------------------------------------
				local suffix = 1;
				for i = 1, cnHandCard do
					if i >= suffix  then
						nWhat = mp_MyCards[i].m_nWhat;
						if (nWhat > lastCards[1].m_nWhat) then
							if (SearchSame4WithTwoSame2(i, nWhat, math.floor(nlastCardsNum / 8))) then
								AddSearch(nWhat);
								while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
									suffix = suffix + 1;
								end
							else
								suffix = suffix + 1;
							end
						else
							suffix = suffix + 1;
						end
					end
				end
			end
		end


		-- ---------------------------------------------------------------------------
		-- 如果上家出的不是炸弹，还要检查炸弹
		-- ---------------------------------------------------------------------------
		if (nType < TYPE_FOUR) then
			--Common.log("位置:: 判断炸弹");
			local suffix = 1;
			for i = 1, cnHandCard do
				if i >= suffix  then
					nWhat = mp_MyCards[i].m_nWhat;
					n = SearchSameCard(i, nWhat, 4);
					if (n >= 4) then
						AddSearch(n * 100 + nWhat);
						while (suffix <= cnHandCard and mp_MyCards[suffix].m_nWhat == nWhat) do
							suffix = suffix + 1;
						end
						--Common.log("位置:: n=" .. n .. " m_cnSearch=" .. m_cnSearch);
					else
						suffix = suffix + 1;
					end
				end
			end
		end
		-- ---------------------------------------------------------------------------
		-- 双王比炸弹大
		-- ---------------------------------------------------------------------------
		local nCat = 0;
		for i = 1, cnHandCard do
			if (mp_MyCards[i].m_nValue >= 52) then
				nCat = nCat + 1;
			end
		end
		--Common.log("位置:: nCat=" .. nCat);
		if (nCat == 2) then
			ClearMark();
			for i = 1, cnHandCard do
				if (mp_MyCards[i].m_nValue >= 52) then
					mp_MyCards[i]:Mark();
				end
			end
			AddSearch(10 * 100);
		end

		-- 对查找到的信息进行排序
		SortSearchInfo(m_SearchInfo);

		m_nCurSearch = 0;
		m_bFirstSearch = false;
	end

	-- ------------------------------------------------------------------------
	SelfCards = tempSelfCards;
	SelfCardsNum = tempSelfCardsNum;
	-- ------------------------------------------------------------------------
	--Common.log("m_cnSearch =========== "..m_cnSearch)
	if (1 == m_cnSearch) then
		-- 没有找到可出的牌直接PASS
		-- Pass();
		return false;
	end
	if (isPopup) then
		m_nCurSearch = m_nCurSearch + 1
		if (m_nCurSearch >= m_cnSearch) then
			m_nCurSearch = 1;
		end
		-- 弹出搜索到的牌
		PopupSearchCards(m_SearchInfo[m_nCurSearch]);
	end

	return true;
end

--[[--
--按下提示出牌时，搜索可出的牌
--@param #table m_ayCardsLast 对方的牌
--@param #boolean isPopup 是否弹起搜索的牌
--]]
function Search(m_ayCardsLast, isPopup)
	local m_nLastCardsNum = #m_ayCardsLast
	if (not m_bFirstSearch) then
		--Common.log("不是第一次搜索");
		-- 如果不是首次搜索
		if (1 == m_cnSearch) then
			-- 没有找到可出的牌直接PASS
			-- Pass();
			return false;
		end
		if (isPopup) then
			m_nCurSearch = m_nCurSearch + 1
			if (m_nCurSearch >= m_cnSearch) then
				m_nCurSearch = 1;
			end

			-- 弹出搜索到的牌
			PopupSearchCards(m_SearchInfo[m_nCurSearch]);
			local selfCardss = TableCardLayer.getSelfCards()
			TableCardLayer.setMingpaiFlagSprite(selfCardss[#selfCardss].m_CardSprite)
			--Common.log("000001")
		end
		return true;
	end

	local nType = GetCardType(m_ayCardsLast);
	--Common.log("别人的牌：nType ====== "..CARD_TYPE[nType + 1]);
	if (nType == TYPE_TWO_CAT) then
		-- 如果是大小王 直接返回false
		return false;
	end

	local searchSuccess = false;
	local commonCardCnt = 0;-- 普通牌数量
	local xCardCnt = 0;-- 万能牌数量
	local commonCards = {};-- 普通牌数组20
	local xCards = {};-- 万能牌数组4
	--Common.log("xCardWhat =========== "..xCardWhat)
	for i = 1, SelfCardsNum do
		if (SelfCards[i].mbLaiZi) then
			xCardCnt = xCardCnt + 1
			xCards[xCardCnt] = SelfCards[i];
		else
			commonCardCnt = commonCardCnt + 1
			commonCards[commonCardCnt] = SelfCards[i];
		end
	end
	--Common.log("commonCards === "..#commonCards)
	-- 存放手牌
	tempSelfCards = SelfCards;
	tempSelfCardsNum = SelfCardsNum;
	SelfCards = commonCards;
	SelfCardsNum = commonCardCnt;
	if (nType == TYPE_FOUR) then
		-- 炸弹特殊处理
		local isPureBomb = true;-- 纯癞子炸
		local isSoftBomb = false;-- 软炸
		for i = 1, m_nLastCardsNum do
			if (m_ayCardsLast[i].mbLaiZi) then
				isSoftBomb = true;
			else
				isPureBomb = false;
			end
		end
		if (isPureBomb) then
			-- 纯癞子炸
			local nCat = 0;
			for i = 1, SelfCardsNum do
				if (SelfCards[i].m_nValue >= 52) then
					nCat = nCat + 1;
				end
			end
			if (nCat == 2) then
				ClearMark();
				for i = 1, SelfCardsNum do
					if (SelfCards[i].m_nValue >= 52) then
						SelfCards[i]:Mark();
					end
				end
				AddSearch(10 * 100);
				if (isPopup) then
					m_nCurSearch = m_nCurSearch + 1
					if (m_nCurSearch >= m_cnSearch) then
						m_nCurSearch = 1;
					end

					-- 弹出搜索到的牌
					PopupSearchCards(m_SearchInfo[m_nCurSearch]);
				end
				return true;
			end
			return false;
		end
		if (isSoftBomb) then
			-- 软炸 挑出硬炸
			local index = 1;
			for i = 1, commonCardCnt do
				if i >= index  then
					local nWhat = commonCards[i].m_nWhat;
					local n = SearchSameCard(i, nWhat, 4);
					if (n >= 4) then
						AddSearch(n * 100 + nWhat);
						while (index <= commonCardCnt and commonCards[index].m_nWhat == nWhat) do
							index = index + 1;
						end
					else
						index = index + 1;
					end
				end
			end
			if (m_cnSearch > 1) then
				if (isPopup) then
					m_nCurSearch = m_nCurSearch + 1
					if (m_nCurSearch >= m_cnSearch) then
						m_nCurSearch = 1;
					end

					-- 弹出搜索到的牌
					PopupSearchCards(m_SearchInfo[m_nCurSearch]);
				end
				return true;
			end
		end
	end

	local commonSearchResult = oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, commonCards, commonCardCnt);-- 普通牌搜索
	if (commonSearchResult) then
		return true;
	end
	--Common.log("位置::2");
	-- 如果上家出炸弹
	if (nType == TYPE_FOUR) then
		local hasLaizi = false;
		for i = 1, m_nLastCardsNum do
			if (m_ayCardsLast[i].mbLaiZi) then
				hasLaizi = true;
				break;
			end
		end
		if (not hasLaizi) then
			-- 不包含癞子牌
			if (xCardCnt < 4) then
				return false;
			else
				-- 增加到搜索列表中
				m_SearchInfo[m_cnSearch]:SetCardsNum(4);
				m_SearchInfo[m_cnSearch].cnCard = 4;
				m_SearchInfo[m_cnSearch].nWeight = xCards[1].m_nWhat;
				for i = 1, 4 do
					m_SearchInfo[m_cnSearch]:InsertCard(i, xCards[i]);
				end
				m_cnSearch = m_cnSearch + 1;
				return true;-- 普通牌搜索
			end
		end
	end
	--Common.log("位置::3");
	-- 普通牌没有能大过上家的牌型
	local newArray = nil;
	for i = 1, xCardCnt do
		if (i == 1) then
			-- 1张x牌
			--Common.log("位置::4 1张混牌遍历开始");
			local tmp0 = xCards[1];
			local insertCards = { tmp0 };
			for j = 0, 12 do
				-- X牌13种变换
				tmp0.m_nWhat = j;
				-- 第一张X牌 插入普通牌
				newArray = insertArrayIntoArray(commonCards, insertCards);
				m_bFirstSearch = true;
				-- 存放手牌
				tempSelfCards = SelfCards;
				tempSelfCardsNum = SelfCardsNum;
				SelfCards = newArray;
				SelfCardsNum = newArrayCnt;
				--Common.log("#tempSelfCards ==== " .. #tempSelfCards)
				--Common.log("#SelfCards ==== " .. #SelfCards)
				local searchResult = oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, newArray, newArrayCnt);
				if (searchResult) then
					--Common.log("j ========== "..j)
					tmp0.m_nWhat = xCardWhat;
					tmp0.m_LaiziValues = {};
					tmp0:addLaiziValues(j);
					return searchResult;
				end
			end
			tmp0.m_nWhat = xCardWhat;
		--Common.log("位置::4 1张混牌遍历完成");
		elseif (i == 2) then
			-- 2张x牌
			--Common.log("位置::5 2张混牌遍历开始");
			local tmp0 = xCards[1];
			local tmp1 = xCards[2];
			local insertCards = { tmp0, tmp1 };
			for j = 0, 12 do
				tmp0.m_nWhat = j;
				for k = j, 12 do
					-- X牌13种变换
					tmp1.m_nWhat = k;
					-- 第一张X牌 插入普通牌
					newArray = insertArrayIntoArray(commonCards, insertCards);
					m_bFirstSearch = true;
					-- 存放手牌
					tempSelfCards = SelfCards;
					tempSelfCardsNum = SelfCardsNum;
					SelfCards = newArray;
					SelfCardsNum = newArrayCnt;
					local searchResult = oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, newArray, newArrayCnt);
					if (searchResult) then
						tmp0.m_nWhat = xCardWhat;
						tmp1.m_nWhat = xCardWhat;
						tmp0.m_LaiziValues = {};
						tmp0:addLaiziValues(j);
						tmp1.m_LaiziValues = {};
						tmp1:addLaiziValues(k);
						return searchResult;
					end
				end
			end
			tmp0.m_nWhat = xCardWhat;
			tmp1.m_nWhat = xCardWhat;
		--Common.log("位置::5 2张混牌遍历完成");
		elseif (i == 3) then
			-- 3张x牌
			--Common.log("位置::6 3张混牌遍历开始");
			local tmp0 = xCards[1];
			local tmp1 = xCards[2];
			local tmp2 = xCards[3];
			local insertCards = { tmp0, tmp1, tmp2 };
			for j = 0, 12 do
				tmp0.m_nWhat = j;
				for k = j, 12 do
					-- X牌13种变换
					tmp1.m_nWhat = k;
					for l = k, 12 do
						tmp2.m_nWhat = l;
						-- 第一张X牌 插入普通牌
						newArray = insertArrayIntoArray(commonCards, insertCards);
						m_bFirstSearch = true;
						-- 存放手牌
						tempSelfCards = SelfCards;
						tempSelfCardsNum = SelfCardsNum;
						SelfCards = newArray;
						SelfCardsNum = newArrayCnt;
						local searchResult = oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, newArray, newArrayCnt);
						if (searchResult) then
							tmp0.m_nWhat = xCardWhat;
							tmp1.m_nWhat = xCardWhat;
							tmp2.m_nWhat = xCardWhat;
							tmp0.m_LaiziValues = {};
							tmp0:addLaiziValues(j);
							tmp1.m_LaiziValues = {};
							tmp1:addLaiziValues(k);
							tmp2.m_LaiziValues = {};
							tmp2:addLaiziValues(l);
							return searchResult;
						end
					end
				end
			end
			tmp0.m_nWhat = xCardWhat;
			tmp1.m_nWhat = xCardWhat;
			tmp2.m_nWhat = xCardWhat;
		--Common.log("位置::6 3张混牌遍历完成");
		elseif (i == 4) then
			-- 4张x牌
			--Common.log("位置::7 4张混牌遍历开始");
			local tmp0 = xCards[1];
			local tmp1 = xCards[2];
			local tmp2 = xCards[3];
			local tmp3 = xCards[4];
			local insertCards = { tmp0, tmp1, tmp2, tmp3 };
			for j = 0, 12 do
				tmp0.m_nWhat = j;
				for k = j, 12 do
					-- X牌13种变换
					tmp1.m_nWhat = k;
					for l = k, 12 do
						tmp2.m_nWhat = l;
						for m = l, 12 do
							tmp3.m_nWhat = m;
							-- 第一张X牌 插入普通牌
							newArray = insertArrayIntoArray(commonCards, insertCards);
							m_bFirstSearch = true;
							-- 存放手牌
							tempSelfCards = SelfCards;
							tempSelfCardsNum = SelfCardsNum;
							SelfCards = newArray;
							SelfCardsNum = newArrayCnt;
							local searchResult = oldSearch(m_ayCardsLast, m_nLastCardsNum, isPopup, newArray, newArrayCnt);
							--Common.log("位置::7 4张混牌遍历 j=" .. j .. " k=" .. k .. " l=" .. l .. " m=" .. m .. " result=" .. searchResult);
							if (searchResult) then
								tmp0.m_nWhat = xCardWhat;
								tmp1.m_nWhat = xCardWhat;
								tmp2.m_nWhat = xCardWhat;
								tmp3.m_nWhat = xCardWhat;
								tmp0.m_LaiziValues = {};
								tmp0:addLaiziValues(j);
								tmp1.m_LaiziValues = {};
								tmp1:addLaiziValues(k);
								tmp2.m_LaiziValues = {};
								tmp2:addLaiziValues(l);
								tmp3.m_LaiziValues = {};
								tmp3:addLaiziValues(m);
								return searchResult;
							end

						end
					end
				end
			end
			tmp0.m_nWhat = xCardWhat;
			tmp1.m_nWhat = xCardWhat;
			tmp2.m_nWhat = xCardWhat;
			tmp3.m_nWhat = xCardWhat;
		--Common.log("位置::7 4张混牌遍历完成");
		end

	end

	return searchSuccess;
end