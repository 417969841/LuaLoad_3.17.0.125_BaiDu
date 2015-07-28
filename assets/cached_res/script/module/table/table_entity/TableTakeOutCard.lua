TableTakeOutCard = {
	-- 原始牌值
	mnTheOriginalValue = -1;
	-- 展示在牌桌上的最终牌值
	mnTheEndValue = -1;
	-- 是否是癞子变换后的牌值
	mbIsLaiZi = false;
	-- 癞子变换后的可能牌值(多种)
	malLaiZiChangeVal = {};
}

TableTakeOutCard.__index = TableTakeOutCard

function TableTakeOutCard:new()
	local self = {}
	setmetatable(self, TableTakeOutCard)

	return self
end


