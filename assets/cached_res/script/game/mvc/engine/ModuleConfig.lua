DESTORY_TYPE_CLEAN = 0
DESTORY_TYPE_EFFECT = 1
--第四层目前只用于loading界面
Layer = {
	["base_layer"] = 1,
	["second_layer"] = 2,
	["third_layer"] = 3,
	["fourth_layer"] = 4
}

ModuleTable = {}

--游戏中loading动画界面
--ModuleTable["GameLoading"] = {}
--ModuleTable["GameLoading"]["ControllerPath"] = "script/module/commondialog/controller/GameLoadingController"
--ModuleTable["GameLoading"]["layer"] = "fourth_layer"

--登录界面
ModuleTable["Login"] = {}
ModuleTable["Login"]["ControllerPath"] = "script/module/login/controller/LoginController"
ModuleTable["Login"]["layer"] = "base_layer"

--牌桌界面
ModuleTable["Table"] = {}
ModuleTable["Table"]["ControllerPath"] = "script/module/table/controller/TableController"
ModuleTable["Table"]["layer"] = "base_layer"

--牌桌退出界面
ModuleTable["TableExit"] = {}
ModuleTable["TableExit"]["ControllerPath"] = "script/module/tableDialog/controller/TableExitController"
ModuleTable["TableExit"]["layer"] = "second_layer"
--牌桌结果界面
ModuleTable["GameResult"] = {}
ModuleTable["GameResult"]["ControllerPath"] = "script/module/tableDialog/controller/GameResultController"
ModuleTable["GameResult"]["layer"] = "third_layer"
--牌桌等待界面
ModuleTable["TableNotEnded"] = {}
ModuleTable["TableNotEnded"]["ControllerPath"] = "script/module/tableDialog/controller/TableNotEndedController"
ModuleTable["TableNotEnded"]["layer"] = "second_layer"
--选择癞子牌界面
ModuleTable["SelectLaiziCard"] = {}
ModuleTable["SelectLaiziCard"]["ControllerPath"] = "script/module/tableDialog/controller/SelectLaiziCardController"
ModuleTable["SelectLaiziCard"]["layer"] = "second_layer"
--比赛奖状
ModuleTable["Certificate"] = {}
ModuleTable["Certificate"]["ControllerPath"] = "script/module/tableDialog/controller/CertificateController"
ModuleTable["Certificate"]["layer"] = "third_layer"
--牌桌用户信息(别人)
ModuleTable["TableOtherUserInfo"] = {}
ModuleTable["TableOtherUserInfo"]["ControllerPath"] = "script/module/tableDialog/controller/TableOtherUserInfoController"
ModuleTable["TableOtherUserInfo"]["layer"] = "third_layer"
--牌桌用户信息(自己)
ModuleTable["TableSelfUserInfo"] = {}
ModuleTable["TableSelfUserInfo"]["ControllerPath"] = "script/module/tableDialog/controller/TableSelfUserInfoController"
ModuleTable["TableSelfUserInfo"]["layer"] = "second_layer"
--牌桌降段
ModuleTable["TTJiangDuan"] = {}
ModuleTable["TTJiangDuan"]["ControllerPath"] = "script/module/tableDialog/controller/TTJiangDuanController"
ModuleTable["TTJiangDuan"]["layer"] = "third_layer"
--牌桌举报
ModuleTable["TableReport"] = {}
ModuleTable["TableReport"]["ControllerPath"] = "script/module/tableDialog/controller/TableReportController"
ModuleTable["TableReport"]["layer"] = "third_layer"
--疯狂闯关结果
ModuleTable["CrazyResult"] = {}
ModuleTable["CrazyResult"]["ControllerPath"] = "script/module/tableDialog/controller/CrazyResultController"
ModuleTable["CrazyResult"]["layer"] = "second_layer"
--疯狂闯关购买复活石
ModuleTable["CrazyBuyStone"] = {}
ModuleTable["CrazyBuyStone"]["ControllerPath"] = "script/module/tableDialog/controller/CrazyBuyStoneController"
ModuleTable["CrazyBuyStone"]["layer"] = "second_layer"
--闯关排行
ModuleTable["CrazyTop"] = {}
ModuleTable["CrazyTop"]["ControllerPath"] = "script/module/chuangguan/controller/CrazyTopController"
ModuleTable["CrazyTop"]["layer"] = "second_layer"
--闯关规则
ModuleTable["CrazyRule"] = {}
ModuleTable["CrazyRule"]["ControllerPath"] = "script/module/chuangguan/controller/CrazyRuleController"
ModuleTable["CrazyRule"]["layer"] = "second_layer"
--牌桌被踢
ModuleTable["BeKicked"] = {}
ModuleTable["BeKicked"]["ControllerPath"] = "script/module/commondialog/controller/BeKickedController"
ModuleTable["BeKicked"]["layer"] = "third_layer"

--大厅、房间比赛列表界面
ModuleTable["Hall"] = {}
ModuleTable["Hall"]["ControllerPath"] = "script/module/hall/controller/HallController"
ModuleTable["Hall"]["layer"] = "base_layer"

--更多用户界面
ModuleTable["More"] = {}
ModuleTable["More"]["ControllerPath"] = "script/module/login/controller/MoreController"
ModuleTable["More"]["layer"] = "third_layer"

--商城界面
ModuleTable["Shop"] = {}
ModuleTable["Shop"]["ControllerPath"] = "script/module/shop/controller/ShopController"
ModuleTable["Shop"]["layer"] = "base_layer"

--商城购买界面
ModuleTable["ShopBuyGoods"] = {}
ModuleTable["ShopBuyGoods"]["ControllerPath"] = "script/module/shop/controller/ShopBuyGoodsController"
ModuleTable["ShopBuyGoods"]["layer"] = "second_layer"

--商城购买金币界面
ModuleTable["ShopBuyCoin"] = {}
ModuleTable["ShopBuyCoin"]["ControllerPath"] = "script/module/shop/controller/ShopBuyCoinController"
ModuleTable["ShopBuyCoin"]["layer"] = "second_layer"
--购买金币确认
ModuleTable["BuyCoinConfim"] = {}
ModuleTable["BuyCoinConfim"]["ControllerPath"] = "script/module/shop/controller/BuyCoinConfimController"
ModuleTable["BuyCoinConfim"]["layer"] = "third_layer"

--购买vip礼包
ModuleTable["BuyVipGift"] = {}
ModuleTable["BuyVipGift"]["ControllerPath"] = "script/module/shop/controller/BuyVipGiftController"
ModuleTable["BuyVipGift"]["layer"] = "second_layer"

ModuleTable["BuyGiftVipNotFit"] = {}
ModuleTable["BuyGiftVipNotFit"]["ControllerPath"] = "script/module/shop/controller/BuyGiftVipNotFitController"
ModuleTable["BuyGiftVipNotFit"]["layer"] = "second_layer"

--重置密码界面
ModuleTable["ResetPassword"] = {}
ModuleTable["ResetPassword"]["ControllerPath"] = "script/module/login/controller/ResetPasswordController"
ModuleTable["ResetPassword"]["layer"] = "second_layer"

--背包詳細界面
ModuleTable["BackDetail"] = {}
ModuleTable["BackDetail"]["ControllerPath"] = "script/module/pack/controller/BackDetailController"
ModuleTable["BackDetail"]["layer"] = "second_layer"

--用戶信息界面
ModuleTable["UserInfo"] = {}
ModuleTable["UserInfo"]["ControllerPath"] = "script/module/userinfo/controller/UserInfoController"
ModuleTable["UserInfo"]["layer"] = "base_layer"
--天梯资格不够没法领工资
ModuleTable["TiantiZigeNot"] = {}
ModuleTable["TiantiZigeNot"]["ControllerPath"] = "script/module/userinfo/controller/TiantiZigeNotController"
ModuleTable["TiantiZigeNot"]["layer"] = "second_layer"

--修改用戶信息你界面
ModuleTable["ModifyUserInfo"] = {}
ModuleTable["ModifyUserInfo"]["ControllerPath"] = "script/module/userinfo/controller/ModifyUserInfoController"
ModuleTable["ModifyUserInfo"]["layer"] = "second_layer"

--修改更多信息界面
ModuleTable["ModifyMoreUserInfo"] = {}
ModuleTable["ModifyMoreUserInfo"]["ControllerPath"] = "script/module/userinfo/controller/ModifyMoreUserInfoController"
ModuleTable["ModifyMoreUserInfo"]["layer"] = "second_layer"

--支付界面
ModuleTable["RechargeCenter"] = {}
ModuleTable["RechargeCenter"]["ControllerPath"] = "script/module/recharge/controller/RechargeCenterController"
ModuleTable["RechargeCenter"]["layer"] = "base_layer"

--短信支付二次确认框
ModuleTable["RechargeConfirm"] = {}
ModuleTable["RechargeConfirm"]["ControllerPath"] = "script/module/recharge/controller/RechargeConfirmController"
ModuleTable["RechargeConfirm"]["layer"] = "third_layer"

ModuleTable["RechargeCardChange"] = {}
ModuleTable["RechargeCardChange"]["ControllerPath"] = "script/module/recharge/controller/RechargeCardChangeController"
ModuleTable["RechargeCardChange"]["layer"] = "second_layer"

--充值卡信息选择界面
ModuleTable["RechargeCardList"] = {}
ModuleTable["RechargeCardList"]["ControllerPath"] = "script/module/recharge/controller/RechargeCardListController"
ModuleTable["RechargeCardList"]["layer"] = "third_layer"

ModuleTable["RechargeRecordList"] = {}
ModuleTable["RechargeRecordList"]["ControllerPath"] = "script/module/recharge/controller/RechargeRecordListController"
ModuleTable["RechargeRecordList"]["layer"] = "second_layer"

--citylist
ModuleTable["CityList"] = {}
ModuleTable["CityList"]["ControllerPath"] = "script/module/userinfo/controller/CityListController"
ModuleTable["CityList"]["layer"] = "second_layer"

--兑换金币list界面
ModuleTable["ConvertList"] = {}
ModuleTable["ConvertList"]["ControllerPath"] = "script/module/shop/controller/ConvertListController"
ModuleTable["ConvertList"]["layer"] = "base_layer"
--兑换金币界面
ModuleTable["ConvertCoin"] = {}
ModuleTable["ConvertCoin"]["ControllerPath"] = "script/module/shop/controller/ConvertCoinController"
ModuleTable["ConvertCoin"]["layer"] = "second_layer"
--大厅弹出更多界面
ModuleTable["HallMorePop"] = {}
ModuleTable["HallMorePop"]["ControllerPath"] = "script/module/hall/controller/HallMorePopController"
ModuleTable["HallMorePop"]["layer"] = "second_layer"

--站内信
ModuleTable["MessageList"] = {}
ModuleTable["MessageList"]["ControllerPath"] = "script/module/message/controller/MessageListController"
ModuleTable["MessageList"]["layer"] = "base_layer"

ModuleTable["MessagePlayer"] = {}
ModuleTable["MessagePlayer"]["ControllerPath"] = "script/module/message/controller/MessagePlayerController"
ModuleTable["MessagePlayer"]["layer"] = "second_layer"

ModuleTable["MessageServer"] = {}
ModuleTable["MessageServer"]["ControllerPath"] = "script/module/message/controller/MessageServerController"
ModuleTable["MessageServer"]["layer"] = "second_layer"

ModuleTable["MessageController"] = {}
ModuleTable["MessageController"]["ControllerPath"] = "script/module/message/controller/MessageControllerController"
ModuleTable["MessageController"]["layer"] = "third_layer"
--站内信领取
ModuleTable["MessageLingqu"] = {}
ModuleTable["MessageLingqu"]["ControllerPath"] = "script/module/message/controller/MessageLingquController"
ModuleTable["MessageLingqu"]["layer"] = "second_layer"
--站内信前往
ModuleTable["MessageGo"] = {}
ModuleTable["MessageGo"]["ControllerPath"] = "script/module/message/controller/MessageGoController"
ModuleTable["MessageGo"]["layer"] = "second_layer"

--用户协议
ModuleTable["UserAgreement"] = {}
ModuleTable["UserAgreement"]["ControllerPath"] = "script/module/login/controller/UserAgreementController"
ModuleTable["UserAgreement"]["layer"] = "second_layer"

--退出/切换账号
ModuleTable["AndroidExit"] = {}
ModuleTable["AndroidExit"]["ControllerPath"] = "script/module/hall/controller/AndroidExitController"
ModuleTable["AndroidExit"]["layer"] = "second_layer"

--设置性别年龄
ModuleTable["SetOldSex"] = {}
ModuleTable["SetOldSex"]["ControllerPath"] = "script/module/userinfo/controller/SetOldSexController"
ModuleTable["SetOldSex"]["layer"] = "third_layer"

--充值本地提示
ModuleTable["RechargePrompt"] = {}
ModuleTable["RechargePrompt"]["ControllerPath"] = "script/module/commondialog/controller/RechargePromptController"
ModuleTable["RechargePrompt"]["layer"] = "third_layer"
--充值引导
ModuleTable["PayGuidePrompt"] = {}
ModuleTable["PayGuidePrompt"]["ControllerPath"] = "script/module/commondialog/controller/PayGuidePromptController"
ModuleTable["PayGuidePrompt"]["layer"] = "third_layer"
--礼包界面
ModuleTable["HallGiftShow"] = {}
ModuleTable["HallGiftShow"]["ControllerPath"] = "script/module/commondialog/controller/HallGiftShowController"
ModuleTable["HallGiftShow"]["layer"] = "second_layer"
--关闭礼包
ModuleTable["HallGiftClose"] = {}
ModuleTable["HallGiftClose"]["ControllerPath"] = "script/module/commondialog/controller/HallGiftCloseController"
ModuleTable["HallGiftClose"]["layer"] = "third_layer"
--脚本更新提示框
ModuleTable["ScriptUpdata"] = {}
ModuleTable["ScriptUpdata"]["ControllerPath"] = "script/module/commondialog/controller/ScriptUpdataController"
ModuleTable["ScriptUpdata"]["layer"] = "third_layer"
--客服中心
ModuleTable["CustomService"] = {}
ModuleTable["CustomService"]["ControllerPath"] = "script/module/customservice/controller/CustomServiceController"
ModuleTable["CustomService"]["layer"] = "third_layer"
--游戏帮助
ModuleTable["GameHelp"] = {}
ModuleTable["GameHelp"]["ControllerPath"] = "script/module/customservice/controller/GameHelpController"
ModuleTable["GameHelp"]["layer"] = "second_layer"

--每日签到
ModuleTable["HallEverydayLoginReward"] = {}
ModuleTable["HallEverydayLoginReward"]["ControllerPath"] = "script/module/hall/controller/HallEverydayLoginRewardController"
ModuleTable["HallEverydayLoginReward"]["layer"] = "second_layer"

--大厅聊天界面
ModuleTable["HallChat"] = {}
ModuleTable["HallChat"]["ControllerPath"] = "script/module/hall/controller/HallChatController"
ModuleTable["HallChat"]["layer"] = "second_layer"

--规则
ModuleTable["Rule"] = {}
ModuleTable["Rule"]["ControllerPath"] = "script/module/hall/controller/RuleController"
ModuleTable["Rule"]["layer"] = "second_layer"

--loading界面
ModuleTable["Loading"] = {}
ModuleTable["Loading"]["ControllerPath"] = "script/module/login/controller/LoadingController"
ModuleTable["Loading"]["layer"] = "base_layer"

--绑定手机界面
ModuleTable["BindPhone"] = {}
ModuleTable["BindPhone"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneController"
ModuleTable["BindPhone"]["layer"] = "third_layer"

ModuleTable["BindPhoneMsg"] = {}
ModuleTable["BindPhoneMsg"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneMsgController"
ModuleTable["BindPhoneMsg"]["layer"] = "third_layer"

ModuleTable["BindPhoneTip"] = {}
ModuleTable["BindPhoneTip"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneTipController"
ModuleTable["BindPhoneTip"]["layer"] = "third_layer"

ModuleTable["BindNotPhoneMsg"] = {}
ModuleTable["BindNotPhoneMsg"]["ControllerPath"] = "script/module/userinfo/controller/BindNotPhoneMsgController"
ModuleTable["BindNotPhoneMsg"]["layer"] = "third_layer"

--合成碎片
ModuleTable["Fragments"] = {}
ModuleTable["Fragments"]["ControllerPath"] = "script/module/pack/controller/FragmentsController"
ModuleTable["Fragments"]["layer"] = "second_layer"

ModuleTable["FragmentsDetail"] = {}
ModuleTable["FragmentsDetail"]["ControllerPath"] = "script/module/pack/controller/FragmentsDetailController"
ModuleTable["FragmentsDetail"]["layer"] = "third_layer"

--兑奖
ModuleTable["Exchange"] = {}
ModuleTable["Exchange"]["ControllerPath"] = "script/module/exchange/controller/ExchangeController"
ModuleTable["Exchange"]["layer"] = "base_layer"

ModuleTable["ExchangeDetail"] = {}
ModuleTable["ExchangeDetail"]["ControllerPath"] = "script/module/exchange/controller/ExchangeDetailController"
ModuleTable["ExchangeDetail"]["layer"] = "second_layer"

ModuleTable["MyPrizeDetail"] = {}
ModuleTable["MyPrizeDetail"]["ControllerPath"] = "script/module/exchange/controller/MyPrizeDetailController"
ModuleTable["MyPrizeDetail"]["layer"] = "second_layer"

ModuleTable["GetAwardInfo"] = {}
ModuleTable["GetAwardInfo"]["ControllerPath"] = "script/module/exchange/controller/GetAwardInfoController"
ModuleTable["GetAwardInfo"]["layer"] = "second_layer"

ModuleTable["ChangeAward"] = {}
ModuleTable["ChangeAward"]["ControllerPath"] = "script/module/exchange/controller/ChangeAwardController"
ModuleTable["ChangeAward"]["layer"] = "second_layer"

ModuleTable["CardDuihuanWays"] = {}
ModuleTable["CardDuihuanWays"]["ControllerPath"] = "script/module/exchange/controller/CardDuihuanWaysController"
ModuleTable["CardDuihuanWays"]["layer"] = "second_layer"

ModuleTable["CardKhAndPass"] = {}
ModuleTable["CardKhAndPass"]["ControllerPath"] = "script/module/exchange/controller/CardKhAndPassController"
ModuleTable["CardKhAndPass"]["layer"] = "second_layer"

ModuleTable["SuipianNotEnough"] = {}
ModuleTable["SuipianNotEnough"]["ControllerPath"] = "script/module/exchange/controller/SuipianNotEnoughController"
ModuleTable["SuipianNotEnough"]["layer"] = "second_layer"


ModuleTable["HuaFeiZhangHu"] = {}
ModuleTable["HuaFeiZhangHu"]["ControllerPath"] = "script/module/exchange/controller/HuaFeiZhangHuController"
ModuleTable["HuaFeiZhangHu"]["layer"] = "third_layer"


ModuleTable["GetCardAwardInfo"] = {}
ModuleTable["GetCardAwardInfo"]["ControllerPath"] = "script/module/exchange/controller/GetCardAwardInfoController"
ModuleTable["GetCardAwardInfo"]["layer"] = "second_layer"

--排行榜
ModuleTable["PaiHangBang"] = {}
ModuleTable["PaiHangBang"]["ControllerPath"] = "script/module/paihangbang/controller/PaiHangBangController"
ModuleTable["PaiHangBang"]["layer"] = "base_layer"

ModuleTable["RechargeRankCover"] = {}
ModuleTable["RechargeRankCover"]["ControllerPath"] = "script/module/paihangbang/controller/RechargeRankCoverController"
ModuleTable["RechargeRankCover"]["layer"] = "third_layer"

--小游戏列表
ModuleTable["MiniGame"] = {}
ModuleTable["MiniGame"]["ControllerPath"] = "script/module/minigame/controller/MiniGameController"
ModuleTable["MiniGame"]["layer"] = "second_layer"

--活动
ModuleTable["HuoDong"] = {}
ModuleTable["HuoDong"]["ControllerPath"] = "script/module/huodong/controller/HuoDongController"
ModuleTable["HuoDong"]["layer"] = "second_layer"

ModuleTable["ChatTanChuang"] = {}
ModuleTable["ChatTanChuang"]["ControllerPath"] = "script/module/chatTanchuang/controller/ChatTanChuangController"
ModuleTable["ChatTanChuang"]["layer"] = "third_layer"

ModuleTable["CaiShen"] = {}
ModuleTable["CaiShen"]["ControllerPath"] = "script/module/caishen/controller/CaiShenController"
ModuleTable["CaiShen"]["layer"] = "second_layer"

ModuleTable["CaiShenOk"] = {}
ModuleTable["CaiShenOk"]["ControllerPath"] = "script/module/caishen/controller/CaiShenOkController"
ModuleTable["CaiShenOk"]["layer"] = "third_layer"

ModuleTable["CaiShenChongZhi"] = {}
ModuleTable["CaiShenChongZhi"]["ControllerPath"] = "script/module/caishen/controller/CaiShenChongZhiController"
ModuleTable["CaiShenChongZhi"]["layer"] = "third_layer"

ModuleTable["CaiShenGuiZe"] = {}
ModuleTable["CaiShenGuiZe"]["ControllerPath"] = "script/module/caishen/controller/CaiShenGuiZeController"
ModuleTable["CaiShenGuiZe"]["layer"] = "third_layer"

---vip
ModuleTable["VIP"] = {}
ModuleTable["VIP"]["ControllerPath"] = "script/module/vip/controller/VIPController"
ModuleTable["VIP"]["layer"] = "base_layer"

ModuleTable["VIPDetail"] = {}
ModuleTable["VIPDetail"]["ControllerPath"] = "script/module/vip/controller/VIPDetailController"
ModuleTable["VIPDetail"]["layer"] = "second_layer"

--比赛相关
ModuleTable["MatchDetail"] = {}
ModuleTable["MatchDetail"]["ControllerPath"] = "script/module/match/controller/MatchDetailController"
ModuleTable["MatchDetail"]["layer"] = "third_layer"

ModuleTable["JsMatchDetail"] = {}
ModuleTable["JsMatchDetail"]["ControllerPath"] = "script/module/match/controller/JsMatchDetailController"
ModuleTable["JsMatchDetail"]["layer"] = "second_layer"

ModuleTable["MatchVipNotEnough"] = {}
ModuleTable["MatchVipNotEnough"]["ControllerPath"] = "script/module/match/controller/MatchVipNotEnoughController"
ModuleTable["MatchVipNotEnough"]["layer"] = "second_layer"
--比赛排名
ModuleTable["MatchRanking"] = {}
ModuleTable["MatchRanking"]["ControllerPath"] = "script/module/tableDialog/controller/MatchRankingController"
ModuleTable["MatchRanking"]["layer"] = "third_layer"

ModuleTable["Setting"] = {}
ModuleTable["Setting"]["ControllerPath"] = "script/module/hall/controller/SettingController"
ModuleTable["Setting"]["layer"] = "second_layer"

--任务
ModuleTable["RenWu"] = {}
ModuleTable["RenWu"]["ControllerPath"] = "script/module/renwu/controller/RenWuController"
ModuleTable["RenWu"]["layer"] = "second_layer"


ModuleTable["RenWuJiangLiInfo"] = {}
ModuleTable["RenWuJiangLiInfo"]["ControllerPath"] = "script/module/renwu/controller/RenWuJiangLiInfoController"
ModuleTable["RenWuJiangLiInfo"]["layer"] = "third_layer"

ModuleTable["RenWuGuiZe"] = {}
ModuleTable["RenWuGuiZe"]["ControllerPath"] = "script/module/renwu/controller/RenWuGuiZeController"
ModuleTable["RenWuGuiZe"]["layer"] = "third_layer"


ModuleTable["RenWuChongZhi"] = {}
ModuleTable["RenWuChongZhi"]["ControllerPath"] = "script/module/renwu/controller/RenWuChongZhiController"
ModuleTable["RenWuChongZhi"]["layer"] = "third_layer"

-----房间上的一些金币不足
ModuleTable["RoomCoinNotFit"] = {}
ModuleTable["RoomCoinNotFit"]["ControllerPath"] = "script/module/hall/controller/RoomCoinNotFitController"
ModuleTable["RoomCoinNotFit"]["layer"] = "second_layer"
--获取金币
ModuleTable["GuideGetCoin"] = {}
ModuleTable["GuideGetCoin"]["ControllerPath"] = "script/module/hall/controller/GuideGetCoinController"
ModuleTable["GuideGetCoin"]["layer"] = "second_layer"
--引导进癞子
ModuleTable["GuideLaizi"] = {}
ModuleTable["GuideLaizi"]["ControllerPath"] = "script/module/hall/controller/GuideLaiziController"
ModuleTable["GuideLaizi"]["layer"] = "second_layer"
--门票不足
ModuleTable["NoTicketGuide"] = {}
ModuleTable["NoTicketGuide"]["ControllerPath"] = "script/module/hall/controller/NoTicketGuideController"
ModuleTable["NoTicketGuide"]["layer"] = "second_layer"
--时间冲突
ModuleTable["TimeNotFit"] = {}
ModuleTable["TimeNotFit"]["ControllerPath"] = "script/module/hall/controller/TimeNotFitController"
ModuleTable["TimeNotFit"]["layer"] = "third_layer"
--破产送金
ModuleTable["SendGold"] = {}
ModuleTable["SendGold"]["ControllerPath"] = "script/module/commondialog/controller/SendGoldController"
ModuleTable["SendGold"]["layer"] = "third_layer"
--房间内兑换金币
ModuleTable["ConvertCoinInRoom"] = {}
ModuleTable["ConvertCoinInRoom"]["ControllerPath"] = "script/module/hall/controller/ConvertCoinInRoomController"
ModuleTable["ConvertCoinInRoom"]["layer"] = "second_layer"

--管理用户删除用户
ModuleTable["DeleteUser"] = {}
ModuleTable["DeleteUser"]["ControllerPath"] = "script/module/login/controller/DeleteUserController"
ModuleTable["DeleteUser"]["layer"] = "third_layer"

--跳过新手引导
ModuleTable["SkipNewUserGuide"] = {}
ModuleTable["SkipNewUserGuide"]["ControllerPath"] = "script/module/NewUserGuide/controller/SkipNewUserGuideController"
ModuleTable["SkipNewUserGuide"]["layer"] = "third_layer"

--新手引导页面
ModuleTable["NewUserGuide"] = {}
ModuleTable["NewUserGuide"]["ControllerPath"] = "script/module/NewUserGuide/controller/NewUserGuideController"
ModuleTable["NewUserGuide"]["layer"] = "second_layer"

--新手引导箭头页面
ModuleTable["NewUserCoverOther"] = {}
ModuleTable["NewUserCoverOther"]["ControllerPath"] = "script/module/NewUserGuide/controller/NewUserCoverOtherController"
ModuleTable["NewUserCoverOther"]["layer"] = "second_layer"

--牌桌聊天界面
ModuleTable["ChatPop"] = {}
ModuleTable["ChatPop"]["ControllerPath"] = "script/module/chatpop/controller/ChatPopController"
ModuleTable["ChatPop"]["layer"] = "second_layer"

--比赛条件报名界面
ModuleTable["TiaoJianBaoMing"] = {}
ModuleTable["TiaoJianBaoMing"]["ControllerPath"] = "script/module/match/controller/TiaoJianBaoMingController"
ModuleTable["TiaoJianBaoMing"]["layer"] = "second_layer"

ModuleTable["TiaoJianBaoMingTanChuang"] = {}
ModuleTable["TiaoJianBaoMingTanChuang"]["ControllerPath"] = "script/module/match/controller/TiaoJianBaoMingTanChuangController"
ModuleTable["TiaoJianBaoMingTanChuang"]["layer"] = "third_layer"

--天梯升级
ModuleTable["TTShengji"] = {}
ModuleTable["TTShengji"]["ControllerPath"] = "script/module/tableDialog/controller/TTShengjiController"
ModuleTable["TTShengji"]["layer"] = "second_layer"

ModuleTable["TTGetTxz"] = {}
ModuleTable["TTGetTxz"]["ControllerPath"] = "script/module/tableDialog/controller/TTGetTxzController"
ModuleTable["TTGetTxz"]["layer"] = "second_layer"

--脚本更新
ModuleTable["LuaUpdate"] = {}
ModuleTable["LuaUpdate"]["ControllerPath"] = "script/module/commondialog/controller/LuaUpdateController"
ModuleTable["LuaUpdate"]["layer"] = "third_layer"

--每日登陆提示
ModuleTable["MeiRiDengLuTiShi"] = {}
ModuleTable["MeiRiDengLuTiShi"]["ControllerPath"] = "script/module/meiridenglutishi/controller/MeiRiDengLuTiShiController"
ModuleTable["MeiRiDengLuTiShi"]["layer"] = "second_layer"
--断网提示
ModuleTable["NetErrExitDialog"] = {}
ModuleTable["NetErrExitDialog"]["ControllerPath"] = "script/module/commondialog/controller/NetErrExitDialogController"
ModuleTable["NetErrExitDialog"]["layer"] = "third_layer"
--系统弹出框
ModuleTable["SystemPromptDialog"] = {}
ModuleTable["SystemPromptDialog"]["ControllerPath"] = "script/module/commondialog/controller/SystemPromptDialogController"
ModuleTable["SystemPromptDialog"]["layer"] = "third_layer"
--宝箱列表
ModuleTable["TreasureChests"] = {}
ModuleTable["TreasureChests"]["ControllerPath"] = "script/module/tableDialog/controller/TreasureChestsController"
ModuleTable["TreasureChests"]["layer"] = "second_layer"
--转盘
ModuleTable["LuckyTurnTable"] = {}
ModuleTable["LuckyTurnTable"]["ControllerPath"] = "script/module/luckyTurnTable/controller/LuckyTurnTableController"
ModuleTable["LuckyTurnTable"]["layer"] = "base_layer"
--25天版月签
ModuleTable["MonthSign"] = {}
ModuleTable["MonthSign"]["ControllerPath"] = "script/module/monthSign/controller/MonthSignController"
ModuleTable["MonthSign"]["layer"] = "second_layer"
--月签展示奖品
ModuleTable["ShowMonthSignPrize"] = {}
ModuleTable["ShowMonthSignPrize"]["ControllerPath"] = "script/module/monthSign/controller/ShowMonthSignPrizeController"
ModuleTable["ShowMonthSignPrize"]["layer"] = "third_layer"
--单按钮透明弹框
ModuleTable["SingleBtnTransparentBox"] = {}
ModuleTable["SingleBtnTransparentBox"]["ControllerPath"] = "script/module/commondialog/controller/SingleBtnTransparentBoxController"
ModuleTable["SingleBtnTransparentBox"]["layer"] = "third_layer"
--纯文本透明弹框
ModuleTable["TextTransparentBox"] = {}
ModuleTable["TextTransparentBox"]["ControllerPath"] = "script/module/commondialog/controller/TextTransparentBoxController"
ModuleTable["TextTransparentBox"]["layer"] = "third_layer"

--闯关
ModuleTable["ChuangGuan"] = {}
ModuleTable["ChuangGuan"]["ControllerPath"] = "script/module/chuangguan/controller/ChuangGuanController"
ModuleTable["ChuangGuan"]["layer"] = "base_layer"

-- 比赛充值等待弹框
ModuleTable["MatchDengdaidaozhang"] = {}
ModuleTable["MatchDengdaidaozhang"]["ControllerPath"] = "script/module/tableDialog/controller/MatchDengdaidaozhangController"
ModuleTable["MatchDengdaidaozhang"]["layer"] = "second_layer"

-- 比赛马上开始弹框
ModuleTable["matchjijiangkaisai"] = {}
ModuleTable["matchjijiangkaisai"]["ControllerPath"] = "script/module/match/controller/matchjijiangkaisaiController"
ModuleTable["matchjijiangkaisai"]["layer"] = "third_layer"

--闯关重置提醒
ModuleTable["CrazyResetAlert"] = {}
ModuleTable["CrazyResetAlert"]["ControllerPath"] = "script/module/chuangguan/controller/CrazyResetAlertController"
ModuleTable["CrazyResetAlert"]["layer"] = "second_layer"

--免费金币
ModuleTable["FreeCoin"] = {}
ModuleTable["FreeCoin"]["ControllerPath"] = "script/module/freeCoin/controller/FreeCoinController"
ModuleTable["FreeCoin"]["layer"] = "second_layer"

--主动分享
ModuleTable["InitiativeShare"] = {}
ModuleTable["InitiativeShare"]["ControllerPath"] = "script/module/commshare/controller/InitiativeShareController"
ModuleTable["InitiativeShare"]["layer"] = "second_layer"

--大厅覆盖
ModuleTable["HallCover"] = {}
ModuleTable["HallCover"]["ControllerPath"] = "script/module/hall/controller/HallCoverController"
ModuleTable["HallCover"]["layer"] = "second_layer"

--充值反馈界面
ModuleTable["RechargeResult"] = {}
ModuleTable["RechargeResult"]["ControllerPath"] = "script/module/commondialog/controller/RechargeResultController"
ModuleTable["RechargeResult"]["layer"] = "third_layer"

--公共分享弹框
ModuleTable["CommShare"] = {}
ModuleTable["CommShare"]["ControllerPath"] = "script/module/commshare/controller/CommShareController"
ModuleTable["CommShare"]["layer"] = "second_layer"

--主动分享豪礼
ModuleTable["InitiativeShareGift"] = {}
ModuleTable["InitiativeShareGift"]["ControllerPath"] = "script/module/commshare/controller/InitiativeShareGiftController"
ModuleTable["InitiativeShareGift"]["layer"] = "third_layer"

--兑换奖励
ModuleTable["Redeem"] = {}
ModuleTable["Redeem"]["ControllerPath"] = "script/module/exchange/controller/RedeemController"
ModuleTable["Redeem"]["layer"] = "second_layer"

--病毒传播红包分享
ModuleTable["RedGiftShare"] = {}
ModuleTable["RedGiftShare"]["ControllerPath"] = "script/module/commshare/controller/RedGiftShareController"
ModuleTable["RedGiftShare"]["layer"] = "second_layer"

--病毒传播红包分享退出确认框
ModuleTable["RedGiftComfirm"] = {}
ModuleTable["RedGiftComfirm"]["ControllerPath"] = "script/module/commshare/controller/RedGiftComfirmController"
ModuleTable["RedGiftComfirm"]["layer"] = "third_layer"

ModuleTable["SelectCarriers"] = {}
ModuleTable["SelectCarriers"]["ControllerPath"] = "script/module/recharge/controller/SelectCarriersController"
ModuleTable["SelectCarriers"]["layer"] = "second_layer"

ModuleTable["InputPrepaidCard"] = {}
ModuleTable["InputPrepaidCard"]["ControllerPath"] = "script/module/recharge/controller/InputPrepaidCardController"
ModuleTable["InputPrepaidCard"]["layer"] = "second_layer"

--天梯帮助
ModuleTable["tiantibangzhu"] = {}
ModuleTable["tiantibangzhu"]["ControllerPath"] = "script/module/userinfo/controller/tiantibangzhuController"
ModuleTable["tiantibangzhu"]["layer"] = "second_layer"

--小游戏引导
ModuleTable["MiNiGameGuideTanChuKuang"] = {}
ModuleTable["MiNiGameGuideTanChuKuang"]["ControllerPath"] = "script/module/minigame/controller/MiNiGameGuideTanChuKuangController"
ModuleTable["MiNiGameGuideTanChuKuang"]["layer"] = "third_layer"