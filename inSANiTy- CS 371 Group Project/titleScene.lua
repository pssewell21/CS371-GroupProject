local composer = require( "composer" )
local widget = require( "widget" )
 
local scene = composer.newScene()

local backgroundMusic
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--[[
local function gotoGame()
    local sceneTransitionsOpitions = 
    {
        effects = "fade",
        time = 500,
    }

    composer.removeScene("titleScene")
    composer.gotoScene("game", sceneTransitionsOpitions)
end
--]]
local function gotoStory()
    local sceneTransitionsOpitions = 
    {
        effects = "fade",
        time = 500,
    }

    composer.removeScene("titleScene")
    composer.gotoScene("story", sceneTransitionsOpitions)
end

 -- Function to handle button events
local function handleButtonEvent( event )
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
    
    local background = display.newImageRect(sceneGroup, "titleBackground.png", 575, 350 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY

    local title = display.newImageRect( sceneGroup, "title3.png", 500, 200 )
    title.x = display.contentCenterX  
    title.y = display.contentCenterY - 25
    -- Function to handle button events    
    
    backgroundMusic = audio.loadStream("titleMusic.mp3")

    -- -----------------
    -- Create the widget
    -- -----------------
    local startButton = widget.newButton(
    {
        label = "startButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 300,
        height = 40,
        cornerRadius = 2,
        fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
        strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
        strokeWidth = 5
    })

    -- -----------------
    -- Center the button
    -- -----------------
    startButton.x = display.contentCenterX
    startButton.y = display.contentCenterY + 120
    
    -- ------------------------------
    -- Change the button's label text
    -- ------------------------------
    startButton:setLabel( "START" )
    startButton:addEventListener("tap", gotoStory)
    
    -- --------------------------------------------------------------------
    --This is just putting all of the objects that is the scene in a group
    -- --------------------------------------------------------------------
    sceneGroup:insert(background)
    sceneGroup:insert(title)
    sceneGroup:insert(startButton)
end
  
-- show()
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
    elseif ( phase == "did" ) then        
        -- Code here runs when the scene is entirely on screen 
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000})
        audio.play(backgroundMusic, {channel = 1, loops = -1})
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
    end
end 
 
-- destroy()
function scene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view 

    -- Stop the music!
    audio.stop(1)
    audio.dispose(backgroundMusic)
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