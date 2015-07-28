module("AudioManager", package.seeall)

local msOldMusicName = nil--当前正在播放的音乐名称

function getOldMusicName()
	return msOldMusicName;
end

--[[--
--预加载背景音乐
--@param #string musicFilePath 背景音乐路径
--]]
function preLoadBgMusic(musicFilePath)

	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(musicFilePath);

	SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(FilePath);
end

--[[--
--预加载音效
--@param #string musicFilePath 音效路径
--]]
function preLoadSound(soundFilePath)

	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundFilePath);

	SimpleAudioEngine:sharedEngine():preloadEffect(FilePath);
end


--[[--
--播放背景音乐
--@param #string musicFilePath 音效路径
--@param #bool loop 是否循环 --default = true
--]]
function playBgMusic(musicFilePath, loop)

	if (SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()) then
		--先判断是否已经在播放,如果在播放，则切换播放
		stopBgMusic(false)
	end
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(musicFilePath);
	SimpleAudioEngine:sharedEngine():playBackgroundMusic(FilePath, loop);
end

--[[--
--播放音效
--@param #string soundFilePath 音效路径
--@param #bool loop 是否循环 --default is false
--]]
function playSound(soundFilePath, loop)
	Common.log("播放音效 soundFilePath ====== "..soundFilePath)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundFilePath);
	local soundId = SimpleAudioEngine:sharedEngine():playEffect(FilePath, loop);
end

--[[--
--暂停背景音乐
--]]
function pauseBgMusic()
	SimpleAudioEngine:sharedEngine():pauseBackgroundMusic();
end

--[[--
--暂停音效
--]]
function pauseSound(soundId)
	SimpleAudioEngine:sharedEngine():pauseEffect(soundId);
end

--[[--
--停止背景音乐
--@param #bool release 是否释放资源 default is true
--]]
function stopBgMusic(release)
	if release then
		msOldMusicName = nil;
	end
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(release);
end

--[[--
--停止音效
--]]
function stopSound(soundId)
	SimpleAudioEngine:sharedEngine():stopEffect(soundId);
end

--[[--
--停止所有音效
--]]
function stopAllSound()
	SimpleAudioEngine:sharedEngine():stopAllEffects();
end

--[[--
--恢复背景音乐
--]]
function resumeBgMusic()
	SimpleAudioEngine:sharedEngine():resumeBackgroundMusic();
end

function AudioEnd()
--    SimpleAudioEngine:sharedEngine():end();
end

mbIsloadSDMusic = true;-- 是否可以加载SD卡上的音乐资源
mbIsloadStart = false;-- 资源是否开始加载
mbIsloadEnd = false;-- 资源是否加载完毕

SOUND = -1;-- 音效(不分男女)
SECRECY = 0;-- 保密
MAN = 1;-- 男
WOMAN = 2;-- 女

SOUND_BACKGOUND = "LordAudio/backgound";-- 背景音乐
SOUND_EFFECT = "LordAudio/sound_effect";-- 音效
SOUND_MAN = "LordAudio/sound_man";-- 男声
SOUND_WOMAN = "LordAudio/sound_woman";-- 女声

TableVoice = {}--游戏的人声
TableSound = {}--游戏的音效
TableBgMusic = {}--背景音乐

--数组长度 #a，等价于table.getn(a)，返回从1开始的连续整数下标个数。另有maxn返回最大的整数下标（可以不连续）。
--[[--
--初始化牌桌音乐
--]]
function initLordTableAudio()

	-- 打在包中的资源------------人声
	TableVoice["YIFEN"] = "yifen.mp3";-- 1分
	TableVoice["LIANGFEN"] = "erfen.mp3";-- 2分
	TableVoice["SANFEN"] = "sanfen.mp3";-- 3分
	TableVoice["JIAODIZHU"] = "jiaodizhu.mp3";-- 叫地主
	TableVoice["QIANGDIZHU1"] = "qiangdizhu1.mp3";-- 抢地主1
	TableVoice["BUQIANG"] = "buqiang.mp3";-- 不抢
	TableVoice["BUJIAO"] = "bujiao.mp3";-- 不叫
	TableVoice["YASI"] = "yasi.mp3";-- 压死
	TableVoice["BUYAO"] = "pass_buyao.mp3";-- 不要
	TableVoice["JIABEISUPER"] = "jiabeisuper.mp3";-- 超级加倍
	TableVoice["JIABEI"] = "jiabei.mp3";-- 加倍
	TableVoice["BUJIABEI"] = "bujiabei.mp3";-- 不加倍
	TableVoice["OPENCARD"] = "opencard.mp3";-- 明牌
	TableVoice["OPENSTART"] = "openstart.mp3";-- 明牌开始
	TableVoice["FEIJI"] = "feiji.mp3";-- 飞机
	TableVoice["HUOJIAN"] = "huojian.mp3";-- 火箭
	TableVoice["ZHADAN"] = "bomb_zhadan.mp3";-- 炸弹
	TableVoice["ZUIHOUYIZHANG1"] = "zuihouyizhang1.mp3";-- 我只有一张牌喽
	TableVoice["ZUIHOUERZHANG1"] = "zuihouerzhang1.mp3";-- 我还有两张牌喽
	TableVoice["FARMER_WIN"] = "farmer_win.mp3";-- 农民赢喽
	TableVoice["LORD_WIN"] = "lord_win.mp3";-- 地主赢啦

	-- 打在包中的资源------------音效
	TableSound["DAOJISHI"] = "daojishi.mp3";-- 倒计时
	TableSound["FAPAI"] = "fapai.mp3";-- 发牌
	TableSound["CHUPAI"] = "chupai.mp3";-- 出牌
	TableSound["COINFLY"] = "coinfly.mp3";-- 飞金币
	TableSound["LAOHUJI"] = "laohuji.mp3";-- 老虎机
	TableSound["SHOWLAIZI"] = "showlaizi.mp3";-- 显示癞子牌
	TableSound["WIN"] = "win.mp3";-- 胜利
	TableSound["XIPAI"] = "xipai.mp3";-- 洗牌
	TableSound["KAISHI"] = "kaishi.mp3";-- 开始
	TableSound["LOSS"] = "loss.mp3";-- 失败
	TableSound["JIABEI_BG"] = "jiabei_bg.mp3";-- 加倍背景音效

	-- 人声
	TableVoice["WOSHIDIZHU"] = "woshidizhu.mp3";-- 我是地主
	TableVoice["QIANGDIZHU2"] = "qiangdizhu2.mp3";-- 抢地主2
	TableVoice["QIANGDIZHU3"] = "qiangdizhu3.mp3";-- 抢地主3
	TableVoice["GUANSHANG"] = "guanshang.mp3";-- 管上
	TableVoice["DANI"] = "dani.mp3";-- 大你
	TableVoice["YAOBUQI"] = "pass_yaobuqi.mp3";-- 要不起
	TableVoice["PASS"] = "pass_pass.mp3";-- pass
	TableVoice["GUO"] = "pass_guo.mp3";-- 过
	TableVoice["CARD_2"] = "card_2.mp3";-- 单牌2
	TableVoice["CARD_3"] = "card_3.mp3";-- 单牌3
	TableVoice["CARD_4"] = "card_4.mp3";-- 单牌4
	TableVoice["CARD_5"] = "card_5.mp3";-- 单牌5
	TableVoice["CARD_6"] = "card_6.mp3";-- 单牌6
	TableVoice["CARD_7"] = "card_7.mp3";-- 单牌7
	TableVoice["CARD_8"] = "card_8.mp3";-- 单牌8
	TableVoice["CARD_9"] = "card_9.mp3";-- 单牌9
	TableVoice["CARD_10"] = "card_10.mp3";-- 单牌10
	TableVoice["CARD_J"] = "card_j.mp3";-- 单牌j
	TableVoice["CARD_Q"] = "card_q.mp3";-- 单牌q
	TableVoice["CARD_K"] = "card_k.mp3";-- 单牌k
	TableVoice["CARD_A"] = "card_a.mp3";-- 单牌a
	TableVoice["DUI_2"] = "dui_2.mp3";-- 对2
	TableVoice["DUI_3"] = "dui_3.mp3";-- 对3
	TableVoice["DUI_4"] = "dui_4.mp3";-- 对4
	TableVoice["DUI_5"] = "dui_5.mp3";-- 对5
	TableVoice["DUI_6"] = "dui_6.mp3";-- 对6
	TableVoice["DUI_7"] = "dui_7.mp3";-- 对7
	TableVoice["DUI_8"] = "dui_8.mp3";-- 对8
	TableVoice["DUI_9"] = "dui_9.mp3";-- 对9
	TableVoice["DUI_10"] = "dui_10.mp3";-- 对10
	TableVoice["DUI_J"] = "dui_j.mp3";-- 对j
	TableVoice["DUI_Q"] = "dui_q.mp3";-- 对q
	TableVoice["DUI_K"] = "dui_k.mp3";-- 对k
	TableVoice["DUI_A"] = "dui_a.mp3";-- 对a
	TableVoice["DAWANG"] = "dawang.mp3";-- 大王
	TableVoice["XIAOWANG"] = "xiaowang.mp3";-- 小王
	TableVoice["HUIJI"] = "kan_huiji.mp3";-- 看，灰机！
	TableVoice["LIANDUI"] = "liandui.mp3";-- 连对
	TableVoice["SANDAIYI"] = "sandaiyi.mp3";-- 三带一
	TableVoice["SANDAIYIDUI"] = "sandaiyidui.mp3";-- 三带一对
	TableVoice["SANGE"] = "sange.mp3";-- 三个
	TableVoice["SHUNZI"] = "shunzi.mp3";-- 顺子
	TableVoice["SIDAIER"] = "sidaier.mp3";-- 四带二
	TableVoice["SIDAILIANGDUI"] = "sidailiangdui.mp3";-- 四带两对
	TableVoice["ZHADNI"] = "bomb_zhani.mp3";-- 炸你
	TableVoice["ZHADANFANBEI"] = "bomb_zhadanfanbei.mp3";-- 炸弹翻倍
	TableVoice["ZUIHOUYIZHANG2"] = "zuihouyizhang2.mp3";-- 最后一张
	TableVoice["ZUIHOUERZHANG2"] = "zuihouerzhang2.mp3";-- 最后两张
	-- 音效
	TableSound["SOUND_FEIJI"] = "sound_feiji.mp3";-- 飞机
	TableSound["SOUND_HUOJIAN"] = "sound_huojian.mp3";-- 火箭
	TableSound["SOUND_SELECT"] = "sound_select.mp3";-- 点击牌
	TableSound["SOUND_INVERSE"] = "sound_inverse.mp3";-- 反选牌
	TableSound["SOUND_SHENGSAN"] = "sound_shengsan.mp3";-- 剩三张
	TableSound["SOUND_SHUNZI"] = "sound_shunzi.mp3";-- 顺子
	TableSound["SOUND_ZHADAN"] = "sound_zhadan.mp3";-- 炸弹
	TableSound["MATCH_LOSS"] = "match_loss.mp3";-- 比赛失败
	TableSound["MATCH_WIN"] = "match_win.mp3";-- 比赛胜利
	TableSound["CLICK"] = "click.mp3";-- 点击按钮
	TableSound["BACK"] = "back.mp3";-- 返回按钮
	TableSound["TT_DUAN_UP"] = "tt_duanup.mp3";-- 天梯升段
	TableSound["GET_AWARD"] = "getaward.mp3";-- 获取奖励
	TableSound["GET_COIN"] = "getcoin.mp3";-- 获取金币

	TableBgMusic["HALL_BACKGROUND"] = "hall_background.mp3";-- 大厅背景音乐

	-- 聊天
	TableVoice["CHAT_0"] = "chat_0.mp3";-- 大家好！给各位请安啦~
	TableVoice["CHAT_1"] = "chat_1.mp3";-- 这牌你也敢叫地主？简直自寻死路！
	TableVoice["CHAT_2"] = "chat_2.mp3";-- 喂！你倒是快点啊！
	TableVoice["CHAT_3"] = "chat_3.mp3";-- 拖时间是没用滴！
	TableVoice["CHAT_4"] = "chat_4.mp3";-- 出啊，好牌都留着下蛋啊！
	TableVoice["CHAT_5"] = "chat_5.mp3";-- 不怕神一样的对手，就怕猪一样的队友
	TableVoice["CHAT_6"] = "chat_6.mp3";-- 你很啰嗦耶，安静打牌好不？
	TableVoice["CHAT_7"] = "chat_7.mp3";-- 别崇拜哥，哥只是个传说
	TableVoice["CHAT_8"] = "chat_8.mp3";-- 和你合作，真是太愉快了！
	TableVoice["CHAT_9"] = "chat_9.mp3";-- 不好意思各位，我先走一步了！
	TableVoice["CHAT_10"] = "chat_10.mp3";-- 这把牌实在太烂了…
	TableVoice["CHAT_11"] = "chat_11.mp3";-- 牌好，心情就好！

	-- 背景音乐
	TableBgMusic["ROOM_BACKGROUND"] = "room_backgound.mp3";-- 房间背景音乐
	TableBgMusic["MATCH_BACKGROUND"] = "match_backgound.mp3";-- 比赛背景音乐
	TableBgMusic["ZHADAN_BACKGROUND"] = "zhadan_background.mp3";-- 炸弹背景音乐
	Common.log("初始化音效 ======== ")
end

--[[--
--加载音效
--]]
function loadTableEffect()
	if (mbIsloadSDMusic) then
		-- 男声
		for key, var in pairs(TableVoice) do
			local soundFilePath = SOUND_MAN .. "/" .. var
			Common.log(soundFilePath)
			preLoadSound(Common.getResourcePath(soundFilePath))
		end
		-- 女声
		for key, var in pairs(TableVoice) do
			local soundFilePath = SOUND_WOMAN .. "/" .. var
			Common.log(soundFilePath)
			preLoadSound(Common.getResourcePath(soundFilePath))
		end
		-- 音效
		for key, var in pairs(TableSound) do
			local soundFilePath = SOUND_EFFECT .. "/" .. var
			Common.log(soundFilePath)
			preLoadSound(Common.getResourcePath(soundFilePath))
		end
		-- 背景音乐
		for key, var in pairs(TableBgMusic) do
			local soundFilePath = SOUND_BACKGOUND .. "/" .. var
			Common.log(soundFilePath)
			preLoadBgMusic(Common.getResourcePath(soundFilePath))
		end
	end
end

--[[--
* 检测/改变文件名
*
* @param soundName
* @return
--]]
local function changeName(soundName)
	local name = soundName;
	if (name == TableVoice.WOSHIDIZHU) then
		-- 叫地主
		name = TableVoice.JIAODIZHU;
	elseif (name == TableVoice.QIANGDIZHU2 or name == TableVoice.QIANGDIZHU3) then
		-- 抢地主
		name = TableVoice.QIANGDIZHU1;
	elseif (name == TableVoice.GUANSHANG or name == TableVoice.DANI) then
		-- 管上
		name = TableVoice.YASI;
	elseif (name == TableVoice.YAOBUQI or name == TableVoice.PASS or name == TableVoice.GUO) then
		-- 不要
		name = TableVoice.BUYAO;
	elseif (name == TableVoice.HUIJI) then
		-- 飞机
		name = TableVoice.FEIJI;
	elseif (name == TableVoice.ZHADNI or name == TableVoice.ZHADANFANBEI) then
		-- 炸弹
		name = TableVoice.ZHADAN;
	elseif (name == TableVoice.ZUIHOUYIZHANG2) then
		-- 最后一张
		name = TableVoice.ZUIHOUYIZHANG1;
	elseif (name == TableVoice.ZUIHOUERZHANG2) then
		-- 最后两张
		name = TableVoice.ZUIHOUERZHANG1;
	end
	return name;
end

--[[--
--是否是牌桌聊天音效
--]]
local function isTableChatVoice(soundName)
	for i = 1, 12 do
		if soundName == "chat_"..(i - 1)..".mp3" then
			return true
		end
	end
end

--[[--
* 播放音效
*
* @param soundName
*            文件名
* @param loop
*            loop mode (0 = no loop, -1 = loop forever)
* @param sex
*            性别 1男 2女;0保密;-1不分男女
--]]

function playLordSound(soundName, loop, sex)
	if (GameConfig.getGameSoundOff()) then
		--		if (not mbIsloadSDMusic) then
		--			-- 未加载SD卡资源,相同意义的不同资源修改为包中的资源
		--			soundName = changeName(soundName);
		--		end
		local sFileName = "";
		if GameConfig.gameIsFullPackage() then
			if (sex == MAN or sex == SECRECY) then
				-- 男
				if isTableChatVoice(soundName) then
					sFileName = "lord_game_res" .. "/" .. SOUND_MAN .. "/" .. soundName;
				else
					sFileName = SOUND_MAN .. "/" .. soundName;
				end
			elseif (sex == WOMAN) then
				-- 女
				sFileName = "lord_game_res" .. "/" .. SOUND_WOMAN .. "/" .. soundName;
			else
				sFileName = SOUND_EFFECT .. "/" .. soundName;
			end
		else
			if (sex == MAN or sex == SECRECY or sex == WOMAN) then
				-- 男
				sFileName = SOUND_MAN .. "/" .. soundName;
			else
				sFileName = SOUND_EFFECT .. "/" .. soundName;
			end
		end

		playSound(Common.getResourcePath(sFileName), loop)
	end

end

--[[--
* 暂停音效
*
* @param soundName
*            如果是nil,则全部停止
--]]
function stopSound(soundName)
	soundName = SOUND_EFFECT .. "/" .. soundName;
end

--[[--
--播放背景音乐
--]]
function playBackgroundMusic(Name)
	if (GameConfig.getGameMusicOff()) then
		if msOldMusicName == Name then
			return;
		end
		msOldMusicName = Name
		if GameConfig.gameIsFullPackage() and msOldMusicName ~= TableBgMusic.HALL_BACKGROUND then
			local MusicName = "lord_game_res" .. "/".. SOUND_BACKGOUND .. "/" .. msOldMusicName;
			playBgMusic(Common.getResourcePath(MusicName), true)
		else
			local MusicName = SOUND_BACKGOUND .. "/" .. TableBgMusic.HALL_BACKGROUND;
			playBgMusic(Common.getResourcePath(MusicName), true)
		end
	end
end

--[[--
--继续上次播放的音乐
--]]
function resumeBackgroundMusic()
	if (GameConfig.getGameMusicOff() and msOldMusicName ~= nil) then
		if GameConfig.gameIsFullPackage() and msOldMusicName ~= TableBgMusic.HALL_BACKGROUND then
			local MusicName = "lord_game_res".. "/".. SOUND_BACKGOUND .. "/" .. msOldMusicName;
			playBgMusic(Common.getResourcePath(MusicName), true)
		else
			local MusicName = SOUND_BACKGOUND .. "/" .. TableBgMusic.HALL_BACKGROUND;
			playBgMusic(Common.getResourcePath(MusicName), true)
		end
	end
end
