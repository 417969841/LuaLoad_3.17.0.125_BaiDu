module("NewUserGuideLogic",package.seeall)

view = nil;
path = nil;--
Panel_background = nil;--任意键继续
btn_skip = nil;--跳过
ImageView_Title = nil;--标题

ImageView_one = nil;--新手引导自动注册
ImageView_two = nil;--新手引导打牌
ImageView_three = nil;--新手引导兑奖

ImageView_LineOne = nil;--新手引导横线1
ImageView_LineTwo = nil;--新手引导横线2

ImageView_duiguo1 = nil;--勾的图片
ImageView_duiguo2 = nil;--勾的图片
ImageView_duiguo3 = nil;--勾的图片


ImageView_StepTable = nil;--第2个任务的光圈
ImageView_Exchange3 = nil;--第3个任务的光圈


ImageView_TouchContinue = nil;--触碰任意区域继续

local lightSprite = nil;--大圈图片
local taskState = 0;--任务阶段
local newUserFlag = false;--判断是否在进行新手引导，true是在进行新手引导，false不是

local isCompleteNewUserGuide = false;--如果为false，没有完成新手引导，如果为true，完成新手引导
local isFlagDaliy = false;--是否继续新手任务

local dataFinishState = {};
dataFinishState.oneFinish = 1; --第一个任务完成布局
dataFinishState.twoFinish = 2;--第二个任务完成显示布局
dataFinishState.threeFinish = 3;--第三个任务完成显示界面
dataFinishState.fourFinish = 4;--第三个任务完成显示界面
local numberScheme = nil;--获取新手引导方案
local First_task_one_finish = 0;--第一次任务完成点击触摸继续
local QuickEnterRoom_New_user_back = 0;--进入快速开始消息回调
--新手牌局是否结束
newUserEndBoard = false;
local isNewUserGuideDisplayed = false;--新手引导页面是否正在展示

--[[--
--获取新手引导页面是否正在展示
--@return #boolean 新手引导页面是否正在展示
--]]
function getNewUserGuideDisplayed()
	return isNewUserGuideDisplayed;
end

local newuser_black_count = 0;
--[[-
--新手引导方案
--]]
function getNewUserScheme()
	--新手引导方案，1是做过公共模块新手引导，0是没有做过公共模块新手引导
	numberScheme = profile.NewUserGuide.getCommonNewUserGuideScheme();

end

--[[--
--获取是否完成新手引导，如果为false，没有完成新手引导，如果为true，完成新手引导
--]]
function getIsCompleteNewUserGuide()
	return isCompleteNewUserGuide;
end

--[[--
--设置是否完成新手引导，如果为false，没有完成新手引导，如果为true，完成新手引导
--]]
function setIsCompleteNewUserGuide(Flag)
	isCompleteNewUserGuide = Flag;
	if isCompleteNewUserGuide then
		--完成新手引导
		--新手引导,设置0，重置状态，防止影响其他程序或者是崩潰出現bug
		NewUserGuideLogic.setResetState(0);
		NewUserCoverOtherLogic.setResetArrow(0);
		setDaliyFalg(Flag);
		--月签
		--		HallLogic.sendMonthMessage();
		Common.setDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID(), "1");
	end
end


function setDaliyFalg(flag)
	isFlagDaliy = flag;
end

function getDaliyFalg()
	return isFlagDaliy;
end

--[[--
--设置当前是否完成新手引导
--]]
function setNewUserFlag(flag)
	newUserFlag = flag;
end
--[[--
--获取当前新手引导状态
--]]
function getNewUserFlag()
	return newUserFlag
end

--[[--
--结束时重置状态
--]]
function setResetState(state)
	taskState = state;
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		Common.log("mac"..newuser_black_count)
		if newuser_black_count == 2 then
			newUserClick()
		else
			mvcEngine.createModule(GUI_SKIPNEWUSERGUIDE);
		end
	elseif event == "menuClicked" then
	--菜单键
	end
end

--获取data数据
function getDataFinishState()
	return dataFinishState;
end

--[[--
--显示领取的图片和提示语
--]]
local function AwardToasView()
	--判断领取奖励是否成功，0未成功，1成功
	if(profile.NewUserGuide.getAwardIsResult() == 1)then
		local dataAward = profile.NewUserGuide.getNewUserAward();
		if(dataAward ~= nil)then
			for i=1,#dataAward do
				ImageToast.createView(dataAward[i].PrizeUrl,nil,dataAward[i].PrizeDescription,profile.NewUserGuide.getResultTxt(),2);
				Common.log("新手引导========显示获取到的奖励！");
				if i == 1 then
					if(numberScheme == 0)then
						ImageToast.OverFunction = setShowNewUserInterface;
					end
				end
			end
		end
	end
end

--显示第一个勾
local function OneGou()
	local ac = CCScaleBy:create(0.4,0.086);
	ImageView_duiguo1:runAction(ac);
	ImageView_duiguo1:setVisible(true);
end
--显示第二个勾
local function TwoGou()
	local ac = CCScaleBy:create(0.4,0.086);
	ImageView_duiguo2:runAction(ac);
	ImageView_duiguo2:setVisible(true);
end
--显示第三个勾
local function ThreeGou()
	local ac = CCScaleBy:create(0.4,0.086);
	ImageView_duiguo3:runAction(ac);
	ImageView_duiguo3:setVisible(true);
end

--[[--
--是否显示勾
--]]
local function imageViewGou(state)
	--0.8秒后调用获取到奖励地址的方法
	local delay = CCDelayTime:create(1.2)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(AwardToasView))
	local seq = CCSequence:create(array)
	view:runAction(seq)
	if(numberScheme == 0)then
		if(state == dataFinishState.oneFinish) then
			--第一个任务完成，显示勾
			local title= CCScaleBy:create(0.2,6);
			ImageView_Title:runAction(title);
			ImageView_Title:setVisible(true);
			local arr = CCArray:create()
			arr:addObject(CCDelayTime:create(0.7))
			arr:addObject(CCCallFuncN:create(OneGou))
			local ac = CCSequence:create(arr)
			view:runAction(ac);
		elseif (state == dataFinishState.twoFinish) then
			--第二个任务完成，显示勾及动画
			ImageView_duiguo1:setScale(0.89)
			ImageView_duiguo1:setVisible(true);
			local title= CCScaleBy:create(0.2,6);
			ImageView_Title:runAction(title);
			ImageView_Title:loadTexture(Common.getResourcePath("ui_titile_congratulation.png"));
			ImageView_Title:setVisible(true);
			ImageView_LineOne:setVisible(true);
			local arr = CCArray:create()
			arr:addObject(CCDelayTime:create(0.7))
			arr:addObject(CCCallFuncN:create(TwoGou))
			local ac = CCSequence:create(arr)
			view:runAction(ac);
		elseif (state == dataFinishState.threeFinish) then
			--第三个任务完成，显示勾及动画
			ImageView_duiguo1:setScale(0.89)
			ImageView_duiguo2:setScale(0.89)
			local title= CCScaleBy:create(0.2,5);
			ImageView_Title:runAction(title);
			ImageView_Title:setVisible(true);
			ImageView_Title:loadTexture(Common.getResourcePath("ui_titile_zuizhong.png"));
			ImageView_duiguo1:setVisible(true);
			ImageView_duiguo2:setVisible(true);
			ImageView_LineOne:setVisible(true);
			ImageView_LineTwo:setVisible(true);
			local arr = CCArray:create()
			arr:addObject(CCDelayTime:create(0.7))
			arr:addObject(CCCallFuncN:create(ThreeGou))
			local ac = CCSequence:create(arr)
			view:runAction(ac);
		elseif (state == dataFinishState.fourFinish) then
			--第四个任务完成，显示勾及动画
			local title= CCScaleBy:create(0.2,6)
			ImageView_Title:runAction(title);
			ImageView_Title:setVisible(true);
			ImageView_Title:loadTexture(Common.getResourcePath("ui_title_yilinghf.png"));
			ImageView_duiguo1:setVisible(true);
			ImageView_duiguo2:setVisible(true);
			ImageView_duiguo3:setVisible(true);
			ImageView_duiguo1:setScale(0.89);
			ImageView_duiguo2:setScale(0.89);
			ImageView_duiguo3:setScale(0.89)
			ImageView_LineOne:setVisible(true);
			ImageView_LineTwo:setVisible(true);
			--取消左上角的跳过
			btn_skip:setVisible(false);
		end
	elseif(numberScheme == 1)then
		Common.log("新手引导第二个任务ui_title:"..state);
		if(state == dataFinishState.oneFinish) then
			--第一个任务完成
			local title= CCScaleBy:create(0.2,6);
			ImageView_Title:loadTexture(Common.getResourcePath("ui_title_xinshouyindao.png"));
			ImageView_Title:setVisible(true);
			ImageView_Title:runAction(title);
		elseif (state == dataFinishState.fourFinish) then
			--第二个任务完成
			local title= CCScaleBy:create(0.2,6);
			ImageView_Title:loadTexture(Common.getResourcePath("ui_title_yiling2.png"));
			ImageView_Title:setVisible(true);
			ImageView_Title:runAction(title);
			Common.log("新手引导第二个任务ui_title_yiling2");
		end
	else
		Common.log("新手引导numberScheme消息错误！");
	end
end
--显示第二个光圈
local function TwoGuangQuan()
	local action = CCFadeIn:create(0.5);
	ImageView_StepTable:setVisible(true);
	ImageView_StepTable:runAction(action);
end
--显示第三个光圈
local function ThreeGuangQuan()
	local action = CCFadeIn:create(0.5);
	ImageView_Exchange3:setVisible(true);
	ImageView_Exchange3:runAction(action);
end

--[[--
--显示当前第几个任务,并设置是否显示横线
--@param #number count 已完成的任务编号
--]]
function setShowNewUserInterface()
	local count = taskState;

	if ImageView_LineOne == nil then
		return
	end

	if (dataFinishState.oneFinish == count) then
		--如果第一个任务完成，则显示第一个完成的界面动画
		ImageView_LineOne:setVisible(true);
		ImageView_LineOne:setPosition(ccp(300,101));
		local onearray = CCArray:create();
		--onearray:addObject(CCMoveBy:create(0.15,ccp(0,0)));
		onearray:addObject(CCMoveBy:create(0.15,ccp(101,0)));
		onearray:addObject(CCDelayTime:create(0.2))
		onearray:addObject(CCCallFuncN:create(TwoGuangQuan))
		ImageView_LineOne:runAction(CCSequence:create(onearray));
	elseif (dataFinishState.twoFinish == count) then
		--如果第二个任务完成，则显示第二个完成的界面动画
		ImageView_LineOne:setVisible(true);
		ImageView_LineTwo:setVisible(true);
		ImageView_LineTwo:setPosition(ccp(510,101));
		local twoarray = CCArray:create();
		twoarray:addObject(CCMoveBy:create(0.15,ccp(0,0)));
		twoarray:addObject(CCMoveBy:create(0.15,ccp(105,0)));
		twoarray:addObject(CCDelayTime:create(0.2))
		twoarray:addObject(CCCallFuncN:create(ThreeGuangQuan))
		ImageView_LineTwo:runAction(CCSequence:create(twoarray));
	elseif (dataFinishState.threeFinish == count) then


	elseif (dataFinishState.fourFinish == count) then
		--第四个任务动画
		ImageView_LineOne:setVisible(true);
		ImageView_LineTwo:setVisible(true);

	end
end
--[[--
@param #number state 当前的任务完成状态编号
--]]
function setTaskFinishState(state)
	Common.log("setTaskFinishState state is " .. state)
	taskState = state;
	imageViewGou(state);
end

--[[--
--获取当前的完成状态编号
--]]
function getTaskFinishState()
	return taskState;
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_background = cocostudio.getUIPanel(view, "Panel_background");
	btn_skip = cocostudio.getUIButton(view, "btn_skip");
	ImageView_Title = cocostudio.getUIImageView(view, "ImageView_Title");
	ImageView_Title:setScale(0.22);
	ImageView_Title:setVisible(false);
	path = cocostudio.getUIPanel(view, "path");
	ImageView_LineTwo = cocostudio.getUIImageView(view, "ImageView_LineTwo");
	ImageView_LineOne = cocostudio.getUIImageView(view, "ImageView_LineOne");
	ImageView_LineOne:setVisible(false);
	ImageView_LineTwo:setVisible(false);
	ImageView_duiguo1 = cocostudio.getUIImageView(view, "ImageView_duiguo1");
	ImageView_duiguo1:setScale(10);
	ImageView_duiguo2 = cocostudio.getUIImageView(view, "ImageView_duiguo2");
	ImageView_duiguo2:setScale(10);
	ImageView_duiguo3 = cocostudio.getUIImageView(view, "ImageView_duiguo3");
	ImageView_duiguo3:setScale(10);
	ImageView_Exchange3 = cocostudio.getUIImageView(view, "ImageView_Exchange3");
	ImageView_StepTable = cocostudio.getUIImageView(view, "ImageView_StepTable");
	ImageView_TouchContinue = cocostudio.getUIImageView(view, "ImageView_TouchContinue");
	ImageView_one = cocostudio.getUIImageView(view, "ImageView_one");
	ImageView_two = cocostudio.getUIImageView(view, "ImageView_two");
	ImageView_three = cocostudio.getUIImageView(view, "ImageView_three");
	LordGamePub.breathEffect(ImageView_TouchContinue);
	if(numberScheme == 1)then
		--如果做过公共模块新手引导，则把勾，横线，光圈等隐藏
		path:setVisible(false);
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("NewUserGuide.json")
	local gui = GUI_NEWUSERGUIDE
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
	isNewUserGuideDisplayed = true;
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	getNewUserScheme();
	initView();
	--关闭Loading
	Common.closeProgressDialog()
end

function requestMsg()

end

--[[--
--新手用户新手引导点击事件
--]]
function newUserClick()
	--检测是否为第三次点击的参数
	newuser_black_count = newuser_black_count + 1
	if(taskState == dataFinishState.oneFinish) then
		--第一个任务完成，跳转到打牌
		if GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
			Common.showProgressDialog("正在进入牌桌,请稍后...");
			sendQuickEnterRoom(1);
			if QuickEnterRoom_New_user_back == 1 and First_task_one_finish == 1 then
				mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
			end
		else
			mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		end

	elseif (taskState == dataFinishState.twoFinish) then
		--第二个任务完成
		mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		sendCOMMONS_SYN_NEWUSERGUIDE_STATE();
		mvcEngine.createModule(GUI_HALL);
		Common.log("第二个新手任务完成========");
	elseif (taskState == dataFinishState.threeFinish) then
		--第三个任务完成
		mvcEngine.destoryModule(GUI_NEWUSERCOVEROTHER)
		mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		sendCOMMONS_SYN_NEWUSERGUIDE_STATE();
		--NewUserCoverOtherLogic.setTableShowInterface(NewUserCoverOtherLogic.getDataTable().TASK_FOUR_EXCHANGE_MYPRIZE);
		Common.log("第三个新手任务完成========");
		mvcEngine.destroyModule(GUI_EXCHANGE);
		mvcEngine.createModule(GUI_HALL);
	--抬起
		GameConfig.setTheLastBaseLayer(GUI_HALL)
	--LordGamePub.showBaseLayerAction(view);
	--Common.log("第三个新手任务完成========");
	--setResetState(4)
	elseif (taskState == dataFinishState.fourFinish) then
		--第四个任务完成
		MessagesPreReadManage.clearData();--这里为了解决进行第三方消息注册，回的是登录消息的问题
		mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		sendCOMMONS_SYN_NEWUSERGUIDE_STATE();
		--		mvcEngine.createModule(GUI_HALL);
		--		mvcEngine.createModule(GUI_NEWUSERCOVEROTHER);
		NewUserCoverOtherLogic.setTableShowInterface(NewUserCoverOtherLogic.getDataTable().TASK_FIVE_TELEPHONE_HALL);
		--mvcEngine.destroyModule(GUI_EXCHANGE);
		--LordGamePub.showBaseLayerAction(view);
		-- -1   服务器自动选择 0普通 1欢乐 2癞子
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);

--		mvcEngine.createModule(GUI_HALL);
		Common.showProgressDialog("进入房间中,请稍后...");
		sendQuickEnterRoom(-1);
		Common.log("第四个新手任务完成========");
	end
end

--[[--
--老用户新手引导点击事件
--]]
function theOldUserClick()
	if(taskState == dataFinishState.oneFinish) then
		--第一个任务完成，跳转到打牌
		if 	GameConfig.getTheCurrentBaseLayer() ~= GUI_TABLE then
			Common.showProgressDialog("正在进入牌桌,请稍后...");
			sendQuickEnterRoom(1);
			mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
		end
	elseif (taskState == dataFinishState.fourFinish) then
		--第二个任务完成
		NewUserGuideLogic.setNewUserFlag(false);--设置完成新手引导
		NewUserGuideLogic.setIsCompleteNewUserGuide(true);
		mvcEngine.destroyModule(GUI_NEWUSERGUIDE);
	end
end
function callback_Panel_background(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if(numberScheme == 0)then
			--开关
			First_task_one_finish = 1
			--新用户
			newUserClick();
		elseif(numberScheme == 1)then
			--老用户
			theOldUserClick();
		else
			Common.log("新手引导方案numberScheme参数不对，请查询！");
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_skip(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.log("======点击跳过新手引导=======");
		mvcEngine.createModule(GUI_SKIPNEWUSERGUIDE);
	elseif component == CANCEL_UP then
	--取消

	end
end
--开关控制
function QuickEnterRoom_New_user_back_function()
	QuickEnterRoom_New_user_back = 1
	if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		Common.log("QuickEnterRoom_New_user_back_function")
		newUserClick()
	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	ImageToast.OverFunction = nil
	isNewUserGuideDisplayed = false;
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(ROOMID_QUICK_START, QuickEnterRoom_New_user_back_function)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(ROOMID_QUICK_START, QuickEnterRoom_New_user_back_function)
end
