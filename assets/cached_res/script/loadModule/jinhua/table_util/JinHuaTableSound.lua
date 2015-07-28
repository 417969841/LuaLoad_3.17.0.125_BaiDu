------------牌桌音乐------------------------------
module("JinHuaTableSound", package.seeall)

SOUND_BET = "load_res/JinHua/bet.mp3"
SOUND_ALLIN = "load_res/JinHua/allin.mp3"
SOUND_PKWIN = "load_res/JinHua/pkwin.mp3"
SOUND_PKLOSS = "load_res/JinHua/pkloss.mp3"
SOUND_PK = "load_res/JinHua/pk.mp3"
SOUND_SENDCARDRING = "load_res/JinHua/sendcardring.mp3"
SOUND_SENDCARD = "load_res/JinHua/sendcard.mp3"
SOUND_FOLD = "load_res/JinHua/fold.mp3"
SOUND_FLYWINCOINS = "load_res/JinHua/flywincoins.mp3"
SOUND_BACKGROUND = "load_res/JinHua/zhajinhua_background.mp3"
SOUND_WIN = "load_res/JinHua/table_win.mp3" -- 赢音效

CHECK_CARD_PLAYER_SOUND = "check_card_player_sound" -- 看牌
BET_PLAYER_SOUND = "bet_player_sound" --跟注
RAISE_BET_PLAYER_SOUND = "raise_bet_player_sound" --加注
FOLD_CARD_PLAYER_SOUND = "fold_card_player_sound" --弃牌
PK_CARD_PLAYER_SOUND = "pk_card_player_sound" -- 比牌
SHOW_CARD_PLAYER_SOUND = "show_card_player_sound" --亮牌
CHANGE_CARD_PLAYER_SOUND = "change_card_player_sound" -- 换牌

-- 背景音乐开关
isBackgroundMusicOn = true
-- 音效开关
isEffectMusicOn = true
-- 震动开关
isVibrateOn = true

local bgMusicHavePlay = false -- 背景音乐是否播放过

local isLoadSDCardRes = false -- 是否加载sd卡中资源

-- 初始化音乐开关
local function initSoundSwitch()
	-- 背景音乐开关
	local playBGMusic = Common.getDataForSqlite(KEY_SET_BGMUSIC)
	if playBGMusic == nil then
		playBGMusic = true
	end
	isBackgroundMusicOn = playBGMusic
	-- 音效开关
	local playEffect = Common.getDataForSqlite(KEY_SET_EFFECT)
	if playEffect == nil then
		playEffect = true
	end
	isEffectMusicOn = playEffect
	-- 震动开关
	local playVibrate = Common.getDataForSqlite(KEY_SET_VIBRATE)
	if playVibrate == nil then
		playVibrate = true
	end
	isVibrateOn = playVibrate
end

-- 预加载牌桌音乐
local function preLoadSound()
	--加载音效
	--下注音效
	local effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_BET, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--押满音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_ALLIN, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--pk自己赢了播音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_PKWIN, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--pk自己输了播音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_PKLOSS, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--别人pk播音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_PK, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--发牌前提醒声音
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_SENDCARDRING, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--发牌音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_SENDCARD, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	--弃牌音效
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_FOLD, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)
	-- 赢金币
	effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(SOUND_FLYWINCOINS, pathTypeInApp))
	SimpleAudioEngine:sharedEngine():preloadEffect(effectPath)

	-- 防止进入牌桌太慢，先不预加载背景音乐
end

-- 获取路径
local function getFullPathForFileName(name)
	local bgMusicPath
	if isLoadSDCardRes then
		bgMusicPath = Common.getTrendsSaveFilePath(GameConfig.DIR_RELOAD .. "/load_res/JinHua")..name.."_data"
	else
		bgMusicPath = Common.getResourcePath("load_res/JinHua/" .. name, pathTypeInApp)
	end
	local bgMusicFile = CCFileUtils:sharedFileUtils():fullPathForFilename(bgMusicPath)
	return bgMusicFile
end

-- 播放背景音乐
function playBackgroundMusic()
	-- 校验
	if not bgMusicHavePlay and JinHuaTableSound.isBackgroundMusicOn then
		--		DownloadControler.startVerifyUnZipedFiles(GameConfig.URL_TABLE_MUSIC, GameConfig.DIR_RELOAD)
		--		if DownloadControler.isZipCanUse(GameConfig.URL_TABLE_MUSIC, GameConfig.DIR_RELOAD) and DownloadControler.isResourceCanUse(GameConfig.URL_TABLE_MUSIC, GameConfig.DIR_RELOAD) then
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(Common.getResourcePath(SOUND_BACKGROUND, pathTypeInApp), true)
		bgMusicHavePlay = true
		--		end
	end
end

-- 停止播放背景音乐
function stopPlayBackgroundMusic()
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
	bgMusicHavePlay = false
end

-- 播放音效
function playEffectMusic(effectMusicName)
	if isEffectMusicOn and effectMusicName then
		local effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(effectMusicName, pathTypeInApp))
		SimpleAudioEngine:sharedEngine():playEffect(effectPath)
	end
end

-- 获取聊天音乐名字
local function getPlayerChatSoundName(index, playerSex)
	if playerSex == profile.JinHuaGameData.MALE then
		return "male_table_chat"..index..".MP3"
	else
		return "female_table_chat"..index..".MP3"
	end
end

-- 播放人声聊天音效
function playPlayerChatSound(index, playerSex)
	if isEffectMusicOn then
		local effectName = getPlayerChatSoundName(index, playerSex)
		SimpleAudioEngine:sharedEngine():playEffect(getFullPathForFileName(effectName))
	end
end

-- 获取操作音乐名字
local function getPlayerOperationSoundName(playerOperationSoundName, playerSex)
	local randomNum = math.random(3)
	if playerSex == profile.JinHuaGameData.MALE then
		return "male_"..playerOperationSoundName..randomNum..".MP3"
	else
		return "female_"..playerOperationSoundName..randomNum..".MP3"
	end
end

-- 播放人声操作音效
function playPlayerOperationSound(playerOperationSoundName, playerSex)
	if isEffectMusicOn then
		local effectName = getPlayerOperationSoundName(playerOperationSoundName, playerSex)
		SimpleAudioEngine:sharedEngine():playEffect(getFullPathForFileName(effectName))
	end
end

-- 初始化牌桌音乐
function initJinHuaTableSound()
	initSoundSwitch()
	preLoadSound()
	playBackgroundMusic()
end