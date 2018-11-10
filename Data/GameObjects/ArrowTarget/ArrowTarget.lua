function Local.Init(board, type)
    Object.baseX=board.position.x;
    Object.y = board.position.y + 0.05;
    if type == "Left" then 
        Object.x = Object.baseX + 0.05 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 90;
    elseif type == "Down" then
        Object.x = Object.baseX + 0.05 + (board.size.x-0.1)/3 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 180;
    elseif type == "Right" then
        Object.x = Object.baseX + 0.05 + 2*(board.size.x-0.1)/3 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = -90;
    elseif type == "Up" then
        Object.x = Object.baseX + 0.05 + (board.size.x-0.1) - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 0;
    end
                
    This:getSceneNode():setPosition(obe.UnitVector(Object.x, Object.y, obe.Units.ViewPercentage));
    This:LevelSprite():setRotation(Object.rotation, obe.Referencial.Center);
end

function Object:getPosition()
    return This:getSceneNode():getPosition();
end