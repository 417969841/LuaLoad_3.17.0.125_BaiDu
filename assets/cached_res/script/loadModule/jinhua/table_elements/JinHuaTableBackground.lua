module("JinHuaTableBackground", package.seeall)

function createJinHuaTableBackground(layer)
	local bg1 = CCSprite:create(getJinHuaResource("desk_background.png", pathTypeInApp))
	bg1:setAnchorPoint(ccp(0,0))
	bg1:setPosition(0, 0)
	local bg2 = CCSprite:create(getJinHuaResource("desk_background.png", pathTypeInApp))
	bg2:setAnchorPoint(ccp(0,0))

	local bgIcon1 = CCSprite:create(getJinHuaResource("ui_desk_background.png", pathTypeInApp))
	bgIcon1:setPosition(JinHuaTableConfig.tableBgPic1X, JinHuaTableConfig.tableBgPic1Y)

	local wdh = GameConfig.ScreenWidth / GameConfig.ScreenHeight
	if JinHuaTableConfig.isPad then
		local widthScale = GameConfig.ScreenWidth / JinHuaTableConfig.TableDefaultWidth;
		local heightScale = GameConfig.ScreenHeight / JinHuaTableConfig.TableDefaultHeight;
		bg1:setScaleX(widthScale)
		bg1:setScaleY(heightScale)
		bg2:setScaleX(widthScale)
		bg2:setScaleY(heightScale)
		bgIcon1:setScaleX(widthScale)
		bgIcon1:setScaleY(heightScale)
	end

	bg2:setPosition(bg1:getContentSize().width, 0)
	bg2:setFlipX(true)

	layer:addChild(bg1)
	layer:addChild(bg2)
	layer:addChild(bgIcon1)
--	layer:addChild(bgIcon2)
end