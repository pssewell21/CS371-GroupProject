local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function gotoGame()
	local sceneTransitionOptions = {
		effect = "slideUp",
		time = 500,
		params = {
            cameFromMenu = true
        }
	}

    composer.gotoScene( "intermediateScene", sceneTransitionOptions )
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "menu.gif", 400, 800 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local title = display.newImageRect( sceneGroup, "transparentTitle3.png", 330, 80 )
    title.x = display.contentCenterX + 3
    title.y = 30

    local studentName1 = display.newText( sceneGroup, "Angela Allison", display.contentCenterX + 120, 55, native.systemFont, 10 )
    studentName1:setFillColor( 0, 0, 0 )

    local studentName2 = display.newText( sceneGroup, "Ryan Davis", display.contentCenterX + 120, 65, native.systemFont, 10 )
    studentName2:setFillColor( 0, 0, 0 )

    local studentName3 = display.newText( sceneGroup, "Andrew Munster", display.contentCenterX + 120, 75, native.systemFont, 10 )
    studentName3:setFillColor( 0, 0, 0 )

    local studentName4 = display.newText( sceneGroup, "Patrick Sewell", display.contentCenterX + 120, 85, native.systemFont, 10 )
    studentName4:setFillColor( 0, 0, 0 )

    local widget = require( "widget" )
 
    -- Function to handle button events
        local function handleButtonEvent( event )
            if ( "ended" == event.phase ) then
            print( "Button was pressed and released" )
            end
    end
 
	-- Create the widget
    local startButton = widget.newButton(
    {
        label = "startButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={255,255,0}, over={255,255,0} },
        strokeColor = { default={0,0,0}, over={0,0,0} },
        strokeWidth = 5
    })
 
	-- Center the button
	startButton.x = display.contentCenterX - 10
	startButton.y = display.contentCenterY + 175
	 
	-- Change the button's label text
	startButton:setLabel( "START" )
	startButton:addEventListener("tap", gotoGame)
	
	-- --------------------------------------------------------------------
	--This is just putting all of the objects that is the scene in a group
	-- --------------------------------------------------------------------
	sceneGroup:insert(background)
	sceneGroup:insert(title)
	sceneGroup:insert(studentName1)
	sceneGroup:insert(studentName2)
	sceneGroup:insert(studentName3)
	sceneGroup:insert(studentName4)
	sceneGroup:insert(startButton)
end
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 
    end
end
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen) 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen 
    end
end
 
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
  
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene