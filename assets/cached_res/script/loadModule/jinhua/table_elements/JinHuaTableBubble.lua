module("JinHuaTableBubble", package.seeall)

--显示气泡结束
local function showBubbleEnd(sender)
	JinHuaTableLogic.getTableParentLayer():removeChild(sender,true)
end
--气泡类型
--看牌
BUBBLE_TYPE_LOOKCARD = 1
--跟注
BUBBLE_TYPE_CALL = 2
--加注
BUBBLE_TYPE_RAISE = 3
--押满
BUBBLE_TYPE_ALLIN = 4
--弃牌
BUBBLE_TYPE_DISCARD = 5
--换牌
BUBBLE_TYPE_CHANGECARD = 6
--禁比
BUBBLE_TYPE_NO_PK = 7

local bubblePicTable = {[BUBBLE_TYPE_LOOKCARD]="desk_action_msg_view.png", [BUBBLE_TYPE_CALL]="desk_action_msg_follow.png",
[BUBBLE_TYPE_RAISE]="desk_action_msg_raise.png",[BUBBLE_TYPE_ALLIN]="desk_action_msg_follow.png",[BUBBLE_TYPE_DISCARD]="desk_action_msg_giveup.png",
[BUBBLE_TYPE_CHANGECARD]="desk_action_msg_changecard.png",[BUBBLE_TYPE_NO_PK]="desk_action_msg_jinbi.png"}

--显示气泡
function showJinHuaTableBubble(pos,bubbleType)
	local texture = CCTextureCache:sharedTextureCache():addImage(getJinHuaResource(bubblePicTable[bubbleType],pathTypeInApp))
	if texture==nil then
		return
	end

	local bubbleSprite = CCSprite:createWithTexture(texture)
	local playerSprites = JinHuaTablePlayer.getPlayers()
	if playerSprites[pos] then
		bubbleSprite:setPosition(playerSprites[pos]:getCenterX(), playerSprites[pos]:getCenterY())
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.5,ccp(0,JinHuaTableConfig.bubbleSpriteMoveDistance)))
		array:addObject(CCDelayTime:create(2.0))
		array:addObject(CCCallFuncN:create(showBubbleEnd))
		bubbleSprite:runAction(CCSequence:create(array))
		JinHuaTableLogic.getTableParentLayer():addChild(bubbleSprite)
	end
end