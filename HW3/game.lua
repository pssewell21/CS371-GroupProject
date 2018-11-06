-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

function buttonPressHandler(event)
	local sceneTransitionOptions = {
		effect = "slideUp",
		time = 500
		--,
		--params = {
		--	speed = ballSpeed
		--}
	}

	composer.gotoScene("game", sceneTransitionOptions)
end

function scene:create( event )
	local sceneGroup = self.view

	-- set up the image sheet coordinates for animations 
	local options =
	{
		frames =
		{
			{ x = 1068, y = 0, width = 260, height = 200 }, -- 1 - Red Square
			{ x = 810, y = 0, width = 260, height = 200 },  -- 2 - House 2
			{ x = 550, y = 0, width = 260, height = 200 },  -- 3 - House 1
			{ x = 368, y = 8, width = 41, height = 41 },  -- 4 - Good Pick Icon
			{ x = 413, y = 10, width = 35, height = 35 },  -- 5 - Bad Pick Icon
			{ x = 148, y = 23, width = 39, height = 36 },  -- 6 - Bird 1
			{ x = 189, y = 23, width = 43, height = 34 }  -- 7 - Bird 2
		}
	}
	
	-- initialize the image sheet
	local sheet = graphics.newImageSheet("marioware.png", options)

	local image = display.newImage(sheet, 7, 200, 100)
	image.xScale = 3
	image.yScale = 3


	labelText = display.newText("Game", display.contentCenterX, 200, native.systemFont, 36)

	sceneGroup:insert(labelText)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene


