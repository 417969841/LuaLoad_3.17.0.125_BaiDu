
--服务器消息信号注册
framework.addSlot2Signal(GAMEID_SERVER_MSG, CommDialogConfig.showServerMsg)

--版本检测
framework.addSlot2Signal(BASEID_PLAT_VERSION, CommDialogConfig.showVersionPrompt)

--显示礼包消息
framework.addSlot2Signal(GIFTBAGID_PUSH_DUAL_GIFTBAG, CommDialogConfig.showGiftView)

--元宝购买礼包应答
framework.addSlot2Signal(GIFTBAGID_BUY_GIFTBAG, CommDialogConfig.BuyGoodsByYuanbao)

--建立连接失败(每连续出现三次，则弹出网络异常对话框)
framework.addSlot2Signal(NETERR_CONN_FAILED, CommDialogConfig.netErrConnFailedFun)

--网络断开(开始重连)
framework.addSlot2Signal(NETERR_NET_BROKEN, CommDialogConfig.netErrNetBrokenFun)

--重连成功(如果是没有出现连接失败的成功，则不是重连)
framework.addSlot2Signal(NETERR_CONN_SUCC, CommDialogConfig.netErrConnSuccFun)

--切出游戏
framework.addSlot2Signal(GAME_ENTER_BACKGROUND, CommDialogConfig.applicationEnterBackground)

--进入游戏
framework.addSlot2Signal(GAME_ENTER_FOREGROUND, CommDialogConfig.applicationEnterForeground)

--跳过新手引导
framework.addSlot2Signal(COMMONS_SKIP_NEWUSERGUIDE,CommDialogConfig.getCOMMONS_SKIP_NEWUSERGUIDE);
--同步新手引导状态
framework.addSlot2Signal(COMMONS_SYN_NEWUSERGUIDE_STATE,CommDialogConfig.getCOMMONS_SYN_NEWUSERGUIDE_STATE);
--获取新手引导基本信息
framework.addSlot2Signal(COMMONS_GET_BASEINFO_NEWUSERGUIDE,CommDialogConfig.getCOMMONS_GET_BASEINFO_NEWUSERGUIDE);
--领取新手引导奖励
framework.addSlot2Signal(COMMONS_GET_NEWUSERGUIDE_AWARD,CommDialogConfig.getCOMMONS_GET_NEWUSERGUIDE_AWARD);

--礼包状态更新
--framework.addSlot2Signal(GIFTBAGID_GET_GIFTBAG_MSG, CommDialogConfig.updataGiftType)

--首充礼包状态更新
framework.addSlot2Signal(GIFTBAGID_SHOW_FIRSTPAY_ICON, CommDialogConfig.updataGiftType)

--礼包请求应答
framework.addSlot2Signal(GIFTBAGID_REQUIRE_GIFTBAG, CommDialogConfig.updataGiftType)

--lua脚本版本检测
framework.addSlot2Signal(MANAGERID_LUA_SCRIPT_VERSION, CommDialogConfig.showScriptUpdataPrompt)

--小游戏脚本版本检测
framework.addSlot2Signal(MANAGERID_MINIGAME_LIST_TYPE_V2, CommDialogConfig.showMiniGameScriptUpdataPrompt)

--活动脚本版本检测
framework.addSlot2Signal(OPERID_GET_OPER_TASK_LIST_V2, CommDialogConfig.showTaskScriptUpdataPrompt)

--充值结果通知
framework.addSlot2Signal(DBID_RECHARGE_RESULT_NOTIFICATION, CommDialogConfig.showRechargeResult)


--初始化图片
framework.addSlot2Signal(MANAGERID_GET_INIT_PIC, CommDialogConfig.initImageList)

--移动支付方式
framework.addSlot2Signal(MANAGERID_MOBILE_PAYMENT_MODE, CommDialogConfig.updataMobilePaymentMode)

--联通支付方式
framework.addSlot2Signal(MANAGERID_CU_PAYMENT_MODE, CommDialogConfig.updataUnicomPaymentMode)

--电信支付方式
framework.addSlot2Signal(MANAGERID_CT_PAYMENT_MODE, CommDialogConfig.updataTelecomPaymentMode)

--登录消息
framework.addSlot2Signal(BASEID_LOGIN, CommDialogConfig.logicLogin)

-- 接收开赛通知
framework.addSlot2Signal(MATID_V4_START_NOTIFY, CommDialogConfig.getMATID_V4_START_NOTIFYInfo)

-- 接收进入比赛通知
framework.addSlot2Signal(MATID_V4_ENTER_MATCH, CommDialogConfig.getMATID_V4_ENTER_MATCHInfo)

--返回比赛列表到WEBVIEW
framework.addSlot2Signal(MATID_MATCH_LIST_NEW, CommDialogConfig.preloadMatchWebViewMessage)

-- 预加载webview信息
framework.addSlot2Signal(COMMONS_HTTPPROXY, CommDialogConfig.preLoadWebViewCommMessage)

-- 分享V2分享下载地址预读
framework.addSlot2Signal(OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL, CommDialogConfig.setWeChatShareAppDownLoadURL)

-- 红包分享V3
framework.addSlot2Signal(OPERID_SHARING_V3_BASE_INFO, CommShareConfig.saveLocalRedGiftShareBaseInfo)

-- 小游戏引导(牌桌连胜和破产)
framework.addSlot2Signal(MINI_COMMON_NEWGUIDE, MiniGameGuideConfig.miniGameGuide)

--小游戏领取打赏V3
--framework.addSlot2Signal(IMID_CHAT_ROOM_SEND_REWARD_V3, HallLogic.showSystemNotice)