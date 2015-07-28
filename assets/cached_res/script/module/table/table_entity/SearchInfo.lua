--存放搜索到的牌型
SearchInfo = {
	cnCard = 0,
	nWeight = 0,
	cardList = {},
	m_nCount = 0
}

SearchInfo.__index = SearchInfo

function SearchInfo:new()
	local self = {}
	setmetatable(self, SearchInfo)

	return self  --返回自身
end

--[[--
-- 设置此搜索信息中牌张数
--]]
function SearchInfo:SetCardsNum(nCount)

	self.cardList = {};
	if(self.cardList == nil) then
		self.m_nCount = 0;
	else
		self.m_nCount = nCount;
	end
end

--[[--
-- 增加一张牌到搜索列表中
--]]
function SearchInfo:InsertCard(nIndex, card)

	if(nIndex > self.m_nCount)then
		return -1;
	end
	self.cardList[nIndex] = card;

	return nIndex;
end

--[[--
-- 从搜索列表中取得一张牌
--]]
function SearchInfo:GetCard(nIndex)

	if(nIndex > self.m_nCount) then
		return nil;
	end
	return self.cardList[nIndex];
end
