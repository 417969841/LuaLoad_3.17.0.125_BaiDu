module("RedGiftComfirmLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
lab_msg = nil;--
btn_close = nil;--
btn_share = nil;--

--自定义变量
local lableMsg = nil --提示文本


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	 mvcEngine.destroyModule(GUI_RED_GIFT_SHARE_CONFIRM)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");
	lab_msg = cocostudio.getUILabel(view, "lab_msg");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	btn_share = cocostudio.getUIButton(view, "btn_share");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
  view = cocostudio.createView("RedGiftComfirm.json")
  local gui = GUI_RED_GIFT_SHARE_CONFIRM
  if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
    --设置当前屏幕的分辨率
    GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
  else
    --设置当前屏幕的分辨率
    GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
  end
end

function createView()
	--初始化当前界面
  initLayer();
  view:setTag(getDiffTag())
  GameConfig.setTheCurrentBaseLayer(GUI_RED_GIFT_SHARE_CONFIRM)
  CCDirector:sharedDirector():getRunningScene():addChild(view)
	initView();
	initData();
end

function initData()
  if lableMsg ~= nil then
    lab_msg:setText(lableMsg)
  end
end

function setConfirmLableText(msg)
  lableMsg = msg
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
    mvcEngine.destroyModule(GUI_RED_GIFT_SHARE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_share(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
    RedGiftShareLogic.clickShare()
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
