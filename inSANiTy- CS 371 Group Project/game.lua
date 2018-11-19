local composer = require( "composer" )
local widget = require( "widget" )
local physics = require("physics")
local scene = composer.newScene()

local roboBlock
local level
local backgroundMusic

local levelMovementSpeed = 80
local levelWidth = 50000
local jumpHeight = 75
local floorHeight = 210
local objectWidth = 30
local objectStrokeWidth = 3

local whiteColorTable = {1, 1, 1}
local redColorTable = {1, 0, 0}
local semiTransparentColorTable = {0, 0, 0, 0.75}

local roboBlockVerticalPosition
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function gotoNextScene()
    local sceneTransitionsOptions = 
    {
        effects = "fade",
        time = 500,
    }

    composer.gotoScene("game2", sceneTransitionsOptions)
end

-- Function to handle button events
local function handleButtonEvent(event)
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
    end
end 

local function screenTouched(event)
    roboBlock:applyLinearImpulse(0, -0.2, roboBlock.x, roboBlock.y)
end

local function moveLevel()
    transition.to(level, 
    {
        time=150, 
        x = level.x - levelMovementSpeed,
        onComplete = 
            function() 
                moveLevel()
            end
    })
end

local function addTriangleObject(x, y)    
    local vertices = {0,0, objectWidth,0, 15,-objectWidth}

    local item = display.newPolygon(x, y, vertices)
    item.strokeWidth = objectStrokeWidth
    item:setStrokeColor(unpack(whiteColorTable))
    item:setFillColor(unpack(semiTransparentColorTable))
    item.anchorX = 0
    item.anchorY = 0
    level:insert(item)
end

local function buildLevel()
    level = display.newGroup()

    local floor = display.newRect(-50, floorHeight + objectStrokeWidth, levelWidth, 110)
    floor.strokeWidth = objectStrokeWidth
    floor:setStrokeColor(unpack(redColorTable))
    floor:setFillColor(unpack(semiTransparentColorTable))
    floor.anchorX = 0
    floor.anchorY = 0
    level:insert(floor)
    physics.addBody(floor, "static")

    addTriangleObject(500, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(1000, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(1150, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(1200, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(1600, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(2000, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(2350, floorHeight - objectWidth - objectStrokeWidth)
    addTriangleObject(2380, floorHeight - objectWidth - objectStrokeWidth)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event ) 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.start()
    physics.setGravity(0, 9.8 * 5)

    local background = display.newImageRect(sceneGroup, "scene1.png", 575, 350 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY
    
    backgroundMusic = audio.loadStream("level1Music.mp3")

   	-- -----------------
    -- Create the widget
    -- This is for testing purposes
    -- -----------------
    local nextSceneButton = widget.newButton(
    {
        label = "nextSceneButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 60,
        height = 40,
        cornerRadius = 2,
        fillColor = { default = {0 ,1, 0.23}, over={0.8,1,0.8} }, 
        strokeColor = { default= {1,0.2,0.6}, over={0,0,0} },
        strokeWidth = 5
    })

    -- -----------------
    -- Center the button
    -- -----------------
    nextSceneButton.x = display.contentCenterX
    nextSceneButton.y = display.contentCenterY + 120
    
    -- ------------------------------
    -- Change the button's label text
    -- ------------------------------
    nextSceneButton:setLabel( "NEXT" )
    nextSceneButton:addEventListener("tap", gotoNextScene)  

    buildLevel() 

    sceneGroup:insert(background)
    sceneGroup:insert(nextSceneButton)
    sceneGroup:insert(level)
end 
 
-- show()
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
        roboBlock = display.newRect(0, floorHeight - objectWidth, objectWidth, objectWidth)
        roboBlock.strokeWidth = objectStrokeWidth
        roboBlock:setStrokeColor(unpack(whiteColorTable))
        roboBlock:setFillColor(unpack(semiTransparentColorTable))
        --roboBlock.anchorX = 0
        --roboBlock.anchorY = 0

        sceneGroup:insert(roboBlock)
        physics.addBody(roboBlock, "dynamic", { bounce = 0 })
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000})
        audio.play(backgroundMusic, {channel = 1, loops = -1})

        Runtime:addEventListener("tap", screenTouched)

        moveLevel()
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
        physics.pause()

        -- Stop the music!
        audio.stop(1)
        audio.dispose(backgroundMusic)
    end
end 
 
-- destroy()
function scene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view    
    physics.stop()
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
