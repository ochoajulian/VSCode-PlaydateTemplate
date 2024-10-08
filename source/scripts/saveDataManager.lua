function GameManager:init()
    --Events
    Events:on('playerTouchedSaveCrate', function()
        self:saveGame()
    end)
end

function saveGame()
    print("hello")
    print(pd.getCurrentTimeMilliseconds())
end
