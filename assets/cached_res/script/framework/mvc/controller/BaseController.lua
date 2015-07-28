
BaseController = class("BaseController",ControllerInterface)
BaseController.__index = BaseController

function BaseController:init()
	self.reset()
    self.createView()
	self.addSlot()
	self.addCallback()
	self.requestMsg()
end

function BaseController:destroy()
	self.removeCallBack()
	self.removeSlot()
end
