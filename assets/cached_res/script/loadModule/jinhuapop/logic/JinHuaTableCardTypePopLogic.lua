module("JinHuaTableCardTypePopLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Button_close = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Button_close = cocostudio.getUIButton(view, "Button_close");
end

function createView()
	view = cocostudio.createView("load_res/JinHua/JinHuaTableCardTypePop.json");
	view:setTag(getDiffTag());

	GameStartConfig.addChildForScene(view);

	initView();
end

function requestMsg()

end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		mvcEngine.destroyModule(GUI_JINHUA_TABLECARDTYPEPOP)
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
