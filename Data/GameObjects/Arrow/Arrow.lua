function Local.Init(board, type)
    Object.boardPosition = board.getPosition();
    Object.boardSize = board.getSize();
    Object.baseX=Object.boardPosition.x;
    Object.y = 0.90;
    if type == "Left" then 
        Object.x = Object.baseX + 0.05 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 90;
    elseif type == "Down" then
        Object.x = Object.baseX + 0.05 + (Object.boardSize.x-0.1)/3 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 180;
    elseif type == "Right" then
        Object.x = Object.baseX + 0.05 + 2*(Object.boardSize.x-0.1)/3 - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = -90;
    elseif type == "Up" then
        Object.x = Object.baseX + 0.05 + (Object.boardSize.x-0.1) - This:LevelSprite():getSize():to(obe.Units.ViewPercentage).x/2;
        Object.rotation = 0;
    end
                
    This:getSceneNode():setPosition(obe.UnitVector(Object.x, Object.y, obe.Units.ViewPercentage));
    This:LevelSprite():setRotation(Object.rotation, obe.Referencial.Center);

    Object.tNode = obe.TrajectoryNode(This:getSceneNode());
    Object.tNode:addTrajectory("Linear")
        :setAngle(90)
        :setSpeed(1)
        :setAcceleration(0)
    --This:getSceneNode():setPosition(obe.UnitVector(Object.x, Object.y, obe.Units.ViewPercentage));
    --This:Collider():setPositionFromCentroid(obe.UnitVector(0.25, 1, obe.Units.ViewPercentage));
    --This:LevelSprite():setPosition(obe.UnitVector(0.25, 1, obe.Units.ViewPercentage), obe.Referencial.Center);
    Object.trajectory = Object.tNode:getTrajectory("Linear");
    Object.pos = This:Collider():getCentroid();

    
    
end

function Global.Game.Update(dt)
    --Object.x = This:Collider():getCentroid():to(obe.Units.ViewPercentage).x;
    --Object.y = This:Collider():getCentroid():to(obe.Units.ViewPercentage).y;
    --Object.pos = This:Collider():getCentroid();

    -- Trajectory
    Object.tNode:update(dt);

    
end

function Object:getPosition()
    return This:getSceneNode():getPosition();
end

function Object:delete()
    This:delete()
end

function Object:checkOOB()
    -- Position
    local selfPoint = This:Collider():getCentroid():to(obe.Units.SceneUnits);
    local bx, by = selfPoint.x, selfPoint.y;

    -- World Bounds (Top and bottom)
    if by < Object.boardPosition.y  then
        return true
    end
    return false
end