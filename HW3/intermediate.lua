-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

local scene = composer.newScene()

local livesRemaining = 4
local stage = 1

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

	gameButton = display.newRect(display.contentCenterX + display.contentWidth / 4, 0, 120, 40)
	gameButton:setFillColor(0, 0, 1)
	gameButton:addEventListener("tap", buttonPressHandler)

	gameButtonText = display.newText("Game", display.contentCenterX + display.contentWidth / 4 + 42, 10, 120, 40)

	menuButton = display.newRect(display.contentCenterX - display.contentWidth / 4, 0, 120, 40)
	menuButton:setFillColor(1, 0, 1)
	menuButton:addEventListener("tap", buttonPressHandler)

	menuButtonText = display.newText("Menu", display.contentCenterX - display.contentWidth / 4 + 40, 10, 120, 40)

	labelText = display.newText("Intermediate", display.contentCenterX, 200, native.systemFont, 36)

	livesText = display.newText("Lives Remaining: "..livesRemaining, display.contentCenterX, 300, native.systemFont, 24)
	stageText = display.newText("Stage: "..stage, display.contentCenterX, 350, native.systemFont, 24)
	messageText = display.newText("Game messages: ", display.contentCenterX, 400, native.systemFont, 24)

	sceneGroup:insert(gameButton)
	sceneGroup:insert(gameButtonText)
	sceneGroup:insert(menuButton)
	sceneGroup:insert(menuButtonText)
	sceneGroup:insert(labelText)
	sceneGroup:insert(livesText)
	sceneGroup:insert(stageText)
	sceneGroup:insert(messageText)
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


