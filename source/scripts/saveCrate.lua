local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SaveCrate').extends(gfx.sprite)

function SaveCrate:init(x,y, width, height)
    local crateImage = gfx.image.new(width, height)
    gfx.pushContext(crateImage)
        gfx.drawRect(0, 0, width, height)    
        --gfx.fillRect(0, 0, width, height)
        gfx.setLineWidth(27)
    gfx.popContext()
    self:setImage(crateImage)
    self:setBounds(0, 0, width, height)
    self:setZIndex(100)
    self:setTag(2)
    self:setCollideRect(-10, 0, width/2, height)
    self:moveWithCollisions(x, y)
    self:add()
end

function SaveCrate:draw()
    gfx.fillRect(0, 0, self.width, self.height)
end

function SaveCrate:collisionResponse(other)
    local tag = other:getTag()
    print (tag)
    if other:getTag() == 1 then 
    return gfx.sprite.kCollisionTypeOverlap
    end
end