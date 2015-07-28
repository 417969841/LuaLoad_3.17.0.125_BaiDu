module("JinHuaUserInfoLogic",package.seeall)

view = nil;

Panel_Info = nil;--
img_useravator = nil;--
Label_Signature = nil;--
Label_NickName = nil;--
Label_Chip = nil;--
Label_yuanbao = nil;--
Label_Coin = nil;--
Label_DuijiangQuan = nil;--
Label_Wins = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_JINHUAUSERINFO;
	view = cocostudio.createView("load_res/JinHua/JinHuaUserInfo.json");
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_Info = cocostudio.getUIPanel(view, "Panel_Info");
	img_useravator = cocostudio.getUIImageView(view, "img_useravator");
	Label_Signature = cocostudio.getUILabel(view, "Label_Signature");
	Label_NickName = cocostudio.getUILabel(view, "Label_NickName");
	Label_Chip = cocostudio.getUILabel(view, "Label_Chip");
	Label_yuanbao = cocostudio.getUILabel(view, "Label_yuanbao");
	Label_Coin = cocostudio.getUILabel(view, "Label_Coin");
	Label_DuijiangQuan = cocostudio.getUILabel(view, "Label_DuijiangQuan");
	Label_Wins = cocostudio.getUILabel(view, "Label_Wins");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();
end

function requestMsg()

end

function callback_Panel_Info(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_JINHUAUSERINFO);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and img_useravator ~= nil) then
		img_useravator:loadTexture(photoPath)
	end
end

--[[--
--设置自己的个人信息
--]]
function setSelfUserInfo()
	local photoUrl = profile.User.getSelfPhotoUrl()
	if photoUrl ~= nil or photoUrl ~= "" then
		Common.getPicFile(photoUrl, 0, true, updataUserPhoto)
	end
	Label_Signature:setText(""..profile.User.getSelfsign())--签名
	Label_NickName:setText(profile.User.getSelfNickName());
	Label_Chip:setText(""..profile.User.getSelfdjqPieces())--碎片
	Label_yuanbao:setText(""..profile.User.getSelfYuanBao())--元宝
	Label_Coin:setText(""..profile.User.getSelfCoin())--筹码
	Label_DuijiangQuan:setText(""..profile.User.getDuiJiangQuan())--兑奖券
	local wingamenum = profile.User.getSelfWinGameNum()
	local losegamenum = profile.User.getSelfLoseGameNum()
	local shenglv = 0
	if(wingamenum+losegamenum == 0) then
	else
		shenglv = math.floor(wingamenum*100/(wingamenum+losegamenum))
	end
	local userzhanjiValue = wingamenum.."胜"..losegamenum.."负".."/"..(shenglv).."%"
	Label_Wins:setText("战绩/胜率：" .. userzhanjiValue);
end

--[[--
--设置他人的个人信息
--@param #number userID 用户ID
--]]
function setOtherUserInfo(userID)
	sendMANAGERID_JINHUA_USERINFO(userID);
	Common.showProgressDialog("请稍后...");
end

--[[--
--显示其他人的信息
--]]
function showOtherUserInfo()
	Common.closeProgressDialog();
	local OtherInfo = profile.User.getOtherUserInfo()
	if OtherInfo.photoUrl ~= nil or OtherInfo.photoUrl ~= "" then
		Common.getPicFile(OtherInfo.photoUrl, 0, true, updataUserPhoto)
	end
	Label_Signature:setText(""..OtherInfo.sign)--签名
	Label_NickName:setText(OtherInfo.NickName);
	Label_Chip:setText(""..OtherInfo.djqPieces)--碎片
	Label_yuanbao:setText(""..OtherInfo.yuanBao)--元宝
	Label_Coin:setText(""..OtherInfo.Coin)--筹码
	Label_DuijiangQuan:setText(""..OtherInfo.DuiJiangQuan)--兑奖券
	local wingamenum = profile.User.getOtherWinGameNum()
	local losegamenum = profile.User.getOtherLoseGameNum()
	local shenglv = 0
	if(wingamenum+losegamenum == 0) then
	else
		shenglv = math.floor(wingamenum*100/(wingamenum+losegamenum))
	end
	local userzhanjiValue = wingamenum.."胜"..losegamenum.."负".."/"..(shenglv).."%"
	Label_Wins:setText("战绩/胜率：" .. userzhanjiValue);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(MANAGERID_JINHUA_USERINFO, showOtherUserInfo)
end

function removeSlot()
	framework.removeSlotFromSignal(MANAGERID_JINHUA_USERINFO, showOtherUserInfo)
end
