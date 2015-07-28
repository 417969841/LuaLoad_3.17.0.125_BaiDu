module("CommSqliteConfig", package.seeall)

--绑定手机弹出提示框弹出时间
BindPhonePoptipTime = "BindPhonePoptipTime"
--礼包类型ID
GiftBagType = "giftBagType_"
--在充值中心显示首充礼包
RechargeCenterShowFirstGiftTime = "RechargeCenterShowFirstGiftTime_"

--寄奖品的用户名、地址、手机号
SendAwardUsername = "SendAwardUsername_"
SendAwardPhone = "SendAwardPhone_"
SendAwardAddress = "SendAwardAddress_"
SendAwardEmail = "SendAwardEmail_"

--本地存储的充值卡卡号 密码
GetCardKhInGameName = "GetCardKhInGameName_"
GetCardKh = "GetCardKh_"
GetCardPass = "GetCardPass_"

--记录每个登录用户的昵称和密码
UserNicknameAndPassword = "UserNicknameAndPassword_"

--音乐默认适时开启  1开启, 0关闭
GameMusicOffData = "GameMusicOffData"

--音效默认是开启   1开启, 0关闭
GameSoundOffData = "GameSoundOffData"

--自动提示是开启   1开启, 0关闭
GameAutomationData = "GameAutomationData"

--游戏震动是否开启   1开启, 0关闭
GameVibrateData = "GameVibrateData"

--新手引导是否完成
IsUserGuidComeplete_ = "IsUserGuidComeplete_"

--房间引导是否兑换金币今日不再提示
ConvertCoinInRoomGuide = "ConvertCoinInRoomGuide_"

--个人头像下载下来之后在本地的位置
SelfAvatorInSD = "SelfAvatorInSD_"

--显示礼包关闭提示时间戳
ShowGiftCloseTimeStamp = "ShowGiftCloseTimeStamp"

--ios海马平台非强制更新的时间戳
LogicVersionIOSHaiMaTimeStamp = "LogicVersionIOSHaiMaTimeStamp_"

--新手引导是否结束 1结束, 0未结束
NewUserGuideIsEnd = "NewUserGuide_"

--新手任务是否结束 1结束, 0未结束
NewUserTaskIsEnd = "NewUserTask_"

--发送公共消息时间戳
SendCommonMsgTimeStamp = "SendCommonMsgTimeStamp_"

--最近一次支付所用方式 alipay：支付宝 union：银联 weixin:微信
RECENT_RECHARGE_MEHTOD = "recent_recharge_method_type_data_";
