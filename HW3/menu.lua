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

	composer.gotoScene("intermediate", sceneTransitionOptions)
end

function scene:create( event )
	local sceneGroup = self.view

	button = display.newRect(display.contentCenterX + display.contentWidth / 4, 0, 120, 40)
	button:setFillColor(1, 0, 0)
	button:addEventListener("tap", buttonPressHandler)

	buttonText = display.newText("Go", display.contentCenterX + display.contentWidth / 4 + 50, 10, 120, 40)

	labelText = display.newText("Menu", display.contentCenterX, 200, native.systemFont, 36)

	sceneGroup:insert(button)
	sceneGroup:insert(buttonText)
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


