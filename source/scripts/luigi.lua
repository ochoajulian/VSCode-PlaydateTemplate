local pd <const> = playdate
local gfx <const> = pd.graphics

class('Luigi').extends(AnimatedSprite)

function Luigi:init(x, y)
    -- State Machine
    local luigiWalkDownImageTable = gfx.imagetable.new("images/luigi-walk-down")
    Luigi.super.init(self, luigiWalkDownImageTable)

    self:addState("walkDown", 1, 8)
    self:playAnimation()

    --Sprite Properties
    self:move(x, y)
    self:setZIndex(100)
    self:setTag(1)
    self:setCollideRect(3, 3, 10, 13)

    --Physics Properties
end    

function Luigi:update()
    self:updateAnimation()

    self:handleState()
    self:handleMovementAndCollisions()
end

function Luigi:handleState()
    if self.currentState == "idle" then
        
    end
end

function Luigi:handleMovementAndCollisions()
    --self
end