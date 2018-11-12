local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local livesRemaining = 4
local stage = 1

local stageText

-- ----------------------------------------------------
-- This function will take the player back to the MENU -- AA
-- -----------------------------------------------------
local function gotoMenu()
    local sceneTransitionOptions = {
        effect = "slideDown",
        time = 500
        --,
        --params = {
        --  speed = ballSpeed
        --}
    }

    composer.gotoScene( "menu", sceneTransitionOptions )
end

-- ----------------------------------------------------
-- This function will take the player to the GAME -- AA
-- -----------------------------------------------------
local function gotoGame()
    local sceneTransitionOptions = {
        effect = "slideUp",
        time = 500,
        params = {
            stage = stage
        }
    }

    composer.gotoScene( "game", sceneTransitionOptions )
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function scene:create( event )
 
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local sceneGroup = self.view

    -- --------------------------------------
    -- This is the background for this scene -- AA
    -- --------------------------------------

    local background = display.newImageRect( sceneGroup, "chair.png", 450, 750 )
    background.x = display.contentCenterX 
    background.y = display.contentCenterY 

    -- ---------------------------------
    -- These represent the player's life -- AA
    -- --------------------------------

    local lifeGroup = display.newGroup()

    local life1 = display.newImageRect( sceneGroup, "life.png", 70, 70 )
    life1.x = display.contentCenterX - 125
    life1.y = display.contentCenterY - 230
    lifeGroup:insert(life1)

    local life2 = display.newImageRect( sceneGroup, "life.png", 70, 70 )
    life2.x = display.contentCenterX - 45
    life2.y = display.contentCenterY - 230
    lifeGroup:insert(life2)

    local life3 = display.newImageRect( sceneGroup, "life.png", 70, 70 )
    life3.x = display.contentCenterX + 45
    life3.y = display.contentCenterY - 230
    lifeGroup:insert(life3)

    local life4 = display.newImageRect( sceneGroup, "life.png", 70, 70 )
    life4.x = display.contentCenterX + 125
    life4.y = display.contentCenterY - 230
    lifeGroup:insert(life4)

    -- ---------------------------------------------------------------------------------
    -- GAME button widget
    -- I only chanhged this to a widget just so it can match the start button in the menu - AA
    -- ---------------------------------------------------------------------------------    

    local widget = require( "widget" )
 
    -- Function to handle button events
    local function handleButtonEvent( event )
        if ( "ended" == event.phase ) then
            print( "Button was pressed and released" )
        end
    end
 
    -- Create the widget
    local gameButton = widget.newButton(
    {
        label = "gameButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 100,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={255,255,0}, over={255,255,0} },
        strokeColor = { default={0,0,0}, over={0,0,0} },
        strokeWidth = 5
    })

    -- Center the button
    gameButton.x = display.contentCenterX + 100
    gameButton.y = display.contentCenterY + 220
     
    -- Change the button's label text
    gameButton:setLabel( "GAME" )
    gameButton:addEventListener("tap", gotoGame)
    
        -- ---------------------------------------------------------------------------------
    -- MENU button widget
    -- I only chanhged this to a widget just so it can match the start button in the menu -AA
    -- ---------------------------------------------------------------------------------    

    local widget = require( "widget" )
 
    -- Function to handle button events
    local function handleButtonEvent( event )
        if ( "ended" == event.phase ) then
            print( "Button was pressed and released" )
        end
    end
 
    -- Create the widget
    local menuButton = widget.newButton(
    {
        label = "menuButton",
        onEvent = handleButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 100,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={255,255,0}, over={255,255,0} },
        strokeColor = { default={0,0,0}, over={0,0,0} },
        strokeWidth = 5
    })
    
    -- Center the button
    menuButton.x = display.contentCenterX - 100
    menuButton.y = display.contentCenterY + 220
     
    -- Change the button's label text
    menuButton:setLabel( "MENU" )
    menuButton:addEventListener("tap", gotoMenu)

    livesText = display.newText("Lives Remaining: "..livesRemaining, display.contentCenterX, 200, native.systemFont, 24)
    livesText:setFillColor(0,0,0)
    stageText = display.newText("Stage: "..stage, display.contentCenterX, 350, native.systemFont, 24)
    stageText:setFillColor(0,0,0)
    messageText = display.newText("Game messages: ", display.contentCenterX, 400, native.systemFont, 24)
    messageText:setFillColor(0,0,0)

    -- --------------------------------------------------------------------
    --This is just putting all of the objects that is the scene in a group
    -- --------------------------------------------------------------------
    sceneGroup:insert(gameButton)
    sceneGroup:insert(menuButton)
    sceneGroup:insert(lifeGroup)
    sceneGroup:insert(livesText)
    sceneGroup:insert(stageText)
    sceneGroup:insert(messageText)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        local params = event.params

        print("Before null check")

        if (params.cameFromMenu ~= nil and params.cameFromMenu == true) then
            print("Came from menu")
            stage = 1
            livesRemaining = 4
            messageText.text = "Game messages: "
        else
            print("Came from game")
            stage = stage + 1
            print("Stage = "..stage)
        end

        if (params.decrementLife ~= nil) then
            livesRemaining = livesRemaining - 1
        end
        
        if (params.gameMessage ~= nil) then
            messageText.text = "Game messages: "..params.gameMessage
        end

        stageText.text = "Stage: "..stage
        livesText.text = "Lives Remaining: "..livesRemaining
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
