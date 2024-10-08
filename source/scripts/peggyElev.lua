import 'CoreLibs/crank'
import 'scripts/OpacityCircles/ElevationDepthOpacityCircle'

local pd <const> = playdate
local gfx <const> = pd.graphics
local ticksPerRevolution = 6
local ticksForGif = 3;

class('PeggyElev').extends(AnimatedSprite)

function PeggyElev:init(x, y)
    local peggyImageTable = gfx.imagetable.new("images/rabbit/rabbit-table-72-72.png")
    assert(peggyImageTable)
    PeggyElev.super.init(self, peggyImageTable)

    --State Machine
    self:addState("idleElev", 29, 32, { tickStep = ticksForGif + 9 })
    self:addState('walkElev', 13, 16, { tickStep = ticksForGif })
    self:addState('jump', 12, 13, { tickStep = ticksForGif })
    self:playAnimation()

    --Sprite Properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Peggy)
    self:setTag(TAGS.Peggy)
    --Try to keep this smaller than Peggy herself (for game feel's sake) -  J8A: 2024-10-05 23:47 MST
    self:setCollideRect(27, 27, 18, 18)
    self:add()

    --Physics Properties
    self.xVelocity = 0;
    self.yVelocity = 0;
    self.gravity = 1.0;
    self.jumpVelocity = -6
    self.maxSpeed = 2.0;
    self.speed = 3;
    self.crankSpeed = 6;

    --PlayerState
    self.touchingGround = false;
end

function PeggyElev:collisionResponse(other)
    local tag = other:getTag()
    return gfx.sprite.kCollisionTypeSlide
end

function PeggyElev:update()
    self:updateAnimation()
    self:handleState()
    self:handleMovementAndCollisions()

    local crankTicks = pd.getCrankTicks(ticksPerRevolution)
    if crankTicks == 1 then
        print("Forward tick")
        --gfx.drawText(pd.)
    elseif crankTicks == -1 then
        print("Backward tick")
    end

    --[[
    if pd.buttonIsPressed(pd.kButtonUp) then
        if self.y > 20 then
            self:moveBy(0, -self.speed)
            self:changeState("walkUp")
        end
    elseif pd.buttonIsPressed(pd.kButtonDown) then
        if self.y < 240 then
            self:moveBy(0, self.speed)
            self:changeState("walkDown")
        end

        --idle states
        if pd.buttonJustReleased(pd.kButtonUp) then
            self:changeState("idleUp")
        elseif pd.buttonJustReleased(pd.kButtonDown) then
            self:changeState("idleDown")
        elseif pd.buttonJustReleased(pd.kButtonLeft) then
            self:changeState("idleLeft")
        elseif pd.buttonJustReleased(pd.kButtonRight) then
            self:changeState("idleRight")
        end

        if (self.x + 200 < 840) then
            --gfx.setDrawOffset(self.x + 200, -self.y + 120)
        end
    ]]

    ElevationDepthOpacityCircle(self.x, self.y)

    local peggyPosX = self.x
    local peggyPosY = self.y
end

function PeggyElev:handleState()
    if self.currentState == "idleElev" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "walkElev" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "jump" then
        if self.touchingGround then
            self:changeToIdleState()
        end
        self:applyGravity()
        self:handleAirInput()
    end
end

function PeggyElev:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)

    self.touchingGround = false
    for i = 1, length do
        local collision = collisions[i]
        if collision.normal.y == -1 then
            self.touchingGround = true
        end

        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()

        if collisionTag == 2 then
            print(pd.getCurrentTimeMilliseconds)
            Events:emit("playerTouchedSaveCrate")
        end
    end

    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end
end

--Input
function PeggyElev:handleGroundInput()
    if pd.buttonJustPressed(pd.kButtonB) then
        self:changeToJumpState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) then
        self:changeToWalkState('left')
        if self.x > 9 then
        elseif self.x > 9 then
        end
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self:changeToWalkState('right')
        if self.x < 396 then
        elseif self.x > 396 then
        end
    else
        self:changeToIdleState()
    end
end

function PeggyElev:handleAirInput()
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.xVelocity = -self.maxSpeed
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.xVelocity = self.maxSpeed
    end
end

--StateTransitions
function PeggyElev:changeToIdleState()
    self.xVelocity = 0
    self:changeState('idleElev')
end

function PeggyElev:changeToWalkState(direction)
    if direction == 'left' then
        self.xVelocity = -self.maxSpeed
        self.globalFlip = 1
    elseif direction == 'right' then
        self.xVelocity = self.maxSpeed
        self.globalFlip = 0
    end
    self:changeState('walkElev')
end

function PeggyElev:changeToJumpState()
    self.yVelocity = self.jumpVelocity
    self:changeState('jump')
end

--Physics helper functions
function PeggyElev:applyGravity()
    self.yVelocity += self.gravity
    if self.touchingGround then
        self.yVelocity = 0
    end
end
