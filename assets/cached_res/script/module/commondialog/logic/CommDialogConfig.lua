module("CommDialogConfig", package.seeall)

local isNetKickOff = false;--强制退出

local netErrConnFailed = 0--建立连接失败(每连续出现三次，则弹出网络异常对话框)
local netErrNetBroken = 0--网络断开(开始重连)

local webViewTable = {} --webView基本信息

preStaticWebView = false --静态webview预加载是否完成
preWebViewCompleted = false --全部webview预加载是否完成
WEBVIEWUPDATETIME = "WEBVIEWUPDATETIME"
local JUDGETIME = false --默认没有达到时间去加载webview

--[[--
--切出游戏
]]
function applicationEnterBackground()
	Common.log("applicationEnterBackground ================== ")
end

--[[--
--进入游戏
]]
function applicationEnterForeground()
	Common.log("applicationEnterForeground ================== ")
	if GameConfig.getGameMusicOff() then
		SimpleAudioEngine:sharedEngine():resumeBackgroundMusic();
	end

	if Common.platform == Common.TargetIos then
	--逻辑在C++层实现
	elseif Common.platform == Common.TargetAndroid then
		Services:getMessageService():closeSocket();
		Services:getMessageService():removeAllMessage();
		Services:getMessageService():reConnect();
	end
end

--[[--
--建立连接失败(每连续出现三次，则弹出网络异常对话框)
]]
function netErrConnFailedFun()
	if isNetKickOff then
		return;
	end
	Common.log("建立连接失败(每连续出现三次，则弹出网络异常对话框)")
	netErrConnFailed = netErrConnFailed + 1
	if netErrConnFailed >= 3 then
		netErrConnFailed = 0
		--断线提示退出
		Services:getMessageService():stopConnect();
		if not NetErrExitDialogLogic.viewIsRunning() then
			mvcEngine.createModule(GUI_NETERREXITDIALOG);
		end
	end
end

--[[--
--网络断开(开始重连)
]]
function netErrNetBrokenFun()
	if isNetKickOff then
		return;
	end
	Common.log("网络断开(开始重连)")
	netErrNetBroken = netErrNetBroken + 1
	if netErrNetBroken == 1 then
		Common.showToast("您的网络已断开，正在帮您重连...", 2);
		GameConfig.isConnect = false;
	end
end

--[[--
--重连以后发送登录
--]]
function netlogin()
	local UserID = profile.User.getSelfUserID();
	local username = profile.User.getSelfNickName();
	local password = profile.User.getSelfPassword();
	local imei = Common.getDeviceInfo();

	if (UserID ~= 0 and username ~= nil and password ~= nil) then
		Common.log("UserID ====== "..UserID);
		Common.log("username ====== "..username);
		Common.log("password ====== "..password);
		sendBASEID_LOGIN(username, password, imei);
	else
		local logininfo = Common.LoadShareUserTable("lastLoginUserInfo")
		if logininfo ~= nil and logininfo["UserID"] ~= nil and logininfo["nickname"] ~= nil and logininfo["password"] ~= nil then
			UserID = logininfo["UserID"];
			username = logininfo["nickname"];
			password = logininfo["password"];
			sendBASEID_LOGIN(username, password, imei);
		end
	end
end

--[[--
--重连成功(如果是没有出现连接失败的成功，则不是重连)
]]
function netErrConnSuccFun()
	--如果已经提示强制退出，则不再重联
	if isNetKickOff then
		return;
	end
	ResumeSocket("Connect");
	if netErrNetBroken > 0 or GameConfig.isConnect then
		--重连成功
		netErrNetBroken = 0;
		if GameConfig.isConnect then
			Common.log("已经建立连接");
		else
			GameConfig.isConnect = true;
			Common.showToast("重连 成功！", 2);
			Common.log("重连成功(如果是没有出现连接失败的成功，则不是重连)");
		end

		if NetErrExitDialogLogic.viewIsRunning() then
			mvcEngine.destroyModule(GUI_NETERREXITDIALOG);
		end

		netlogin();

		--万人金花牌桌同步逻辑
		logicWanRenJinHuaGameSync();
	else
		--首次连接成功
		GameConfig.isConnect = true;
		Common.log("首次连接成功");
		if Common.isDebugState() and GameConfig.getTheCurrentBaseLayer() == GUI_LOGIN then
			LoginLogic.setIpLable();
		end
	end
end

local GameSyncTimer = nil;
local GameSynctimerNum = 0;

--[[--
--判断是否有断线续玩的结束处理
--]]
function closeLogicTime()
	profile.GameDoc.setIsGameSync(false);
	if (GameSyncTimer ~= nil) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(GameSyncTimer);
		GameSyncTimer = nil
	end
	GameSynctimerNum = 0;
end

--[[--
--根据时间判断是否退出牌桌
--]]
function logicCurrentTime()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		if profile.GameDoc.getIsGameSync() then
			--已经断线续玩
			closeLogicTime();
		else
			--未断线续玩
			GameSynctimerNum = GameSynctimerNum + 1;
			if GameSynctimerNum > 10 then
				--时间定时器
				closeLogicTime();
				TableLogic.exitLordTable();
				Common.showToast("网络意外中断，请稍后重试！", 2);
			end
		end
	else
		closeLogicTime();
	end
end

--[[--
--重连成功以后判断是否有断线续玩
--]]
function logicGameSync()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		if TableConsole.mode == TableConsole.MATCH or
			(TableConsole.mode == TableConsole.ROOM and
			TableConsole.m_nGameStatus >= TableConsole.STAT_CALLSCORE and
			TableConsole.m_nGameStatus <= TableConsole.STAT_TAKEOUT) then
			--比赛中/房间中的叫分至出牌阶段需要判断是否有断线续玩
			if GameSyncTimer == nil then
				GameSyncTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(logicCurrentTime, 1 ,false);
			end
		end
	end
end

--[[--
--万人金花牌桌同步逻辑
--]]
function logicWanRenJinHuaGameSync()
	if GameConfig.getTheCurrentBaseLayer() == GUI_WANRENJINHUA then
		sendJHROOMID_MINI_JINHUA_ENTER_GAME()
	end
end

--[[--
--展示充值引导
--@param #number GuideType 引导类型
--@param #number needCurrencyNum 需要的货币数量
--@param #number position 充值引导的位置信息
--@param #number RechargeMode 0双按钮 1短代
]]
function showPayGuide(GuideType, needCurrencyNum, position, RechargeMode, tipsText)

	Common.log("GuideType = "..GuideType)
	Common.log("needCurrencyNum = "..needCurrencyNum)
	Common.log("position = "..position)
	if ServerConfig.getQuickPayIsShow() then
		--可以显示充值引导
		local isSearchSMS = true;
		if RechargeMode ~= nil and RechargeMode == 0 then
			--第三方支付
			isSearchSMS = false;
		else
			--短代
			isSearchSMS = true;
		end

		mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
		PayGuidePromptLogic.setPayGuideData(GuideType, needCurrencyNum, position, isSearchSMS, tipsText)
	else
		--不显示充值引导
		local sMsg = "您当前金币/元宝不足，请进入充值获取！"
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, "充值提示", sMsg);
	end
end

--[[--
--展示礼包
--]]
function showGiftView()
	if NewUserGuideLogic.getNewUserFlag() or not ServerConfig.getGiftIsShow() or matchjijiangkaisaiLogic.view ~= nil then
		return;
	end
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and TableConsole.isCrazyStage == true and CrazyResultLogic.isShow == true or CrazyBuyStoneLogic.isShow == true then
		--如果在牌桌且是闯关赛,则暂存礼包
		HallGiftShowLogic.canBeShow = true
		HallGiftShowLogic.nextView = GUI_CHUANGGUAN
		return
	end
	local giftData = profile.Gift.getGiftDataTable()
	local num = profile.User.getSelfRound()--盘数
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and giftData.mnAllowTableShow ~= 1 or BeKickedLogic.getIsShowBeKick() == true then
	--如果当前在牌桌并且此礼包不可以在牌桌中弹出,暂存礼包
	elseif GameConfig.getTheCurrentBaseLayer() == GUI_HALL and HallLogic.isUnlockAnimationPlay then
		--如果当前是大厅,且解锁动画正在进行,则暂存礼包,等待解锁动画完成再弹礼包
		HallLogic.hasGiftShowDataChange = true;
	elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE and not GameConfig.isShowHallGiftOrBindPhone then
		--如果在牌桌且完成三局牌桌暂不弹出红包
		GameConfig.hasShowHallGift = true
	else
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	end
end

--[[--
--显示支付本地提示
--]]
function showRechargePrompt(text)
	if text ~= nil and text ~= "" then
		RechargePromptLogic.setValue(text)
		mvcEngine.createModule(GUI_RECHARGEPROMPT)
	end

end

local SEVER_MSG_RECHARGE_POPUP = 1;-- 充值弹窗
local SEVER_MSG_FLY_WORDS = 2;-- 飘字
local SEVER_MSG_MATCH_MSG = 3;-- 比赛播报
local SEVER_MSG_SERVER_NOTICE = 4;-- 系统公告
local SEVER_MSG_EXIT = 5;-- 强制退出
local SEVER_MSG_FLY_TOAST = 6;-- Toast
local SEVER_MSG_EMIGRATED_FLY_WORDS = 7;-- 冲榜飘字
local SEVER_MSG_POPUP = 8;-- 普通弹框

--[[--
--处理ServerMsg消息,弹出相应对话框
--]]
function showServerMsg()
	Common.log("showServerMsg")
	ServerMsg = {}
	ServerMsg = profile.ServerMsg.getServerMsgTable()
	-- Type Byte 类型 1:充值弹窗 2:飘字 3:比赛播报 4.系统公告 5.强制退出 6.Toast,7.冲榜飘字,8.普通弹框
	local nType = ServerMsg["nType"]
	-- Msg text 比赛状态的客户端提示语
	local sMsg = ServerMsg["sMsg"]
	-- 充值是否成功（充值特有）1成功，0失败
	local isSucceed = ServerMsg["isSucceed"]

	if nType == SEVER_MSG_RECHARGE_POPUP then
		-- 充值弹窗
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL,nil,sMsg);
		if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--profile.Gift.sendFirstGiftIconMsg(1);
		elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
			profile.Gift.sendFirstGiftIconMsg(2);
		end
		sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
		sendDBID_BACKPACK_LIST()--背包
	elseif nType == SEVER_MSG_FLY_WORDS then
		-- 飘字
		TableElementLayer.addServerMsg(sMsg);
	elseif nType == SEVER_MSG_MATCH_MSG then
	-- 比赛播报
	elseif nType == SEVER_MSG_SERVER_NOTICE then
	-- 系统公告
	elseif nType == SEVER_MSG_EXIT then
		-- 强制退出
		isNetKickOff = true;
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().EXIT,nil,sMsg);
	elseif nType == SEVER_MSG_FLY_TOAST then
		-- Toast
		Common.showToast(sMsg, 2)
	elseif nType == SEVER_MSG_EMIGRATED_FLY_WORDS then
	-- 冲榜飘字
	elseif nType == SEVER_MSG_POPUP then
		Common.showDialog(sMsg)
	end
end

--[[--
--显示版本升级提示
]]
function showVersionPrompt()
	Common.log("**********************显示版本升级提示")
	if Common.platform == Common.TargetIos then

	elseif Common.platform == Common.TargetAndroid then
		local dataTable = {}
		dataTable = profile.Version.getAppVersionTable()
		if dataTable ~= nil then
			local javaClassName = "com.tongqu.client.game.TQGameAndroidBridge"
			local javaMethodName = "downAppUpdate"
			local javaParams = {
				dataTable.isUserInitiative,
				dataTable.updateType,
				dataTable.updateTxt,
				dataTable.updataAwardTxt,
				dataTable.updateAppSizeTxt,
				dataTable.NotificationTxt,
				dataTable.updateUrl,
			}
			luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
			Common.log("**********************显示版本升级提示" .. dataTable.gameName)
		end
	end
end

--[[--
--当前是否在玩二次加载的模块
--]]
function isPlayLoadModule()
	if GameConfig.getTheCurrentBaseLayer() == GUI_AIXINNVSHEN or
		GameConfig.getTheCurrentBaseLayer() == GUI_FUXINGGAOZHAO or
		GameConfig.getTheCurrentBaseLayer() == GUI_JINHUA_TABLE or
		GameConfig.getTheCurrentBaseLayer() == GUI_MINIGAME_FRUIT_MACHINE or
		GameConfig.getTheCurrentBaseLayer() == GUI_JINHUANGUAN or
		GameConfig.getTheCurrentBaseLayer() == GUI_WRSGJ or
		GameConfig.getTheCurrentBaseLayer() == GUI_WANRENJINHUA then
		return true
	else
		return false
	end
end

local isUpdataDone = false
--[[--
--设置已经脚本更新完毕状态
--]]
function setScriptUpdataDone(isDone)
	isUpdataDone = isDone;
end

--[[--
--获取已经脚本更新完毕
--]]
function getScriptUpdataDone()
	return isUpdataDone;
end

--[[--
--设置下载脚本完成后回调方法
--]]
function setExitDialogCallBack()
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			callback = setScriptUpdataDone,
		}
		luaoc.callStaticMethod("DownLoad", "setUpdataDialogExitInfo", args)
	elseif Common.platform == Common.TargetAndroid then
	--Android
	end
end

--[[--
--下载脚本完成(Android使用)
--]]
function downloadScriptDone(parameters)
	Common.log("下载脚本完成  ========== " .. parameters)
	if parameters == "1" then
		--需要重载
		if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
			--当前在牌桌，不要弹出提示更新
			setScriptUpdataDone(true);
		else
			showUnzipLuaPrompt();
		end
	elseif parameters == "0" then
		--不用重载
		if not Load.isLoadFromSD or isPlayLoadModule() then
			--当前加载的是包中的脚本 或者 在二次加载模块
			setScriptUpdataDone(true);
		else
			--可以不弹提示，直接解压更新
			LuaUpdateConsole.logicLuaLord();
		end
	end
end

--[[--
--lua更新主版本游戏
--]]
function updateLuaMainGame(zipUrl, DelListUrl)
	Common.log("zipUrl ====== "..zipUrl)
	Common.log("DelListUrl ====== "..DelListUrl)
	DownloadControler.getDownloadLuaUpdateFile(zipUrl, DelListUrl, Common.getZipDownloadDir(), DownloadControler.DOWNLOAD_ACTION_H, true, false, "", downloadScriptDone, true)
end

--[[--
--显示下载lua脚本提示框
--]]
function showDownloadLuaPrompt()
	mvcEngine.createModule(GUI_LUA_UPDATE_VIEW);
	LuaUpdateLogic.setLuaUpdateType(LuaUpdateLogic.getLuaUpdateType().DOWNLOAD);
end

--[[--
--显示解压lua脚本提示框
--]]
function showUnzipLuaPrompt()
	setScriptUpdataDone(false);
	mvcEngine.createModule(GUI_LUA_UPDATE_VIEW);
	LuaUpdateLogic.setLuaUpdateType(LuaUpdateLogic.getLuaUpdateType().UNZIP);
end

--[[--
--显示脚本升级提示
--]]
function showScriptUpdataPrompt()
	Common.log("**********************显示脚本升级提示")
	local dataTable = {}
	dataTable = profile.Script.getScriptUpdateData()
	--升级方案
	--0、不升级
	--1、提示升级
	--2、强制升级
	--3、有新版本，不提升(wifi后台升级，2G不升级)
	--4、后台升级(wifi、2G下均后台升级)
	--5、wifi后台升级，2G提示升级
	--6、提示升级(用户取消时，wifi后台升级)
	--7、提示升级(用户取消时，wifi、2G后台升级)
	if dataTable["updateType"]  == 0 then
		--0、不升级
		--主版本不升级时才会检测小游戏和活动的更新
		sendMANAGERID_MINIGAME_LIST_TYPE_V2(GameLoadModuleConfig.getMiniGameConfigList());
		sendOPERID_GET_OPER_TASK_LIST_V2(GameLoadModuleConfig.getTaskGameConfigList());
	elseif dataTable["updateType"]  == 1 then
		--1、提示升级
		showDownloadLuaPrompt();
	elseif dataTable["updateType"]  == 2 then
		--2、强制升级
		showDownloadLuaPrompt();
	elseif dataTable["updateType"]  == 3 then
		--3、有新版本，不提升(wifi下后台升级，2G不升级)
		if Common.getConnectionType() == NET_WIFI then
			updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
		end
	elseif dataTable["updateType"]  == 4 then
		--4、后台升级(wifi、2G下均后台升级)
		updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
	elseif dataTable["updateType"]  == 5 then
		--5、wifi下后台升级，2G提示升级
		if Common.getConnectionType() == NET_WIFI then
			updateLuaMainGame(dataTable["ScriptUpdateUrl"], dataTable["fileDelListTxtUrl"]);
		else
			showDownloadLuaPrompt();
		end
	elseif dataTable["updateType"]  == 6 then
		--6、提示升级(用户取消时，wifi后台升级)
		showDownloadLuaPrompt();
	elseif dataTable["updateType"]  == 7 then
		--7、提示升级(用户取消时，wifi、2G后台升级)
		showDownloadLuaPrompt();
	end
end

--[[--
--小游戏脚本检测
--]]
function showMiniGameScriptUpdataPrompt()
	if not Common.logicScriptInSD() or Common.platform == Common.TargetIos or not getNewUserGiudeFinish() then
		--如果没有复制完脚本或者是ios平台(ios平台发布完整包)，则不升级
		return;
	end
	local miniGameList = profile.MiniGame.getCanUpdateMiniGameInfo();

	for i = 1, #miniGameList do
		--是否需要更新  0不更新 1更新
		Common.log("小游戏脚本检测 == isUpdate === "..miniGameList[i].isUpdate)
		--脚本升级Url地址
		Common.log("小游戏脚本检测 == ScriptUpdateUrl === "..miniGameList[i].ScriptUpdateUrl)
		--删除文件列表
		Common.log("小游戏脚本检测 == fileDelListTxtUrl === "..miniGameList[i].fileDelListTxtUrl)

		DownloadControler.getDownloadLuaUpdateFile(miniGameList[i].ScriptUpdateUrl, miniGameList[i].fileDelListTxtUrl, Common.getZipDownloadDir(), DownloadControler.DOWNLOAD_ACTION_H, true, false, "", downloadScriptDone, false)
	end
end

--[[--
--活动脚本检测
--]]
function showTaskScriptUpdataPrompt()
	if not Common.logicScriptInSD() or Common.platform == Common.TargetIos or not getNewUserGiudeFinish() then
		--如果没有复制完脚本或者是ios平台(ios平台发布完整包)，则不升级
		return;
	end
	local operTaskList = profile.HuoDong.getCanUpdateOperTaskInfo();

	for i = 1, #operTaskList do
		--是否需要更新  0不更新 1更新
		Common.log("活动脚本检测 == isUpdate === "..operTaskList[i].isUpdate)
		--脚本升级Url地址
		Common.log("活动脚本检测 == ScriptUpdateUrl === "..operTaskList[i].ScriptUpdateUrl)
		--删除文件列表
		Common.log("活动脚本检测 == fileDelListTxtUrl === "..operTaskList[i].fileDelListTxtUrl)

		DownloadControler.getDownloadLuaUpdateFile(operTaskList[i].ScriptUpdateUrl, operTaskList[i].fileDelListTxtUrl, Common.getZipDownloadDir(), DownloadControler.DOWNLOAD_ACTION_H, true, false, "", downloadScriptDone, false)
	end
end

--[[--
-- 校验牌桌解压后文件完整性（是都解压完全，解压后的文件大小是否一致）
--]]
function startVerifyUnZipedFiles()
	DownloadControler.startVerifyUnZipedFiles(GameConfig.URL_TABLE_MUSIC, GameConfig.DIR_RELOAD)
end

--完成新手任务保存数据
function getNewUserTaskFinish()
	if(Common.getDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID()) ~= nil and
		Common.getDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID()) == 1)then
		return true;
	else
		return false;
	end
end

--完成新手引导保存数据
function getNewUserGiudeFinish()
	if(Common.getDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID()) ~= nil and
		Common.getDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID()) == "1")then
		return true;
	else
		return false;
	end
end

--跳过新手引导
function getCOMMONS_SKIP_NEWUSERGUIDE()
	local result = profile.NewUserGuide.getNewUserGuideSkipResult();
	local txt = profile.NewUserGuide.getNewUserGuideSkipTxt()
	if(result == 1)then
		--跳过新手引导成功
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		if(SkipNewUserGuideLogic.getClickSkipNewUserGuideFlag() == true)then
		--	Common.showToast(txt,2);
		end
		if(GameConfig.getTheCurrentBaseLayer() == GUI_TABLE)then
			TableLogic.exitLordTable();
		elseif  GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL then
			mvcEngine.createModule(GUI_HALL);
		end
		--完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);
	else
	--跳过新手引导失败
	--Common.showToast(txt,2);
	end
end

--同步新手引导消息
function getCOMMONS_SYN_NEWUSERGUIDE_STATE()

	if(profile.NewUserGuide.getIsCanSatarTask() == false)then
		--新手引导已完成
		Common.setDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID(), "1");
		--显示预读消息的有关弹窗
		MessagesPreReadManage.showPopupsAboutPreReadMessages();
	elseif( GameConfig.isRegister == false and not GameConfig.isFirstSendTaskState and profile.NewUserGuide.getIsCanSatarTask() )then
		Common.log("如果不是新注册用户，且新手引导未完成1");
		NewUserCreateLogic.InterruptNewUserTask();
		GameConfig.isFirstSendTaskState = true;
	end
end

--获取新手引导基本信息

function getCOMMONS_GET_BASEINFO_NEWUSERGUIDE()
	local dataBaseInfo = profile.NewUserGuide.getNewUserGuideBaseInfo();
	if dataBaseInfo ~= nil then
		Common.log("======获取到了新手引导的基本信息=======");
	else
		Common.log("======请求新手引导的基本信息失败=======");
	end

end

--领取新手引导奖励
function getCOMMONS_GET_NEWUSERGUIDE_AWARD()
	--如果是新手引导第四步获取奖励,就已经提前获得
	--所有先保存消息,等待用户点击才显示
	if NewUserCoverOtherLogic.getTaskState() == NewUserCoverOtherLogic.getDataTable().TASK_FOUR_TELEPHONE_CLOSE
		and NewUserCreateLogic.isUserOnClickCloseBtn == false then
		--有数据没更新
		NewUserCreateLogic.hasNewUserGuideData = true;
		return;
	end

	--是否领取成功，0未成功，1成功
	if(profile.NewUserGuide.getAwardIsResult() == 1)then
		--领奖成功
		NewUserCreateLogic.TaskFinish();
	else
	--领奖失败
	end
end


--[[--
--处理元宝购买礼包
--]]
function BuyGoodsByYuanbao()
	Common.closeProgressDialog()
	local giftData = profile.Gift.getGiftResultForYuanbao()
	--result  是否成功1是0否
	Common.log("是否成功1是0否 = " .. giftData["result"])
	--resultMsg
	Common.log(" = " .. giftData["resultMsg"])
	Common.showToast(giftData["resultMsg"], 2)
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
	--profile.Gift.sendFirstGiftIconMsg(1);
	elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		profile.Gift.sendFirstGiftIconMsg(2);
	end
	sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
	sendGIFTBAGID_GIFTBAG_LIST()
end

--[[--
--更新用户礼包状态
--]]
function updataGiftType()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		TableLogic.showGiftIcon()
	end
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		HallLogic.isShowCountDownGiftPackage()
	end
end

--[[--
--显示被踢出窗口
--]]
function showBeKickedView()
	Common.log("showBeKickedView")
	mvcEngine.createModule(GUI_BE_KICKED_VIEW)
end

--[[--
--显示充值结果弹窗
--]]
function showRechargeResult()
	local RechargeResultTable = {};

	RechargeResultTable = profile.RechargeResult.getRechargeResultTable();
	--充值结果类型0：失败 1：购买金币成功2：购买元宝成功3：购买礼包成功
	local result = RechargeResultTable.result;
	--本次充值元宝数量
	local yuanbaoCount = RechargeResultTable.yuanbaoCount;
	--充值结果提示语
	local resultMsg = RechargeResultTable.resultMsg;
	--是否短代充值  0：非短代 1：短代
	local isSmsRecharge = RechargeResultTable.isSmsRecharge;
	--当前VIP等级
	local newVipLevel = RechargeResultTable.newVipLevel;
	--充值引导ID
	local rechargeID = RechargeResultTable.rechargeID;
	--Giftype	Int	礼包类型
	local Giftype = RechargeResultTable.Giftype
	--price	int	人民币价格（分）	单位：分
	local price = RechargeResultTable.price
	--IsGift	byte	是否为礼包	0不是，1是礼包
	local IsGift = RechargeResultTable.IsGift
	--IsExchange	byte	是否兑换金币
	local IsExchange = RechargeResultTable.IsExchange

	Common.log("result === "..result)
	Common.log("isSmsRecharge === "..isSmsRecharge)
	Common.log("Giftype === "..Giftype)
	Common.log("price === "..price)
	Common.log("IsGift === "..IsGift)
	Common.log("IsExchange === "..IsExchange)

	if result == 0 then
		--0：失败
		if isSmsRecharge == 1 then
			-- 1：短代
			if IsGift == 1 then
				--1是礼包
				sendGIFTBAGID_REQUIRE_GIFTBAG(Giftype, 0, 1)
			else
				--0不是礼包
				if Giftype == 0 then
					if IsExchange == 0 then
						--金币
						--						showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, price * 7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您的话费支付失败，请用以下方式再来一次！");
						showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, price * 7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您支付失败了，请用以下方式再来一次！");
					else
						--元宝
						--						showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, (price / 100) * 0.7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您的话费支付失败，请用以下方式再来一次！");
						showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, (price / 100) * 0.7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您支付失败了，请用以下方式再来一次！");
					end
				end
			end
		else
			mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
			SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
		end
		return
	end

	if result == 2 then
		--2：购买元宝成功
		if rechargeID > 0 then
			--充值引导
			mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
			SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
		else
			--充值列表
			mvcEngine.createModule(GUI_RECHARGE_RESULT);
			RechargeResultLogic.setDialogData(resultMsg, yuanbaoCount);
		end
	else
		--1：购买金币成功 3：购买礼包成功
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
	end
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
	--profile.Gift.sendFirstGiftIconMsg(1);
	elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		profile.Gift.sendFirstGiftIconMsg(2);
	end
	sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_JIPAIQI) --查看记牌器信息
	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_GAOJIBIAOQINGBAO)  --查看高级表情包信息
	sendDBID_BACKPACK_LIST()--背包

	sendGIFTBAGID_GIFTBAG_LIST()
end

ImageList = {}--要初始化的图片

--[[--
--初始化图片的下载回调
--]]
function downloadImageCallBack(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" then
		if #ImageList > 0 then
			table.remove(ImageList, tonumber(id));
			downloadImage();
		end
	end
end

--[[--
--下载初始化图片
--]]
function downloadImage()
	if #ImageList == 0 then
		--webview静态预加载
		sendWebViewCommonMessage()
		return;
	end

	local msPhotoUrl = ImageList[1].picUrl;
	if msPhotoUrl ~= nil and msPhotoUrl ~= "" then
		Common.getPicFile(msPhotoUrl, 1, true, downloadImageCallBack);
	end
end

--[[--
--初始化图片
--]]
function initImageList()
	ImageList = profile.InitImageList.getInitImageList();
	downloadImage();
end

--[[--
--创建显示debug信息
--]]
function createDebugInfo(info)
	local view = cocostudio.createView("GameLoading.json")
	GameStartConfig.addChildForScene(view)
	local w = GameConfig.ScreenWidth;
	local h = GameConfig.ScreenHeight;
	local x = 0;
	local y = 0;
	Common.showWebView("", "<font color=#ff0000>"..info.."</font>", x, y, w, h);
end

--[[--
--更新移动支付方式
--]]
function updataMobilePaymentMode()
	--PaymentMode int 移动支付方式 0：不显示移动支付1：显示MM支付2：显示短代支付3：带验证码的短代（已废弃）
	local PaymentMode = profile.PaymentMode.getMobilePaymentMode()
	Common.log("移动支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS;
	elseif PaymentMode == 1 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_SHOW_MM_OTHERS;
	elseif PaymentMode == 2 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_SHOW_SMSONLINE_OTHERS;
	elseif PaymentMode == 3 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_ONLY_PURSE;
	elseif PaymentMode == 4 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_SHOW_EPAY;
	elseif 	PaymentMode == 5 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_SHOW_YINBEIKE_CMCC;
	elseif PaymentMode == 6 then
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_CMCC
	else
		GameConfig.PAYMENT_METHOD_STATUS = GameConfig.PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS;
	end
end

--[[--
--更新联通支付方式
--]]
function updataUnicomPaymentMode()
	--PaymentMode int 联通支付方式 0：不显示联通支付1：显示联通短代支付2：显示沃商店支付
	local PaymentMode = profile.PaymentMode.getUnicomMPaymentMode()
	Common.log("联通支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_NO_SHOW_UNICOM;
	elseif PaymentMode == 1 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS;
	elseif PaymentMode == 2 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_WOSTORE_OTHERS;
	elseif PaymentMode == 3 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_EPAY;
	elseif PaymentMode == 4 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_YINBEIKE_UNI;
	elseif PaymentMode == 5 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_UNICOM;
	elseif PaymentMode == 6 then
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_SHOW_WOJIA;
	else
		GameConfig.PAYMENT_METHOD_STATUS_LIANTONG = GameConfig.PAYMENT_NO_SHOW_UNICOM;
	end
end

--[[--
--更新电信支付方式
--]]
function updataTelecomPaymentMode()
	--PaymentMode int 电信支付方式 0：不显示电信支付1：显示华建支付2：显示天翼空间支付
	local PaymentMode = profile.PaymentMode.getTelecomPaymentMode()
	Common.log("电信支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_NO_SHOW_TELECOM;
	elseif PaymentMode == 1 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_SHOW_HUAJIAN_OTHERS;
	elseif PaymentMode == 2 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_SHOW_CTESTORE_OTHERS;
	elseif PaymentMode == 3 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_SHOW_EPAY;
	elseif PaymentMode == 4 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_SHOW_YINBEIKE_CT;
	elseif PaymentMode == 5 then
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_SHOW_HONGRUAN_SDK_CT;
	else
		GameConfig.PAYMENT_METHOD_STATUS_DIANXIN = GameConfig.PAYMENT_NO_SHOW_TELECOM;
	end
end

function logicLogin()
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--在大厅中收到登录消息
		local result = profile.UserLoginReg.getResult();
		if (result == 0) then
			--登录成功
			HallChatLogic.clearChatText();
			HallChatLogic.sendEnterChatRoom();
		end
	end
	logicGameSync();
	if CommShareConfig.isOpenRedGiftShare() == true then
		CommShareConfig.sendRedGiftShareReceiveReward()
	end
end

--[[--
--判断上一次加载WEBVIEW的时间里现在是否达到24小时
--]]
function judgeTimeToLoadWebView()
	if not JUDGETIME then
		local timeStamp = Common.getDataForSqlite(WEBVIEWUPDATETIME)
		local nowStamp = Common.getServerTime()
		if timeStamp == nil or timeStamp == "" then
			Common.setDataForSqlite(WEBVIEWUPDATETIME, nowStamp);
			JUDGETIME = true --首次加载webview设置为true
		else
			nowStamp = tonumber(nowStamp);
			timeStamp = tonumber(timeStamp);
			if (nowStamp - timeStamp) / (3600 * 24) > 1 then
				JUDGETIME = true --达到24小时可以加载webview
				preLoadWebViewCommMessage()
			end
		end
	end
end

--[[--
--所有WEBVIEW的预加载
--]]
function preLoadWebViewCommMessage()
	--遍历url表获得key和url
	if webViewTable["Key"] ~= nil and #webViewTable["Key"] > 0 and #webViewTable["Url"] > 0 and not preWebViewCompleted then
		local key = webViewTable["Key"][1]
		local url = webViewTable["Url"][1]
		local itemTable = Common.LoadTable(key) --根据key加载本地本地数据
		if itemTable then
			sendCOMMONS_HTTPPROXY(url, itemTable.HashCode, key) --如果本地有数据请求服务器更新，比较hasecode判断是否有更新
		else
			sendCOMMONS_HTTPPROXY(url, 0, key) --如果本地无数据，请求服务器
		end
		table.remove(webViewTable["Key"], 1)
		table.remove(webViewTable["Url"], 1)
		return
	elseif webViewTable["Key"] ~= nil and #webViewTable["Key"] == 0 then
		Common.log("webview----webview加载完成")
		preWebViewCompleted = true --全部webview预加载完成
		Common.setDataForSqlite(WEBVIEWUPDATETIME, Common.getServerTime());
	end
end

--[[--
--初始化webview列表
--]]
function preloadMatchWebViewMessage()
	local MatchTable = {}
	webViewTable["Key"] = {}
	webViewTable["Url"] = {}

	MatchTable["MatchList"] = profile.Match.getMatchTable()
	if MatchTable["MatchList"] ~= nil and not preWebViewCompleted then
		webViewTable["Key"] = {
			"URL_TABLE_LOGIN",
			"URL_TABLE_LUKEYTURN_HELP",
			"URL_TABLE_MONTHSIGN_HELP",
			"URL_TABLE_CUSTOMSERVICE_SERVICE",
			"URL_TABLE_CUSTOMSERVICE_HELP",
			"URL_TABLE_TTHELP",
			"URL_TABLE_CRAZYSTAGE_HELP",
			"URL_TABLE_PAIHANGBANG_HEIP",
		}
		webViewTable["Url"] = {
			GameConfig.URL_TABLE_LOGIN,
			GameConfig.URL_TABLE_LUKEYTURN_HELP,
			GameConfig.URL_TABLE_MONTHSIGN_HELP,
			GameConfig.URL_TABLE_CUSTOMSERVICE_SERVICE,
			GameConfig.URL_TABLE_CUSTOMSERVICE_HELP,
			GameConfig.URL_TABLE_TTHELP,
			GameConfig.URL_TABLE_CRAZYSTAGE_HELP,
			GameConfig.URL_XY_PLATFORM_GIFT_BAG,
			GameConfig.URL_TABLE_PAIHANGBANG_HEIP,
		}
		Common.log("MatchTable = "..#MatchTable["MatchList"])
		local versioncode = Common.getVersionCode() + Common.getChannelID()--版本号
		local VipLevel = profile.User.getSelfVipLevel()--vip级别
		local vipjb = VIPPub.getUserVipType(VipLevel)--vip
		local itemTable = {}
		local num = #webViewTable["Key"]
		local selfVip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
		for j=1, #MatchTable["MatchList"] do
			local MatchID = MatchTable["MatchList"][j].MatchID
			local key = string.format("MATCH%d_%d", MatchID, selfVip) --自定义key 由MATCH加比赛ID组成
			--测试用
			--			local url = "http://10.10.0.99:8090/TqRechargeAdminMvn/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
			--新比赛
			local url = "http://matchdetail.tongqutongqu.cn/tqAdmin/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
			--旧比赛
			--			local url = "http://58.68.246.34/tqAdmin/matchDetailManagerNew!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb;
			webViewTable["Key"][j+num] = key
			webViewTable["Url"][j+num] = url
		end
		if #ImageList == 0 then
			--webview静态预加载
			if JUDGETIME then
				preLoadWebViewCommMessage()
			end
			return;
		end
	end
end

--[[--
--webview预加载
--]]
function sendWebViewCommonMessage()
	Common.log("sendWebViewCommonMessage---------------")
	--如果比赛列表加载完成，则进行所有WEBVIEW的预加载
	judgeTimeToLoadWebView()
end

--[[--
-- 公共WEBVIEW预加载
@param webURL	读取web的url地址
@param key	存入本地的key
@param x	显示webview的x坐标
@param y	显示webview的x坐标
@param width	显示webview的宽
@param height	显示webview的高
]]
function commonLoadWebView(webURL, key, x, y, width, height)
	webViewTable.URL = webURL
	webViewTable.x = x
	webViewTable.y = y
	webViewTable.width = width
	webViewTable.height = height
	webViewTable.key = key
	local itemTable = Common.LoadTable(webViewTable.key)
	--[[if itemTable then --存在本地数据
	Common.log("sendCOMMONS_HTTPPROXY = 有本地数据")
	sendCOMMONS_HTTPPROXY(webURL, itemTable.HashCode) --获取web是否有更新
	webViewTable.html = itemTable.Html	--预存本地数据
	else
	Common.log("sendCOMMONS_HTTPPROXY = 没有本地数据")
	sendCOMMONS_HTTPPROXY(webURL, 0) --请求web数据
	webViewTable.html = ""	--预存本地数据，防止空
	end--]]

	if itemTable then --存在本地数据
		Common.log("sendCOMMONS_HTTPPROXY = 有本地数据")
		--sendCOMMONS_HTTPPROXY(webURL, itemTable.HashCode, key) --获取web更新
		Common.showWebView("", itemTable.Html, x, y, width, height); --显示webview
	else
		Common.log("sendCOMMONS_HTTPPROXY = 没有本地数据")
		sendCOMMONS_HTTPPROXY(webURL, 0, key) --获取web更新
		Common.showWebView(webURL, "", x, y, width, height);	--显示webview
	end
end

--[[--
--开赛通知V4
--]]
function getMATID_V4_START_NOTIFYInfo()
	Common.log("getMATID_V4_START_NOTIFYInfo")

	local table = profile.Match.getMATID_START_NOTIFYTable()

	if JsMatchDetailLogic.view ~= nil then
		-- 如果是即时赛，则停止继续同步报名人数
		Common.log("如果是即时赛，则停止继续同步报名人数")
		JsMatchDetailLogic.view:stopAllActions();

		-- 更新进度条
		local regTable = {}
		regTable.MaxRegCnt = table.maxRegCnt
		regTable.RegCnt = table.regCnt
		JsMatchDetailLogic.updateProgressUI(regTable)
	end

	Common.showToast(table.Msg, 2)

	if TableLogic.view == nil then
		-- 不在牌桌中时，才发送进入比赛请求
		sendMATID_V4_ENTER_MATCH(GameConfig.GAME_ID, table.MatchInstanceID)
	end
end

local simulateSyncTimer = nil;
local simulateSynctimerNum = 0;

--[[--
--进入比赛V4
--]]
function getMATID_V4_ENTER_MATCHInfo()
	local table = profile.Match.getMATID_ENTER_MATCHTable()
	--1失败  0成功
	if(table.Result == 1)then
		Common.showToast(table.ResultMsg, 2)
	else
		--GameConfig.setTheLastBaseLayer(GUI_HALL)
		-- 添加loading界面
		Common.showProgressDialog("正在进入比赛房间, 请稍后...")
		Common.log("table.MatchID = "..table.MatchID)
		profile.Match.setCurPlayedMatchID(table.MatchID) --记录当前进行的比赛ID，用于后面破产送金使用
		MatchList.removeAlarmQueue(table.MatchID)

		--开启模拟断线续玩定时器(牌桌外)
		startSimulateSync(0)
	end
end

--[[--
--开启模拟断线续玩定时器
--type: 0-牌桌外	1-牌桌内
--]]
function startSimulateSync(type)
	if type == 0 then
		if simulateSyncTimer == nil then
			simulateSyncTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(simulateSyncCntWithoutTable, 1, false);
		end
	elseif type == 1 then
		if simulateSyncTimer == nil then
			simulateSyncTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(simulateSyncCntWithinTable, 1, false);
		end
	end
end

--[[--
--模拟断线续玩计时器(牌桌外)--牌桌外开赛后无法进入牌桌保底方案
--]]
function simulateSyncCntWithoutTable()
	simulateSynctimerNum = simulateSynctimerNum+1
	Common.log("simulateSynctimerNum = "..simulateSynctimerNum)
	if simulateSynctimerNum == 15 then
		if TableLogic.view == nil then
			-- 15秒之类如果没有进入牌桌，开始模拟断线续玩
			Services:getMessageService():closeSocket();
			Services:getMessageService():reConnect();
		end

		if (simulateSyncTimer ~= nil) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(simulateSyncTimer);
			simulateSyncTimer = nil
			simulateSynctimerNum = 0
		end
	end
end

--[[--
--模拟断线续玩计时器(牌桌内)--牌桌内解除托管保底方案
--]]
function simulateSyncCntWithinTable()
	simulateSynctimerNum = simulateSynctimerNum+1
	Common.log("simulateSynctimerNum = "..simulateSynctimerNum)
	if simulateSynctimerNum == 5 then
		if TableConsole.getPlayer(TableConsole.getSelfSeat()) ~= nil and TableConsole.getPlayer(TableConsole.getSelfSeat()).m_bTrustPlay then
			-- 5秒之类如果没有解除托管，开始模拟断线续玩
			Services:getMessageService():closeSocket();
			Services:getMessageService():reConnect();
		end
		if (simulateSyncTimer ~= nil) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(simulateSyncTimer);
			simulateSyncTimer = nil
			simulateSynctimerNum = 0
		end
	end
end

--[[--
--检测脚本升级
--]]
function checkScriptVersion()
	if GameConfig.isCheckScript then
		--已经检测过
		return
	end
	if Common.logicScriptInSD() and getNewUserGiudeFinish() then
		--复制完脚本&&完成新手引导
		GameConfig.isCheckScript = true
		--脚本升级检测
		sendMANAGERID_LUA_SCRIPT_VERSION()
	end
end

--[[--
--设置微信分享的app下载URL
--]]
function setWeChatShareAppDownLoadURL()
	local AppDownLoadURL = profile.ShareToWX.getAppDownLoadURL();
	if Common.platform == Common.TargetWindows then
	--windows平台
	elseif Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then
		--Android
		local javaClassName = Load.AndroidPackageName .. ".wxapi.WXEntryActivity";
		local javaMethodName = "setWeChatShareAppDownLoadURL"
		local javaParams = {
			AppDownLoadURL,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

