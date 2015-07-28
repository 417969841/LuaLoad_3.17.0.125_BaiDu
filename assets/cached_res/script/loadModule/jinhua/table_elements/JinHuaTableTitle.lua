JinHuaTableTitle = {}
local titleSprite
--单注,总注,轮数
local baseCoin, labelSumCoin, sumCoinBg, sumCoin, imageRound, round, sysTimeLabel, imgBaseCoin
local updateTimeScheduler -- 更新时间定时器

local function init()
	local texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("table0.png", pathTypeInApp))
	titleSprite = CCSprite:createWithTexture(texture)
	titleSprite:setContentSize(CCSizeMake(JinHuaTableConfig.TableDefaultWidth,GameConfig.ScreenHeight / 8))
	local selfSize = titleSprite:getContentSize()
	local currentTime = os.date("%H:%M", os.time())
	sysTimeLabel = CCLabelTTF:create(currentTime, "Arial", 24)
	sysTimeLabel:setColor(ccc3(218, 199, 208))
	--系统时间X轴距离
	local sysTimeLabelX = JinHuaTableConfig.TableDefaultWidth / 40;
	sysTimeLabel:setAnchorPoint(ccp(0, 0.5))
	sysTimeLabel:setPosition(sysTimeLabelX, selfSize.height / 2)

	local baseConX = GameConfig.ScreenWidth / 5;

	imgBaseCoin = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_title_basecoin.png", pathTypeInApp))
	local imgBaseCoinSprite = CCSprite:createWithTexture(imgBaseCoin)
	imgBaseCoinSprite:setAnchorPoint(ccp(0, 0.5))
	imgBaseCoinSprite:setPosition(baseConX, selfSize.height / 2)
--	baseCoin = CCLabelTTF:create("单注：0", "Arial", 24)
	---CCLabelAtlas:create(显示内容,图片名字,每一个数字的宽,每一个数字的高,开始字符)
	baseCoin = CCLabelAtlas:create("2", getJinHuaResource("desk_atlas_2.png",pathTypeInApp), 24, 31, 48)
--	baseCoin = ccs.labelAtlas({
--			text = 0 .. "",
--			image = Common.getResourcePath("desk_atlas_2.png"),
--			start = "0",
--			w = 25,
--			h = 31,
--		})
--	baseCoin:setColor(ccc3(240, 229, 232))
	baseCoin:setAnchorPoint(ccp(0, 0.5))
	--单注X轴距离
	baseCoin:setPosition(ccp(imgBaseCoinSprite:getPositionX() + imgBaseCoinSprite:getContentSize().width, selfSize.height / 2))
--	baseCoin:setPosition(ccp(0,0))
	local sunCoinBgTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_bg_sumcoin.png", pathTypeInApp))
	sumCoinBg = CCSprite:createWithTexture(sunCoinBgTexture)
	sumCoinBg:setAnchorPoint(ccp(0, 0.5))
	local sumCoinBgX = GameConfig.ScreenWidth * 290 / 800
	sumCoinBg:setScaleX(1.2)
	sumCoinBg:setPosition(sumCoinBgX, selfSize.height / 2)

	local sumCoinTexture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_title_sumcoin_text.png", pathTypeInApp))
	labelSumCoin = CCSprite:createWithTexture(sumCoinTexture)
	labelSumCoin:setAnchorPoint(ccp(0, 0.5))
	--总注X轴距离
	local labelSumCoinX = JinHuaTableConfig.TableDefaultWidth  *302/800;
	labelSumCoin:setPosition(labelSumCoinX, selfSize.height / 2)
	--desk_num.png的每个数字宽
	local deskNumPicWidth = 19;
	--desk_num.png的高
	local deskNumPicHeight = 24;
	---CCLabelAtlas:create(显示内容,图片名字,每一个数字的宽,每一个数字的高,开始字符)
	sumCoin = CCLabelAtlas:create("30589", getJinHuaResource("desk_atlas_1.png"), 28, 31, 48)
	sumCoin:setAnchorPoint(ccp(0, 0))
	sumCoin:setPosition(labelSumCoin:getPositionX() + labelSumCoin:getContentSize().width, selfSize.height / 2 - sumCoin:getContentSize().height / 2)
	imageRound = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource("desk_title_round.png", pathTypeInApp))
	local roundSprite = CCSprite:createWithTexture(imageRound)
	roundSprite:setAnchorPoint(ccp(0, 0.5))
	roundSprite:setPosition(baseConX, selfSize.height / 2)
	local roundSpriteX = JinHuaTableConfig.TableDefaultWidth * 549 / 800;
	roundSprite:setPosition(roundSpriteX, selfSize.height / 2)

	round = CCLabelAtlas:create("212", getJinHuaResource("desk_atlas_2.png"), 24, 31, 48)
--	round:setColor(ccc3(240, 229, 232))
	round:setAnchorPoint(ccp(0, 0.5))
	--轮数X轴距离
	local roundX = JinHuaTableConfig.TableDefaultWidth * 549 / 800 + roundSprite:getContentSize().width;
	round:setPosition(roundX, selfSize.height / 2)
	titleSprite:addChild(sysTimeLabel)
	titleSprite:addChild(imgBaseCoinSprite)
	titleSprite:addChild(baseCoin)
	titleSprite:addChild(sumCoinBg)
	titleSprite:addChild(labelSumCoin)
	titleSprite:addChild(sumCoin)
	titleSprite:addChild(roundSprite)
	titleSprite:addChild(round)
	titleSprite:setAnchorPoint(ccp(0, 1))
	titleSprite:setPosition(JinHuaTableConfig.fitX, JinHuaTableConfig.TableDefaultHeight *JinHuaTableConfig.TableScaleY - JinHuaTableConfig.fitY)
end

-- 更新时间
local function updateCurrentTimeOnTitle()
	local currentTime = os.date("%H:%M", os.time())
	if sysTimeLabel then
		sysTimeLabel:setString(currentTime)
	end
end

-- 启动计时器
local function startUpdateTimeScheduler()
	if not updateTimeScheduler then
		updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateCurrentTimeOnTitle, 60, false)
	end
end

-- clear标题栏   退出时调用
function JinHuaTableTitle.clearTableTitle()
	if updateTimeScheduler then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimeScheduler)
		updateTimeScheduler = nil
	end
end

function JinHuaTableTitle.setBaseCoin(value)
	local mValue = ""
	for i = 1,string.len(value) do
		local subValue = string.sub(value,i,i) + 2
		if subValue == 10 then
			subValue = ":"
		elseif subValue == 11 then
			subValue = ";"
		end
		mValue = mValue .. subValue
	end
	baseCoin:setString("" .. mValue)
end

function JinHuaTableTitle.setSumCoin(value)
	sumCoin:setString("" .. value)
end

function JinHuaTableTitle.setRound(value)
	Common.log("setRound value is " .. value)
	local mValue = ""
	for i = 1,string.len(value) do
		local subValue = string.sub(value,i,i) + 2
		if subValue == 10 then
			subValue = ":"
		elseif subValue == 11 then
			subValue = ";"
		end
		mValue = mValue .. subValue
	end
	Common.log("setRound mValue is " .. mValue)
	round:setString(""..mValue.."147")
end

-- 更新
function JinHuaTableTitle.updateTitle()
	local GameData = profile.JinHuaGameData.getGameData()
	JinHuaTableTitle.setBaseCoin(GameData.singleCoin)
	JinHuaTableTitle.setSumCoin(GameData.totalPoolCoin)
	JinHuaTableTitle.setRound(GameData.round)
end

function JinHuaTableTitle.createTitle(layer)
	init()
	startUpdateTimeScheduler()
	JinHuaTableTitle.updateTitle()
	layer:addChild(titleSprite)
end
