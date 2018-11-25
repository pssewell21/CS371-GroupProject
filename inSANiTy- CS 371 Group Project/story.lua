local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()
local backgroundMusic
local nextSceneButton

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local function gotoNextScene()
    local sceneTransitionsOptions = 
    {
        effects = "crossfade",
        time = 500,
    }

    composer.removeScene("story")
    composer.gotoScene("game", sceneTransitionsOptions)
end

-- Function to handle button events
local function handleButtonEvent(event)
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event ) 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "scene4.png", 575, 350 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY

    backgroundMusic = audio.loadStream("CS371Story.wav")

        -- -----------------
        -- Create the widget
        -- -----------------
        nextSceneButton = widget.newButton(
        {
            label = "nextSceneButton",
            onEvent = handleButtonEvent,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = 70,
            height = 25,
            cornerRadius = 2,
            fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
            strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
            strokeWidth = 5
        })

        nextSceneButton.x = display.contentCenterX + 230
        nextSceneButton.y = display.contentCenterY - 130
        nextSceneButton:setLabel("NEXT")
        nextSceneButton:addEventListener("tap", gotoNextScene) 
        nextSceneButton.isVisible = true

        cityName = display.newImageRect(sceneGroup, "cityName.png", 550,100)
        cityName.x = display.contentCenterX 
        cityName.y = display.contentCenterY - 70
        cityName.isVisible = false 

        year = display.newImageRect(sceneGroup, "yearOfGame.png", 550,100)
        year.x = display.contentCenterX 
        year.y = display.contentCenterY - 20
        year.isVisible = false 

        roboBlockFace = display.newImageRect(sceneGroup, "yearOfGame.png", 700,700)
        roboBlockFace.x = display.contentCenterX 
        roboBlockFace.y = display.contentCenterY 
        roboBlockFace.isVisible = true 





    sceneGroup:insert(background)
    sceneGroup:insert(nextSceneButton)
    sceneGroup:insert(cityName)
    sceneGroup:insert(year)
    sceneGroup:insert(roboBlockFace)
end 
 
-- show()
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 
         -- Code here runs when the scene is entirely on screen 
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 3, loops = -1, fadein = 5000})
        audio.play(backgroundMusic, {channel = 3, loops = -1})
    end
end
 
 -- hide()
function scene:hide( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen) 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

        -- Stop the music!
        audio.stop(3)
        audio.dispose(backgroundMusic)
 
    end
end
  
-- destroy()
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
