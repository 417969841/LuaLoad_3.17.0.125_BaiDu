--用lua进行面向对象的编程,声明方法和调用方法统一用冒号,对于属性的调用全部用点号

--声明，这里声明了类名还有属性，并且给出了属性的初始值。
TablePayer = {
	m_nRoomID = 0,
	m_nTableID = 0,
	m_nSeatID = 0,
	m_sNickName = "",
  	m_nWinChip = 0,-- 上局赢得积分/金币数
  	m_nChipCnt = 0,-- 剩余金币数
  	m_nWinScoreCnt = 0,-- 积分变化
 	m_nRemainScoreCnt = 0,-- 剩余积分
	m_bTrustPlay = false,-- 是否托管中
	m_nTrustType = 0,-- 托管类型
	m_bReady = false,-- 是否准备好开始游戏
	m_nCallScore = -1,-- 叫分
	m_nGrabScore = -1,-- 抢地主 0不抢，1抢
	m_nDoubleScore = -1,-- …doubleScore  加倍倍数 是否加倍 -1是还没加倍 ，0不加倍, 2两倍, 4 四倍
	m_nCanDoubleMax = -1,-- 可以加倍的最大数 0:不能加倍, 2:可以加2倍, 4:可以加4倍
	m_nNoDoubleReason = -1,-- …NoDoubleReason Byte 0 N/A 1自己金币不足 2别人金币不足
	m_nMinCoins = -1,-- …MinCoins  满足加倍条件的最低金币数
	mnOpenCardsTimes = 1,-- 明牌的倍数
	m_nCardCnt = 0,-- 牌数量
	m_bIsLord = false,-- 是否地主
	isNewTablePlayer = 0,-- …isNewTablePlayer	byte	是不是新加入牌桌的人，用于判断是否可被踢 1是新人不可踢 0 可踢
	m_nRemainCardCnt = 0,-- 剩余牌数
	m_anRemainCards = {},-- 剩余牌
	m_nTaskTimes = 1,-- 任务倍数 1为没完成
	m_nAnimType = 0,-- 动画类型
	m_nAnimFlag = -1,-- 当player为地主或自己时为-1
	m_nPos = 0,-- 玩家位置，0，1，2，与动画ID相对应(自己的位置永远是0,逆时针旋转)
	m_sTitle = "",-- 称号
	m_nMasterScore = 0,-- 大师分
	m_nWinMasterScore = 0,
	m_nWinRate = 0,-- 胜率
	m_nBrokenRate = 0,-- 逃跑率
	m_nCoin = 0,
	m_nUserID = 0,
	m_sPhotoUrl = "",
	m_sSign = "",
	m_nHonor = 0,
	m_nDuiJiang = 0,
	m_nYuanbao = 0,-- 元宝
	ladderScore = 0,-- 天梯积分
	ladderRanking = 0,-- 天梯排名
	ladderTitleUrl = "",-- 天梯称号网址
	m_nMasterPlayer = 0,-- 冲榜高手
	mnVipLevel = 0,
	mnVipCoinAddition = 0,-- 玩家Vip金币加成百分比 普通玩家：100 黄金VIP：120
	ladderDuan = 0,-- 天梯段位
	ladderLevel = 0,-- 天梯等级
	userSex = "",-- 用户信息 男
	userAge = "",-- 用户信息 男 10岁
	userAddress = "",-- 用户信息 北京-西城区
	round = 0,-- 局数
	titlePicUrl = "",-- 玩家系统称号网址
	mnSex = 0,-- sex == 1 "男"sex == 2 "女"
	djqPieces = 0-- 兑奖券碎片
}

TablePayer.__index = TablePayer

function TablePayer:new()
	local self = {}  --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(self, TablePayer)  --将self的元表设定为TablePayer

	return self  --返回自身
end

--[[--
--设置显示动画
--@param #number nAnimType 动画类型
--]]
function TablePayer:setAnim(nAnimType)
	if not self.m_bTrustPlay then
		Common.log("动画类型 === "..nAnimType);
		GameArmature.setPalyerArmature(self.m_nPos, self.mnSex, self.m_bIsLord, nAnimType)
	else
		if nAnimType == GameArmature.ARMATURE_TUOGUAN then
			GameArmature.setPalyerArmature(self.m_nPos, self.mnSex, self.m_bIsLord, nAnimType)
		end
	end
end

