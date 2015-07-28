local path = "script.module."

ccs = require"script.framework.mvc.view.ccs"

----------------------------登录--------------------------------
Load.LuaRequire(path .. "login.logic.LoginLogic")
Load.LuaRequire(path .. "login.logic.MoreLogic")
Load.LuaRequire(path .. "login.logic.DeleteUserLogic")

----------------------------大厅-------------------------------
Load.LuaRequire(path .. "hall.logic.HallLogic")
Load.LuaRequire(path .. "hall.logic.AndroidExitLogic")
Load.LuaRequire(path .. "hall.logic.HallChatLogic")
Load.LuaRequire(path .. "chatTanchuang.logic.ChatTanChuangLogic")
Load.LuaRequire(path .. "hall.logic.SettingLogic")
Load.LuaRequire(path .. "hall.logic.TimeNotFitLogic")
Load.LuaRequire(path .. "hall.logic.HallCoverLogic")
Load.LuaRequire(path .. "hall.logic.HallButton")
Load.LuaRequire(path .. "hall.logic.HallButtonConfig")
Load.LuaRequire(path .. "hall.logic.HallButtonManage")
Load.LuaRequire(path .. "hall.logic.MessagesPreReadManage")

----------------------------牌桌-------------------------------
Load.LuaRequire(path .. "tableDialog.logic.TableExitLogic")
Load.LuaRequire(path .. "tableDialog.logic.GameResultLogic")
Load.LuaRequire(path .. "tableDialog.logic.TableNotEndedLogic")
Load.LuaRequire(path .. "tableDialog.logic.CertificateLogic")
Load.LuaRequire(path .. "tableDialog.logic.SelectLaiziCardLogic")
Load.LuaRequire(path .. "tableDialog.logic.TableOtherUserInfoLogic")
Load.LuaRequire(path .. "tableDialog.logic.TableSelfUserInfoLogic")
Load.LuaRequire(path .. "tableDialog.logic.TableFlyUserInfo")
Load.LuaRequire(path .. "tableDialog.logic.TTGetTxzLogic")
Load.LuaRequire(path .. "tableDialog.logic.TTShengjiLogic")
Load.LuaRequire(path .. "tableDialog.logic.MatchRankingLogic")
Load.LuaRequire(path .. "tableDialog.logic.TTJiangDuanLogic")
Load.LuaRequire(path .. "tableDialog.logic.TableReportLogic")
Load.LuaRequire(path .. "tableDialog.logic.TreasureChestsLogic")

Load.LuaRequire(path .. "tableDialog.logic.CrazyResultLogic")
Load.LuaRequire(path .. "tableDialog.logic.CrazyBuyStoneLogic")
Load.LuaRequire(path .. "tableDialog.logic.MatchDengdaidaozhangLogic")

Load.LuaRequire(path .. "table.logic.TableLogic")
Load.LuaRequire(path .. "table.table_util.TableUtilRequire")
Load.LuaRequire(path .. "table.table_entity.TableEntityRequire")
Load.LuaRequire(path .. "table.table_console.TableConsoleRequire")
Load.LuaRequire(path .. "table.logic.jipaiqiLogic")

----------------------------背包---------------------------
Load.LuaRequire(path .. "pack.logic.FragmentsLogic")

-----------------------------商城----------------------
Load.LuaRequire(path .. "shop.logic.ConvertCoinLogic")
Load.LuaRequire(path .. "shop.logic.ShopBuyGoodsLogic")
Load.LuaRequire(path .. "shop.logic.ShopBuyCoinLogic")
Load.LuaRequire(path .. "shop.logic.ShopLogic")
Load.LuaRequire(path .. "shop.logic.BuyCoinConfimLogic")
Load.LuaRequire(path .. "shop.logic.BuyGiftVipNotFitLogic")
Load.LuaRequire(path .. "shop.logic.BuyVipGiftLogic")

----------------------------排行榜---------------------------
Load.LuaRequire(path .. "paihangbang.logic.ccTableView")
Load.LuaRequire(path .. "paihangbang.logic.PaiHangLayer")
Load.LuaRequire(path .. "paihangbang.logic.PaiHangBangLogic")
Load.LuaRequire(path .. "paihangbang.logic.RechargeRankCoverLogic")

----------------------------小游戏列表---------------------------
Load.LuaRequire(path .. "minigame.logic.MiniGameLogic")
Load.LuaRequire(path .. "minigame.logic.MiNiGameGuideTanChuKuangLogic")
Load.LuaRequire(path .. "minigame.logic.MiniGameGuideConfig")

----------------------------活动 ---------------------------
Load.LuaRequire(path .. "huodong.logic.HuoDongLogic")
Load.LuaRequire(path .. "meiridenglutishi.logic.MeiRiDengLuTiShiLogic")
-----------------------------个人信息----------------------
Load.LuaRequire(path .. "userinfo.logic.AddressConfig")
Load.LuaRequire(path .. "userinfo.logic.UserInfoLogic")
Load.LuaRequire(path .. "userinfo.logic.SetOldSexLogic")
Load.LuaRequire(path .. "userinfo.logic.BindPhoneLogic")
Load.LuaRequire(path .. "userinfo.logic.BindPhoneMsgLogic")
Load.LuaRequire(path .. "userinfo.logic.CityListLogic")
Load.LuaRequire(path .. "userinfo.logic.tiantibangzhuLogic")
Load.LuaRequire(path .. "userinfo.logic.BindPhoneConfig")

-----------------------------站内信----------------------
Load.LuaRequire(path .. "message.logic.MessagePlayerLogic")
Load.LuaRequire(path .. "message.logic.MessageServerLogic")
Load.LuaRequire(path .. "message.logic.MessageListLogic")

-----------------------------游戏公共方法-------------------------
Load.LuaRequire(path .. "gameUtil.QuickPay")
Load.LuaRequire(path .. "gameUtil.PaymentMethod")
Load.LuaRequire(path .. "gameUtil.RechargeGuidePositionID")
Load.LuaRequire(path .. "gameUtil.AudioManager")
Load.LuaRequire(path .. "gameUtil.GameArmature")
Load.LuaRequire(path .. "gameUtil.LordGamePub")
Load.LuaRequire(path .. "gameUtil.RoomGuide")
Load.LuaRequire(path .. "gameUtil.FontStyle")
Load.LuaRequire(path .. "gameUtil.ScrollPub")
Load.LuaRequire(path .. "gameUtil.VIPPub")
Load.LuaRequire(path .. "gameUtil.JavaCallBackLuaFunction")
Load.LuaRequire(path .. "gameUtil.ShadowForFullScreen")
Load.LuaRequire(path .. "gameUtil.GamePauseResumeListener")

--兑换
Load.LuaRequire(path .. "exchange.logic.HuaFeiZhangHuLogic")
Load.LuaRequire(path .. "exchange.logic.GetCardAwardInfoLogic")
Load.LuaRequire(path .. "exchange.logic.ExchangeDetailLogic")
Load.LuaRequire(path .. "exchange.logic.GetAwardInfoLogic")
Load.LuaRequire(path .. "exchange.logic.MyPrizeDetailLogic")
Load.LuaRequire(path .. "exchange.logic.CardDuihuanWaysLogic")
Load.LuaRequire(path .. "exchange.logic.CardKhAndPassLogic")
Load.LuaRequire(path .. "exchange.logic.SuipianNotEnoughLogic")
Load.LuaRequire(path .. "exchange.logic.ExchangeLogic")
Load.LuaRequire(path .. "exchange.logic.RedeemLogic")
----------------------------财神模块-----------------------------
Load.LuaRequire(path .. "caishen.logic.CaiShenLogic")
Load.LuaRequire(path .. "caishen.logic.CaiShenChongZhiLogic")
Load.LuaRequire(path .. "caishen.logic.CaiShenOkLogic")

Load.LuaRequire(path .. "caishen.logic.CaiShenGuiZeLogic")

------vip
Load.LuaRequire(path .. "vip.logic.VIPDetailLogic")
Load.LuaRequire(path .. "vip.logic.VIPLogic")
------------------------------比赛模块----------------------------
Load.LuaRequire(path .. "match.logic.JsMatchDetailLogic")
Load.LuaRequire(path .. "match.logic.MatchDetailLogic")
Load.LuaRequire(path .. "match.logic.MatchVipNotEnoughLogic")
Load.LuaRequire(path .. "match.logic.TiaoJianBaoMingLogic")
Load.LuaRequire(path .. "match.logic.TiaoJianBaoMingTanChuangLogic")
Load.LuaRequire(path .. "match.logic.MatchList")
Load.LuaRequire(path .. "match.logic.MatchRechargeCoin")
Load.LuaRequire(path .. "match.logic.matchjijiangkaisaiLogic")

------------------------------任务模块----------------------------
Load.LuaRequire(path .. "renwu.logic.RenWuGuiZeLogic")
Load.LuaRequire(path .. "renwu.logic.RenWuJiangLiInfoLogic")
Load.LuaRequire(path .. "renwu.logic.RenWuLogic")

---------------------------------- 房间引导模块  -------------
Load.LuaRequire(path .. "hall.logic.RoomCoinNotFitLogic")
Load.LuaRequire(path .. "hall.logic.ConvertCoinInRoomLogic")
Load.LuaRequire(path .. "commondialog.logic.SendGoldLogic")
---------------------------------- 充值模块   -------------
Load.LuaRequire(path .. "recharge.logic.RechargeCenterLogic")
Load.LuaRequire(path .. "recharge.logic.RechargeConfirmLogic")
Load.LuaRequire(path .. "recharge.logic.SelectCarriersLogic")
Load.LuaRequire(path .. "recharge.logic.SelectCarriersLogic")
Load.LuaRequire(path .. "recharge.logic.InputPrepaidCardLogic")
--客服
Load.LuaRequire(path .. "customservice.logic.CustomServiceLogic")
Load.LuaRequire(path .. "customservice.logic.GameHelpLogic")

----------------------------- 新手引导 ----------------------
Load.LuaRequire(path .. "NewUserGuide.logic.NewUserGuideLogic")
Load.LuaRequire(path .. "NewUserGuide.logic.SkipNewUserGuideLogic")
Load.LuaRequire(path .. "NewUserGuide.logic.NewUserCoverOtherLogic")
Load.LuaRequire(path .. "NewUserGuide.logic.NewUserCreateLogic")
--牌桌聊天
Load.LuaRequire(path .. "chatpop.logic.ChatPopLogic")
--月签(25天版)
Load.LuaRequire(path .. "monthSign.logic.MonthSignLogic")
Load.LuaRequire(path .. "monthSign.logic.ShowMonthSignPrizeLogic")
--转盘
Load.LuaRequire(path .. "luckyTurnTable.logic.LuckyTurnTableLogic")

----------------------------- 闯关 ----------------------
Load.LuaRequire(path .. "chuangguan.logic.ChuangGuanLogic")
Load.LuaRequire(path .. "chuangguan.logic.CrazyTopLogic")
Load.LuaRequire(path .. "chuangguan.logic.CrazyResetAlertLogic")
Load.LuaRequire(path .. "chuangguan.logic.CrazyRuleLogic")

---------------------免费金币---------------------------
Load.LuaRequire(path .. "freeCoin.logic.FreeCoinLogic")

--------------公共分享弹窗----------------------------
Load.LuaRequire(path .. "commshare.logic.CommShareLogic")
Load.LuaRequire(path .. "commshare.logic.InitiativeShareLogic")
Load.LuaRequire(path .. "commshare.logic.CommShareConfig")
Load.LuaRequire(path .. "commshare.logic.InitiativeShareGiftLogic")

---------------------红点------------------------------
Load.LuaRequire(path .. "hongdian.logic.HongDianLogic")

---------------------病毒传播------------------------------
Load.LuaRequire(path .. "commshare.logic.RedGiftShareLogic")
Load.LuaRequire(path .. "commshare.logic.RedGiftComfirmLogic")

----------------------------公共模块(注意已经要最后加载)-----------------------------
Load.LuaRequire(path .. "commondialog.logic.RechargePromptLogic")
Load.LuaRequire(path .. "commondialog.logic.PayGuidePromptLogic")
Load.LuaRequire(path .. "commondialog.logic.CommDialogConfig")
Load.LuaRequire(path .. "commondialog.logic.CommServerConfig")
Load.LuaRequire(path .. "commondialog.logic.CommSignalConfig")
Load.LuaRequire(path .. "commondialog.logic.CommSqliteConfig")
Load.LuaRequire(path .. "commondialog.logic.HallGiftShowLogic")
Load.LuaRequire(path .. "commondialog.logic.HallGiftCloseLogic")
Load.LuaRequire(path .. "commondialog.logic.ImageToast")
Load.LuaRequire(path .. "commondialog.logic.GameLoadingLogic")
Load.LuaRequire(path .. "commondialog.logic.CommonUploadConfig")
--lua脚本更新
Load.LuaRequire(path .. "commondialog.logic.LuaUpdateLogic")
Load.LuaRequire(path .. "commondialog.logic.BeKickedLogic")
Load.LuaRequire(path .. "commondialog.logic.NetErrExitDialogLogic")
Load.LuaRequire(path .. "commondialog.logic.SystemPromptDialogLogic")
Load.LuaRequire(path .. "commondialog.logic.SingleBtnTransparentBoxLogic")
Load.LuaRequire(path .. "commondialog.logic.TextTransparentBoxLogic")

GameLoadModuleConfig.loadGameModule();
