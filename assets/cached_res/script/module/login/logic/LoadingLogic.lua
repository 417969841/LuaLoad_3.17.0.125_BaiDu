module("LoadingLogic",package.seeall)

view = nil
local run_logic = nil
local sceneGame = nil

--控件
local parentLayer = nil
local panel = nil

--图片
local logoimage = nil
local iconGameimage = nil
--字体
local lab_version = nil
local lab_copyright = nil
local lab_banquan = nil

--数据
local imei = nil
local usernamevalue = nil
local passwordvalue = nil
local UserID = nil
local cellSize = 0
local size = nil

local TimeIndex = 0;--建立连接的时间帧

local LoadingAminEnd = false;--loading动画是否结束

function onKeypad(event)
  if event == "backClicked" then
    Common.AndroidExitSendOnlineTime()
  elseif event == "menuClicked" then
  end
end

--[[--
--开始登陆游戏
--]]
local function startLoginGame()
  if GameConfig.isConnect then
    --已经建立链接
    Common.log("已经建立链接");

    TimeIndex = 0;

    --请求病毒传播红包分享基本信息(为了不影响新手引导弹出，消息提前发)
    sendOPERID_SHARING_V3_BASE_INFO()
	sendCOMMONS_GET_NEWUSERGUIDE_IS_OPEN()
    local logininfo = Common.LoadShareUserTable("lastLoginUserInfo");
    if logininfo ~= nil and logininfo["UserID"] ~= nil and logininfo["nickname"] ~= nil and logininfo["password"] ~= nil then
      UserID = logininfo["UserID"];
      usernamevalue = logininfo["nickname"];
      passwordvalue = logininfo["password"];
      sendBASEID_LOGIN(usernamevalue, passwordvalue, imei);
    else
      --sendBASEID_GET_IMEIUSERS(imei);--老逻辑：判断是否是新设备
      --如果本地没有用户名密码则直接发送注册
      sendBASEID_REGISTER(imei)--注册
    end

    if not LoadingAminEnd then
      --loading动画没有结束,暂停接收消息
      PauseSocket("Loading");
    end
  else
    Common.log("没有建立链接"..TimeIndex);

    TimeIndex = TimeIndex + 1
    --没有建立链接
    if TimeIndex >= 10 then
      --5秒以后重连
      TimeIndex = 0;
      Services:getMessageService():closeSocket();
      Services:getMessageService():reConnect();
    end

    local delay = CCDelayTime:create(0.5);
    local array = CCArray:create();
    array:addObject(delay);
    array:addObject(CCCallFuncN:create(startLoginGame));
    local seq = CCSequence:create(array);
    view:runAction(seq);
  end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
  if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
    --如果手机当前的分比率小于1.6且大于1.4,使用960x640的UI工程
    view = cocostudio.createView("Loading_960_640.json");
    --设置当前屏幕的分辨率
    GameConfig.setCurrentScreenResolution(view, GUI_LOADING, 960, 640, kResolutionExactFit);
  elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
    --如果手机当前的分比率小于等于1.4,使用2048x1536的UI工程(本期Pad版留黑边)
    view = cocostudio.createView("Loading.json");
    --设置当前屏幕的分辨率
    GameConfig.setCurrentScreenResolution(view, GUI_LOADING, 1136, 640, kResolutionShowAll);
  elseif GameConfig.RealProportion >= GameConfig.SCREEN_PROPORTION_GREAT then
    --如果手机当前的分比率大于等于1.6,使用1136x640的UI工程
    view = cocostudio.createView("Loading.json");
    --设置当前屏幕的分辨率
    GameConfig.setCurrentScreenResolution(view, GUI_LOADING, 1136, 640, kResolutionExactFit);
  end
end

function createView()
  --初始化当前界面
  initLayer();
  view:setTag(getDiffTag())
  GameConfig.setTheCurrentBaseLayer(GUI_LOADING)

  GameStartConfig.addChildForScene(view)

  panel = cocostudio.getUIPanel(view, "panel")
  --进入游戏的时间
  GameConfig.enterGameTime = os.time();

  --全局变量
  size = CCDirector:sharedDirector():getWinSize()

  --iemi
  imei = Common.getDeviceInfo()
  Common.log("getDeviceInfo" .. imei)

  parentLayer = CCLayer:create()
  sceneGame = view

  if Common.platform == Common.TargetIos then
    --显示icon翻转
    changeView()
  else
    sceneGame:addChild(createLogoLayer())

    --logo渐渐消失
    local secondAction = CCSequence:createWithTwoActions(CCFadeOut:create(1),CCCallFuncN:create(changeView))
    local action = CCSequence:createWithTwoActions(CCDelayTime:create(1),secondAction)
    logoimage:runAction(action)
  end

  GameStartConfig.GameInit();

  startLoginGame();
end



function createLogoLayer()
  logoimage  = CCSprite:create(Common.getResourcePath("splash_icon.png"))
  logoimage:setPosition(GameConfig.ScreenWidth/2, GameConfig.ScreenHeight /2)
  parentLayer:addChild(logoimage)
  return parentLayer
end

function createIconLayer()
  local iconLayer  = CCLayer:create()
  --版本号
  local versioncode = Common.getVersionName().."."..Common.getChannelID()

  iconGameimage = CCSprite:create(Common.getResourcePath("logo.png"))
  iconGameimage:setPosition(GameConfig.ScreenWidth/2, 5/8*GameConfig.ScreenHeight)
  iconLayer:addChild(iconGameimage)

  --版本信息、版权
  lab_version = CCLabelTTF:create("lab_version", "Arial", 25)
  lab_version:setPosition(GameConfig.ScreenWidth/2,6/16*GameConfig.ScreenHeight)
  lab_version:setString("Version "..versioncode)
  lab_version:setColor(ccc3(0,0,0))
  iconLayer:addChild(lab_version)

  lab_copyright = CCLabelTTF:create("lab_copyright", "Arial", 25)
  lab_copyright:setPosition(GameConfig.ScreenWidth/2,5/16*GameConfig.ScreenHeight)
  lab_copyright:setString("Copyright © 北京同趣同趣科技有限公司")
  lab_copyright:setColor(ccc3(0,0,0))
  iconLayer:addChild(lab_copyright)

  lab_banquan = CCLabelTTF:create("lab_banquan", "Arial", 25)
  lab_banquan:setPosition(GameConfig.ScreenWidth/2,4/16*GameConfig.ScreenHeight)
  lab_banquan:setString("版权所有 2015")
  lab_banquan:setColor(ccc3(0,0,0))
  iconLayer:addChild(lab_banquan)

  return iconLayer
end

function changeView()
  --显示icon翻转
  parentLayer:removeChild(logoimage,true)
  sceneGame:addChild(createIconLayer())

  --扎金花icon
  showTqIcon();
--open(iconGameimage, showTqIcon)
end

function showTqIcon()
  --同趣游戏icon
  iconGameimage:setVisible(true)
  local secondAction = CCCallFuncN:create(autologin);
  local action = CCSequence:createWithTwoActions(CCDelayTime:create(1),secondAction);
  iconGameimage:runAction(action)

end

--翻开动画
function open(Sprite,func)
  local array = CCArray:create()
  array:addObject(CCDelayTime:create(1))
  array:addObject(CCScaleTo:create(0.3,0,Sprite:getScaleY()))
  array:addObject(CCCallFuncN:create(func))
  array:addObject(CCScaleTo:create(0.3,Sprite:getScaleX(),Sprite:getScaleY()))
  Sprite:runAction(CCSequence:create(array))
end

function requestMsg()

end

--[[--
--动画结束自动登录
--]]
function autologin()
  --lab_version:setVisible(false);
  --lab_copyright:setVisible(false);
  --lab_banquan:setVisible(false);
  -- 自动登录
  LoadingAminEnd = true;
  ResumeSocket("Loading");
end

--[[--
--保存用户数据
]]
local function saveUserData()
  local userinfo = {}
  local UserID = profile.User.getSelfUserID()
  local username = profile.User.getSelfNickName()
  local password = profile.User.getSelfPassword()
  userinfo["UserID"] = UserID
  userinfo["nickname"] = username
  userinfo["password"] = password
  Common.SaveShareUserTable("lastLoginUserInfo", userinfo)
  --斗地主记录所有登陆昵称和密码
  Common.setDataForSqlite(CommSqliteConfig.UserNicknameAndPassword..username,password)
end

--[[--
--登录消息应答
--]]
function slot_Login()
  local result = profile.UserLoginReg.getResult()
  local resultText = profile.UserLoginReg.getResultText()
  if LoadingAminEnd then
    if (result == 0) then
      local BaseInfo = {}
      BaseInfo = profile.UserLoginReg.getBaseInfo()
      profile.User.setSelfUserID(BaseInfo["UserID"])
      profile.User.setSelfNickName(BaseInfo["NickName"])
      profile.User.setSelfPassword(passwordvalue)
      saveUserData()
      CommUploadConfig.sendException()
      --发送预读消息
      MessagesPreReadManage.sendPreReadingMessages();
      mvcEngine.createModule(GUI_HALL)
    else
      mvcEngine.createModule(GUI_LOGIN)
    end
  end
end

--[[--
--注册消息应答
--]]
function slot_Reg()
  local result = profile.UserLoginReg.getResult()
  local resultText = profile.UserLoginReg.getResultText()
  if LoadingAminEnd then
    if (result == 0) then
      local BaseInfo = {}
      BaseInfo = profile.UserLoginReg.getBaseInfo()
      profile.User.setSelfUserID(BaseInfo["UserID"])
      profile.User.setSelfNickName(BaseInfo["NickName"])
      profile.User.setSelfPassword(BaseInfo["Password"])
      saveUserData()
      GameConfig.isRegister = true
      GameConfig.isFirstEnterGame = true
      --发送预读消息
      MessagesPreReadManage.sendPreReadingMessages();
      mvcEngine.createModule(GUI_HALL)
    else
      mvcEngine.createModule(GUI_LOGIN)
    end
  end
end

--[[--
--获取设备IMEI信息下用户数
--]]
function slot_MoreUser()
  cellSize = profile.MoreUser.getCnt()--总数
  if cellSize == 0 then
    Common.log("新设备")
    sendBASEID_REGISTER(imei)--注册
  else
    Common.log("老设备")
    mvcEngine.createModule(GUI_LOGIN)
  end
end

function addSlot()
  framework.addSlot2Signal(BASEID_LOGIN, slot_Login)
  framework.addSlot2Signal(BASEID_REGISTER, slot_Reg)
  --framework.addSlot2Signal(BASEID_GET_IMEIUSERS, slot_MoreUser)
end

function removeSlot()
  framework.removeSlotFromSignal(BASEID_LOGIN, slot_Login)
  framework.removeSlotFromSignal(BASEID_REGISTER, slot_Reg)
  --framework.removeSlotFromSignal(BASEID_GET_IMEIUSERS, slot_MoreUser)
end
