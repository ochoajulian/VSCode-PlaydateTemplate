local gfx <const> = playdate.graphics;
local ldtk <const> = LDtk;

TAGS = {
    Peggy = 1
}

Z_INDEXES = {
    Peggy = 100
}

ldtk.load("levels/example0.ldtk", false)

class('GameScene').extends();

local currentLevel = 'string'

function GameScene:init()
    self:goToLevel("Level_00")
    currentLevel = "Level_00"
    --playdate.display.setInverted(true);
    print(currentLevel)
    self.spawnX = 12
    self.spawnY = 5

    self.player = PeggyPlan(self.spawnX, self.spawnY)
end

function GameScene:getCurrentLevel()
    return currentLevel
end

--[[Not working here... works in main.lua tho! --- J8A: 2024-10-05 00:23 MST
function GameScene:update()
    if playdate.buttonIsPressed(pd.kButtonA) then
        print('gameScene A pressed')
        self:goToLevel("Level_10")
    end
end
]]

function GameScene:goToLevel(level_name)
    gfx.sprite.removeAll();

    for layer_name, layer in pairs(ldtk.get_layers(level_name)) do
        if layer.tiles then
            local tilemap = ldtk.create_tilemap(level_name, layer_name);

            local layerSprite = gfx.sprite.new()
            layerSprite:setTilemap(tilemap)
            layerSprite:setCenter(0, 0)
            layerSprite:moveTo(0, 0)
            layerSprite:setZIndex(layer.zIndex)
            layerSprite:add()

            local emptyTiles = ldtk.get_empty_tileIDs(level_name, "Solid", layer_name)
            if emptyTiles then
                gfx.sprite.addWallSprites(tilemap, emptyTiles)
            end
        end
    end

    currentLevel = level_name
end
