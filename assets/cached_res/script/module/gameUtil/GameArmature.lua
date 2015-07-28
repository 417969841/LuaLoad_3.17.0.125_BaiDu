module("GameArmature", package.seeall)

SECRECY = 0;-- 保密
MAN = 1;-- 男
WOMAN = 2;-- 女

ARMATURE_DAIJI = "daiji"--待机
ARMATURE_BUYAO = "buyao"--不要
ARMATURE_SHENGLI = "shengli"--胜利
ARMATURE_SHIBAI = "shibai"--失败
ARMATURE_TUOGUAN = "tuoguan"--托管
ARMATURE_ZHADAN = "zhadan"--炸弹
ARMATURE_TUOGUAN_RIGHT = "youtuoguan"--右托管
ARMATURE_ZHADAN_RIGHT = "youzhadan"--右炸弹
ARMATURE_CHUPAI = "chupai"--出牌

ARMATURE_DIZHU = "lordAnim"--男地主动画集
ARMATURE_DIZHU_WOMAN = "lordfemaleAnim"--女地主动画集
ARMATURE_DIZHU_PREFIX = "dizhu_"--地主动画前缀

ARMATURE_NONGMIN = "farmerAnim"--男农民动画集
ARMATURE_NONGMIN_WOMAN = "farmerfemaleAnim"--女农民动画集
ARMATURE_NONGMIN_PREFIX = "nongmin_"--地主动画前缀

ARMATURE_NONGMIN_TIREN = "tiren"--农民被踢出房间的动画
ARMATURE_NONGMIN_JINRU = "jinru"--农民进入房间的动画

ARMATURE_TABLE = "paixingdonghua"--牌桌动画集
ARMATURE_TABLE_SHIBAI = "shibai"--失败
ARMATURE_TABLE_SHENGLI = "shengli"--胜利
ARMATURE_TABLE_FEIJI = "feiji"--飞机
ARMATURE_TABLE_SHUNZI = "shunzi"--顺子
ARMATURE_TABLE_HUOJIAN = "huojian"--火箭
ARMATURE_TABLE_ZHADAN = "zhadan"--炸弹
ARMATURE_TABLE_LAOHUJI = "laohuji"--老虎机
ARMATURE_TABLE_CHUNTIAN = "chuntian"--春天

--首页动画
ARMATURE_HALL = "HallAnimation";--大厅动画集
ARMATURE_HALL_MATCHGAME = "bisaiyingjiang";--比赛赢奖按钮
ARMATURE_HALL_LEISUREGAME = "xiuxianfangjian";--休闲房间按钮
ARMATURE_HALL_LUCKYGAME = "xingyunyouxi";--幸运游戏按钮
ARMATURE_HALL_PKGAME = "fengkuangchuangguan";--疯狂闯关按钮
ARMATURE_HALL_CAISHEN = "caishen";--财神按钮

local hallBtnArmature = {};--大厅按钮骨骼动画
local matchGameArmature = nil;--比赛赢奖骨骼动画
local leisureGameArmature = nil;--休闲房间骨骼动画
local luckyGameArmature = nil;--幸运游戏骨骼动画
local pkGameArmature = nil;--疯狂闯关骨骼动画
local caishenArmature = nil;--财神骨骼动画
local vipArmature = nil;--VIP优惠动画
local vipArmatureOfUserInfo = nil --VIP优惠动画(个人资料)

local mArmatureLord = nil--男地主动画
local mArmatureFarmerRight = nil--男下家农民
local mArmatureFarmerLeft = nil--男上家农民

local mArmatureTable = nil--牌桌动画
local armatureLoading = nil--牌桌loading动画
local mArmatureShifted = {}--变身动画(下标:pos+1)
local mArmatureTianti = nil --天梯动画
local mArmatureTiantiShengDuan = nil--天梯升段动画
local mArmatureGameLoading = nil--游戏中loading动画loading

MovementEventType = {
	START = 0,
	COMPLETE = 1,
	LOOP_COMPLETE = 2,
}

local function animationEvent(armatureBack, movementType, movementID)
	--	Common.log("movementType == "..movementType)
	--	Common.log("movementID == "..movementID)
	local id = movementID
	if movementType == MovementEventType.LOOP_COMPLETE then
		--循环动画结束一次
		if id == ARMATURE_DIZHU_PREFIX .. ARMATURE_DAIJI then
			armatureBack:stopAllActions()
		elseif id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_DAIJI then
			armatureBack:stopAllActions()
		end
	elseif movementType == MovementEventType.COMPLETE then
		--动画结束一次
		--地主
		if id == ARMATURE_DIZHU_PREFIX .. ARMATURE_BUYAO or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_SHENGLI or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_SHIBAI or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_TUOGUAN or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_CHUPAI or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_ZHADAN then
			armatureBack:stopAllActions()
			armatureBack:getAnimation():play(ARMATURE_DIZHU_PREFIX..ARMATURE_DAIJI)
		elseif id == ARMATURE_DIZHU_PREFIX .. ARMATURE_TUOGUAN_RIGHT or
			id == ARMATURE_DIZHU_PREFIX .. ARMATURE_ZHADAN_RIGHT then
			armatureBack:stopAllActions()
			armatureBack:setScaleX(-1)
			armatureBack:getAnimation():play(ARMATURE_DIZHU_PREFIX..ARMATURE_DAIJI)
		end
		--农民
		if id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_BUYAO or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_SHENGLI or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_SHIBAI or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_TUOGUAN or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_CHUPAI or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_ZHADAN or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_NONGMIN_JINRU then
			armatureBack:stopAllActions()
			armatureBack:getAnimation():play(ARMATURE_NONGMIN_PREFIX..ARMATURE_DAIJI)
		elseif id == ARMATURE_NONGMIN_PREFIX..ARMATURE_NONGMIN_TIREN then
			armatureBack:stopAllActions()
			armatureBack:setVisible(false)
			TableConsole.afterKickOutPlayer()
		elseif id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_TUOGUAN_RIGHT or
			id == ARMATURE_NONGMIN_PREFIX .. ARMATURE_ZHADAN_RIGHT then
			armatureBack:stopAllActions()
			armatureBack:setScaleX(-1)
			armatureBack:getAnimation():play(ARMATURE_NONGMIN_PREFIX..ARMATURE_DAIJI)
		end
		--牌桌牌型动画
		if id == ARMATURE_TABLE_SHIBAI or
			id == ARMATURE_TABLE_SHENGLI or
			id == ARMATURE_TABLE_FEIJI or
			id == ARMATURE_TABLE_SHUNZI or
			id == ARMATURE_TABLE_HUOJIAN or
			id == ARMATURE_TABLE_ZHADAN or
			id == ARMATURE_TABLE_CHUNTIAN then
			armatureBack:stopAllActions()
			armatureBack:setVisible(false)
		elseif id == ARMATURE_TABLE_LAOHUJI then
			--老虎机动画
			armatureBack:stopAllActions()
			armatureBack:setVisible(false)
			TableCardLayer.showLaiZiCard(TableConsole.tempLaiziCardVal)
		elseif id == "tiantishengduan" then
			--天梯升段动画
			closeTiantiShengDuanAnim();
		elseif id == "bianshen" then
			--变身动画
			armatureBack:stopAllActions()
			armatureBack:setVisible(false)
		end

	end
end

local function initLord(sex)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
	end
	--地主
	if mArmatureLord == nil then
		if sex == WOMAN then
			mArmatureLord = CCArmature:create(ARMATURE_DIZHU_WOMAN)
		else
			mArmatureLord = CCArmature:create(ARMATURE_DIZHU)
		end
		mArmatureLord:setVisible(false)
		TableElementLayer.getElementLayer():addChild(mArmatureLord)
		mArmatureLord:getAnimation():setMovementEventCallFunc(animationEvent)
	end
end

function removeLord()
	if mArmatureLord ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureLord, true)
		mArmatureLord = nil
	end

end

function updataLord(sex)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
	end
	removeLord()
	initLord(sex)
end

local function initFarmerRight(sex)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
	end
	--下家农民
	if mArmatureFarmerRight == nil then
		if sex == WOMAN then
			mArmatureFarmerRight = CCArmature:create(ARMATURE_NONGMIN_WOMAN)
		else
			mArmatureFarmerRight = CCArmature:create(ARMATURE_NONGMIN)
		end
		mArmatureFarmerRight:setVisible(false)
		TableElementLayer.getElementLayer():addChild(mArmatureFarmerRight)
		mArmatureFarmerRight:getAnimation():setMovementEventCallFunc(animationEvent)
	end
end

local function removeFarmerRight()
	if mArmatureFarmerRight ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureFarmerRight, true)
		mArmatureFarmerRight = nil
	end

end

function updataFarmerRight(sex)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
	end
	removeFarmerRight()
	initFarmerRight(sex)
end

local function initFarmerLeft(sex)
	if not GameConfig.gameIsFullPackage() then
		Common.log("not gameIsFullPackage")
		sex = MAN
	end
	--上家农民
	if mArmatureFarmerLeft == nil then
		if sex == WOMAN then
			mArmatureFarmerLeft = CCArmature:create(ARMATURE_NONGMIN_WOMAN)
		else
			mArmatureFarmerLeft = CCArmature:create(ARMATURE_NONGMIN)
		end
		mArmatureFarmerLeft:setVisible(false)
		TableElementLayer.getElementLayer():addChild(mArmatureFarmerLeft)
		mArmatureFarmerLeft:getAnimation():setMovementEventCallFunc(animationEvent)
	end
end

local function removeFarmerLeft()
	if mArmatureFarmerLeft ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureFarmerLeft, true)
		mArmatureFarmerLeft = nil
	end
end

function updataFarmerLeft(sex)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
	end
	removeFarmerLeft()
	initFarmerLeft(sex)
end

--[[--
--创建骨骼动画
--]]
function initTableArmature()
	--牌桌动画
	if mArmatureTable == nil then
		mArmatureTable = CCArmature:create(ARMATURE_TABLE)
		mArmatureTable:setVisible(false)
		TableElementLayer.getElementLayer():addChild(mArmatureTable)
		mArmatureTable:getAnimation():setMovementEventCallFunc(animationEvent)
	end
	--牌桌等待loading动画
	if armatureLoading == nil then
		armatureLoading = CCArmature:create("loading")
		armatureLoading:setVisible(false)
		armatureLoading:setPosition(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight * 0.7)
		TableElementLayer.getElementLayer():addChild(armatureLoading)
		armatureLoading:getAnimation():setMovementEventCallFunc(animationEvent)
	end
	--变身动画
	mArmatureShifted = {};
	for i = 1, #TableConfig.StandardPos do
		mArmatureShifted[i] = CCArmature:create("bianshen")
		mArmatureShifted[i]:setVisible(false)
		if i == 1 then
			mArmatureShifted[i]:setPosition(64, 45)
		else
			mArmatureShifted[i]:setPosition(TableConfig.StandardPos[i][1], TableConfig.StandardPos[i][2])
		end

		TableElementLayer.getElementLayer():addChild(mArmatureShifted[i])
		mArmatureShifted[i]:getAnimation():setMovementEventCallFunc(animationEvent)
	end
end

--[[--
--显示变身动画
--]]
function showArmatureShifted(pos)
	if mArmatureShifted[pos + 1] ~= nil then
		mArmatureShifted[pos + 1]:setVisible(true)
		mArmatureShifted[pos + 1]:getAnimation():play("bianshen")
	end
end

--[[--
--关闭天梯动画
--]]
function closeTiantiAnim()
	if mArmatureTianti ~= nil then
		mArmatureTianti:stopAllActions()
		TableElementLayer.getElementLayer():removeChild(mArmatureTianti, true);
		mArmatureTianti = nil;
	end
end

--[[--
--显示天梯动画
--]]
function showTiantiAnim(name)
	if mArmatureTianti == nil then
		mArmatureTianti = CCArmature:create("tiantidonghua")
		mArmatureTianti:getAnimation():play(name)
		mArmatureTianti:setPosition(1075, 150)
		TableElementLayer.getElementLayer():addChild(mArmatureTianti)
		mArmatureTianti:getAnimation():setMovementEventCallFunc(animationEvent)
	end
end

--[[--
--关闭天梯升段动画
--]]
function closeTiantiShengDuanAnim()
	if mArmatureTiantiShengDuan ~= nil then
		mArmatureTiantiShengDuan:stopAllActions()
		TableElementLayer.getElementLayer():removeChild(mArmatureTiantiShengDuan, true);
		mArmatureTiantiShengDuan = nil;
	end
end

--[[--
--天梯升段动画
--]]
function showTiantiShengDuanAnim()
	if GameConfig.gameIsFullPackage() then
		if mArmatureTiantiShengDuan == nil then
			mArmatureTiantiShengDuan = CCArmature:create("tiantishengduan")
			mArmatureTiantiShengDuan:getAnimation():play("tiantishengduan")
			mArmatureTiantiShengDuan:setPosition(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight / 2)
			TableElementLayer.getElementLayer():addChild(mArmatureTiantiShengDuan)
			mArmatureTiantiShengDuan:getAnimation():setMovementEventCallFunc(animationEvent)
		end
	end
end

--[[--
--隐藏牌桌loading动画
--]]
function hideLoadingAnim()
	if armatureLoading ~= nil then
		armatureLoading:stopAllActions()
		armatureLoading:setVisible(false)
	end
end

--[[--
--显示牌桌loading动画
--]]
function showLoadingAnim()
	if armatureLoading ~= nil then
		armatureLoading:getAnimation():play("miniloading")
		armatureLoading:setVisible(true)
	end
end

--[[--
--隐藏游戏中loading界面
--]]
function hideGameLoadingAnim(view)
	if mArmatureGameLoading ~= nil then
		mArmatureGameLoading:stopAllActions()
		mArmatureGameLoading:setVisible(false)
		view:removeChild(mArmatureGameLoading, true);
		mArmatureGameLoading = nil;
	end
end

--[[--
--显示游戏中loading界面
--]]
function showGameLoadingAnim(view, x, y)
	if mArmatureGameLoading == nil then
		mArmatureGameLoading = CCArmature:create("loading")
		mArmatureGameLoading:getAnimation():play("loading")
		if x ~= nil and y ~= nil then
			mArmatureGameLoading:setPosition(x, y)
		else
			mArmatureGameLoading:setPosition(GameConfig.ScreenWidth / 2, GameConfig.ScreenHeight / 2)
		end
		mArmatureGameLoading:setVisible(true)
		view:addChild(mArmatureGameLoading)
	end
end

local MusicAmin = nil;
local SoundAmin = nil;
local AutomationAmin = nil;
local RevibrateAmin = nil

--[[--
--隐藏震动Icon动画
--]]
function hideVibrateAmin(view)
	if RevibrateAmin ~= nil then
		RevibrateAmin:stopAllActions()
		RevibrateAmin:setVisible(false)
		view:removeChild(RevibrateAmin, true);
		RevibrateAmin = nil;
	end
end

--[[--
--显示震动Icon动画
--]]
function showVibrateAmin(view, x, y)
	if RevibrateAmin == nil then
		RevibrateAmin = CCArmature:create("settings")
		RevibrateAmin:getAnimation():play("zhendong")
		RevibrateAmin:setScale(0.8)
		RevibrateAmin:setPosition(x, y)
		view:addChild(RevibrateAmin)
	end
end

--[[--
--隐藏音乐Icon动画
--]]
function hideMusicAmin(view)
	if MusicAmin ~= nil then
		MusicAmin:stopAllActions()
		MusicAmin:setVisible(false)
		view:removeChild(MusicAmin, true);
		MusicAmin = nil;
	end
end

--[[--
--显示音乐Icon动画
--]]
function showMusicAmin(view, x, y)
	if MusicAmin == nil then
		MusicAmin = CCArmature:create("settings")
		MusicAmin:getAnimation():play("music")
		MusicAmin:setPosition(x, y)
		view:addChild(MusicAmin)
	end
end

--[[--
--隐藏音效Icon动画
--]]
function hideSoundAmin(view)
	if SoundAmin ~= nil then
		SoundAmin:stopAllActions()
		SoundAmin:setVisible(false)
		view:removeChild(SoundAmin, true);
		SoundAmin = nil;
	end
end

--[[--
--显示音效Icon动画
--]]
function showSoundAmin(view, x, y)
	if SoundAmin == nil then
		SoundAmin = CCArmature:create("settings")
		SoundAmin:getAnimation():play("volume")
		SoundAmin:setPosition(x, y)
		view:addChild(SoundAmin)
	end
end

--[[--
--隐藏提示出牌Icon动画
--]]
function hideAutomationAmin(view)
	if AutomationAmin ~= nil then
		AutomationAmin:stopAllActions()
		AutomationAmin:setVisible(false)
		view:removeChild(AutomationAmin, true);
		AutomationAmin = nil;
	end
end

--[[--
--显示提示出牌Icon动画
--]]
function showAutomationAmin(view, x, y)
	if AutomationAmin == nil then
		AutomationAmin = CCArmature:create("settings")
		AutomationAmin:getAnimation():play("chupaitishi")
		AutomationAmin:setScale(0.9)
		AutomationAmin:setPosition(x, y)
		view:addChild(AutomationAmin)
	end
end


--[[--
--设置人物动画
--@param #number pos 人物位置
--@param #number sex 人物性别
--@param #boolean isLord 是否是地主
--@param #number animType 动画类型
--]]
function setPalyerArmature(pos, sex, isLord, animType)
	if not GameConfig.gameIsFullPackage() then
		sex = MAN
		if animType == ARMATURE_BUYAO
			or animType == ARMATURE_SHENGLI
			or animType == ARMATURE_ZHADAN
			or animType == ARMATURE_SHIBAI
			or animType == ARMATURE_CHUPAI then
			--非完整包不显示不要、胜利、失败、出牌、炸弹
			return
		end
	end
	if pos == 1 and isLord then
		--创建下家地主
		if mArmatureFarmerRight ~= nil then
			mArmatureFarmerRight:setVisible(false)
		end
		if mArmatureLord == nil then
			updataLord(sex)
		end
		mArmatureLord:stopAllActions();
		if animType == ARMATURE_TUOGUAN then
			animType = ARMATURE_TUOGUAN_RIGHT
			mArmatureLord:setScaleX(1)
		elseif animType == ARMATURE_ZHADAN then
			animType = ARMATURE_ZHADAN_RIGHT
			mArmatureLord:setScaleX(1)
		else
			mArmatureLord:setScaleX(-1)
		end
		mArmatureLord:setPosition(TableConfig.StandardPos[pos + 1][1], TableConfig.StandardPos[pos + 1][2])
		mArmatureLord:getAnimation():play(ARMATURE_DIZHU_PREFIX..animType)
		mArmatureLord:setVisible(true)
	elseif pos == 2 and isLord then
		--创建上家地主
		if mArmatureFarmerLeft ~= nil then
			mArmatureFarmerLeft:setVisible(false)
		end
		if mArmatureLord == nil then
			updataLord(sex)
		end
		mArmatureLord:stopAllActions();
		mArmatureLord:setScaleX(1)
		mArmatureLord:setPosition(TableConfig.StandardPos[pos + 1][1], TableConfig.StandardPos[pos + 1][2])
		mArmatureLord:getAnimation():play(ARMATURE_DIZHU_PREFIX..animType)
		mArmatureLord:setVisible(true)
	elseif pos == 1 and not isLord then
		--创建下家农民
		if mArmatureFarmerRight ~= nil then
			mArmatureFarmerRight:stopAllActions();
			if animType == ARMATURE_TUOGUAN then
				animType = ARMATURE_TUOGUAN_RIGHT
				mArmatureFarmerRight:setScaleX(1)
			elseif animType == ARMATURE_ZHADAN then
				animType = ARMATURE_ZHADAN_RIGHT
				mArmatureFarmerRight:setScaleX(1)
			else
				mArmatureFarmerRight:setScaleX(-1)
			end
			mArmatureFarmerRight:setPosition(TableConfig.StandardPos[pos + 1][1], TableConfig.StandardPos[pos + 1][2])
			mArmatureFarmerRight:getAnimation():play(ARMATURE_NONGMIN_PREFIX..animType)
			mArmatureFarmerRight:setVisible(true)
		end
	elseif pos == 2 and not isLord then
		--创建上家农民
		if mArmatureFarmerLeft ~= nil then
			mArmatureFarmerLeft:stopAllActions();
			mArmatureFarmerLeft:setScaleX(1)
			mArmatureFarmerLeft:setPosition(TableConfig.StandardPos[pos + 1][1], TableConfig.StandardPos[pos + 1][2])
			mArmatureFarmerLeft:getAnimation():play(ARMATURE_NONGMIN_PREFIX..animType)
			mArmatureFarmerLeft:setVisible(true)
		end
	end
end

--[[--
--显示两个农民
--]]
function showDoubleFarmer()

	removeLord()
	if mArmatureFarmerRight ~= nil then
		mArmatureFarmerRight:setScaleX(-1)
		mArmatureFarmerRight:setPosition(TableConfig.StandardPos[2][1], TableConfig.StandardPos[2][2])
		mArmatureFarmerRight:getAnimation():play(ARMATURE_NONGMIN_PREFIX..ARMATURE_DAIJI)
		mArmatureFarmerRight:setVisible(true)
	end
	if mArmatureFarmerLeft ~= nil then
		mArmatureFarmerLeft:setScaleX(1)
		mArmatureFarmerLeft:setPosition(TableConfig.StandardPos[3][1], TableConfig.StandardPos[3][2])
		mArmatureFarmerLeft:getAnimation():play(ARMATURE_NONGMIN_PREFIX..ARMATURE_DAIJI)
		mArmatureFarmerLeft:setVisible(true)
	end
end

--[[--
--设置牌桌动画
--]]
function setTableArmature(animType)
	if mArmatureTable == nil then
		return
	end
	if not GameConfig.gameIsFullPackage() then
		if animType == ARMATURE_TABLE_FEIJI or animType == ARMATURE_TABLE_SHUNZI or animType == ARMATURE_TABLE_CHUNTIAN then
			--非完整包不显示飞机、顺子、春天
			return
		end
	end
	mArmatureTable:setPosition(TableConfig.TableDefaultWidth / 2, TableConfig.TableDefaultHeight / 2)
	mArmatureTable:getAnimation():play(animType)
	mArmatureTable:setVisible(true)

end

local function hideFarmer1Armature()
	if mArmatureFarmerRight ~= nil and mArmatureFarmerRight:isVisible() then
		local move = CCMoveBy:create(0.5,ccp(600,0));
		local arr = CCArray:create();
		arr:addObject(move);
		local seq = CCSequence:create(arr);
		mArmatureFarmerRight:runAction(seq);

		local function setArmaturehide()
			Common.log("hideFarmer1Armature mArmatureFarmerRight ================== ")
			mArmatureFarmerRight:setVisible(false);
		end

		local hide = CCArray:create();
		hide:addObject(CCDelayTime:create(0.2));
		hide:addObject(CCCallFuncN:create(setArmaturehide));
		mArmatureFarmerRight:runAction(CCSequence:create(hide));
	end
end

local function hideFarmer2Armature()
	if mArmatureFarmerLeft ~= nil and mArmatureFarmerLeft:isVisible() then
		local move = CCMoveBy:create(0.5,ccp(-600,0));
		local arr = CCArray:create();
		arr:addObject(move);
		local seq = CCSequence:create(arr);
		mArmatureFarmerLeft:runAction(seq);

		local function setArmaturehide()
			Common.log("hideFarmer2Armature mArmatureFarmerLeft ================== ")
			mArmatureFarmerLeft:setVisible(false);
		end

		local hide = CCArray:create();
		hide:addObject(CCDelayTime:create(0.2));
		hide:addObject(CCCallFuncN:create(setArmaturehide));
		mArmatureFarmerLeft:runAction(CCSequence:create(hide));
	end
end

local function hideLordArmature()
	if mArmatureLord ~= nil and mArmatureLord:isVisible() then
		mArmatureLord:setVisible(false);
	end
end

--[[--
--按位置隐藏动画
--]]
function hideTableArmature(pos)
	if pos == 1 then
		hideFarmer1Armature();
	elseif pos == 2 then
		hideFarmer2Armature();
	end
end

--[[--
--隐藏所有动画
--]]
function hideAllTableArmature()
	hideFarmer1Armature();
	hideFarmer2Armature();
	hideLordArmature();
	mArmatureTable:setVisible(false);
end

--[[--
--删除动画
--]]
function removeArmature()
	Common.log("删除骨骼动画===================")

	removeLord()
	removeFarmerRight()
	removeFarmerLeft()

	if mArmatureTable ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureTable, true)
		mArmatureTable = nil
	end
	if armatureLoading ~= nil then
		TableElementLayer.getElementLayer():removeChild(armatureLoading, true)
		armatureLoading = nil
	end
	if mArmatureTianti ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureTianti, true)
		mArmatureTianti = nil
	end
	if mArmatureTiantiShengDuan ~= nil then
		TableElementLayer.getElementLayer():removeChild(mArmatureTiantiShengDuan, true)
		mArmatureTiantiShengDuan = nil
	end
	if mArmatureShifted ~= nil then
		for i = 1, #mArmatureShifted do
			if mArmatureShifted[i] ~= nil then
				TableElementLayer.getElementLayer():removeChild(mArmatureShifted[i], true)
			end
		end
		mArmatureShifted = {}
	end
end


---------大厅按钮骨骼动画----------------

--[[--
--按钮骨骼动画事件回调
--@param #CCArmature armature 骨骼动画
--@param #number movementType 是否循环
--@param #String movementID 播放动画的name
--]]
local function btnAnimationEventCallFunc(armatureBack, movementType, movementID)
	--延时播放骨骼动画
	local function delayPlayBrmature()
		if HallLogic.view ~= nil and GameConfig.getHallShowMode() == HallLogic.getHallModeValue() and armatureBack ~= nil then
			--大厅模式才播放动画
			armatureBack:getAnimation():play(movementID);
		end
	end

	if movementType == MovementEventType.LOOP_COMPLETE then
	--循环动画结束一次
	elseif movementType == MovementEventType.COMPLETE then
		--动画结束一次

		armatureBack:stopAllActions();

		if HallLogic.view ~= nil and GameConfig.getHallShowMode() == HallLogic.getHallModeValue() then
			--大厅模式才执行回调
			local array = CCArray:create();
			local time = math.random(5, 10);--随机延时播放的时间
			array:addObject(CCDelayTime:create(time));
			array:addObject(CCCallFuncN:create(delayPlayBrmature));
			HallLogic.view:runAction(CCSequence:create(array))
		end

	elseif movementType == MovementEventType.START then
	end
end

--[[--
--隐藏按钮骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function hideBtnArmature(btnArmature)
	if btnArmature ~= nil and btnArmature:isVisible() then
		btnArmature:stopAllActions();
		btnArmature:setVisible(false);
	end
end

--[[--
--显示按钮骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function showBtnArmature(btnArmature)
	if btnArmature ~= nil and btnArmature:isVisible() == false then
		btnArmature:setVisible(true);
	end
end

--[[--
--隐藏大厅按钮骨骼动画
--]]
function hideHallBtnArmature()
	for i = 1, #hallBtnArmature do
		hideBtnArmature(hallBtnArmature[i]);
	end
end

--[[--
--在大厅按钮骨骼动画table中移除骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function removeArmatureInHallBtnArmatureTable(btnArmature)
	for key, value in pairs(hallBtnArmature) do
		if value == btnArmature then
			table.remove(hallBtnArmature, key);
			break;
		end
	end
end

--[[--
--移除大厅按钮按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallBtnArmature(view)
	--移除比赛赢奖按钮骨骼动画
	removeMatchGameBtnArmature(view)
	--移除休闲房间按钮骨骼动画
	removeLeisureGameBtnArmature(view)
	--移除幸运游戏按钮骨骼动画
	removeLuckyGameBtnArmature(view);
	--移除疯狂闯关按钮骨骼动画
	removePkGameBtnArmature(view);
	--移除财神骨骼动画
	removeCaishenBtnArmature(view);
	--移除VIP优惠骨骼动画
	removeVipSaleArmature(view)
end

--[[--
--显示比赛赢奖按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showMatchGameBtnArmature(view,x,y)
	if matchGameArmature == nil then
		--如果骨骼动画不存在,create
		matchGameArmature = CCArmature:create(ARMATURE_HALL);
		table.insert(hallBtnArmature, matchGameArmature);
		view:addChild(matchGameArmature);
	else
		--如果骨骼动画存在,show
		matchGameArmature:stopAllActions();
		showBtnArmature(matchGameArmature);
	end
	--开启可能会转换位置
	matchGameArmature:setPosition(ccp(x,y));
	matchGameArmature:getAnimation():play(ARMATURE_HALL_MATCHGAME);
	matchGameArmature:getAnimation():setMovementEventCallFunc(btnAnimationEventCallFunc);
end

--[[--
--移除比赛赢奖按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeMatchGameBtnArmature(view)
	if matchGameArmature ~= nil then
		matchGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(matchGameArmature);
		view:removeChild(matchGameArmature, true);
		matchGameArmature = nil;
	end
end

--[[--
--显示休闲房间按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showLeisureGameBtnArmature(view,x,y)
	if leisureGameArmature == nil then
		--如果骨骼动画不存在,create
		leisureGameArmature = CCArmature:create(ARMATURE_HALL);
		table.insert(hallBtnArmature, leisureGameArmature);
		view:addChild(leisureGameArmature);
	else
		leisureGameArmature:stopAllActions();
		--如果骨骼动画存在,show
		showBtnArmature(leisureGameArmature);
	end
	--开启可能会转换位置
	leisureGameArmature:setPosition(ccp(x,y));
	leisureGameArmature:getAnimation():play(ARMATURE_HALL_LEISUREGAME);
	leisureGameArmature:getAnimation():setMovementEventCallFunc(btnAnimationEventCallFunc);
end

--[[--
--移除休闲房间按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeLeisureGameBtnArmature(view)
	if leisureGameArmature ~= nil then
		leisureGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(leisureGameArmature);
		view:removeChild(leisureGameArmature, true);
		leisureGameArmature = nil;
	end
end

--[[--
--显示幸运游戏按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showLuckyGameBtnArmature(view,x,y)
	if luckyGameArmature == nil then
		--如果骨骼动画不存在,create
		luckyGameArmature = CCArmature:create(ARMATURE_HALL);
		table.insert(hallBtnArmature, luckyGameArmature);
		view:addChild(luckyGameArmature);
	else
		luckyGameArmature:stopAllActions();
		--如果骨骼动画存在,show
		showBtnArmature(luckyGameArmature);
	end
	--开启可能会转换位置
	luckyGameArmature:setPosition(ccp(x,y));
	luckyGameArmature:getAnimation():play(ARMATURE_HALL_LUCKYGAME);
	luckyGameArmature:getAnimation():setMovementEventCallFunc(btnAnimationEventCallFunc);
end

--[[--
--移除幸运游戏按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeLuckyGameBtnArmature(view)
	if luckyGameArmature ~= nil then
		luckyGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(luckyGameArmature);
		view:removeChild(luckyGameArmature, true);
		luckyGameArmature = nil;
	end
end

--[[--
--显示疯狂闯关按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showPkGameBtnArmature(view,x,y)
	if pkGameArmature == nil then
		--如果骨骼动画不存在,create
		pkGameArmature = CCArmature:create(ARMATURE_HALL);
		table.insert(hallBtnArmature, pkGameArmature);
		view:addChild(pkGameArmature);
	else
		pkGameArmature:stopAllActions();
		--如果骨骼动画存在,show
		showBtnArmature(pkGameArmature);
	end
	pkGameArmature:setPosition(ccp(x,y));
	pkGameArmature:getAnimation():play(ARMATURE_HALL_PKGAME);
	pkGameArmature:getAnimation():setMovementEventCallFunc(btnAnimationEventCallFunc);
end

--[[--
--移除疯狂闯关按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removePkGameBtnArmature(view)
	if pkGameArmature ~= nil then
		pkGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(pkGameArmature);
		view:removeChild(pkGameArmature, true);
		pkGameArmature = nil;
	end
end

--[[--
--显示财神按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showCaiShenBtnArmature(view,x,y)
	if caishenArmature == nil then
		--如果骨骼动画不存在,create
		caishenArmature = CCArmature:create(ARMATURE_HALL_CAISHEN);
		--table.insert(hallBtnArmature, caishenArmature);
		view:addChild(caishenArmature);
	else
		caishenArmature:stopAllActions();
		--如果骨骼动画存在,show
		showBtnArmature(caishenArmature);
	end
	caishenArmature:setPosition(ccp(x,y));
	caishenArmature:getAnimation():playByIndex(0)
end

--[[--
--移除财神按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeCaishenBtnArmature(view)
	if caishenArmature ~= nil then
		caishenArmature:stopAllActions();
		--removeArmatureInHallBtnArmatureTable(caishenArmature);
		view:removeChild(caishenArmature, true);
		caishenArmature = nil;
	end
end

--[[--
--隐藏财神骨骼动画
--]]
function hideCaiShenArmature()
	hideBtnArmature(caishenArmature);
end


--[[--
--显示VIP优惠动画
--]]
function showVipSaleArmature(view,x,y)
	--VIP优惠动画
	if vipArmature == nil then
		vipArmature = CCArmature:create("vipyouhui")
		vipArmature:getAnimation():playByIndex(0);
		vipArmature:setPosition(ccp(x,y))
		view:addChild(vipArmature)
	end
	if vipArmature:isVisible() then
		return;
	end
	vipArmature:setVisible(true)
end

--[[--
--移除VIP优惠动画
--]]
function removeVipSaleArmature(view)
	if vipArmature ~= nil then
		vipArmature:stopAllActions();
		--removeArmatureInHallBtnArmatureTable(caishenArmature);
		view:removeChild(vipArmature, true);
		vipArmature = nil;
	end
end

--[[--
--隐藏VIP优惠动画
--]]
function hideVipSaleArmature()
	if vipArmature ~= nil and vipArmature:isVisible() then
		vipArmature:setVisible(false)
	end
end

--[[--
--显示VIP优惠动画(个人信息)
--]]
function showVipSaleArmatureOfUserInfo(view,x,y)
	--VIP优惠动画
	if vipArmatureOfUserInfo == nil then
		vipArmatureOfUserInfo = CCArmature:create("vipyouhui")
		vipArmatureOfUserInfo:getAnimation():playByIndex(0);
		vipArmatureOfUserInfo:setPosition(ccp(x,y))
		view:addChild(vipArmatureOfUserInfo)
	end
	if vipArmatureOfUserInfo:isVisible() then
		return;
	end
	vipArmatureOfUserInfo:setVisible(true)
end

--[[--
--移除VIP优惠动画(个人信息)
--]]
function removeVipSaleArmatureOfUserInfo(view)
	if vipArmatureOfUserInfo ~= nil then
		vipArmatureOfUserInfo:stopAllActions();
		--removeArmatureInHallBtnArmatureTable(caishenArmature);
		view:removeChild(vipArmatureOfUserInfo, true);
		vipArmatureOfUserInfo = nil;
	end
end

--[[--
--隐藏VIP优惠动画(个人信息)
--]]
function hideVipSaleArmatureOfUserInfo()
	if vipArmatureOfUserInfo ~= nil and vipArmatureOfUserInfo:isVisible() then
		vipArmatureOfUserInfo:setVisible(false)
	end
end


local function getPlayerAnimPath(name)
	return Common.getResourcePath("player_anim/"..name)
end

local function getloadPlayerAnimPath(name)
	return Common.getResourcePath("lord_game_res/player_anim/"..name)
end

local function getloadCardAnimPath(name)
	return Common.getResourcePath("lord_game_res/card_anim/"..name)
end

local function getCardAnimPath(name)
	return Common.getResourcePath("card_anim/"..name)
end

--表情动画
local function getEmtionAnimPath(name)
	return Common.getResourcePath("lord_game_res/expression_anim/"..name)
end

--天梯动画
local function getTiantiAnimPath(name)
	return Common.getResourcePath("tianti_anim/"..name)
end

--天梯升段动画
local function getLoadTiantiAnimPath(name)
	return Common.getResourcePath("lord_game_res/tianti_anim/"..name)
end

local function getGameCommonAnimPath(name)
	return Common.getResourcePath("gameCommon_anim/"..name)
end

local function loadArmatureData(PngPath, PlistPath, ExportJsonPath)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(PngPath, PlistPath, ExportJsonPath)
end

function loadTableArmature()
	if GameConfig.gameIsFullPackage() then
		--当前是完整包
		--==========地主==========--
		loadArmatureData(getloadPlayerAnimPath("lordAnim0.png"),getloadPlayerAnimPath("lordAnim0.plist"),getloadPlayerAnimPath("lordAnim.ExportJson"))
		loadArmatureData(getloadPlayerAnimPath("lordAnim1.png"),getloadPlayerAnimPath("lordAnim1.plist"),getloadPlayerAnimPath("lordAnim.ExportJson"))
		--==========农民==========--
		loadArmatureData(getloadPlayerAnimPath("farmerAnim0.png"),getloadPlayerAnimPath("farmerAnim0.plist"),getloadPlayerAnimPath("farmerAnim.ExportJson"))
		loadArmatureData(getloadPlayerAnimPath("farmerAnim1.png"),getloadPlayerAnimPath("farmerAnim1.plist"),getloadPlayerAnimPath("farmerAnim.ExportJson"))
		--==========地主女==========--
		loadArmatureData(getloadPlayerAnimPath("lordfemaleAnim0.png"),getloadPlayerAnimPath("lordfemaleAnim0.plist"),getloadPlayerAnimPath("lordfemaleAnim.ExportJson"))
		loadArmatureData(getloadPlayerAnimPath("lordfemaleAnim1.png"),getloadPlayerAnimPath("lordfemaleAnim1.plist"),getloadPlayerAnimPath("lordfemaleAnim.ExportJson"))
		--==========农民女==========--
		loadArmatureData(getloadPlayerAnimPath("farmerfemaleAnim0.png"),getloadPlayerAnimPath("farmerfemaleAnim0.plist"),getloadPlayerAnimPath("farmerfemaleAnim.ExportJson"))
		loadArmatureData(getloadPlayerAnimPath("farmerfemaleAnim1.png"),getloadPlayerAnimPath("farmerfemaleAnim1.plist"),getloadPlayerAnimPath("farmerfemaleAnim.ExportJson"))
		--==========表情动画==========--
		loadArmatureData(getEmtionAnimPath("putongbiaoqing0.png"),getEmtionAnimPath("putongbiaoqing0.plist"),getEmtionAnimPath("putongbiaoqing.ExportJson"))
		loadArmatureData(getEmtionAnimPath("gaojibiaoqing0.png"),getEmtionAnimPath("gaojibiaoqing0.plist"),getEmtionAnimPath("gaojibiaoqing.ExportJson"))
		--==========天梯升段动画==========--
		loadArmatureData(getLoadTiantiAnimPath("tiantishengduan0.png"),getLoadTiantiAnimPath("tiantishengduan0.plist"),getLoadTiantiAnimPath("tiantishengduan.ExportJson"))
		loadArmatureData(getLoadTiantiAnimPath("tiantishengduan1.png"),getLoadTiantiAnimPath("tiantishengduan1.plist"),getLoadTiantiAnimPath("tiantishengduan.ExportJson"))
		--==========牌桌动画==========--
		loadArmatureData(getloadCardAnimPath("paixingdonghua0.png"),getloadCardAnimPath("paixingdonghua0.plist"),getloadCardAnimPath("paixingdonghua.ExportJson"))
		loadArmatureData(getloadCardAnimPath("paixingdonghua1.png"),getloadCardAnimPath("paixingdonghua1.plist"),getloadCardAnimPath("paixingdonghua.ExportJson"))
	else
		--当前是非完整包
		--==========牌桌动画==========--
		loadArmatureData(getCardAnimPath("paixingdonghua0.png"),getCardAnimPath("paixingdonghua0.plist"),getCardAnimPath("paixingdonghua.ExportJson"))
		--==========地主==========--
		loadArmatureData(getPlayerAnimPath("lordAnim0.png"),getPlayerAnimPath("lordAnim0.plist"),getPlayerAnimPath("lordAnim.ExportJson"))
		--==========农民==========--
		loadArmatureData(getPlayerAnimPath("farmerAnim0.png"),getPlayerAnimPath("farmerAnim0.plist"),getPlayerAnimPath("farmerAnim.ExportJson"))

	end
	--==========天梯动画==========--
	loadArmatureData(getTiantiAnimPath("tiantidonghua0.png"),getTiantiAnimPath("tiantidonghua0.plist"),getTiantiAnimPath("tiantidonghua.ExportJson"))
	--变身动画
	loadArmatureData(getGameCommonAnimPath("bianshen0.png"),getGameCommonAnimPath("bianshen0.plist"),getGameCommonAnimPath("bianshen.ExportJson"))
end

--[[--
--预加载大厅动画
--]]
function loadHallArmature()
	--loading动画
	loadArmatureData(getGameCommonAnimPath("loading0.png"),getGameCommonAnimPath("loading0.plist"),getGameCommonAnimPath("loading.ExportJson"))
	--设置动画
	--loadArmatureData(getGameCommonAnimPath("settings0.png"),getGameCommonAnimPath("settings0.plist"),getGameCommonAnimPath("settings.ExportJson"))
	--大厅按钮动画
	loadArmatureData(getGameCommonAnimPath("HallAnimation0.png"),getGameCommonAnimPath("HallAnimation0.plist"),getGameCommonAnimPath("HallAnimation.ExportJson"));
	--财神动画
	loadArmatureData(getGameCommonAnimPath("caishen0.png"),getGameCommonAnimPath("caishen0.plist"),getGameCommonAnimPath("caishen.ExportJson"));
	--VIP优惠动画
	loadArmatureData(getGameCommonAnimPath("vipyouhui0.png"),getGameCommonAnimPath("vipyouhui0.plist"),getGameCommonAnimPath("vipyouhui.ExportJson"));
end

local function getGiftCommonAnimPath(name)
	return Common.getResourcePath("giftAnimation/"..name)
end
--[[--
--预加载大厅动画
--]]
function loadRechargeArmature()
	--loading动画
	loadArmatureData(getGiftCommonAnimPath("libaodonghua0.png"),getGiftCommonAnimPath("libaodonghua0.plist"),getGiftCommonAnimPath("libaodonghua.ExportJson"))
end
--[[--
--移除VIP优惠动画
--]]
function removeRechargeArmature(view)
	if vipArmature ~= nil then
		vipArmature:stopAllActions();
		--removeArmatureInHallBtnArmatureTable(caishenArmature);
		view:removeChild(vipArmature, true);
		vipArmature = nil;
	end
end

