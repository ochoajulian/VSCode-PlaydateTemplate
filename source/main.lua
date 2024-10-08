-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/animator"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

--Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"
--import 'scripts/libraries/Panels'

--Game
import "scripts/events"
import "scripts/player"
import "scripts/peggyPlan"
import "scripts/peggyElev"
import "scripts/saveCrate"
import "scripts/gameScene"

GameScene()

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local plDt <const> = playdate
local sfx <const> = playdate.sound
local gfx <const> = playdate.graphics

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.
local playerSprite = nil

local backgroundMusic = nil

local square = playdate.graphics.image.new(20, 20, playdate.graphics.kColorBlack)
local squareSprite = playdate.graphics.sprite.new(square)
squareSprite:add()
--Set up animations
local diagonalLineSegment = nil
--diagonalLineSegment = playdate.geometry.diagonalLineSegment.new(0, 0, 400, 240)
--local diagonalLineSegment = playdate.geometrygi

--local lineAnimator = gfx.animator.new(2000, diagonalLineSegment, playdate.easingFunctions.outBounce)
--local ballSpriteLine = Ball(0, 0)

-- A function to set up our game environment.
function myGameSetUp()
    -- Set up the player sprite

    local playerImage = gfx.image.new("images/IMG_0019")
    assert(playerImage) -- make sure the image was where we thought

    playerSprite = gfx.sprite.new(playerImage)
    playerSprite:moveTo(20, 120) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    --playerSprite:add() -- This is critical!

    -- We want an environment displayed behind our sprite.
    -- There are generally two ways to do this:
    -- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
    -- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
    --       and call :setZIndex() with some low number so the background stays behind
    --       your other sprites.

    local backgroundImage = gfx.image.new("Images/IMG_0018")
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            -- x,y,width,height is the updated area in sprite-local coordinates
            -- The clip rect is already set to this area, so we don't need to set it ourselves
            -- backgroundImage:draw( 0, 0 )
        end
    )

    --Set up music and sfx
    backgroundMusic = sfx.fileplayer.new("Sounds/recorder_IMA")
    assert(backgroundMusic)

    backgroundMusic:load("Sounds/recorder_IMA")
    --backgroundMusic:play(9)
end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()
--SaveCrate(360, 100, 30, 30)
--PlayTimer(200, 400)

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()
    --[[ Call the functions below in playdate.update() to draw sprites and keep
timers updated. (We aren't using timers in this example, but in most
average-complexity games, you will.)
]]
    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.drawFPS(0, 0)

    if playdate.buttonJustReleased(playdate.kButtonA) then
        print(GameScene:getCurrentLevel())
        if GameScene:getCurrentLevel() == 'Level_00' then
            GameScene:goToLevel('Level_10')
            PeggyPlan(99, 120)
            -- peggyPos = PeggyOne:setPosition()
        elseif GameScene:getCurrentLevel() == 'Level_10' then
            GameScene:goToLevel('Level_00')
            PeggyElev(110, 120)
        end
    end
end
