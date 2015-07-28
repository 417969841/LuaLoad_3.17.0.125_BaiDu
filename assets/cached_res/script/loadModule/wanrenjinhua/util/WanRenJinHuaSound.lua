module("WanRenJinHuaSound", package.seeall)

SOUND_BET = "load_res/WanRenJinHua/bet.mp3"
SOUND_BEFORE_BET = "load_res/WanRenJinHua/before_bet.mp3"
SOUND_BET_PLEASE = "load_res/WanRenJinHua/bet_please.mp3"
SOUND_TIMER = "load_res/WanRenJinHua/timer.mp3"
SOUND_FLYWINCOINS = "load_res/WanRenJinHua/flywincoins.mp3"
SOUND_SENDCARD = "load_res/WanRenJinHua/sendcard.mp3"

-- 播放音效
function playEffectMusic(effectMusicName)
	if effectMusicName then
		local effectPath = CCFileUtils:sharedFileUtils():fullPathForFilename(Common.getResourcePath(effectMusicName, pathTypeInApp))
		SimpleAudioEngine:sharedEngine():playEffect(effectPath)
	end
end