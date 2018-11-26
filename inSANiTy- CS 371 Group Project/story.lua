local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

local backgroundMusic
local nextSceneButton
local sceneTime = 60

local cityName
local year
local roboBlockFace
-- --------------------------------
-- This is for the monster - AA
-- --------------------------------
local monsterGroup
local roboBlocksGroup

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoNextScene()
    local sceneTransitionsOptions = 
    {
        effect = "crossfade",
        time = 500,
    }

    composer.removeScene("story")
    composer.gotoScene("game", sceneTransitionsOptions)
end

-- Function to handle button events
local function handleButtonEvent(event)
    if ("ended" == event.phase) then
        print("Button was pressed and released")
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

        cityName = display.newImageRect(sceneGroup, "cityName.png", 500, 75)
        cityName.x = display.contentCenterX 
        cityName.y = display.contentCenterY + 138
        cityName.isVisible = true 

      --[[  year = display.newImageRect(sceneGroup, "yearOfGame.png", 200,50)
        year.x = display.contentCenterX 
        year.y = display.contentCenterY - 20
        year.isVisible = true
--]]
        elder = display.newImageRect(sceneGroup, "elder.png", 300, 250)
        elder.x = display.contentCenterX 
        elder.y = display.contentCenterY - 20 
        elder.isVisible = true 

        monsterGroup = display.newGroup()

        monster1 = display.newImageRect(sceneGroup, "monster.png", 50, 50)
        monster1.x = display.contentCenterX - 230
        monster1.y = display.contentCenterY + 50
        monster1.isVisible = true
        monsterGroup:insert(monster1)

        monster2 = display.newImageRect(sceneGroup, "monster.png", 85, 85)
        monster2.x = display.contentCenterX + 235
        monster2.y = display.contentCenterY + 75
        monster2.xScale = -1
        monster2.isVisible = true
        monsterGroup:insert(monster2)

        roboBlocksGroup = display.newGroup()

        woman = display.newImageRect(sceneGroup, "womanBlock.png", 60, 60)
        woman.x = display.contentCenterX - 170
        woman.y = display.contentCenterY + 75
        woman.isVisible = true 
        roboBlocksGroup:insert(woman)

        crazy = display.newImageRect(sceneGroup, "crazyBlock.png", 35, 35)
        crazy.x = display.contentCenterX + 155
        crazy.y = display.contentCenterY + 55
        crazy.isVisible = true 
        roboBlocksGroup:insert(crazy)


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

    cityName = display.newImageRect(sceneGroup, "cityName.png", 500, 75)
    cityName.x = display.contentCenterX 
    cityName.y = display.contentCenterY + 138
    cityName.isVisible = true 

    elder = display.newImageRect(sceneGroup, "elder.png", 300, 290)
    elder.x = display.contentCenterX 
    elder.y = display.contentCenterY - 20 
    elder.isVisible = true 


    sceneGroup:insert(background)
    sceneGroup:insert(nextSceneButton)
    sceneGroup:insert(monsterGroup)
    sceneGroup:insert(roboBlocksGroup)
    sceneGroup:insert(cityName)
    sceneGroup:insert(elder)
end 
 
-- show()
function scene:show( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen) 
    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen 
        audio.setVolume(1, {channel = 3})
        local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 3, loops = -1, fadein = 5000})
    end
end
 
 -- hide()
function scene:hide( event ) 
    local sceneGroup = self.view
    local phase = event.phase
 
    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen) 
    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
  
-- destroy()
function scene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    -- Stop the music!
    audio.stop(3)
    audio.dispose(backgroundMusic) 
end
  
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------
 
return scene
