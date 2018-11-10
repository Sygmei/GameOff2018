direction={"Left","Down","Right","Up"}

function Local.Init(pos)
    if pos == "Left" then Object.posX = 0.1
    elseif pos == "Right" then Object.posX = 0.6 
    end
    This:getSceneNode():setPosition(obe.UnitVector(Object.posX, 0.05, obe.Units.ViewPercentage));
    
    Object.arrowTargets = {};

    for k,v in pairs(direction) do
        Object.arrowTargets[v] = Scene:createGameObject("ArrowTarget")({board = {position=This:getSceneNode():getPosition():to(obe.Units.ViewPercentage), size=This:LevelSprite():getSize():to(obe.Units.ViewPercentage)}, type=v});
    end
end

function Object:getSize()
    return This:LevelSprite():getSize():to(obe.Units.ViewPercentage)
end

function Object:getPosition()
    return This:getSceneNode():getPosition():to(obe.Units.ViewPercentage)
end