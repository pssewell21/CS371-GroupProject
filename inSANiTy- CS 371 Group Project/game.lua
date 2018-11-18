local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local roboBlock
local level

local levelMovementSpeed = 25
 
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

local function jumpUp()
    transition.to(roboBlock, {time=150, y = roboBlock.y - 75})
end

local function jumpDown()

    transition.to(roboBlock, {time=150, y = roboBlock.y + 75})
end

local function screenTouched(event)
    jumpUp()
    timer.performWithDelay(150, jumpDown)
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

local function buildLevel()
    local group = display.newGroup()

    local floor = display.newRect(-50, 210 + 3, 50000, 110)
    floor.strokeWidth = 3
    floor:setStrokeColor(1, 0, 0)
    floor:setFillColor(0, 0, 0, 0.75)
    floor.anchorX = 0
    floor.anchorY = 0
    group:insert(floor)

    local vertices = {0,0, 30,0, 15,-30}

    local item1 = display.newPolygon(250, 180 - 3, vertices)
    item1.strokeWidth = 3
    item1:setStrokeColor(1, 1, 1)
    item1:setFillColor(0, 0, 0, 0.75)
    item1.anchorX = 0
    item1.anchorY = 0
    group:insert(item1)

    local item2 = display.newPolygon(400, 180 - 3, vertices)
    item2.strokeWidth = 3
    item2:setStrokeColor(1, 1, 1)
    item2:setFillColor(0, 0, 0, 0.75)
    item2.anchorX = 0
    item2.anchorY = 0
    group:insert(item2)

    local item3 = display.newPolygon(800, 180 - 3, vertices)
    item3.strokeWidth = 3
    item3:setStrokeColor(1, 1, 1)
    item3:setFillColor(0, 0, 0, 0.75)
    item3.anchorX = 0
    item3.anchorY = 0
    group:insert(item3)

    local item4 = display.newPolygon(1200, 180 - 3, vertices)
    item4.strokeWidth = 3
    item4:setStrokeColor(1, 1, 1)
    item4:setFillColor(0, 0, 0, 0.75)
    item4.anchorX = 0
    item4.anchorY = 0
    group:insert(item4)

    return group
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event ) 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local background = display.newImageRect(sceneGroup, "scene1.png", 575, 350 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY

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

    level = buildLevel() 

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
        roboBlock = display.newRect(0, 180, 30, 30)
        roboBlock.strokeWidth = 3
        roboBlock:setStrokeColor(1, 1, 1)
        roboBlock:setFillColor(0, 0, 0, 0.75)
        roboBlock.anchorX = 0
        roboBlock.anchorY = 0

        sceneGroup:insert(roboBlock)

        Runtime:addEventListener("tap", screenTouched)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen 
        timer.performWithDelay()
        moveLevel()
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
