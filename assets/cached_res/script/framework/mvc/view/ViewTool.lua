module("cocostudio",package.seeall)

function createView(name)
	name = Common.getPackageResourcePath()..name
    local ui = UILayer:create()
    --ui:addWidget(UIHelper:instance():createWidgetFromJsonFile(name));

    ui:addWidget(GUIReader:shareReader():widgetFromJsonFile(name));
    return ui
end

function getComponent(ui, name)
	return ui:getWidgetByName(name)
end

local function getGUI(ui,type,name)
	return tolua.cast(ui:getWidgetByName(name),type)
end

function getUIButton(ui, name)
	return getGUI(ui,"UIButton",name)
end

function getUICheckBox(ui, name)
	return getGUI(ui,"UICheckBox",name)
end

function getUIDragPanel(ui, name)
	return getGUI(ui,"UIDragPanel",name)
end

function getUIImageView(ui, name)
	return getGUI(ui,"UIImageView",name)
end

function getUILabel(ui, name)
	return getGUI(ui,"UILabel",name)
end

function getUIListView(ui, name)
	return getGUI(ui,"UIListView",name)
end

function getUILoadingBar(ui, name)
	return getGUI(ui,"UILoadingBar",name)
end

function getUINodeContainer(ui, name)
	return getGUI(ui,"UINodeContainer",name)
end

function getUIPageView(ui, name)
	return getGUI(ui,"UIPageView",name)
end

function getUIPanel(ui, name)
	return getGUI(ui,"UILayout",name)
end

function getUIScrollView(ui, name)
	return getGUI(ui,"UIScrollView",name)
end

function getUISlider(ui, name)
	return getGUI(ui,"UISlider",name)
end

function getUITextButton(ui, name)
	return getGUI(ui,"UITextButton",name)--UITextButton
end

function getUITextField(ui, name)
	return getGUI(ui,"UITextField",name)
end

function getUILabelAtlas(ui, name)
	return getGUI(ui,"UILabelAtlas",name)
end