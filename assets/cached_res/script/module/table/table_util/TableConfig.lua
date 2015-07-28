module("TableConfig", package.seeall)

TableDefaultWidth = 1136 -- 牌桌默认宽度
TableDefaultHeight = 640 -- 牌桌默认高度
TableRealHeight = 640 -- 牌桌实际高度
TableScaleX = 1 -- 牌桌缩放比例x
TableScaleY = 1 -- 牌桌缩放比例y
cardWidth = 128 -- 纸牌宽
cardHeight = 160 -- 纸牌高
BottomH = 45 --牌桌底部布局高度

TableCardsPos = { { TableDefaultWidth / 2, 300 }, { TableDefaultWidth - 130, 450 }, { 130, 450 } };--桌上的牌的位置

StandardPos = { {0, 0}, { TableDefaultWidth - 100, 410}, { 100, 410} };--人物站位

FlyCoinPos = { {64, 42}, { TableDefaultWidth - 100, 350}, { 100, 350} };--飞金币坐标

EmtionPos = {{150, 240},{TableDefaultWidth - 300, 400},{300, 400}};--表情位置