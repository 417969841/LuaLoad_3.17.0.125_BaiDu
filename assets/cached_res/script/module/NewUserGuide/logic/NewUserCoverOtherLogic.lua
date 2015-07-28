module("NewUserCoverOtherLogic",package.seeall)

view = nil;
local isNewUserCoverDisplayed = false;--新手引导页面是否正在展示
Panel_bgPrompt = nil;--背景
ImageView_value = nil;--标题
ImageView_arrowhead = nil;--箭头
Label_prompt = nil;--提示语
Panel_Button = nil;--按钮
local state = 0;--任务状态

function onKeypad(event)
	if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		if event == "backClicked" then
			--返回键
			--LordGamePub.showBaseLayerAction(view);
			mvcEngine.createModule(GUI_SKIPNEWUSERGUIDE);
		elseif event == "menuClicked" then
		--菜单键
		end
	end
end

--[[--
--结束重置当前状态
--@param #number num 传递参数
--]]

function setResetArrow(num)
	state = num;
end

local dataTable = {}
--第二个任务，牌桌页面
dataTable.TASK_TWO_TABLE_1_START = 201;--打牌页面
dataTable.TASK_TWO_TABLE_2_BAOXIANG = 202;--宝箱页面
--新手任务大厅引导
dataTable.TASK_THREE_HALL_1_MORE = 3001;--大厅页面下方更多按钮
dataTable.TASK_THREE_HALL_2_EXCHANGE = 3002;--大厅页面更多中的兑奖按钮
dataTable.TASK_THREE_HALL_3_ONETELEPHONECOST = 3003;--点击兑奖过后页面中的领取一元话费
dataTable.TASK_THREE_HALL_4_EXCHANGE = 3004;--点击领取一元话费后的兑换
dataTable.TASK_THREE_HALL_5_SYNTHESIS_EXCHANGE = 3005;--点击后选择合成并兑换
dataTable.TASK_THREE_HALL_6_SURE = 3006;--点击合成并兑换后确定
--我的奖品
dataTable.TASK_FOUR_EXCHANGE_MYPRIZE = 401;--我的奖品
dataTable.TASK_FOUR_EXCHANGE_BILL_ACCOUNT = 402;--点击一元话费
dataTable.TASK_FOUR_TELEPHONE_CLOSE = 403;--点击关闭一元话费
dataTable.TASK_FIVE_TELEPHONE_HALL = 503;--点击任意继续

--[[--
--获取dataTable里面的数据
--]]
function getDataTable()
	return dataTable;
end

--[[--
--获取新手引导页面是否正在展示
--@return #boolean 新手引导页面是否正在展示
--]]
function getNewUserCoverDisplayed()
	return isNewUserCoverDisplayed
end

--[[--
--获取当前的任务状态
--@param #number state 当前的任务状态
--]]
function getTaskState()
	return state;
end

--关闭一元话费
local function OnePhoneClose()
	ImageView_arrowhead:setRotation(-180);
	ImageView_arrowhead:setPosition(ccp(902,489));
	Panel_Button:setPosition(ccp(690,451))
	Panel_Button:setTouchEnabled(true);
	Panel_Button:setVisible(true);
	ImageView_arrowhead:setVisible(true);
	local array = CCArray:create()
	array:addObject(CCMoveBy:create(0.25, ccp(25,0)))
	array:addObject(CCMoveBy:create(0.25, ccp(-25,0)))
	ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)))
end

--[[--
--@param #width number 宽度位置
--@param #height number 高度位置
--@param #SizeWidth number 设置显示宽度
--@param #SizeHeight number 设置显示高度
--@param #Hierarchy number 设置层级
--]]
function ShadowLayer(width,height,SizeWidth,SizeHeight,Hierarchy)
	--500，200，300，200，50
	if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		local panelTemp = ShadowForFullScreen.createShadowForFullScreenUIImageView(width,height,SizeWidth,SizeHeight);
		Panel_bgPrompt:addChild(panelTemp);
		panelTemp:setZOrder(Hierarchy);
	end
end

--[[--
--设置界面布局
--]]
local function ShowCover(tableNum)
	--新手引导方案，1是做过公共模块新手引导，0是没有做过公共模块新手引导
	local numberScheme = profile.NewUserGuide.getCommonNewUserGuideScheme();
	if(dataTable.TASK_TWO_TABLE_1_START == tableNum)then
		--第二个任务，点击开始
		ImageView_arrowhead:setRotation(-90);
		Panel_Button:setPosition(ccp(634,232))
		ImageView_value:setPosition(ccp(525,500));
		--		ImageView_value:setPosition(ccp(1500,500));
		ImageView_arrowhead:setPosition(ccp(730,155))
		Label_prompt:setText("【明牌开始x5倍】很刺激！但对于新手，建议还是先选择平倍【开始】打一局吧。")
		--		local ima = CCArray:create()
		--		ima:addObject(CCMoveTo:create(0.2, ccp(1500,500)))
		--		ima:addObject(CCMoveTo:create(0.2, ccp(525,500)))
		--		ImageView_value:runAction(CCSequence:create(ima))
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)))
		if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
			ShadowLayer(505,166,470,220,-1);
		end
	elseif (dataTable.TASK_TWO_TABLE_2_BAOXIANG == tableNum) then
		--点击开宝箱
		if(numberScheme == 0)then
			TableLogic.hideGameBtn();
		end
		ImageView_value:setPosition(ccp(525,340));
		--		ImageView_value:setPosition(ccp(1500,340));
		ImageView_arrowhead:setRotation(90);
		ImageView_arrowhead:setPosition(ccp(1060,125));
		Panel_Button:setPosition(ccp(950,0))
		Label_prompt:setText("房间中每玩一定盘数，即可开启宝盒获得金币、元宝还有珍贵道具哦！")
		--		local ima = CCArray:create()
		--		ima:addObject(CCMoveTo:create(0.2, ccp(1500,340)))
		--		ima:addObject(CCMoveTo:create(0.2, ccp(525,340)))
		--		ImageView_value:runAction(CCSequence:create(ima))
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)))
		if  profile.NewUserGuide.getisNewUserGuideisEnable() == true then
			ShadowLayer(830,-130,400,260,-1);
		end
	elseif(dataTable.TASK_THREE_HALL_2_EXCHANGE == tableNum)then
		--点击大厅按钮,然后选择兑奖
		ImageView_arrowhead:setRotation(90);
		ImageView_arrowhead:setPosition(ccp(565,126));
		Panel_Button:setPosition(ccp(450,20))
		Panel_Button:setSize(CCSizeMake(1136, 640));
		ImageView_value:setPosition(ccp(525,306));
		--		ImageView_value:setPosition(ccp(1500,306));
		Label_prompt:setText("现在前往【兑奖】页面，兑换1元话费!");
		--		local ima = CCArray:create()
		--		ima:addObject(CCMoveTo:create(0.2, ccp(1500,306)))
		--		ima:addObject(CCMoveTo:create(0.2, ccp(525,306)))
		--		ImageView_value:runAction(CCSequence:create(ima))
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)))
		ShadowLayer(425,-55,300,200,-1);
		Common.log("选择了大厅中的兑奖！")

	elseif(dataTable.TASK_THREE_HALL_3_ONETELEPHONECOST == tableNum)then
		--点击大厅按钮,然后选择兑奖，再选择兑奖物品
		ImageView_arrowhead:setRotation(-180);
		ImageView_arrowhead:setPosition(ccp(300,350));
		ImageView_value:setVisible(false);
		Panel_Button:setPosition(ccp(40,85));
		Panel_Button:setSize(CCSizeMake(242, 309));
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(25,0)))
		array:addObject(CCMoveBy:create(0.25, ccp(-25,0)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)));
		ShadowLayer(-100,100,400,600,-1);

	elseif(dataTable.TASK_THREE_HALL_4_EXCHANGE == tableNum)then
		--点击一元话费，兑换
		ImageView_value:setVisible(false);
		ImageView_arrowhead:setRotation(-90);
		ImageView_arrowhead:setPosition(ccp(568,13));
		Panel_Button:setPosition(ccp(473,100));
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)));
	--	elseif(dataTable.TASK_THREE_HALL_6_SURE == tableNum)then
	--		--点击合成并兑换选择确定
	--		ImageView_value:setVisible(false);
	--		ImageView_arrowhead:setRotation(0);
	--		ImageView_arrowhead:setPosition(ccp(568,29));
	--		Panel_Button:setPosition(ccp(473,144));
	--		local array = CCArray:create()
	--		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
	--		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
	--		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)));
	--		ShadowLayer(323,20,850,600,1);

	elseif(dataTable.TASK_FOUR_EXCHANGE_MYPRIZE == tableNum)then
		--点我的奖品
		ImageView_arrowhead:setRotation(-90);
		ImageView_arrowhead:setPosition(ccp(948,386));
		Panel_Button:setPosition(ccp(848,458));
		ImageView_value:setVisible(false);
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(0,25)))
		array:addObject(CCMoveBy:create(0.25, ccp(0,-25)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)));
		ShadowLayer(502,346,860,260,-1);

	elseif(dataTable.TASK_FOUR_EXCHANGE_BILL_ACCOUNT == tableNum)then
		--然后选择一元话费
		ImageView_arrowhead:setRotation(-180);
		ImageView_arrowhead:setPosition(ccp(348,250));
		ImageView_value:setVisible(false);
		Panel_Button:setPosition(ccp(40,34));
		Panel_Button:setSize(CCSizeMake(242,310));
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.25, ccp(25,0)))
		array:addObject(CCMoveBy:create(0.25, ccp(-25,0)))
		ImageView_arrowhead:runAction(CCRepeatForever:create(CCSequence:create(array)))
		ShadowLayer(-100,-180,500,700,-1);

	elseif(dataTable.TASK_FOUR_TELEPHONE_CLOSE == tableNum)then
		--提前发送新手引导第四步完成的消息,提高关闭按钮的速度
		sendCOMMONS_GET_NEWUSERGUIDE_AWARD(4);
		--然后选择一元话费右上方的关闭
		Panel_Button:setVisible(false);
		Panel_Button:setTouchEnabled(false);
		ImageView_value:setPosition(ccp(505,170));
		--		ImageView_value:setPosition(ccp(1500,170));
		ImageView_arrowhead:setVisible(false);
		Label_prompt:setText("您的【1元话费】全部储存在【话费账户】中哦!");
		--		local ima = CCArray:create()
		--		ima:addObject(CCMoveTo:create(0.2, ccp(1500,170)))
		--		ima:addObject(CCMoveTo:create(0.2, ccp(505,170)))
		--		ImageView_value:runAction(CCSequence:create(ima))
		--		local delay = CCDelayTime:create(1.2)
		local array = CCArray:create()
		--		array:addObject(delay)
		array:addObject(CCCallFuncN:create(OnePhoneClose))
		local seq = CCSequence:create(array)
		view:runAction(seq)

		--	elseif(dataTable.TASK_FIVE_TELEPHONE_HALL == tableNum)then
		--		ImageView_arrowhead:setVisible(false);
		--		Panel_Button:setPosition(ccp(0,0));
		--		Panel_Button:setSize(CCSizeMake(1136,640));
		--		ImageView_value:setPosition(ccp(505,316));
		--		--		ImageView_value:setPosition(ccp(1500,316));
		--		Label_prompt:setText("您已经完成了新手引导的所有内容，可以愉快的游戏了，点击任意区域继续！");
		--		--		local ima = CCArray:create()
		--		--		ima:addObject(CCMoveTo:create(0.2, ccp(1500,316)))
		--		--		ima:addObject(CCMoveTo:create(0.2, ccp(505,316)))
		--		--		ImageView_value:runAction(CCSequence:create(ima))
		--		ShadowLayer(0,0,0,0,-1);
		--		--		NewUserCreateLogic.ListenerPanel();
		--		Common.log("完成新手引导的最后页面");
	end
end

--[[--
--设置桌面的显示
--@param #number tableNum 根据桌面的编号来显示桌面的信息
--]]
function setTableShowInterface(tableNum)
	if profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		state = tableNum;
		ShowCover(tableNum)
	end
end

--[[--
--屏蔽兑换按钮
--]]
function shieldExchangeButton()
	ImageView_arrowhead:setVisible(false);
	ImageView_value:setVisible(false);
	Panel_Button:setTouchEnabled(false);
	Panel_Button:setVisible(false);
end

--[[--
--显示新手引导领奖
--]]
function showNewUserPrizeToast()
	--不是新手引导
	if CommDialogConfig.getNewUserGiudeFinish() then
		return;
	end

	local message = "一元话费兑换成功！"
	local picUrl = "http://f.99sai.com/assets/cash-award/cash-award_0004.png"; --一元话费url
	ImageToast.createView(picUrl, nil, "x1", message, 2);
	--发送兑换列表的消息
	ExchangeLogic.sendMsgAfterOpenBox();
	--延时发送完成第三个任务
	NewUserCreateLogic.delaySendGetNewUserGuideAardMsg(view);
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_bgPrompt = cocostudio.getUIPanel(view, "Panel_bgPrompt");
	ImageView_value = cocostudio.getUIImageView(view, "ImageView_value");
	ImageView_arrowhead = cocostudio.getUIImageView(view, "ImageView_arrowhead");
	Label_prompt = cocostudio.getUILabel(view, "Label_prompt");
	Panel_Button = cocostudio.getUIPanel(view, "Panel_Button");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("NewUserCoverOther.json")
	local gui = GUI_NEWUSERCOVEROTHER
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
	if profile.NewUserGuide.getisNewUserGuideisEnable() == true then
		initLayer();
		isNewUserCoverDisplayed = true;
		view:setTag(getDiffTag());
		GameStartConfig.addChildForScene(view)
		initView();
	end
end

function requestMsg()

end

function callback_Panel_Button(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		NewUserCreateLogic.ListenerPanel();
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	isNewUserCoverDisplayed = false
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
